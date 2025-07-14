clear
clc
close all


load('Mats/db_Dl_Cact.mat','dat')
stat2plot = {'F'};
endG      = {25};
% iIsland   = 1;

% opts.pPar    = 0.01;
opts.nIslands = 4;
% opts.nlin = 2;
opts.yeslin  = true;
% % opts.startnew = 1;
% % opts.endnew  = 75;
% % opts.nlin = 2;
% % opts.nnewt = 1;
opts.yesnew  = true;
% opts.endnew = 50;
% opts.endlin = 75;
opts.nlin = 5;
opts.sortPrevParamsByError = false;
% opts.useFullNewtonStep = true;





[nU,nUall] = findUnique(dat,opts);

% [BestMin,vals]      = getStats(dat,opts,stat2plot);

%%

output  = getStats(dat,opts,stat2plot);
output2 = getStats(dat,opts,{'X'});

%%
output3 = getStats(dat,opts,{'Stats'});

%%
num2check = [246:250,496:500,746:750,996:100]';
numlen = length(num2check);
for i=1:length(output)
   op = output{i}; 
   x  = output2{i};
   [row,col] = find(isnan(op)); 
   if ~isempty(row)
      for j=1:numlen
          found = any(row==num2check(i));
         if found
            disp('got it') 
         end
      end
      xnan = x(row,:,col);
   end
end

%%
for i=1:length(row)
   xnan2(:,:) = xnan(:,:,i) 
end