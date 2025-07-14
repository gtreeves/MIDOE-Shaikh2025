clc
clear
close all


filename = 'Smad_v3';
load([filename,'.mat'],'dat')
%%
for i=1:length(dat)
    XB_(:,i) = dat(i).xb;
    BM_(i) = dat(i).BestMin;
end
BM  = BM_(BM_<2);
XB = XB_(:,BM_<2); 
%% Load data to EGFP-Smad2

load("smad2_dynamics_WF.mat")


time = t_smad2_plusSB;
tspan1 = time(time<60); tspan2 = time(time>60);

e = smad2_std;
errorbar_left = e(time<60); errorbar_right = e(time>60);
% cyt_data = data.cyt_data;
% cyt_data_SB = data.cyt_data_SB;
nuc_data = smad2_avg(time<60);
nuc_data_SB = smad2_avg(time>60);

%% Load RFP-Smad4 data Warmflash2012 https://doi.org/10.1073/pnas.1207607109

load("smad4_dynamics.mat")
tspan3 = t_smad4;
smad4data_avg = smad4_avg;
smad4data_std = smad4_std;

%% Load RFP-Smad4 data Warmflash2012 https://doi.org/10.1073/pnas.1207607109

load("v9.mat") %trimer data
tspan3 = stf;
strimerdata_avg = strimer_avg;
strimerdata_std = strimer_std;


% initial conditions
R = 1;
TGFb = 0.066*5/2;
Ract = 0;
Rinact = 0;
SB = 1000;
S2c = 60.6;
S2n = 28.5;
pS2c = 0;
pS2n = 0;
S4c = 50.8;
S4n = 50.8;
pS22c = 0;
pS22n = 0;
pS24c = 0;
pS24n = 0;
pS224c = 0;
pS224n = 0; %--nuc. trimer
% ES2c = 60.6;
% ES2n = 28.5; %nuc. EGFP-SMAD2
% EpS2c = 0;
% EpS2n = 0; %nuc. EGFP-SMAD2
% EpS2cEpS2c = 0;
% EpS2nEpS2n = 0; %2*nuc. EGFP-SMAD2
% EpS2cpS2c = 0;
% EpS2npS2n = 0; %nuc. EGFP-SMAD2
% EpS2cS4c = 0;
% EpS2nS4n = 0; %nuc. EGFP-SMAD2
% EpS2cEpS2cS4c = 0;
% EpS2nEpS2nS4n = 0; %2*nuc. EGFP-SMAD2
% EpS2cpS2cS4c = 0;
% EpS2npS2nS4n = 0; %nuc. EGFP-SMAD2 %--nuc. trimer

y0 = [R TGFb Ract Rinact SB S2c S2n pS2c pS2n S4c S4n pS22c pS22n pS24c pS24n pS224c pS224n];

