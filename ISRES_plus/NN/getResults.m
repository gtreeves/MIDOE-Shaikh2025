clear
clc
close all


folder =  '/Users/prasadbandodkar/Desktop/Dl-Cact local/Results/Dl_Cact/current/';
files  = extractFileLocations(folder,'mat');


nParams  = 16;
nPenalty = 2;
Xall = [];
Phiall = [];
Fall = [];
for i=1:length(files)
    load(files(i),'Stats')
    X   = Stats.X;
    F   = Stats.F;
    Phi = Stats.Phi;
    X           = permute(X,[1,3,2]);
    X           = reshape(X,[],nParams);  
    F           = reshape(F,[],1);
    Phi         = permute(Phi,[1,3,2]);
    Phi         = reshape(Phi,[],nPenalty); 
    
    Xall = [Xall; X];
    Fall = [Fall;F];
    Phiall = [Phiall;Phi];
    
end

n = size(Fall,1);
i0          = randperm(n)';
Xall      = Xall(i0,:);
Fall      = Fall(i0);
Phiall    = Phiall(i0,:);

Fall = log10(Fall);

writematrix(Xall,'Xtrain.csv')
writematrix(Fall,'Ftrain.csv')
writematrix(Phiall,'Phitrain.csv')
