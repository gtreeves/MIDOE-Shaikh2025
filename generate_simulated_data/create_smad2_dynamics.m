clc
clear
close all

%% Load and process data Smad 2 Data from Warmflash
T = readtable("1C_tgfbonly.csv");
%tgfB1 = 5ng/mL
t_smad2 = T.Var1* 60; %hours
smad2 = T.Var2;

T_plusSB = readtable("1C_tgfbonly_SB.csv");
t_smad2_plusSB = T_plusSB.Var1 * 60; %hours; now mins
smad2_plusSB = T_plusSB.Var2;
%{
figure
plot(t_smad2,ipsmad2_,LineWidth=2)
hold on
plot(t_smad2_plusSB,ipsmad2_plusSB_,LineWidth=2)

xline(45/60)
xticks(0:50:600)
xlabel('time (h)')
ylabel('nuc.conc (a.u.)')
legend('+TGF_{\beta}','+TGF_{\beta} +SB(+1h)','')
set(gca,'FontSize',20,'FontName','Arial')
%}
T = readtable("F3D.csv");
% %tgfB1 = 5ng/mL
% t_smad2_F3D = rmmissing(T.smad2) * 60; %mins
% smad2_F3D = rmmissing(T.Var2);

t_smad4_F3D = rmmissing(T.smad4) * 60; %mins
smad4_F3D = rmmissing(T.Var4);

figure
% plot(t_smad2_F3D,smad2_F3D,LineWidth=2)
hold on
plot(t_smad4_F3D,smad4_F3D,LineWidth=2)
% plot(t_smad2,smad2,LineWidth=2)
plot(t_smad2_plusSB,smad2_plusSB,LineWidth=2)

%% normalize smad2_plusSB by max 

norm_smad2_plusSB = smad2_plusSB./max(smad2_plusSB);

figure
plot(t_smad2_plusSB,norm_smad2_plusSB,LineWidth=2)

%% assume that max = 65 nM (Schmierer2008)

cali_norm_smad2_plusSB = norm_smad2_plusSB*65;

figure
plot(t_smad2_plusSB,cali_norm_smad2_plusSB,LineWidth=2)

%% add noise to cali_norm_smad2_plusSB
%based on Smad2 Schmierer data add random noise in the range +/-5

rng('default')
r = -5 + (5+5)*rand(length(cali_norm_smad2_plusSB),59);
smad2_r = cali_norm_smad2_plusSB + r;
figure;
plot(t_smad2_plusSB,smad2_r,LineWidth=2)
smad2_avg = mean(smad2_r,2);
smad2_std = std(smad2_r,[],2);

figure
plot(t_smad2_plusSB,smad2_avg)
hold on
errorbar(t_smad2_plusSB,smad2_avg,smad2_std,smad2_std,'.')
smad4_avg = cali_norm_smad2_plusSB;

xlabel('time (min)')
ylabel('nuc.conc (nM)')
legend('Smad2','','')
set(gca,'FontSize',20,'FontName','Arial')

save("smad2_dynamics_WF.mat",'smad2_avg',"smad2_std","t_smad2_plusSB")