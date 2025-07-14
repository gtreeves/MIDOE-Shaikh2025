clear
clc
close all

%
clc
load('Mats/reci_v3.3.mat','dat')
clear opts
stat2plot  = {'Gm'};

opts.G      = 500;
opts.yeslin = true;
opts.yesnew = true;
% opts.reshuffGen = 0;
% % opts.migGen = -1;
% opts.nlin = 2;
% opts.nnewt = 1;
% opts.startlin   = 1;
% opts.endlin     = 250;
% opts.startnew   = 251;
% opts.endnew     = 1000;
% opts.nIslands   = 1;
opts.betalin    = 2;

[nU,nUall] = findUnique(dat,opts,true);

% T = findNumberOfFiles(dat,opts)

%%

output = getStats(dat,opts,stat2plot);
out    = cellfun(@(x) min(x,[],2),output,'UniformOutput',false);
out    = cellfun(@(x) x',out,'UniformOutput',false);
out    = cell2mat(out);

G1 = nUall.G(1);
% plottitle = ['pEvo = ',num2str(opts.pEvo),', pPar = ',num2str(opts.pPar)];
% savename  = [num2str(opts.pEvo*100),'_',num2str(opts.pPar*1000)];


%% Compare to
clc
load('Mats/reci_v3.3.mat','dat')
clear opts2
opts2.G      = 500;
% opts1.nIslands = 1;
opts2.yeslin = false; 
opts2.yesnew = false;
% opts2.nIslands = 1;
% opts2.nIslands = 1;
% opts2.reshuffGen = 0;
% opts2.nIslands = 1;
% opts2.reshuffGen = 0;
% opts2.nIslands = 1;
% opts2.startnew = 251;
% opts2.endnew = 1000;
% opts2.nnewt = 1;
% opts2.nlin = 2;
% opts2.lambda = 1000;
% opts2.nlin = 3;
% opts2.sortPrevParamsByError = true;
% opts1.lambda = 350;

[nU,nUall] = findUnique(dat,opts2,true);

%%
output = getStats(dat,opts2,stat2plot);
out2   = cellfun(@(x) min(x,[],2),output,'UniformOutput',false);
out2   = cellfun(@(x) x',out2,'UniformOutput',false);
out2   = cell2mat(out2);

G2     = nUall.G(1);

%%
% out  = log10(out);
% out2 = log10(out2);

% plot(out); hold on; plot(out2)
% legend('plus','vanilla')

%%

close all

outmean   = mean(out);
outmin    = min(out);
outmax    = max(out);
out25     = prctile(out,25);
out50     = prctile(out,50);
out75     = prctile(out,75);

outmean2   = mean(out2);
outmin2    = min(out2);
outmax2    = max(out2);
out225     = prctile(out2,25);
out250     = prctile(out2,50);
out275     = prctile(out2,75);


close all
irange    = 1:G1;
xrange    = 1:G1;
liwd      = 1;

figure('Position',[100,100,1000,800])
color1 = [44,123,182]/256;
% p1a = plot(xrange(irange),outmean(irange),'color',[0, 0.5, 0],'LineWidth',liwd); hold on;
% p1b = plot(xrange(irange),outmin(irange),'color',[0,0.50,0],'LineWidth',liwd);
% p1c = plot(xrange(irange),outmax(irange),'color',[0,0.50,0],'LineWidth',liwd);
p1d = plot(xrange(irange),out25(irange),'color',color1,'LineWidth',liwd); hold on
p1e = plot(xrange(irange),out75(irange),'color',color1,'LineWidth',liwd);
p1f = plot(xrange(irange),out50(irange),'color',color1,'LineWidth',liwd);


x = [irange,fliplr(irange)];
y = [out25(irange),fliplr(out75(irange))];
fill(x,y,color1,'FaceAlpha',0.5)


irange    = 1:G2;
xrange    = 1:G2;


color2 = [215,25,28]/256;
% p2a = plot(xrange(irange),outmean2(irange),'color',[1,0,0],'LineWidth',liwd); hold on;
% p2b = plot(xrange(irange),outmin2(irange),'color',[1,0,0],'LineWidth',liwd);
% p2c = plot(xrange(irange),outmax2(irange),'color',[1,0,0],'LineWidth',liwd);
p2d = plot(xrange(irange),out225(irange),'color',color2,'LineWidth',liwd);
p2e = plot(xrange(irange),out275(irange),'color',color2,'LineWidth',liwd);
p2f = plot(xrange(irange),out250(irange),'color',color2,'LineWidth',liwd);

x = [irange,fliplr(irange)];
y = [out225(irange),fliplr(out275(irange))];
fill(x,y,color2,'FaceAlpha',0.5)




% xlim([1000,1500])
% ylim([1.65,1.95])
% ylim([-15.0000001,-14.9999999])
legend([p1d p2d],{'isres+','vanilla isres+'})

set(gca,'fontsize',28)
xlabel('Generations')
ylabel('Fitness')
title(stat2plot)
% saveas(gcf,['Figs/MinVsG/',savename,'.tiff'])



%
% Print original opts on the plot
%
names = fieldnames(opts);
txt0   = cell(length(names),1);
for i=1:length(names)   
   txt0{i} = [names{i},' = ',num2str(opts.(names{i}))];
end
text(0.5,0.75,txt0,'Units','normalized','fontsize',22)

%% save figure
% 
% saveas(gcf,'Figs/2/E','svg')
% close





