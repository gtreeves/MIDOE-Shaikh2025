% script_isres
clear
clc
close all 

%addpath(genpath('./'))

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% CONTROLS

modelname   ='dsat';

%
% Algorithm parameters
%
G            = 20;          % maximum number of generations
lambda       = 140;         % population size (number of offspring) (100 to 400) 
mu           = 20;
pf           = .45;         % pressure on fitness in [0 0.5] try 0.45
varphi       = 1;           % expected rate of convergence (usually 1)
mm           = 'min';       % Minimize ('min') or Maximize('max')

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
    lu(1,17) = -1;                      % lower limit on delta
    lu(2,17) = 1;
    addParams = [];
else
    error('Please specify correct modelname')
end





%
% Run isres
%
fhandle = @calc_error;

tic
[xb,Statistics,Gm] = isres(fhandle,mm,lu,lambda,G,mu,pf,varphi);
toc
                 

if ~exist('Results','dir')
    mkdir('Results')
end
filename = ['Results/Results_isres_',modelname,'_',datestr(now,'yyyy-mm-dd-HH-MM-SS'),'-',char(randi([97,106],1,2)),num2str(randi(10))];
save([filename,'.mat'])   




