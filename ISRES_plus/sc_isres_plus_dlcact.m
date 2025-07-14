% script_isres_plus for the Dl_Cact model
clear
clc
close all 

disp('started')
% addpath(genpath('./'))

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%
% CONTROLS
%
modelname           = 'dsat';

% evo options
evo.G               = 1000;          % maximum number of generations
evo.lambda          = 75;         % population size (number of offspring) (100 to 400) 
evo.mue             = 20;          % ~round((lambda)/7)
evo.nIslands        = 1;           % number of islands
evo.migGen          = 1;           % ~10 times migration is executed

evo.alphaa          = 0.2;         % Smoothing factor
evo.gammaa          = 0.85;        % Recombination parameter
evo.pf              = .45;         % pressure on fitness in [0 0.5] try 0.45
evo.varphi          = 1;           % expected rate of convergence (usually 1)
evo.tmax            = 72*3600;     % hrs * seconds/hr
evo.mm              = 'min';       % Minimize ('min') or Maximize('max')

% plus options
plus.yeslin         = true;
plus.yesnew         = true;
plus.nlin           = 2;        % 2-4       % 3  
plus.nnewt          = 1;        % 2-4       % 2
plus.nlinPar        = 1;        % 2-4       % 2
plus.nnewtPar       = 1;        % 2-4       % 1
plus.useFullNewtonStep      = true;     % applies only to newton step.
plus.sortPrevParamsByError  = false;     % applies to both linstep and newton step
plus.startnew       = 251;
plus.endnew         = 1000;
plus.startlin       = 1;
plus.endlin         = 250;

% model options
model.modelname     =  modelname;

% other options
options.reshuffGen  = 0; 
options.liveUpdates = false;
options.restart     = false;
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


%
% Dl-Cact model specifications: lower and upper bound for parameters
%
if strcmp(modelname,'decon')
    kappa       = 1e6;                  % toll param...make large if you want unsaturable Toll
    delta       = 1e-100;               % neg fbk params 1
    K           = 0.05;                 % neg fbk params 2
    nParams     = 15;                   % 15 free parameters
    lu          = [-4*ones(1,nParams); 4*ones(1,nParams)];
    lu(1,14)    = -1;
    lu(2,14)    = 0;                    % Limits on phi
    lu(1,13)    = log10(kappa) - 4;
    lu(2,13)    = log10(kappa) + 4;     % Limits for beta (depends on kappa
    addParams   = [log10(kappa), log10(delta), log10(K)];
elseif strcmp(modelname,'dsat')
    delta       = 1e-100;               % neg fbk params 1
    K           = 0.05;                 % neg fbk params 2
    addParams   = [log10(delta), log10(K)];
    nParams     = 16;                   % 16 free parameters
    lu          = [-4*ones(1,nParams); 4*ones(1,nParams)];
    lu(1,14)    = -1;
    lu(2,14)    = 0;                    % Limits on phi    
elseif strcmp(modelname,'negfb')   
    nParams  = 17;                      % 18 free parameters 
    lu       = [-4*ones(1,nParams); 4*ones(1,nParams)];
    lu(1,14) = -1;                      % lower limit on phi
    lu(2,14) = 0;                       % upper limit on phi
    lu(1,17) = -1;                      %ci lower limit on delta
    lu(2,17) = 1;
    addParams = [];
else
    error('Please specify correct modelname')
end

% Add additional parameters to model structure
model.addParams = addParams;


% Create options super-structure
options.evo         = evo;
options.plus        = plus;
options.model       = model;



%
% Run isres
%
fhandle = @calc_error;
[xb,BestMin,Gm,Stats,options] = isres_plus(fhandle,lu,options);


if ~exist('Results','dir')
    mkdir('Results')
end
filename = ['Results/Results_isres-plus_',modelname,'_',datestr(now,'yyyy-mm-dd-HH-MM-SS'),'-',char(randi([97,106],1,2)),num2str(randi(10))];
save([filename,'.mat'])   




