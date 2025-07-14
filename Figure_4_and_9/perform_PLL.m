function [xb,BestMin,PLL_Stats] =  perform_PLL(fhandle,lb,ub)

lu = [lb;ub];
[xb,BestMin,Gm,Stats,opts] = isres_plus(fhandle,lu);

[x,fval,exitflag,output,lambda,grad,hessian]= fmincon(fhandle,xb,[],[],[],[],lb,ub);

PLL_Stats.xb = xb;
PLL_Stats.BestMin = BestMin;
PLL_Stats.Gm = Gm;
PLL_Stats.Stats = Stats;
PLL_Stats.opts = opts;
PLL_Stats.x = x;
PLL_Stats.fval = fval;
PLL_Stats.exitflag = exitflag;
PLL_Stats.output = output;
PLL_Stats.lambda = lambda;
PLL_Stats.grad = grad;
PLL_Stats.hessian = hessian;
end