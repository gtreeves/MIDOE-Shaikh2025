clear
clc
close all

endG    = 40;

load('db3.mat','dat')
stat2plot = 'Min';


pEvo = 0.90;

opts.pEvo    = pEvo;
opts.lambda  = 350;
opts.G       = 60;
opts.nIslands = 3;
%opts.migGen = 10;
%opts.oneByLinPar  = 5;
%opts.oneByParents = 5;
%opts.yesComp = false;
% opts.pPar    = 0.01;
opts.yeslin  = true;
% opts.yesnew = true;
% opts.yesComp = true;
opts.yesnew  = true;
opts.fullnew = true;
% opts.fullnew = false;
opts.pPar    = 0.01;
% opts.migGen  = 7;
% opts.yesComp = false;


%opts.pEvo    = 0.95;
%opts.pPar     = 0.01;
%opts.migGen   = 7;

[nU,nUall] = findUnique(dat,opts);

%% Get best parameter from a given generation

stat    = {'X','F','Phi'};
ind     = {{[],[],endG},{[],endG},{[],[],endG}};
output  = getStats(dat,opts,stat,ind);


Xb      = cell(length(output),1);
Fb      = zeros(length(output),1);
for i=1:length(output) 
    X       = output{i,1};
    F       = output{i,2};
    Phi     = output{i,3};  
    nParams = size(X,2);
    X       = permute(X,[1,3,2]);
    X       = reshape(X,[],nParams); 
    F       = reshape(F,[],1);
    Phi     = permute(Phi,[1,3,2]);
    Phi     = reshape(Phi,[],2);
    Phi     = sum(Phi,2);   
    v       = Phi == 0;
    F       = F(v);
    [f,i0]  = min(F);
    Xb{i}   = X(i0,:);
    Fb(i)   = f;
end

save(['Xb_',num2str(endG),'.mat'])




































