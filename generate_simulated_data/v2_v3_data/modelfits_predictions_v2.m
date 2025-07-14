function [all_Smad2n,pS224nuc,all_fits] = modelfits_predictions_v2(xb,data)

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


% initial conditions
R = 1;
TGFb = 0.066;
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
yp0 = zeros(1,length(y0));
% [y0,yp0] = decic(@(t,y)Smad_model_trimer(t,y,xb),0,y0,1,yp0,0);
sol = ode15s(@Model_before_SB,0:0.1:120,y0,[],xb);
%         if max(sol.x) < 45
%             error('ode15s failed')
%         end
Yn = (deval(sol,0:0.1:45))';

sol_SB = ode15s(@Model_after_SB,45:0.1:150,Yn(end,:),[],xb);
%         if max(sol_SB.x) < 150
%             error('ode15s failed')
%         end
Yn_SB = (deval(sol_SB,45.1:0.1:150))';

Smad2n = (Yn(:,7) + Yn(:,9) +2*Yn(:,13) +Yn(:,15) +2*Yn(:,17))';
Smad2n_SB = (Yn_SB(:,7) + Yn_SB(:,9) +2*Yn_SB(:,13) +Yn_SB(:,15) +2*Yn_SB(:,17))';
all_Smad2n = [Smad2n Smad2n_SB]; %model fit

YnT = (deval(sol,0:0.1:100))';
pS224nuc = YnT(:,17)'; %model prediction
all_fits = [Yn;Yn_SB];
% f1 = figure;
% plot(0:0.1:150,all_Smad2n,'LineWidth',2)
% hold on
% errorbar([tspan1' tspan2'],[nuc_data nuc_data_SB],errorbar_lower-[nuc_data nuc_data_SB],errorbar_upper-[nuc_data nuc_data_SB],'Marker','o','LineStyle','none')
% axis equal



end

