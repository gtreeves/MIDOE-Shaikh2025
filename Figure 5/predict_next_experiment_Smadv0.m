function [all_Smad4n,allSmad2_Smad4nuc,pS224nuc,all_fits] = predict_next_experiment_Smadv0(xb)

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

load("smad4_dynamics_4.mat")
tspan3 = t_smad4;
smad4data_avg = smad4_avg;
smad4data_std = smad4_std;

%% initial conditions
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

y0 = [R TGFb Ract Rinact SB S2c S2n pS2c pS2n S4c S4n pS22c pS22n pS24c pS24n pS224c pS224n];

% yp0 = zeros(1,length(y0));
% [y0,yp0] = decic(@(t,y)Smad_model_trimer(t,y,xb),0,y0,1,yp0,0);
sol = ode15s(@Smad_model_trimer_screen_smad4,0:0.1:300,y0,[],xb);
%         if max(sol.x) < 45
%             error('ode15s failed')
%         end
Yn = (deval(sol,0:0.1:300))';

% sol_SB = ode15s(@Smad_model_trimer_SB,45:0.1:150,Yn(end,:),[],xb);
%         if max(sol_SB.x) < 150
%             error('ode15s failed')
%         end
% Yn_SB = (deval(sol_SB,45.1:0.1:150))';

% Smad2n = (Yn(:,19) + Yn(:,21) +2*Yn(:,23) +Yn(:,25) +Yn(:,27) +2*Yn(:,29)+Yn(:,31))';
% Smad2n_SB = (Yn_SB(:,19) + Yn_SB(:,21) +2*Yn_SB(:,23) +Yn_SB(:,25) +Yn_SB(:,27) +2*Yn_SB(:,29)+Yn_SB(:,31))';
% all_Smad2n = [Smad2n Smad2n_SB]; %model fit
%11 15 17 27 29 31
all_Smad4n = (Yn(:,11) + Yn(:,15) + Yn(:,17))';
 % all Smad2 & 4
allSmad2_Smad4nuc = (Yn(:,15) + Yn(:,17))';

pS224nuc = Yn(:,17)'; %model prediction

% all_fits = [Yn;Yn_SB];
% f1 = figure;
% plot(0:0.1:150,all_Smad2n,'LineWidth',2)
% hold on
% errorbar([tspan1' tspan2'],[nuc_data nuc_data_SB],errorbar_lower-[nuc_data nuc_data_SB],errorbar_upper-[nuc_data nuc_data_SB],'Marker','o','LineStyle','none')
% axis equal



end

