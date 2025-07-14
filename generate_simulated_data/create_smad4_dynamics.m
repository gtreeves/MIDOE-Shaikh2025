clc
clear
% close all

T = readtable("F3D.csv");
%tgfB1 = 5ng/mL
t_smad2 = T.smad2 * 60;
smad2 = T.Var2;

t_smad4 = rmmissing(T.smad4) * 60;
smad4 = rmmissing(T.Var4);


figure
plot(t_smad2,smad2,LineWidth=2)
hold on
plot(t_smad4,smad4,LineWidth=2)

xline(45/60)
xticks(0:50:600)
xlabel('time (min)')
ylabel('nuc.conc (a.u.)')
legend('Smad2','Smad4','')
set(gca,'FontSize',20,'FontName','Arial')

t_smad4_ = t_smad4;
smad4_ = smad4;

t_smad4 = [];
smad4 = [];

t_smad4 = t_smad4_(1:17);
smad4 = smad4_(1:17);

figure
plot(t_smad2,smad2,LineWidth=2)
hold on
plot(t_smad4,smad4,LineWidth=2)

xline(45/60)
xticks(0:50:600)
xlabel('time (min)')
ylabel('nuc.conc (a.u.)')
legend('Smad2','Smad4','')
set(gca,'FontSize',20,'FontName','Arial')

% at 45min nucSmad2 ~65nM (Schmierer2008)
nucSmad2_in_au = interp1(t_smad2,smad2,45);
smad2_nM = smad2*65/nucSmad2_in_au;
smad4_nM = smad4*65/nucSmad2_in_au;

figure
plot(t_smad2,smad2_nM,LineWidth=2)
hold on
plot(t_smad4,smad4_nM,LineWidth=2)
hold on
xline(45)

xlabel('time (min)')
ylabel('nuc.conc (nM)')
legend('Smad2','Smad4','')
set(gca,'FontSize',20,'FontName','Arial')
%% adjust smad4 to match its ICs to Schmierer
dS4 = 50.8 - smad4_nM(1);
smad4_nM_adjusted_ = smad4_nM + dS4;
% smad4_nM_adjusted_ = smooth(smad4_nM_adjusted);

figure
plot(t_smad4,smad4_nM_adjusted_,LineWidth=2)
%% manually introduce a delay
t_smad4(2:3) = [15 23];
%% add noise to Smad4
%based on Smad2 Schmierer data add random noise in the range +/-5
rng('default')
r = -5 + (5+5)*rand(17,20);
smad4_r = smad4_nM_adjusted_ + r;
figure;
plot(t_smad4,smad4_r,LineWidth=2)
smad4_avg = mean(smad4_r,2);
smad4_std = std(smad4_r,[],2);

figure
plot(t_smad4,smad4_avg)
hold on
errorbar(t_smad4,smad4_avg,smad4_std,smad4_std,'.')
smad4_avg = smad4_nM_adjusted_;

xlabel('time (min)')
ylabel('nuc.conc (nM)')
legend('Smad4','','')
set(gca,'FontSize',20,'FontName','Arial')

save("smad4_dynamics.mat",'smad4_avg',"smad4_std","t_smad4")