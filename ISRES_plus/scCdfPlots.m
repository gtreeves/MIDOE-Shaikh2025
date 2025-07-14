clear
clc
close all

load('Mats/dsat_v3.2.mat','dat')
stat2plot  = {'BestMin'};

opts.G      = 1000;
opts.yeslin = false;
opts.yesnew = true;
% opts.reshuffGen = 0;
% % opts.migGen = -1;
% opts.nlin = 2;
% opts.nnewt = 1;
opts.startlin   = -1;
opts.endlin     = -1;
opts.startnew   = 1;
opts.endnew     = 1000;

[nU,nUall] = findUnique(dat,opts,true);

%% Make cdfplot 1
 
figure('Position',[250,250,1100,800],'PaperOrientation','landscape');
[h,txt1,leg1] = makeAdvCdfPlot(dat,opts,stat2plot);

%% plot options



%% Configuration to compare
% %
% % stat2plot           = 'Min';
% % index               = {25};
% load('Mats/dsat-isres.mat','dat')
clc
load('Mats/dsat_v3.2.mat','dat')
clear opts2
opts2.G      = 1000;
% opts1.nIslands = 1;
opts2.yeslin = false; 
opts2.yesnew = false;
opts2.nIslands = 1;
opts2.reshuffGen = 0;

[nU,nUall] = findUnique(dat,opts2,true);


%% Make cdfplot 2
[h,txt2,leg2] = makeAdvCdfPlot(dat,opts2,stat2plot);


%% plot options

% leg = {'ISRES+ v2: vanilla';'ISRES+ v1: vanilla'};
% txt = txt1;

% leg = leg1;
txt = txt1;

leg = [leg1,leg2];
% txt = [txt1,txt2];

% 
% Plot options
%

title('BestMin')
% xlim([50,150])
legend(leg,'location','northwest')
set(gca,'fontsize',32)
xlim([20,70])


%
% Print options of each configuration on the plot
%
i0      = cellfun(@(x) isempty(x),txt,'UniformOutput',false);
i0      = cell2mat(i0);
txt(i0) = [];
ntxt    = size(txt,2);
pos     = linspace(0.3,0.85,ntxt);
for i=1:ntxt
    text(pos(i),0.3,txt(:,i),'Units','normalized','fontsize',12)
end



%
% Print original opts on the plot
%
names = fieldnames(opts);
txt0   = cell(length(names),1);
for i=1:length(names)   
   txt0{i} = [names{i},' = ',num2str(opts.(names{i}))];
end
text(0.5,0.75,txt0,'Units','normalized','fontsize',12)



%
% Save plot
%
% print('plot','-dpdf','-fillpage')
%saveas(gcf,[num2str(1000*pEvo)],'pdf')
disp('done')
















