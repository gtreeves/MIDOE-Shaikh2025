clc
clear
close all

%load data
load("2025-01-31-db_v0.mat")
%add model path
load("data.mat")
load("smad4_dynamics.mat")
%% Load parameter sets
for i =1:length(dat)
    XB(i,:) = dat(i).xb;
    BM(i) = dat(i).BestMin;
end

lb(1,:) = 1e-4*ones(1,10);
ub(1,:) = 1e3*ones(1,10);
lu = [lb;ub];

plot_BM = BM(BM<1);
plot_sets = log10(XB(BM<1,:));

errorbar_lower = (data.errorbar_lower)';
errorbar_upper = (data.errorbar_upper)';
e = errorbar_upper - errorbar_lower;
errorbar_left = e(1:15); errorbar_right = e(16:end);

time = data.time;
tspan1 = time(1:15); tspan2 = time(16:end);

Smad24n = data.Smad24n;
sd = data.Smad24nSD;

% cyt_data = data.cyt_data;
% cyt_data_SB = data.cyt_data_SB;
nuc_data = (data.nuc_data)';
nuc_data_SB = (data.nuc_data_SB)';

% errorbar([tspan1' tspan2'],[nuc_data nuc_data_SB],errorbar_lower-[nuc_data nuc_data_SB],errorbar_upper-[nuc_data nuc_data_SB],'Marker','o','LineStyle','none','Color','k')

tf = 0:0.1:150;
tp = 0:0.1:45;
f1 = figure(1);
f2 = figure(2);
f3 = figure(3);

for i = [73 74 75 76 77 78 79 80] 
    %1:size(plot_sets,1)

    [all_Smad2n,pS224n,all_fits] = modelfits_predictions_v2(10.^plot_sets(i,:),data);

    coLoc = all_fits(:,[15 17]);
    tcoLoc = sum(coLoc,2);
    Smad2all = [all_fits(:,6:9) 2*all_fits(:,12:17)];
    tSmad2all = sum(Smad2all,2);
    pSmad2all = [all_fits(:,12:15) ,2*all_fits(:,16:17)];
    tpSmad2all = sum(pSmad2all,2);
    % plot(tf(tf<45),tpSmad2all(tf<45)./tSmad2all(tf<45))

    figure(f1)
    hold on
    plot(tf,tpSmad2all./tSmad2all)

    figure(f2)
    hold on
    plot(tf(tf<45),tcoLoc(tf<45))

    figure(f3)
    hold on
    plot(tf(tf<45),all_fits(tf<45,17))

% %     plot(tp,pS224n)
%     % model_predictions_pS224n = calc_prediction_stats_v2(pS224n,tp);
%     a = tpSmad2all(tf == 45)./tSmad2all(tf == 45);
%     if (a < 0.3) && (a > 0.2)
%         i
%     end
end

figure(f1)
xlabel('time [min]')
ylabel('frac. Phos')

figure(f2)
xlabel('time [min]')
ylabel('nuc. coLuc [nM]')

figure(f3)
xlabel('time [min]')
ylabel('nuc. trimer [nM]')
%%
stcoLoc = tcoLoc(tf<45.1);
strimer = all_fits(tf<45.1,17);
stf = 5:2.5:45;
istcoLoc = interp1(tf(tf<45.1)',stcoLoc,stf');
istrimer = interp1(tf(tf<45.1)',strimer,stf');
%% add noise to Smad4
%based on Smad2 Schmierer data add random noise in the range +/-5
rng('default')
r = -5 + (5+5)*rand(17,20);
stcoLoc_r = istcoLoc + r;
figure;
plot(stf,stcoLoc_r,LineWidth=2)
stcoLoc_avg = mean(stcoLoc_r,2);
stcoLoc_std = std(stcoLoc_r,[],2);

figure
plot(stf,stcoLoc_avg)
hold on
errorbar(stf,stcoLoc_avg,stcoLoc_std,stcoLoc_std,'.')
% smad4_avg = smad4_nM_adjusted_;

xlabel('time (min)')
ylabel('nuc.conc (nM)')
legend('coLoc','','')
set(gca,'FontSize',20,'FontName','Arial')

%%
rng('default')
r = -1.5 + (1.5+1.5)*rand(17,20);
strimer_r = istrimer + r;
figure;
plot(stf,strimer_r,LineWidth=2)
strimer_avg = mean(strimer_r,2);
strimer_std = std(strimer_r,[],2);

figure
plot(stf,strimer_avg)
hold on
strimer_std(1:3,:) = [0.2 0.5 0.4];
errorbar(stf,strimer_avg,strimer_std,strimer_std,'.')
% smad4_avg = smad4_nM_adjusted_;

xlabel('time (min)')
ylabel('nuc.conc (nM)')
legend('trimer','','')
set(gca,'FontSize',20,'FontName','Arial')