%%
for i=1:length(BM)
    ka  = XB(:,i);
    %% Calc errors
    %
    % EGFP-Smad2 nuclear concentrations
    %
    % y0(2) = 0.066; y0(5) = 1000;
    sol = ode15s(@Model_before_SB,0:0.1:150,y0,[],ka);
    %         if max(sol.x) < 45
    %             error('ode15s failed')
    %         end
    Yn = (deval(sol,0:0.1:60))';
    
    % y0(2) = 0.066; y0(5) = 1000;
    sol_SB = ode15s(@Model_after_SB,60.1:0.1:600,Yn(end,:),[],ka);
    %         if max(sol_SB.x) < 150
    %             error('ode15s failed')
    %         end
    Yn_SB = (deval(sol_SB,60.1:0.1:600))';

    Smad2n(:,i) = (Yn(:,7) + Yn(:,9) +2*Yn(:,13) +Yn(:,15) +2*Yn(:,17))';
    Smad2n_SB(:,i) = (Yn_SB(:,7) + Yn_SB(:,9) +2*Yn_SB(:,13) +Yn_SB(:,15) +2*Yn_SB(:,17))';
    Smad2_total(:,i) = (Yn(:,6)+Yn(:,7)+Yn(:,8)+Yn(:,9)+2*Yn(:,12)+2*Yn(:,13)+Yn(:,14)+Yn(:,15)+2*Yn(:,16)+2*Yn(:,17))';
    pSmad2_total(:,i) = (Yn(:,8)+Yn(:,9)+2*Yn(:,12)+2*Yn(:,13)+Yn(:,14)+Yn(:,15)+2*Yn(:,16)+2*Yn(:,17))';
    Smad2_total_SB(:,i) = (Yn_SB(:,6)+Yn_SB(:,7)+Yn_SB(:,8)+Yn_SB(:,9)+2*Yn_SB(:,12)+2*Yn_SB(:,13)+Yn_SB(:,14)+Yn_SB(:,15)+2*Yn_SB(:,16)+2*Yn_SB(:,17))';
    pSmad2_total_SB(:,i) = (Yn_SB(:,8)+Yn_SB(:,9)+2*Yn_SB(:,12)+2*Yn_SB(:,13)+Yn_SB(:,14)+Yn_SB(:,15)+2*Yn_SB(:,16)+2*Yn_SB(:,17))';
    % Smad2n_all(:,i) = [Smad2n Smad2n_SB]';
    
    TRI = (deval(sol,0:0.1:150))';
    trimer(:,i) = (TRI(:,17))';
    %
    % EGFP-Smad2 cytoplasmic concentrations
    %
    % [~,Yc] = ode15s(@(t,y)diffun(t,y,ka),tspan1,y0);
    % [~,Yc_SB] = ode15s(@(t,y)diffunSB(t,y,ka),tspan2,Yc(end,:));
    %
    % Smad2c = (Yc(:,7) + Yc(:,9) + Yc(:,12) +Yc(:,14) +2*Yc(:,15))';
    % Smad2c_SB = (Yc_SB(:,7) + Yc_SB(:,9) + Yc_SB(:,12) +Yc_SB(:,14) +2*Yc_SB(:,15))';

    % error_all_Smad2n(i) = sum(((Smad2n - nuc_data)./errorbar_left).^2,'all')+sum(((Smad2n_SB - nuc_data_SB)./errorbar_right).^2,'all');
%{
    figure
    plot(tspan1,Smad2n);hold on; plot(tspan1,nuc_data)

    figure
    plot(tspan2,Smad2n_SB);hold on; plot(tspan2,nuc_data_SB)
    %}
    %% smad4
    %{
    % y0(2) = 0.066*5/2; y0(5) = 0;
    solSmad4 = ode15s(@Smad_model_trimer_screen_smad4,0:0.1:500,y0,[],ka);
    %         if max(sol.x) < 45
    %             error('ode15s failed')
    %         end
    YnSmad4 = (deval(solSmad4,0:0.1:300))';
    Smad4nuc(:,i) = (YnSmad4(:,11) + YnSmad4(:,15) + YnSmad4(:,17))';
    % error_all_Smad4n(i) = sum(((Smad4nuc - smad4data_avg)./smad4data_std).^2,'all');
    % error_all_Smadc = sum(((Smad2c - cyt_data)./errorbar_left).^2,'all')+sum(((Smad2c_SB - cyt_data_SB)./errorbar_right).^2,'all');
    %{
    figure
    plot(t_smad4,Smad4nuc);hold on; plot(t_smad4,smad4_avg)
    %}
    %
    %     catch ME
    %         disp(ME)
    %         error_all_Smadn = 1e6;
    %     end
    %pSmad24n complex
    %
    % Smad24n_calc = calc_Smad24n(ka);
    % error_Smad_complex = sum(((Smad24n_calc - Smad24n)./sd).^2,'all');
    %}
    
    %% coLoc expt
    % solcoLoc = ode15s(@Smad_model_trimer_screen_smad4,0:0.1:45,y0,[],ka);
    % %         if max(sol.x) < 45
    % %             error('ode15s failed')
    % %         end
    % YncoLoc = (deval(solcoLoc,tspan3))';
    % coLoc = (YncoLoc(:,15) +YncoLoc(:,17));
    % 
    % error_all_coLoc = sum(((coLoc - stcoLocdata_avg)./stcoLocdata_std).^2,'all');
    %% Calc error
    % F(i) =  (error_all_Smad2n + error_all_Smad4n)/2;% + error_Smad_complex;%+ sum((ycalc_e(:,:,i) - yvalse).^2) + sum((ycalc_f(:,:,i) - yvalsf).^2);
