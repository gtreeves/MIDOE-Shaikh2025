% g02, Runnarson & Yao_2005
clear
clc
close all

%addpath(genpath('../.'))

% Solution
%{
n = 20 and 0 ≤ xi ≤ 10 (i = 1, ... , n). 
The global maximum is unknown, the best we found is f(x*) = 0.803619, 
constraint g1 is close to being active (g1 = −10^-8)
%}


fhandle     = @fun;
lu          = [zeros(1,20); 10*ones(1,20)];
lu          = lu + 1;
lu          = log10(lu);


%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%
% CONTROLS
%
modelname           = 'g02';

% evo options
evo.G               = 1000;          % maximum number of generations
evo.lambda          = 150;         % population size (number of offspring) (100 to 400) 
evo.mue             = 20;          % ~round((lambda)/7)
evo.nIslands        = 1;           % number of islands
evo.migGen          = 1;           % ~10 times migration is executed

evo.alphaa          = 0.2;         % Smoothing factor
evo.gammaa          = 0.85;        % Recombination parameter
evo.pf              = .45;         % pressure on fitness in [0 0.5] try 0.45
evo.varphi          = 1;           % expected rate of convergence (usually 1)
evo.tmax            = 72*3600;     % hrs * seconds/hr
evo.mm              = 'max';       % Minimize ('min') or Maximize('max')

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
model.addParams      = [];

% other options
options.reshuffGen  = 0; 
options.liveUpdates = false;
options.restart     = false;

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


% Create options super-structure
options.evo         = evo;
options.plus        = plus;
options.model       = model;





nruns = 2;

for i=1:nruns
    disp(strcat('Run:',num2str(i),'/',num2str(nruns)))
    tic
    isres_wrapper(fhandle,'g02',lu,options,i);
    toc
end







function [f,g] = fun(x,model)

x        = 10.^(x);
x        = x - 1;


% fitness function
f = abs(sum((cos(x).^4),2) - 2*prod((cos(x).^2),2))./...
    sqrt(sum(((ones(size(x,1),1)*(1:size(x,2))).*(x.^2)),2)) ;

% constraints g<=0
g(:,1) = 0.75-prod(x,2) ;
g(:,2) = sum(x,2) - 7.5*size(x,2) ;

g      = g >= 0;
end




















