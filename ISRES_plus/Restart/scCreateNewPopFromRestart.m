clear
clc
close all

load('Mats/Config0.1/config1_G_25.mat')
n       = length(fmin);
% n = 50;
nfiles  = 100;
lambda  = 1000;
nParams = 16;


lu          = [-4*ones(1,nParams); 4*ones(1,nParams)];
lu(1,14)    = -1;
lu(2,14)    = 0;                    % Limits on phi
lb          = lu(1,:);
ub          = lu(2,:);


alphaa = options.alphaa;
varphi = options.varphi;
chi             = (1/(2*nParams)+1/(2*sqrt(nParams)));
varphi          = sqrt((2/chi) * log((1/alphaa)*(exp(varphi^2*chi/2)-(1-alphaa))));
tau             = varphi/(sqrt(2*sqrt(nParams)));      % learning rate for a parameter ???
tau_            = varphi/(sqrt(2*nParams));            % learning rate for an individual  ???
eta             = (lu(2,:)-lu(1,:))/sqrt(nParams);
eta_u           = eta(1,:);


fmin   = fmin(1:n);
xmin   = xmin(1:n,:);
etamin = etamin(1:n,:);


% if n>nfiles
%     i0 = randperm(n,nfiles);
%     fmin   = fmin(i0);
%     xmin   = xmin(i0,:);
%     etamin = etamin(i0,:);
%     n = nfiles;
% elseif n<nfiles
%     error('Number of files in Config.mat is less than what is asked for')
% end


nretry = 20;
X      = cell(nfiles,1);
for i=1:nfiles
   fprintf('Running: %i\n',i)
   i0           = 1:n;
   gamma        = randrange(0.5,1.5,lambda);
   x            = repelem(xmin(i0,:),lambda/(n),1);   
   eta          = repelem(etamin(i0,:),lambda/(n),1);
   x    = [x;x(1:10,:)];
   eta  = [eta;eta(1:10,:)];
   eta_         = eta;
   x_           = x;
   
   % Reduce eta as per original isres
   eta     = eta.*exp(tau_*randn(lambda,1)*ones(1,nParams) + tau*randn(lambda,nParams));        
   v0      = any((eta>=eta_u)==true,2);
   retry   = 1;
   while any(v0>=1) && retry<=nretry
       ntimes       = length(find(v0 == true));
       eta(v0,:)    = eta_(v0,:).*exp(tau_*randn(ntimes,1)*ones(1,nParams) + tau*randn(ntimes,1));
       v0           = any((eta>=eta_u)==true,2);
       retry        = retry + 1;
   end  

    
   % get new population by mutation and fix for boundary
   x            = x + eta.*randn(lambda,nParams);
   [row,col]    = find((x>ub) | (x<lb));
   row          = unique(row);
   retry        = 1;
   while ~isempty(row) && retry<nretry
       len          = length(row);
       x(row,:)     = x(row,:) + eta(row,:).*randn(len,nParams);
       [row,col]    = find((x>ub) | (x<lb));
       row          = unique(row);
       retry        = retry + 1;
   end

   % Correct individuals that are out of bounds parameter-wise.
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
   
   X{i} = x;
   save(['restart1_',num2str(i),'.mat'],'x','eta','options')
     
end