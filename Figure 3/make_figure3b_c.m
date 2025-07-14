function g = make_figure3b_c(thetac,number)

%load smad2,smad4 data
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


g = 1;
ff1 = figure(g);
ff1.Units = 'inches';
ff1.Position(3:4) = [2 2]; %W,H
errorbar([tspan1' tspan2'],[nuc_data' nuc_data_SB'],e,e,'Marker','.','LineStyle','none','Color',[0.6 0.6 0.6])



ff2 = figure(g+1);
ff2.Units = 'inches';
ff2.Position(3:4) = [2 2]; %W,H

tspan3 = t_smad4;
smad4data_avg = smad4_avg;
smad4data_std = smad4_std;

errorbar(t_smad4,smad4_avg,smad4_std,smad4_std,'.','Color',[0.6 0.6 0.6])

tf = 0:0.1:600;
tp = 0:0.1:150;
fp = figure(g+2);
fp.Units = 'inches';
fp.Position(3:4) = [2 2]; %W,H

for i = 1:size(thetac,1)

    try
        k = thetac(i,:);
        F(i) = objective_Smad_v0(log10(k));
        if F(i) < 1.6
            [all_Smad2n,all_Smad4n,pS224n] = modelfits_predictions_Smadv0(k);

            figure(ff1)
            hold on
            plot(tf,all_Smad2n,'LineWidth',0.5,'Color',[0.6 0.6 0.6])

            figure(ff2)
            hold on
            plot(0:0.1:300,all_Smad4n,"Color",[0.6 0.6 0.6])

            figure(fp)
            hold on
            plot(tp,pS224n,'LineWidth',0.5,'Color',[0.6 0.6 0.6])
        end

    end
end
figure(ff1)
axis('square')
xlabel('time [min]')
ylabel('SMAD2 [nM]')
set(gca,'FontSize',8,'FontName','Arial')
exportgraphics(ff1,[['FitsSmad2',num2str(number)],'.eps'],'ContentType','vector')
exportgraphics(ff1,[['FitsSmad2',num2str(number)],'.png'])

figure(ff2)
axis('square')
xlabel('time [min]')
ylabel('SMAD4 [nM]')
set(gca,'FontSize',8,'FontName','Arial')
exportgraphics(ff2,[['FitsSmad4',num2str(number)],'.eps'],'ContentType','vector')
exportgraphics(ff2,[['FitsSmad4',num2str(number)],'.png'])

figure(fp)
axis('square')
xlabel('time [min]')
ylabel('SC [nM]')
set(gca,'FontSize',8,'FontName','Arial')
exportgraphics(fp,[['Predictions',num2str(number)],'.eps'],'ContentType','vector')
exportgraphics(fp,[['Predictions',num2str(number)],'.png'])
close all
end