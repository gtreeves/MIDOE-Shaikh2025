function [protein,K] = run_negfb(params, dl0, cact0, reltol, abstol)
% This function runs the deconvolution model with Toll saturation (dsat)
% from NC 10 -- NC 14.
% params:     a vector of parameters in linear space.
% dl0,cact0:  the initial concentrations (normalized) of dl,cact (resp)
% T:          a vector that delineates time points between mitoses and interphases.

K0         = 0.005;
K          = advNtnDU(@findK,K0,[0.001,0.1],[],[],[],[],[],params, dl0, cact0, reltol, abstol);
protein    = run_model([params, K], dl0, cact0, reltol, abstol);

end

function TOL = findK(K,params, dl0, cact0, reltol, abstol)
    x0              = 0.4; 
    [protein,XT]    = run_model([params, K], dl0, cact0, reltol, abstol);
    dl              = protein.dlNuc.NC14(:,end);
    x               = XT.X14;
    [~,i0]          = min(abs(x-x0));       
    TOL             = K - dl(i0);
end



% old code
%{ 
fun             = @(K) Kfun(K,params, dl0, cact0, reltol, abstol);
tic
options         = optimset('TolX',1e-6);
[xzero,fval,exitflag,output]  = fzero(fun,0.05,options);
toc

% TOL         = inf;
% x0          = 0.4;
% nattempts   = 10;
% retry       = 1;
% while TOL > 1e-3 && retry < nattempts
%     [protein,XT]    = run_dsat(params, dl0, cact0, reltol, abstol);
%     params_         = params;
%     dl              = protein.dlNuc.NC14(:,end);
%     x               = XT.X14;
%     [~,i0]          = min(abs(x-x0));       
%     K               = dl(i0);           % Value of K is equal to un at x ~ 0.4
%     TOL             = abs(params(end) - K);
%     params(end)     = K;
%     retry           = retry + 1;
% end
%}

 


