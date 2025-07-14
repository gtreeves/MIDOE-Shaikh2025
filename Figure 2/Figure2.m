clc
clear
close all

%load data
v0 = load('Smad_v0.mat','dat');
dat = v0.dat;

%load smad2,smad4 data
load("smad2_dynamics_WF.mat")
load("smad4_dynamics.mat")


%% Load parameter sets
for i =1:length(dat)
    XB(i,:) = dat(i).xb;
    BM(i) = dat(i).BestMin;
end

lb(1,:) = 1e-4*ones(1,10);
ub(1,:) = 1e3*ones(1,10);
lu = [lb;ub];
confidence_threshold = 1.6;
plot_BM = BM(BM<confidence_threshold);
plot_sets = log10(XB(BM<confidence_threshold,:));

%% Plot all parameter sets and color by BestMin

F4 = figure;
F4.Units = 'inches';
F4.Position(3:4) = [3 2]; %W,H
% yeslog = 1;
make_box_and_scatter(plot_sets,plot_BM,{'k_{TGF \beta}','k_{phos}','k_{onSB}','k_{on}','k_{dephos}','CIF','k_{in}','k_{ex}','k_{off}','k_{offSB}'},log10(lb),log10(ub))

xtickangle(90)
yticks(-4:1:3)
axis square
exportgraphics(F4,['Parameters','.eps'],'ContentType','vector')

%% Plot all model fits and predictions

time = t_smad2_plusSB;
tspan1 = time(time<60); tspan2 = time(time>60);

e = smad2_std;
errorbar_left = e(time<60); errorbar_right = e(time>60);

nuc_data = smad2_avg(time<60);
nuc_data_SB = smad2_avg(time>60);

tspan3 = t_smad4;
smad4data_avg = smad4_avg;
smad4data_std = smad4_std;

ff = figure(2);
ff.Units = 'inches';
ff.Position(3:4) = [2 2]; %W,H

errorbar([tspan1' tspan2'],[nuc_data' nuc_data_SB'],e,e,'Marker','.','LineStyle','none','Color',[0.6 0.6 0.6])

tf = 0:0.1:600;
tp = 0:0.1:150;
fp = figure(3);
fp.Units = 'inches';
fp.Position(3:4) = [2 2]; %W,H
for i = 1:size(plot_sets,1)

    [all_Smad2n,all_Smad4n,pS224n] = modelfits_predictions_Smadv0(10.^plot_sets(i,:));


    model_predictions_pS224n = calc_prediction_stats(pS224n,tp);
    
    %
    TRISE_pS224n(i) = model_predictions_pS224n.trise; %response time

    SS_pS224n(i) = model_predictions_pS224n.ss; %steady state

    DT_pS224n(i) = model_predictions_pS224n.dead_time; %dead time

    TAU_pS224n(i) = model_predictions_pS224n.tau; %time constant

    DY_pS224n(i) = model_predictions_pS224n.dely; %peak height relative to ss

    OS_pS224n(i) = model_predictions_pS224n.overshoot; %overshoot

    [Do,gmapprox,isnull] = calc_goodness_of_fit_metrics(all_Smad2n,10.^plot_sets(i,:),i);
    
    % if ~isnull
    isnull_(i) = isnull;
    PU(i) = Do;
    GM(i) = gmapprox;
    figure(ff)
    hold on
    if i == 18
       plot(tf,all_Smad2n,'LineWidth',5,'Color','magenta') 
       
    else
       plot(tf,all_Smad2n,'LineWidth',0.5,'Color',[0.6 0.6 0.6])

    end

    figure(fp)
    hold on
    if i == 18 %parameter set in magenta
        plot(tp,pS224n,'LineWidth',5,'Color','magenta')
        hold on
        yline(SS_pS224n(2))
        xline(TRISE_pS224n(2))
        xline(DT_pS224n(2))
        xline(TAU_pS224n(2))
    else
        plot(tp,pS224n,'LineWidth',0.5,'Color',[0.6 0.6 0.6])
    end
    % end
    
end
% CV_BM = calc_CV(BM);
CV_trise = calc_CV(TRISE_pS224n);
CV_SS = calc_CV(SS_pS224n);
CV_DT = calc_CV(DT_pS224n);
CV_TAU = calc_CV(TAU_pS224n);
CV_DY = calc_CV(DY_pS224n);
CV_OS = calc_CV(OS_pS224n);

PU_ = PU(~isnull_);
GM_ = GM(~isnull_);

