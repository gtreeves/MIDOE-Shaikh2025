% g04, Runnarson & Yao_2005
clear
clc
close all

%addpath(genpath('../.'))

% Solution
%{
78 ≤ x1 ≤ 102, 33 ≤ x2 ≤ 45 and 27 ≤ xi ≤ 45 (i = 3, 4, 5). 
The optimum solution is x ∗ =(78, 33, 29.995256025682, 45, 36.775812905788) 
where f(x ∗ ) = −30665.539. 
Two constraints are active (g 1 and g 6 ).
%}


fhandle  = @fun1;
lu       = [[78,33,27,27,27];[102,45,45,45,45]];
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
    isres_wrapper(fhandle,'g01',lu,options,i);
    toc
end






function [f,g] = fun1(x,model)


x = 10.^(x);

% fitness function
f = 5.3578547*x(:,3).^2+0.8356891*x(:,1).*x(:,5)+37.293239*x(:,1)-40792.141 ;

% constraints g<=0
g(:,1) = 85.334407 + 0.0056858*x(:,2).*x(:,5) + 0.0006262*x(:,1).*x(:,4) - 0.0022053*x(:,3).*x(:,5) - 92 ;
g(:,2) = -85.334407 - 0.0056858*x(:,2).*x(:,5) - 0.0006262*x(:,1).*x(:,4) + 0.0022053*x(:,3).*x(:,5) ;
g(:,3) = 80.51249 + 0.0071317*x(:,2).*x(:,5) + 0.0029955*x(:,1).*x(:,2) + 0.0021813*x(:,3).^2 - 110 ;
g(:,4) = -80.51249 - 0.0071317*x(:,2).*x(:,5) - 0.0029955*x(:,1).*x(:,2) - 0.0021813*x(:,3).^2 + 90 ;
g(:,5) = 9.300961 + 0.0047026*x(:,3).*x(:,5) + 0.0012547*x(:,1).*x(:,3) + 0.0019085*x(:,3).*x(:,4) - 25 ;
g(:,6) = -9.300961 - 0.0047026*x(:,3).*x(:,5) - 0.0012547*x(:,1).*x(:,3) - 0.0019085*x(:,3).*x(:,4) + 20 ;




end