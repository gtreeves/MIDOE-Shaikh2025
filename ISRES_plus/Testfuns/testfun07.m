% g07, Runnarson & Yao_2005
clear
clc
close all

%addpath(genpath('../.'))

% Solution
%{
where −10 ≤ xi ≤ 10 (i = 1, . . . , 10). 
The optimum solution is x* = (2.171996, 2.363683, 8.773926, 5.095984,
0.9906548, 1.430574, 1.321644, 9.828726, 8.280092, 8.375927) where 
f(x ∗ ) = 24.3062091. 
Six constraints are active (g1 , g2 , g3 , g4 , g5 and g6)
%}



fhandle  = @fun1;
lu       = [repmat(-10,1,10); repmat(10,1,10)];    % translate by +11
lu       = lu + 11;
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
    isres_wrapper(fhandle,'g07',lu,options,i);
end








function [f,g] = fun1(x,model)


x     = 10.^(x);
x     = x - 11;


% fitness function
f = x(:,1).^2+x(:,2).^2+x(:,1).*x(:,2)-14*x(:,1)-16*x(:,2)+(x(:,3)-10).^2+...
    4*(x(:,4)-5).^2+(x(:,5)-3).^2+2*(x(:,6)-1).^2+5*x(:,7).^2+...
    7*(x(:,8)-11).^2+2*(x(:,9)-10).^2+(x(:,10)-7).^2+45 ;

% constraints g<=0
g(:,1) = -105+4*x(:,1)+5*x(:,2)-3*x(:,7)+9*x(:,8) ;
g(:,2) = 10*x(:,1)-8*x(:,2)-17*x(:,7)+2*x(:,8) ;
g(:,3) = -8*x(:,1)+2*x(:,2)+5*x(:,9)-2*x(:,10)-12 ;
g(:,4) = 3*(x(:,1)-2).^2+4*(x(:,2)-3).^2+2*x(:,3).^2-7*x(:,4)-120 ;
g(:,5) = 5*x(:,1).^2+8*x(:,2)+(x(:,3)-6).^2-2*x(:,4)-40 ;
g(:,6) = x(:,1).^2+2*(x(:,2)-2).^2-2*x(:,1).*x(:,2)+14*x(:,5)-6*x(:,6) ;
g(:,7) = 0.5*(x(:,1)-8).^2+2*(x(:,2)-4).^2+3*x(:,5).^2-x(:,6)-30 ;
g(:,8) = -3*x(:,1)+6*x(:,2)+12*(x(:,9)-8).^2-7*x(:,10) ;



end