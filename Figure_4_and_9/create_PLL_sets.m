clc
clear
close all


%
% Specify the lb and ub 
%

lb = 1e-4*ones(1,10);
ub = 1e3*ones(1,10);
Nparams = length(lb);
NPLL = 100; %PLL grid elements

lbN = repmat(lb,NPLL,1);
ubN = repmat(ub,NPLL,1);

lu = [lb ; ub];
lu = log10(lu);

for j=1:Nparams
    
    linP = logspace(lu(1,j),lu(2,j),NPLL);

    lb_ = lbN;
    lb_(:,j) = linP;
    bounds(j).lb = lb_;

    ub_ = ubN;
    ub_(:,j) = linP;
    bounds(j).ub = ub_;

    clearvars lb_ ub_ linP
end

save('bounds.mat','bounds')