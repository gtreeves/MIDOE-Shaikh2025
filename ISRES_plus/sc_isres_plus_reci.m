% script_isres_plus for the Dl_Cact model
clear
clc
close all 

disp('started')
addpath(genpath('./'))

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%
% CONTROLS
%
modelname           = 'reci';

% evo options
evo.G               = 5;        % maximum number of generations
evo.lambda          = 150;         % population size (number of offspring) (100 to 400) 
evo.mue             = 20;          % ~round((lambda)/7)
evo.nIslands        = 1;           % number of islands
evo.migGen          = -1;          % ~10 times migration is executed

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
plus.startlin       = 1;
plus.endlin         = evo.G;
plus.startnew       = 251;
plus.endnew         = 1000;
plus.betalin        = 1.5;
plus.useFullNewtonStep      = true;     % applies only to newton step.
plus.sortPrevParamsByError  = false;     % applies to both linstep and newton step

% model options
model.modelname     =  modelname;

% other options
options.reshuffGen  = 0; 
options.liveUpdates = true;
options.restart     = false;
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


% Add additional parameters to model structure
model.addParams = [];

% Create options super-structure
options.evo         = evo;
options.plus        = plus;
options.model       = model;



lu       = [[0.0001 0.00001 0.0001 0.0001 0.00001 0.0001 0.00001 0.00001 0.0001 0.0001 10 10 10 1 0.001];[10 10 10 10 10 100 10 10 10 1000 1000 1000 1000 1000 1000]];
lu       = log10(lu);


%
% Run isres
%
fhandle = @error_calc_RECI;
[xb,BestMin,Gm,Stats,options] = isres_plus(fhandle,lu,options);


if ~exist('Results','dir')
    mkdir('Results')
end
filename = ['Results/Results_isres-plus_',modelname,'_',datestr(now,'yyyy-mm-dd-HH-MM-SS'),'-',char(randi([97,106],1,2)),num2str(randi(10))];
save([filename,'.mat'])   




