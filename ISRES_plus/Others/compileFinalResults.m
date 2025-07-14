clear
clc
close all

%% 1a) Final errors from the main Results folder

path = '../Results/';

Files1      = extractFileLocations(path,'mat',true);
nfiles1     = length(Files1);
BestError1  = zeros(nfiles1,1);
Xbest1      = zeros(nfiles1,18);

for i=1:length(Files1)
    try
       load(Files1(i)) 
       BestError1(i) = Gm;
       Xbest1(i,:)   = [xb,addParams];
    catch ME
        disp(ME)
    end
end


%% 1c) clean and combine

v = BestError1 == 0;
BestError1(v) = [];
Xbest1(v,:) = [];

v = BestError2 == 0;
BestError2(v) = [];
Xbest2(v,:) = [];

Xbest = [Xbest1;Xbest2];
BestError = [BestError1;BestError2];

save('Best-Fit.mat','Xbest','BestError')

%% 2). All errors < 200

path = '../Results/';

Files      = extractFileLocations(path,'mat',true);
nfiles     = length(Files);

Params1 = [];
Errors1  = [];

for i=1:length(Files)
    try
        if mod(i,100) == 0
           disp(num2str(i)) 
        end
       load(Files(i),'Stats','addParams') 
       X        = Stats.X;
       F        = Stats.F;
       Phi      = Stats.Phi;  
       nPenalty = size(Phi,2);
       nParams  = size(X,2);
       X        = permute(X,[1,3,2]);
       X        = reshape(X,[],nParams); 
       F        = reshape(F,[],1);
       Phi      = permute(Phi,[1,3,2]);
       Phi      = reshape(Phi,[],nPenalty); 
       Phi      = sum(Phi,2);

       v = Phi == 0 & F<=125;
       X = X(v,:);
       F = F(v);
       
       if ~isempty(F)
           X = [X,repmat(addParams,size(X,1),1)];
           
           Params1  = [Params1; X];
           Errors1  = [Errors1; F];
       end
    catch ME
        disp(ME)
    end   
end




% Combine and clean

Params = [Params1; Params2];
Errors = [Errors1; Errors2];


save('Error<125.mat','Params','Errors')


