figure(ff)
ylim([25 75])
xlabel('time [min]')
ylabel('SMAD2-EGFP [nM]')
set(gca,'FontSize',8,'FontName','Arial')
% exportgraphics(ff,['Fits','.eps'],'ContentType','vector')

figure(fp)
xticks(0:20:100)
xlabel('time [min]')
ylabel('(pSMAD2)_2/pSMAD4 [nM]')
set(gca,'FontSize',8,'FontName','Arial')
% exportgraphics(fp,['Predictions','.eps'],'ContentType','vector')

%% Plot prediction stats
%trise
fhist_trise = figure(4);
fhist_trise.Units = 'inches';
fhist_trise.Position(3:4) = [2 2]; %W,H
hold on
histogram(TRISE_pS224n,'Normalization','probability','NumBins',10)
xline(mean(TRISE_pS224n))
xline(mean(TRISE_pS224n) + std(TRISE_pS224n),'--')
xline(mean(TRISE_pS224n) - std(TRISE_pS224n),'--')
xticks(0:10:40)

xlabel('Rise time [min]')
ylabel('pdf.')
set(gca,'FontSize',8,'FontName','Arial')
exportgraphics(fhist_trise,['RT','.eps'],'ContentType','vector')

%steady state
fhist_SS = figure(5);
fhist_SS.Units = 'inches';
fhist_SS.Position(3:4) = [2 2]; %W,H

hold on
histogram(SS_pS224n,'Normalization','probability','NumBins',10)
xline(mean(SS_pS224n))
xline(mean(SS_pS224n) + std(SS_pS224n),'--')
xline(mean(SS_pS224n) - std(SS_pS224n),'--')
xticks(0:10:40)

xlabel('steady state [nM]')
ylabel('pdf.')
set(gca,'FontSize',8,'FontName','Arial')
exportgraphics(fhist_SS,['SS','.eps'],'ContentType','vector')

% tau time constant

fhist_tau = figure(6);
fhist_tau.Units = 'inches';
fhist_tau.Position(3:4) = [2 2]; %W,H
hold on
histogram(TAU_pS224n,'Normalization','probability','NumBins',10)
xline(mean(TAU_pS224n))
xline(mean(TAU_pS224n) + std(TAU_pS224n),'--')
xline(mean(TAU_pS224n) - std(TAU_pS224n),'--')
% xticks(0:10:40)

xlabel('time constant [min]')
ylabel('pdf.')
set(gca,'FontSize',8,'FontName','Arial')
exportgraphics(fhist_tau,['TC','.eps'],'ContentType','vector')

%deadtime DT

fhist_deadtime = figure(7);
fhist_deadtime.Units = 'inches';
fhist_deadtime.Position(3:4) = [2 2]; %W,H
hold on
histogram(DT_pS224n,'Normalization','probability','NumBins',10)
xline(mean(DT_pS224n))
xline(mean(DT_pS224n) + std(DT_pS224n),'--')
xline(mean(DT_pS224n) - std(DT_pS224n),'--')
% xticks(0:10:40)

xlabel('Dead time [min]')
ylabel('pdf.')
set(gca,'FontSize',8,'FontName','Arial')
exportgraphics(fhist_deadtime,['DT','.eps'],'ContentType','vector')

%overshoot
fhist_overshoot = figure(8);
fhist_overshoot.Units = 'inches';
fhist_overshoot.Position(3:4) = [2 2]; %W,H
hold on
histogram(OS_pS224n,'Normalization','probability','NumBins',10)
xline(mean(OS_pS224n))
xline(mean(OS_pS224n) + std(OS_pS224n),'--')
xline(mean(OS_pS224n) - std(OS_pS224n),'--')
xlim([-0.1 0.3])
% xticks(0:10:40)

xlabel('Overshoot')
ylabel('pdf.')
set(gca,'FontSize',8,'FontName','Arial')
exportgraphics(fhist_overshoot,['OS','.eps'],'ContentType','vector')

%PU
fPU = figure(9);
fPU.Units = 'inches';
fPU.Position(3:4) = [2 2]; %W,H

hold on
histogram(log10(PU_),'Normalization','probability','NumBins',10)
xline(mean(log10(PU_)))
xline(mean(log10(PU_)) + std(log10(PU_)),'--')
xline(mean(log10(PU_)) - std(log10(PU_)),'--')
% xticks(0:10:40)

