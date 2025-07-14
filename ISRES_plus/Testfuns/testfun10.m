% g10, Runnarson & Yao_2005
clear
clc
close all

%addpath(genpath('../.'))

% Solutions
%{
where 100 ≤ x 1 ≤ 10000, 1000 ≤ x i ≤ 10000 (i = 2, 3)
and 10 ≤ x i ≤ 1000 (i = 4, . . . , 8). 
The optimum solution is x ∗ = (579.3167, 1359.943, 5110.071, 182.0174, 295.5985, 217.9799, 286.4162, 395.5979) 
where f(x ∗ ) = 7049.3307. 
Three constraints are active (g1 , g2 and g3 ).
%}


fhandle  = @fun1;
lu       = [[100,1000,1000,10,10,10,10,10];[10000,10000,10000,1000,1000,1000,1000,1000]];
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
options.liveUpdates = true;
options.restart     = false;

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


% Create options super-structure
options.evo         = evo;
options.plus        = plus;
options.model       = model;






parfor (i=1:100,48)
    disp(strcat('Run:',num2str(i),'/',num2str(100)))
    isres_wrapper(fhandle,'g10',lu,options,i);
end







function [f,g] = fun1(x,model)

x = 10.^(x);

% fitness function
f = sum(x(:,1:3),2) ;

% constraints g<=0
g(:,1) = -1+0.0025*(x(:,4)+x(:,6)) ;
g(:,2) = -1+0.0025*(x(:,5)+x(:,7)-x(:,4)) ;
g(:,3) = -1+0.01*(x(:,8)-x(:,5)) ;
g(:,4) = -x(:,1).*x(:,6)+833.33252*x(:,4)+100*x(:,1)-83333.333 ;
g(:,5) = -x(:,2).*x(:,7)+1250*x(:,5)+x(:,2).*x(:,4)-1250*x(:,4) ;
g(:,6) = -x(:,3).*x(:,8)+1250000+x(:,3).*x(:,5)-2500*x(:,5) ;



end