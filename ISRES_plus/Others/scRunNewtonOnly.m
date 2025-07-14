% Run Newton's step on the best parameter from a given generation
clear
clc
close all


endG   = 40;
nSteps = 100;
useno  = 1;

if ~exist('Xb','var')
   load(['Xb_',num2str(endG),'.mat']) 
end
xb              = Xb{1};
[nParams, np]   = size(xb);


if np == 15
    kappa       = 1e6;                  % toll param...make large if you want unsaturable Toll
    delta       = 1e-100;               % neg fbk params 1
    K           = 0.05;                 % neg fbk params 2
    lu          = [-4*ones(1,np); 4*ones(1,np)];
    lu(1,14)    = -1;
    lu(2,14)    = 0;                    % Limits on phi
    lu(1,13)    = log10(kappa) - 4;
    lu(2,13)    = log10(kappa) + 4;     % Limits for beta (depends on kappa
elseif np == 16
    delta       = 1e-100;               % neg fbk params 1
    K           = 0.05;                 % neg fbk params 2
    addParams   = [log10(delta), log10(K)];                 
    lu          = [-4*ones(1,np); 4*ones(1,np)];
    lu(1,14)    = -1;
    lu(2,14)    = 0;                    % Limits on phi
    
elseif np == 18                    
    lu          = [-4*ones(1,np); 4*ones(1,np)];
    lu(1,14)    = -1;                      % lower limit on phi
    lu(2,14)    = 0;                       % upper limit on phi
    lu(1,17)    = -1;                      % lower limit on delta
    lu(2,17)    = 1;
else
    error('Please specify correct modelname')
end
lb       = lu(1,:);
ub       = lu(2,:);




for j=1:nSteps
    %
    % Calculate Hessian
    %
    % 1. From finite differences
    %
    tic
    [Hess,Grad,f]           = calc_hessian_finitedifference(xb);
    toc
    %}
    
    % 2. From gradients
    %{
    tic
    [Hgrad,Grad,f]                = calc_hessian_grads(xb);
    toc  
    %}
    
    disp(['Error = ',num2str(f)])
    %load('Hessian.mat')

    % 3. From taylor series expansions
    %{
    nNeed = (np*np-np)/2 + np;
    nNeed = np^2;
    xpert = xb + (-1).^randi(2,nNeed,1).* randrange(0.01,0.02,nNeed).*xb;
    xs    = [xb;xpert];
    fs    = calc_error(xs); 
    
    load('Taylor1.mat','xs','fs')
    [HTaylor,~,~,~,flag] = calc_hessian_taylor(xs(1:256,:),fs(1:256));
    %}
    
    % Find the max value that can be multiplied to the recodir so the resulting
    % individuals hit the boundary.
    pertdir  = (Hess\Grad')';
    llimit   = (repmat(lb,nParams,1)- xb)./(pertdir);
    ulimit   = (repmat(ub,nParams,1)- xb)./(pertdir);
    betamax  = zeros(nParams,1);
    for i=1:nParams
        lim         = llimit(i,:);
        lbeta       = min(lim(lim > 0));
        lim         = ulimit(i,:);
        ubeta       = min(lim(lim > 0));
        if isempty(lbeta)
           lbeta = inf; 
        end
        if isempty(ubeta)
            ubeta = inf; 
        end
        betamax(i) = min(lbeta,ubeta);
    end     
    % The individuals that have betamax<1 will be unsuccessful in taking a full
    % step
    v = betamax < 1; 


    % RECOMBINATION STEP
    xpert = xb  + pertdir;

    % Correct individuals that are out of bounds.
    betarand    = rand(nParams,1);
    xpert(v,:)  = xb  + betarand(v).*betamax(v).*pertdir(v,:);
   
    xb = xpert;
end
toc


save('ResultsNewtonOnly.mat')