xlabel('log_{10} Parameter Uncertainty')
ylabel('pdf.')
set(gca,'FontSize',8,'FontName','Arial')
exportgraphics(fPU,['PU','.eps'],'ContentType','vector')
%GM
fGM = figure(10);
fGM.Units = 'inches';
fGM.Position(3:4) = [2 2]; %W,H

hold on
histogram(log10(GM_),'Normalization','probability','NumBins',10)
xline(mean(log10(GM_)))
xline(mean(log10(GM_)) + std(log10(GM_)),'--')
xline(mean(log10(GM_)) - std(log10(GM_)),'--')
% xticks(0:10:40)

xlabel('log_{10} Geometric Mean')
ylabel('pdf.')
set(gca,'FontSize',8,'FontName','Arial')
exportgraphics(fGM,['GM','.eps'],'ContentType','vector')
%% 
function [Do,gmapprox,isnull] = calc_goodness_of_fit_metrics(predictions,k,number)

%     pred = calc_model_profile(k,yesplot);
    Jo = preJac_Smad_v0(predictions,k);
    Io = transpose(Jo)*Jo; %approximate hessian
    Do = trace(inv(Io)); %parameter uncertainty
    isnull = 0;
    eigHapprox = eig(Io);

    if number == 18
        FEig = figure(11);
        FEig.Units = 'inches';
        FEig.Position(3:4) = [1 2]; %W,H
% hold on
        semilogy(1,eigHapprox,'magenta','LineStyle','none','Marker','_','MarkerSize',8)
        hold on
        semilogy(1,geomean(eigHapprox),'k','LineStyle','none','Marker','_','MarkerSize',8)
%         semilogy(i,min(deigH/max(deigH)),'b','LineStyle','none','Marker','_','MarkerSize',4)
        ylim([1e-3 1e14])
        yticks([1e-4 1e-2 1e0 1e2 1e4 1e6 1e8 1e10 1e12 1e14])
        xticklabels('')

%         title('Eigenvalues')
        set(gca,'FontSize',8)
        exportgraphics(FEig,['EigOne','.eps'],'ContentType','vector')
    end

    % eigHapprox(1:2,:) = [1e-20 1e-20];
    if all(eigHapprox > 0) 
        PDapprox = 1;
        gmapprox = geomean(eigHapprox);
        gm_min3_max3approx = geomean(eigHapprox(1:3))/geomean(eigHapprox(end-2:end));
        gm_min_maxapprox = min(eigHapprox)./max(eigHapprox);
    else
        i = 1;
        isnull = 1;
        PDapprox = 0;
        gmapprox = 0;
        % gm_min3_max3approx = [];
        % gm_min_maxapprox = [];
    end
end
%%
function J = preJac_Smad_v0(pred,k)


h = 1e-5;
J = zeros(length(pred),length(k));


for i = 1:length(k)
    
    k(i) = k(i) + h;
    [pred_h,~] = modelfits_predictions_Smadv0(k);
    J(:,i) = (pred_h - pred)'/h;
    k(i) = k(i) - h;
end

% J = transpose(J);
end

%% 
function f =  make_box_and_scatter(plot_sets,colorby,labelby,lb,ub,yeslog)

if ~exist("yeslog")
    yeslog = 0;
end




x = 1:size(plot_sets,2);

x1 = repmat(x,size(plot_sets,1),1);


boxchart(plot_sets,'Notch','on','BoxFaceColor',[0.6 0.6 0.6],'MarkerColor','k','MarkerSize',2)

for i = 1:length(x)
    hold on
    swarmchart(i*ones(size(plot_sets,1),1),plot_sets(:,i),6,colorby,'filled')
end

for i = 1:length(x)
swarmchart(i,plot_sets(1,i),6,'magenta','filled')
end

if yeslog
    ax = gca;
    ax.YScale = 'log';
end

xticklabels(labelby)
xtickangle(0)
hold on
xint = [1 x(2:end-1) x(end) x(end) x(end-1:-1:2) 1];

yint = [lb(1:end) ub(end:-1:1)];
p1 = fill(xint,yint,[0.6 0.6 0.6]);
p1.FaceColor = [0.6 0.6 0.6];      
p1.EdgeColor = 'none'; 
p1.FaceAlpha = 0.2;
cb = colorbar;
cb.Location = 'eastoutside';

set(gca,'FontSize',8,'FontName','Arial')

end

function CV = calc_CV(x)

CV = std(x)/mean(x);

end