% script_isres
clear
clc
close all 

%
% Run isres
%
fhandle  = @objective_Smad_v0; %change version of Smad model to calibrate (v1, v2, v3, v0_FRAP)

%%
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%
% CONTROLS (SI Table 4)
%
modelname           = 'schmierer';

% evo options
evo.G               = 3000;        % maximum number of generations
evo.lambda          = 400;          % population size (number of offspring) (100 to 400) 
evo.mue             = 60;          % ~round((lambda)/7)
evo.nIslands        = 1;           % number of islands
evo.migGen          = -1;           % ~10 times migration is executed

evo.alphaa          = 0.2;         % Smoothing factor
evo.gammaa          = 0.85;        % Recombination parameter
evo.pf              = .45;         % pressure on fitness in [0 0.5] try 0.45
evo.varphi          = 1;           % expected rate of convergence (usually 1)
evo.tmax            = 72*3600;     % hrs * seconds/hr
evo.mm              = 'min';       % Minimize ('min') or Maximize('max')

% plus options
plus.yeslin         = true;
plus.yesnew         = true;
plus.nlin           = 2;        % 1-2       % 2  
plus.nnewt          = 1;        % 1-2       % 1
plus.nlinPar        = 1;        % 1-2       % 1
plus.nnewtPar       = 1;        % 1-2       % 1
plus.startlin       = 1;
plus.endlin         = evo.G;
plus.startnew       = 1;
plus.endnew         = evo.G;
plus.useFullNewtonStep      = true;     % applies only to newton step.
plus.sortPrevParamsByError  = false;     % applies to both linstep and newton step
plus.betalin = 1;

% model options
model.modelname     =  modelname;

% other options
options.reshuffGen  = 0; 
options.liveUpdates = true;
options.restart     = false;
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


% Create options super-structure
options.evo         = evo;
options.plus        = plus;
%options.model       = model;




lb(1,:)       = 1e-4*ones(1,10);
ub(1,:) = 1e3*ones(1,10);
lu = [lb;ub];

lu       = log10(lu);

[xb,BestMin,Gm,Stats,opts] = isres_plus(fhandle,lu,options);
xb = 10.^xb;
BestMin;
Gm;
Stats;
opts;

if ~exist("Results","dir")
    mkdir("Results")
end
filename = ['.',filesep,'Results',filesep,'Results_isres-plus',datestr(now,'yyyy-mm-dd-HH-MM-SS'),'-',char(randi([97,106],1,2)),num2str(randi(10))];
save([filename,'.mat'])   




