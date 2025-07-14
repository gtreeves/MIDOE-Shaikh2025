clc
clear
close all

T = readtable("data_psuedo_manifold.csv");
T1 = T(2:end,13:19);

F1 = figure;
F1.Units = 'inches';
F1.Position(3:4) = [2.5 2.5]; %W,H

% c(1) = cdfplot(T1.REP_cCV_all_1); %CV_BM
hold on
c(1) = cdfplot(100*T1.REP_cCV_all_4); %CV_DT
c(2) = cdfplot(100*T1.REP_cCV_all_5); %CV_TAU
c(3) = cdfplot(100*T1.REP_cCV_all_2); %CV_trise
c(4) = cdfplot(100*T1.REP_cCV_all_3); %CV_SS
c(5) = cdfplot(100*T1.REP_cCV_all_7); %CV_OS
xline(0.087,'-',{'DT'})
xline(0.166,'-',{'TC'})
xline(0.309,'-',{'RT'})
xline(0.329,'-',{'SS'})
xline(2.303,'-',{'OS'})
ax = gca;
ax.XScale = 'log';
xlim([1e-4 1e1])
legend('Dead Time','Time Constant','Rise Time','Steady State','Overshoot')
set(c,'Linewidth',1.5)
title('')
xlabel('coeff. of var')
ylabel('probability')
set(gca,'FontSize',8,'FontName','Arial')
exportgraphics(F1,['analyzeCV1','.eps'],'ContentType','vector')


F2 = figure;
F2.Units = 'inches';
F2.Position(3:4) = [2.5 2.5]; %W,H

% c(1) = cdfplot(T1.REP_cCV_all_1); %CV_BM
hold on
c(1) = cdfplot(100*T1.REP_cCV_all_4./0.087); %CV_DT
c(2) = cdfplot(100*T1.REP_cCV_all_5./0.166); %CV_TAU
c(3) = cdfplot(100*T1.REP_cCV_all_2./0.309); %CV_trise
c(4) = cdfplot(100*T1.REP_cCV_all_3./0.329); %CV_SS
c(5) = cdfplot(100*T1.REP_cCV_all_7./2.303); %CV_OS
% xline(0.087,'-',{'DT'})
% xline(0.166,'-',{'TC'})
% xline(0.309,'-',{'RT'})
% xline(0.329,'-',{'SS'})
% xline(2.303,'-',{'OS'})
ax = gca;
% ax.XScale = 'log';
% xlim([1e-4 1e1])
legend('Dead Time','Time Constant','Rise Time','Steady State','Overshoot')
set(c,'Linewidth',1.5)
title('')
xlabel('coeff. of var')
ylabel('probability')
set(gca,'FontSize',8,'FontName','Arial')
exportgraphics(F1,['analyzeCV2','.eps'],'ContentType','vector')