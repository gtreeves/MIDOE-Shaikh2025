% g08, Runnarson & Yao_2005
clear
clc
close all

%addpath(genpath('../.'))

% Solutions
%{
0 ≤ x1 ≤ 10 and 0 ≤ x2 ≤ 10. 
The optimum is located at x∗ = (1.2279713, 4.2453733) 
where f(x ∗ ) = 0.095825. 
The solution lies within the feasible region.
%}


fhandle  = @fun1;
lu       = [[0,0];[10,10]];
lu       = lu + 1;
lu       = log10(lu);


%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%
% CONTROLS
%
modelname           = 'dsat';

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
options.liveUpdates = true;
options.restart     = false;

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


% Create options super-structure
options.evo         = evo;
options.plus        = plus;
options.model       = model;





parfor (i=1:100,48)
    disp(strcat('Run:',num2str(i),'/',num2str(100)))
    isres_wrapper(fhandle,'g08',lu,options,i);
end







function [f,g] = fun1(x,model)


x = 10.^(x);
x = x - 1;

% fitness functions
f = ((sin(2*pi*x(:,1)).^3).*sin(2*pi*x(:,2)))./((x(:,1).^3).*(x(:,1)+x(:,2))) ;

% constraints g<=0
g(:,1) = x(:,1).^2 - x(:,2) + 1 ;
g(:,2) = 1 - x(:,1) + (x(:,2)-4).^2 ;


end