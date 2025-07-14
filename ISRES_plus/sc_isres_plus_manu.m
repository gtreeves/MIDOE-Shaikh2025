% script_isres
clear
clc
close all 


%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%
% CONTROLS
%
modelname           = 'manu';

% evo options
evo.G               = 3000;        % maximum number of generations
evo.lambda          = 150;          % population size (number of offspring) (100 to 400) 
evo.mue             = 20;          % ~round((lambda)/7)
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
plus.endlin         = 1000;
plus.startnew       = 1001;
plus.endnew         = evo.G;
plus.betalin        = 2;
plus.useFullNewtonStep      = true;      % applies only to newton step.
plus.sortPrevParamsByError  = false;     % applies to both linstep and newton step


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


%
% Assemble bounds for the Manu model
%
f       = @objectiveFunction;

% lu(1,:) = [repmat(10,1,4),zeros(1,4),repmat(0.01,1,4),repmat(-0.5,1,32)];
% lu(2,:) = [repmat(20,1,4),repmat(0.5,1,4),repmat(0.1,1,4),repmat(0.5,1,32)];
lu(1,:) = [repmat(10,1,4),zeros(1,4),repmat(0.01,1,4),repmat(-1,1,32)];
lu(2,:) = [repmat(100,1,4),repmat(0.5,1,4),repmat(0.1,1,4),repmat(1,1,32)];

% shift bounds to ensure that all values are of order 0
lu(:,1:4)  = log10(lu(:,1:4));
lu(:,9:12) = log10(lu(:,9:12)); 



%
% Run isres
%
tic
[xb,BestMin,Gm,Stats,opts] = isres_plus(f,lu,options);
toc
xb(1:4)  = 10.^xb(1:4);
xb(9:12) = 10.^xb(9:12);

if ~exist('Results','dir')
    mkdir('Results')
end
filename = ['Results/Results_isres-plus_',modelname,'_',datestr(now,'yyyy-mm-dd-HH-MM-SS'),'-',char(randi([97,106],1,2)),num2str(randi(10))];
save([filename,'.mat'])   




