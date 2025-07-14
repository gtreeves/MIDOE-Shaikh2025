% g01, Runnarson & Yao_2005
clear
clc
close all

% addpath(genpath('../.'))

% Solution
%{
0 ≤ xi ≤ 1 (i = 1, ... , 9), 0 ≤ xi ≤ 100 (i = 10, 11, 12) and 0 ≤ x13 ≤ 1 
The global minimum is at x* = (1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 1) 
where six constraints are active (g1 , g2 , g3 , g7 , g8 and g9) 
and f(x*) = −15.
%}

fhandle     = @fun;
lu          = [zeros(1,13);[ones(1,9),100*ones(1,3),1]];
lu          = lu + 1;
lu          = log10(lu);


%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%
% CONTROLS
%
modelname           = 'g01';

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





function [f,g] = fun(x,varargin)

% Translate x
x        = 10.^(x);
x        = x - 1;


% fitness function
f = 5*sum(x(:,1:4),2) - 5*sum((x(:,1:4).^2),2) - sum(x(:,5:13),2) ;


% constraints g<=0
g(:,1) = 2*x(:,1)+2*x(:,2)+x(:,10)+x(:,11) - 10 ;
g(:,2) = 2*x(:,1)+2*x(:,3)+x(:,10)+x(:,12) - 10 ;
g(:,3) = 2*x(:,2)+2*x(:,3)+x(:,11)+x(:,12) - 10 ;
g(:,4) = -8*x(:,1)+x(:,10) ;
g(:,5) = -8*x(:,2)+x(:,11) ;
g(:,6) = -8*x(:,3)+x(:,12) ;
g(:,7) = -2*x(:,4)-x(:,5)+x(:,10) ;
g(:,8) = -2*x(:,6)-x(:,7)+x(:,11) ;
g(:,9) = -2*x(:,8)-x(:,9)+x(:,12) ;

%g = g>=0;

end




















