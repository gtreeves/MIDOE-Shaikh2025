% This script first accepts certain values of the inputs to filter the
% results from the database and then in those files finds at what
% generation does a file reach pClose*BestError! It then makes the
% appropriate histograms.

clear
clc
close all

pClose = 1.1;


load('db.mat','dat')

a.lambda = 1000;
a.G      = 60;
a.pBub   = 0.2;
a.yeslin = true;

v       = findInDb(dat,a);
nfiles	= length(v);
Gyes    = zeros(nfiles,1);
for i=1:nfiles
   load(dat(v(i)).FileLocations,'Stats','Gm')
   Min = Stats.Min;
   Gyes(i) = find(Min < pClose*Gm,1);
   evalyes(i) = Min(Gyes(i));
end
nYeslin = length(Gyes);


a.yeslin = false;
v       = findInDb(dat,a);
nfiles	= length(v);
Gno = zeros(nfiles,1);
for i=1:nfiles
   load(dat(v(i)).FileLocations,'Stats','Gm')
   Min = Stats.Min;
   Gno(i) = find(Min < pClose*Gm,1); 
   evalno(i) = Min(Gno(i));
end
nNolin = length(Gno);

%% make plots
close
clc
BinWidth = 10;
h1 = histogram(Gyes,'EdgeAlpha',0.1,'FaceAlpha',0.5);
hold on
h2 = histogram(Gno,'EdgeAlpha',0.1,'FaceAlpha',0.5);
h1.Normalization = 'probability';
h1.BinWidth = BinWidth;
h2.Normalization = 'probability';
h2.BinWidth = BinWidth;
%xlim([0,1000])
legend('yeslin','nolin')
set(gca,'fontsize',14)
title({['What gen does min error reaches ',num2str(pClose),'* BestMinError'];['lambda = ',num2str(a.lambda),'  #yeslin = ',num2str(nYeslin),' #nolin = ',num2str(nNolin)]})

saveas(gcf,[num2str(a.lambda)],'png')


figure
plot(evalyes); hold on; plot(evalno);
legend('yeslin','nolin')



















