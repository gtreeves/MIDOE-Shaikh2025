clear
clc
close all

load('Mats/db_Dl_Cact.mat','dat')
endG      = 25;


% opts.G = 75;
% opts.pPar    = 0.01;
opts.nIslands = 4;

% % % % opts.startnew = 1;
% % % % opts.endnew  = 75;
% opts.nlin = 3;
% % % % opts.nlin = 2;
% % % % opts.nnewt = 1;
opts.yesnew  =true;
opts.nlin = 3;
% opts.yeslin  = true;
% opts.nlin = 5;
% opts.nnewt = 2;
% % opts.endnew = 50;
% opts.endlin = 25;
% % opts.nnewtPar = 1;
% opts.sortPrevParamsByError = true;
% opts.useFullNewtonStep = true;
% opts.endlin = 25;



T = findNumberOfFiles(dat,opts)

[nU,nUall] = findUnique(dat,opts,false);


options    = structfun(@(x) x(1),nUall,'UniformOutput',false);

%% Extract all individuals from the population
X      = getStats(dat,opts,{'X'});
F      = getStats(dat,opts,{'F'});
Phi    = getStats(dat,opts,{'Phi'});
Eta    = getStats(dat,opts,{'Eta'});


%% Get best min from every files at endG
nParams = 16;
nfiles  = length(F);
xmin    = zeros(nfiles,nParams);
fmin    = zeros(nfiles,1);
etamin  = xmin;
for i=1:nfiles
    phi = Phi{i}(:,:,1:endG);
    x   = X{i}(:,:,1:endG);
    f   = F{i}(:,1:endG);
    eta = Eta{i}(:,:,1:endG);
    x    = permute(x,[1,3,2]);
    x    = reshape(x,[],nParams); 
    eta  = permute(eta,[1,3,2]);
    eta  = reshape(eta,[],nParams);
    f    = reshape(f,[],1);
    phi  = permute(phi,[1,3,2]);
    phi  = reshape(phi,[],2); 
    

    phi(phi<=0)     = 0;
    phi             = sum(phi.^2,2);
    i0   = phi <=0;
    x    = x(i0,:);
    f    = f(i0,:);
    eta  = eta(i0,:);
    [fmin(i),imin] = min(f);
    xmin(i,:) = x(imin,:);
    etamin(i,:) = eta(imin,:);
end


%% Take the top 50 
[fmin,imin] = sort(fmin);
xmin    = xmin(imin,:);
etamin  = etamin(imin,:);


%%
save('config1_G_25.mat','xmin','fmin','etamin','opts','endG','options')




















