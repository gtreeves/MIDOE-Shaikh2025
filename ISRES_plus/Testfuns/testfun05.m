% g01, Runnarson & Yao_2005
clear
clc
close all

% Solution
%{
where 0 ≤ x1 ≤ 1200, 0 ≤ x2 ≤ 1200, −0.55 ≤ x3 ≤ 0.55 and −0.55 ≤ x4 ≤ 0.55. 
The best known solution x* = (679.9453, 1026.067, 0.1188764, −0.3962336), 
where f(x*) = 5126.4981.
%}

fhandle     = @fun;
lu          = [[0,0,-0.55,-0.55];[1200,1200,0.55,0.55]];
lu          = lu + 1;
lu          = log10(lu);


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






function [f,g] = fun(x,model)


x        = 10.^(x);
x        = x - 1;

delta    = 0.0001 ; % tolerated equality constraint violation

% fitness function
f      = 3*x(:,1) + 0.000001*x(:,1).^3 + 2*x(:,2) + (0.000002/3).*(x(:,2).^3) ;

% constraints g<=0
g(:,1) = -x(:,4) + x(:,3) - 0.55 ;
g(:,2) = -x(:,3) + x(:,4) - 0.55 ;

% constraints h=0 => g=|h|-delta<=0
g(:,3)  = 1000*sin(-x(:,3)-0.25) + 1000*sin(-x(:,4)-0.25) + 894.8 - x(:,1) ;
g(:,4)  = 1000*sin(x(:,3)-0.25) + 1000*sin(x(:,3)-x(:,4)-0.25) + 894.8 - x(:,2) ;
g(:,5)  = 1000*sin(x(:,4)-0.25) + 1000*sin(x(:,4)-x(:,3)-0.25) + 1294.8 ;
g(:,3:5) = abs(g(:,3:5))-delta ;


end




















