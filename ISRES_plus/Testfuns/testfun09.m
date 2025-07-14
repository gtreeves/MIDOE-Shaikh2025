% g01, Runnarson & Yao_2005
clear
clc
close all

%addpath(genpath('../.'))


% Solution
%{
where −10 ≤ xi ≤ 10 for (i = 1, ... , 7). 
The optimum solution is x ∗ = (2.330499, 1.951372, −0.4775414, 4.365726, −0.6244870, 1.038131, 1.594227) 
where f(x*) = 680.6300573. Two constraints are active (g1 and g4).
%}


fhandle     = @fun;
lu          = [-10*ones(1,7); 10*ones(1,7)];
lu          = lu + 11;
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
options.liveUpdates = true;
options.restart     = false;

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


% Create options super-structure
options.evo         = evo;
options.plus        = plus;
options.model       = model;






parfor (i=1:100,48)
    disp(strcat('Run:',num2str(i),'/',num2str(100)))
    isres_wrapper(fhandle,'g09',lu,options,i);
end






function [f,g] = fun(x,model)

x        = 10.^(x);
x        = x - 11;

% fitness function
f = (x(:,1)-10).^2+5*(x(:,2)-12).^2+x(:,3).^4+3*(x(:,4)-11).^2+...
    10*x(:,5).^6+7*x(:,6).^2+x(:,7).^4-4*x(:,6).*x(:,7)-10*x(:,6)-8*x(:,7) ;

% contraints g<=0
g(:,1) = -127+2*x(:,1).^2+3*x(:,2).^4+x(:,3)+4*x(:,4).^2+5*x(:,5) ;
g(:,2) = -282+7*x(:,1)+3*x(:,2)+10*x(:,3).^2+x(:,4)-x(:,5) ;
g(:,3) = -196+23*x(:,1)+x(:,2).^2+6*x(:,6).^2-8*x(:,7) ;
g(:,4) = 4*x(:,1).^2+x(:,2).^2-3*x(:,1).*x(:,2)+2*x(:,3).^2+5*x(:,6)-11*x(:,7) ;



end




