end
%%

FParams = figure(1);
FParams.Units = 'inches';
FParams.Position(3:4) = [2.5 2.5]; %W,H
set(gca,'FontSize',8,'FontName','Arial')

lb(1,:)       = 1e-4*ones(1,10);
ub(1,:) = 1e3*ones(1,10);
lu = [lb;ub];
% lb(1,:)       = 1e-4*ones(1,10);
% ub(1,:) = [0.1 100 1e4 1 1 1e3 1 10 1 1e4];
% lu = [lb;ub];


make_box_and_scatter(log10(XB'),BM,{'k_{TGF \beta}','k_{phos}','k_{onSB}','k_{on}','k_{dephos}','CIF','k_{in}','k_{ex}','k_{off}','k_{offSB}'},log10(lb),log10(ub))

xtickangle(90)
yticks(-4:1:3)
axis('square')

FSmad2 = figure(2);
FSmad2.Units = 'inches';
FSmad2.Position(3:4) = [2 2]; %W,H
xticks(0:100:600)
xtickangle(0)
set(gca,'FontSize',8,'FontName','Arial')

Ftrimer = figure(3);
Ftrimer.Units = 'inches';
Ftrimer.Position(3:4) = [2 2]; %W,H
xticks(0:25:150)
xtickangle(0)
set(gca,'FontSize',8,'FontName','Arial')



for i=1:length(BM)
% i = 1;


figure(FSmad2)
% nexttile(2)
hold on
plot(0:0.1:60,Smad2n(:,i),"Color",'k');hold on;plot(60.1:0.1:600,Smad2n_SB(:,i),"Color",'k');hold on; 
%plot(tspan1,nuc_data,'k');hold on; plot(tspan2,nuc_data_SB,'k');
errorbar([tspan1' tspan2'],[nuc_data' nuc_data_SB'],e,e,'Marker','.','LineStyle','none','Color','g')
% xticks(0:25:150)
axis('square')
xlabel('time [min]')
ylabel('SMAD2-EGFP [nM]')
set(gca,'FontSize',8,'FontName','Arial')

% nexttile(3)
% hold on
% % plot(0:0.1:300,Smad4nuc(:,i),"Color",'k');hold on; 
% % % plot(t_smad4,smad4_avg,'k');
% % % hold on 
% % errorbar(t_smad4,smad4_avg,smad4_std,smad4_std,'.','Color',[0.6 0.6 0.6])
% % % xticks(0:50:300)
% % axis('square')
% % xlabel('time [min]')
% % ylabel('SMAD4-EGFP [nM]')
% % set(gca,'FontSize',8,'FontName','Arial')
% 
% plot(stf,coLoc,"Color",'k')
% errorbar(stf,stcoLocdata_avg,stcoLocdata_std,stcoLocdata_std,'Marker','.','LineStyle','none','Color',[0.6 0.6 0.6])
% axis('square')
% xlabel('time [min]')
% ylabel('coLoc [nM]')
% set(gca,'FontSize',8,'FontName','Arial')
figure(Ftrimer)
% nexttile(4)
hold on
% x = 0:0.1:60;
errorbar(stf,strimerdata_avg,strimerdata_std,strimerdata_std,'Marker','.','LineStyle','none','Color','g')
plot(0:0.1:150,trimer,'Color','k')
% xticks(0:10:50)
axis('square')

xlabel('time [min]')
ylabel('SC [nM]')
set(gca,'FontSize',8,'FontName','Arial')


end
% title(t,filename)
% set(gca,'FontSize',8,'FontName','Arial')
% exportgraphics(F4,[filename,'.eps'],'ContentType','vector')
exportgraphics(FParams,[filename,'_params','.eps'],'ContentType','vector')
exportgraphics(FSmad2,[filename,'_smad2','.eps'],'ContentType','vector')
% exportgraphics(FSmad4,[filename,'_smad4','.eps'],'ContentType','vector')
exportgraphics(Ftrimer,[filename,'_trimer','.eps'],'ContentType','vector')
%%
% figure
% for i=1:length(BM)
%     hold on
%     plot(0:0.1:45,pSmad2_total(:,i)./Smad2_total(:,i),"Color",'k');hold on;plot(45.1:0.1:150,pSmad2_total_SB(:,i)./Smad2_total_SB(:,i),"Color",'k');hold on;
% 
% end
%%
%{
figure;boxchart(XB');
ax=gca;
ax.YScale = 'log';

hold on
% lb(1,:)       = 1e-4*ones(1,10);
% ub(1,:) = 1e3*ones(1,10);
% lu = [lb;ub];
lb(1,:)       = 1e-4*ones(1,10);
ub(1,:) = [0.1 100 1e4 1 1 1e3 1 10 1 1e4];
lu = [lb;ub];
x = 1:size(XB',2);
xint = [1 x(2:end-1) x(end) x(end) x(end-1:-1:2) 1];

yint = [lb(1:end) ub(end:-1:1)];
p1 = fill(xint,yint,[0.6 0.6 0.6]);
p1.FaceColor = [0.6 0.6 0.6];      
p1.EdgeColor = 'none'; 
p1.FaceAlpha = 0.2;

%}
%%
calc_CV(trimer(end,:))
%%
function CV = calc_CV(x)

CV = std(x)/mean(x);

end
%%
function f =  make_box_and_scatter(plot_sets,colorby,labelby,lb,ub,yeslog)

if ~exist("yeslog")
    yeslog = 0;
end




x = 1:size(plot_sets,2);
% X = {'1','2','3','4','5','6','7','8'};
% X = categorical(X);
% T = [x' plot_sets'];
% T = array2table(T);
x1 = repmat(x,size(plot_sets,1),1);
% BMrep = repmat(BM,1,length(BM));
% boxchart(plot_sets)

boxchart(plot_sets,'Notch','on','BoxFaceColor',[0.6 0.6 0.6],'MarkerColor','k','MarkerSize',2)

for i = 1:length(x)
    hold on
    swarmchart(i*ones(size(plot_sets,1),1),plot_sets(:,i),3,colorby,'filled')
end
if yeslog
    ax = gca;
    ax.YScale = 'log';
end

xticklabels(labelby)
xtickangle(0)
hold on
xint = [1 x(2:end-1) x(end) x(end) x(end-1:-1:2) 1];
% lb = [1e-2*ones(1,14) 1e-2*ones(1,2) 1e2*ones(1,4)];
% ub = [1e2*ones(1,14) 1e1*ones(1,2) 1e4*ones(1,4)];
yint = [lb(1:end) ub(end:-1:1)];
p1 = fill(xint,yint,[0.6 0.6 0.6]);
p1.FaceColor = [0.6 0.6 0.6];      
p1.EdgeColor = 'none'; 
p1.FaceAlpha = 0.2;
cb = colorbar;
cb.Location = 'southoutside';
% cb.Position(3:4) = [6 0.2];
% cb.Label.String = 'Error';
set(gca,'FontSize',8,'FontName','Arial')

end