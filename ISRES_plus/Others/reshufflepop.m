function [x,eta,nmuta,nRetryX,nRetryEta] = reshufflepop(X,Phi,Eta,F,lambda,mue,nIslands,lu,eta_u,tau,tau_)


nretry      = 1000;
nParams     = size(X,2);
nPenalty    = size(Phi,2);

% go over all islands
x = []; 
eta = [];
posI = 1:lambda;
for i=1:nIslands
    xI      = X(posI,:,:);
    phiI    = Phi(posI,:,:);
    etaI    = Eta(posI,:,:);
    fI      = F(posI,:);

    xI      = permute(xI,[1,3,2]);
    xI      = reshape(xI,[],nParams);
    etaI    = permute(etaI,[1,3,2]);
    etaI    = reshape(etaI,[],nParams);
    fI      = reshape(fI,[],1);

    phiI         = permute(phiI,[1,3,2]);
    phiI         = reshape(phiI,[],nPenalty); 
    phiI(phiI<0) = 0;
    phiI         = sum(phiI.^2,2);  
    v            = phiI <= 0 & ~isnan(fI);

    xI      = xI(v,:);
    etaI    = etaI(v,:);
    fI      = fI(v);
    [~,i0]  = sort(fI);
    xI      = xI(i0,:);
    etaI    = etaI(i0,:);

    
    if size(xI,1) > lambda
        xI   = xI(1:mue,:);
        etaI = etaI(1:mue,:);
        sI   = (1:mue)'*ones(1,ceil(lambda/mue));
        sI   = sI(1:lambda);
        xI   = xI(sI,:);
        etaI = etaI(sI,:);
    else
        N = size(xI,1);
        sI = (1:N)'*ones(1,ceil(lambda/N));
        sI = sI(1:lambda);
        xI = xI(sI,:);
        etaI = etaI(sI,:);
    end
    
    x    = [x;xI];
    eta  = [eta;etaI];
    posI = posI + lambda;
end


% randomly shuffle population
i0 = randperm(lambda*nIslands);
x = x(i0,:);
eta = eta(i0,:);

% 
% sI          = (1:lambda);
% sI          = repmat(reshape(sI,nPerIsland,[]),nIslands,1);
% lam         = repelem(cumsum(repmat(lambda,nIslands,1))-lambda,nPerIsland);
% sI          = sI+lam;
% sI          = sI(:);
% x           = x(sI,:);
% eta         = eta(sI,:);



% 
% Smoothing of eta
%
eta_ = eta;
eta     = eta.*exp(tau_*randn(lambda*nIslands,1)*ones(1,nParams) + tau*randn(lambda*nIslands,nParams));

% Check upper bound on eta by retry      
v0      = any((eta>eta_u)==true,2);
retry   = 1;
while any(v0>=1) && retry<=nretry
    ntimes       = length(find(v0 == true));
    eta(v0,:)    = eta_(v0,:).*exp(tau_*randn(ntimes,1)*ones(1,nParams) + tau*randn(ntimes,nParams));
    v0           = any((eta>eta_u)==true,2);
    retry        = retry + 1;
end  
nRetryEta   = repmat(retry,1,nIslands);
for j = 1:nParams 
    I        = find(eta(:,j)>eta_u(j)); 
    eta(I,j) = eta_u(j)*ones(size(I));
end



% 
% Generate new population
%
nmuta           = lambda*nIslands;          
x               = x + eta.*randn(nmuta,nParams);

% Check upper bound on x by retry    
v0      = any((x<lu(1,:) | x>lu(2,:))==true,2);
retry   = 1;
x_      = x;
while any(v0>=1) && retry<=nretry
    ntimes       = length(find(v0 == true));
    x(v0,:)      = x_(v0,:) +  eta(v0,:).*randn(ntimes,nParams);
    v0           = any((x<lu(1,:) | x>lu(2,:))==true,2);
    retry        = retry + 1;
end 
nRetryX = retry;


% Correct individuals that are out of bounds parameter-wise.
lb = lu(1,:);
ub = lu(2,:);
I     = find((x>ub) | (x<lb));
retry = 1 ;
while ~isempty(I)
    x(I)   = x_(I) + eta(I).*randn(length(I),1);
    I       = find((x>ub) | (x<lb));
    if (retry>nretry) 
        break; 
    end
    retry   = retry + 1;
end
if ~isempty(I)
    x(I) = x_(I);              % ignore failures
end






end