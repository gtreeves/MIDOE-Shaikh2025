% This script compares Hessians calculated from three different methods:
% a). from creating a cluster around a point and use error calculations
% b). from finite differences
% c). from Taylor series expansion.
%
% Currently only methods b). and c). are currently implemented. 

clear
clc
close all


% first load a param set that is a result of an isres run
path        = '../../Results/Mats/SSE_calc_error/';
files       = extractFileLocations(path,'mat');
filename    = files(2);
load(filename,'xb','addParams','Stats','modelname')
params = [xb,addParams];
params = 10.^params;
struct2vars(Stats)


% get a list of parameter sets that are a within a certain distance of xb 
dis             = 1;
betaprev        = 0.5;
[xmain,fmain,d] = previous_params(X,F,Phi,dis,betaprev,xb);
[d,i0]          = sort(d);
xmain           = xmain(i0,:);
fmain           = fmain(i0);
v               = repeatcheck(xmain(:,1));

for i=1:length(v)
    xmain(v{i}(2:end),:) = []; 
end

%% GRADIENTS

% Check if gradient calculations are correct

clc
[f,~,soln] = calc_error(xb);


% check finite difference gradient for multiple values of perturbation
% clear gradCheck
% npert = 5;
% pert = logspace(-7,-8,npert);
% for i=1:npert
%     gradCheck(:,i)   = calc_grad_finitedifference(xb,f,modelname,pert(i));
% end

tic
GFiniteDifference      = calc_grad_finitedifference(soln);
toc
tic
grad1                  = dsat2_gradcalc(soln)';
toc
GForwardSensitivity    = grad1(1:16);

AllGrads   = table(GFiniteDifference,GForwardSensitivity, ...
    'VariableNames',{'Finite Differences','Forward Sensitivity'});

fprintf('Norm of the difference is = %.3f\n', ...
    norm(GFiniteDifference - GForwardSensitivity))


%% HESSIAN 1: From finite differences 

clc

Xb = 10.^xb'*10.^xb;

% Using finite differences
tic
H0                  = calc_hessian_finitedifference(xb);    % in linear space
HFiniteDifferences  = (H0.*Xb)/log(10)^2;                   % in log space
toc


% Using gradients
tic
gradhandle        = @dsat2_gradcalc;
H                 = calc_hessian_grads(xb,gradhandle);      % in linear space
HGrads            = (H.*Xb)/log(10)^2;                      % in log space
toc

% Using gradients - Greg's code
tic
HGradsGreg        = dsat2_hessiancalc(xb);                  % in log space
toc

fprintf('Norm of the difference (Hessian from gradient) is = %.3f\n', ...
    norm(HGrads(:) - HFiniteDifferences(:))/numel(HGrads))

save('Mats/DirectHessianCalc2.mat')

%% HESSIAN 2: from Taylor series expansion

% First, generate a cluster of parameters very close to xb
n       = length(xb);
np      = 300;
dx      = randn(np,n);
xpert   = repmat(xb,np,1) + 1e-5*dx;	

fpert   = calc_error(xpert);

save('Mats/params_perturbed_around_small_region2a.mat','xpert','fpert','xb')
%% Calculate Hessian from Taylor series

%load('Mats/params_perturbed_around_small_region.mat')
[HTaylor,GTaylor,isPositiveDefinite] =  calc_hessian_taylor(xpert,fpert);


%
% Greg's code
%
HTaylorGreg     = quad_step2(xpert,fpert);
Xb              = 10.^xb'*10.^xb;
HTaylorGreg2    = HTaylorGreg./Xb/(log(10)^2); % Estimated Hessian 2

fprintf('Norm of the difference is = %.3f\n',norm(HTaylor(:) - HTaylorGreg(:))/numel(HTaylor))


%% Compare the 2 Hessians

% All comparisions in log-space!

% Take Hessian from gradient to logspace
% Xb = 10.^xb'*10.^xb;
% H_grads_log = H_grads.*Xb/log10(exp(1))^2;
% 
% %H2 = H_taylor./Xb/(log(10)^2);
% 
% H_taylor2 = H_taylor./Xb/(log(10)^2);

CompareTaylorGrad  = HTaylor./HGrads;
CompareTaylorFD    = HTaylor./HFiniteDifferences;


CompareTaylorGradGreg = HTaylorGreg2./HGradsGreg;















