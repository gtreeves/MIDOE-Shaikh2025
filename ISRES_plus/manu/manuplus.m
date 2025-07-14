% script_isres
% clear
% clc
% close all 
addpath /scratch/user/razeen/myfiles/ISRES_plus/
%addpath /scratch/user/razeen/manu/Dl-Cact-Code-main/
addpath /scratch/user/razeen/myfiles/ISRES_plus/Algorithm/
addpath /scratch/user/razeen/myfiles/ISRES_plus/Functions/
addpath /scratch/user/razeen/myfiles/ISRES_plus/Methods/
addpath /scratch/user/razeen/myfiles/ISRES_plus/Methods/Hessian/

addpath /scratch/user/razeen/myfiles/manu/manu_model_fit/
addpath /scratch/user/razeen/myfiles/manu/manu_model_fit/mcmcstat_master/

% CONTROLS

%modelname     = 'dsat'; %raz

% evo options
evo.G               = 1000;          % maximum number of generations
evo.lambda          = 350;         % population size (number of offspring) (100 to 400) 
evo.alphaa          = 0.2;         % Smoothing factor
evo.gammaa          = 0.85;        % Recombination parameter

evo.mue             = 50;           %round((lambda-nLin-nNewt)/7) 
evo.nIslands        = 1;           % number of islands
evo.migGen          = -1;            %number of migrations = 7-13

evo.pf              = .45;         % pressure on fitness in [0 0.5] try 0.45
evo.varphi          = 1;           % expected rate of convergence (usually 1)
evo.tmax            = 72*3600;     % hrs * seconds/hr
evo.mm              = 'min';       % Minimize ('min') or Maximize('max')


% plus options
plus.nlin           = 2; %2-4 %3
plus.nlinPar        = 1; %less than nLin 2-4 %2
%keep newt less than lin
plus.nnewt          = 1; %2-4 %2
plus.nnewtPar       = 1; %less than nNewt 2-4 %1

plus.useFullNewtonStep      = true; %always true
plus.sortPrevParamsByError  = true; %always true

plus.yeslin         = true; %just isres false
plus.yesnew         = true; %just isres false
plus.startnew       = 1;
plus.endnew         = evo.G;
plus.startlin       = 1;
plus.endlin         = evo.G;


% model options
%model.modelname     =  modelname; %raz

% options
options.reshuffGen  = 0; 
options.liveUpdates = true;
options.restart     = false;
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



%
% Dl-Cact model specifications: lower and upper bound for parameters
%raz start comment
% if strcmp(modelname,'decon')
%     kappa       = 1e6;                  % toll param...make large if you want unsaturable Toll
%     delta       = 1e-100;               % neg fbk params 1
%     K           = 0.05;                 % neg fbk params 2
%     nParams     = 15;                   % 15 free parameters
%     lu          = [-4*ones(1,nParams); 4*ones(1,nParams)];
%     lu(1,14)    = -1;
%     lu(2,14)    = 0;                    % Limits on phi
%     lu(1,13)    = log10(kappa) - 4;
%     lu(2,13)    = log10(kappa) + 4;     % Limits for beta (depends on kappa
%     addParams   = [log10(kappa), log10(delta), log10(K)];
% elseif strcmp(modelname,'dsat')
%     delta       = 1e-100;               % neg fbk params 1
%     K           = 0.05;                 % neg fbk params 2
%     addParams   = [log10(delta), log10(K)];
%     nParams     = 16;                   % 16 free parameters
%     lu          = [-4*ones(1,nParams); 4*ones(1,nParams)];
%     lu(1,14)    = -1;
%     lu(2,14)    = 0;                    % Limits on phi
%     
% elseif strcmp(modelname,'negfb')   
%     nParams  = 17;                      % 18 free parameters 
%     lu       = [-4*ones(1,nParams); 4*ones(1,nParams)];
%     lu(1,14) = -1;                      % lower limit on phi
%     lu(2,14) = 0;                       % upper limit on phi
%     lu(1,17) = -1;                      % lower limit on delta
%     lu(2,17) = 1;
%     addParams = [];
% else
%     error('Please specify correct modelname')
% end
% 
% % Add additional parameters to model structure
% model.addParams = addParams;
%raz end comment

% Create options super-structure
options.evo         = evo;
options.plus        = plus;
%options.model       = model;



%
% Run isres
%
load bounds.mat
f=@objectiveFunction;
lu       = [lb;ub];
[xb,BestMin,Gm,Stats,opts] = isres_plus(f,lu,options);

%raz commented to remove model name %filename = ['./Results_isres-plus_',modelname,'_',datestr(now,'yyyy-mm-dd-HH-MM-SS'),'-',char(randi([97,106],1,2)),num2str(randi(10))];
filename = ['./Results_isres-plus_',datestr(now,'yyyy-mm-dd-HH-MM-SS'),'-',char(randi([97,106],1,2)),num2str(randi(10))];
save([filename,'.mat'])   




