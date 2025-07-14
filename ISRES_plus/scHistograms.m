clear
clc
close all

load('Mats/g02_v3.3.mat','dat')
stat2plot  = {'Gm'};

opts.G      = 1500;
opts.yeslin = true;
opts.yesnew = true;
% opts.nlin = 2;
% opts.nnewt = 1;
% opts.startlin   = 1;
% opts.endlin     = 1000;
% opts.startnew   = 1;
% opts.endnew     = 1000;
opts.betalin    = 2;

[nU,nUall] = findUnique(dat,opts,true);

%% Get bestMin

[BestMin,fieldvalues]  = getStats(dat,opts,stat2plot);
BestMin                = min(cell2mat(BestMin),[],2); 
nFiles                 = length(BestMin);


%% Compare with
clc
load('Mats/g02_v3.3.mat','dat')
clear opts2
opts2.G      = 1500;
% opts1.nIslands = 1;
opts2.yeslin = false; 
opts2.yesnew = false;
% opts2.nIslands = 1;
% opts2.reshuffGen = 0;


[nU,nUall] = findUnique(dat,opts2,true);


%% Get bestMin

[BestMin2,fieldvalues2]  = getStats(dat,opts2,stat2plot);
BestMin2                 = min(cell2mat(BestMin2),[],2); 
nFiles                   = length(BestMin2);

%% Histogram Plots
clc
close all

nbins = 200;
figure('Position',[250,250,800,600],'PaperOrientation','landscape')
color1 = [44,123,182]/256;
plotHistogram(BestMin,[],nbins,color1);
hold on

color2 = [215,25,28]/256;
plotHistogram(BestMin2,fieldvalues2,nbins,color2);
legend('ISRES+','ISRES')
ylim([0,0.7])

% saveas(gcf,'Figs/2_1/C','svg')
%% histograms between 25 - 75 percentile

% iBmin  = (BestMin > prctile(BestMin,25)) & (BestMin < prctile(BestMin,75));
% iBmin2 = (BestMin2 > prctile(BestMin2,25)) & (BestMin2 < prctile(BestMin2,75));
% 
% BMin = BestMin(iBmin);
% Bmin2 = BestMin2(iBmin2);
% 
% 
% nbins = 2;
% figure('Position',[250,250,800,600],'PaperOrientation','landscape')
% color1 = [44,123,182]/256;
% plotHistogram(BMin,opts,nbins,color1);
% 
% % legend('plus')
% hold on
% 
% color2 = [215,25,28]/256;
% plotHistogram(Bmin2,[],nbins,color2);
% legend('ISRES+','ISRES')
% saveas(gcf,'Figs/3/B','svg')

%% Functions


function plotHistogram(stat2plot,cond,BinWidth,color)

if ~exist('BinWidth','var')
    BinWidth = 25;
end

histogram(stat2plot,'FaceAlpha',0.5,'EdgeAlpha',0.1, ...
        'Normalization','probability','BinWidth',BinWidth,'FaceColor',color);
% xlim([0,500])
% ylim([0,0.7])
% xticklabels(string(0:50:500))


if ~isempty(cond)
    names = fieldnames(cond);
    leg = [];
    for i=1:length(names)   
       leg{i} = [names{i},' = ',num2str(cond.(names{i}))];
    end
    text(0.5,0.5,leg,'Units','normalized','fontsize',12)
end


title(['#files = ',num2str(length(stat2plot))])

set(gca,'fontsize',20)
end
















