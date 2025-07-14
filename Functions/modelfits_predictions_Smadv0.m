function [all_Smad2n,all_Smad4n,pS224nuc] = modelfits_predictions_Smadv0(xb)

%% Load data to Smad2

load("smad2_dynamics_WF.mat")

time = t_smad2_plusSB;
tspan1 = time(time<60); tspan2 = time(time>60);

e = smad2_std;
errorbar_left = e(time<60); errorbar_right = e(time>60);
% cyt_data = data.cyt_data;
% cyt_data_SB = data.cyt_data_SB;
nuc_data = smad2_avg(time<60);
nuc_data_SB = smad2_avg(time>60);


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

sol = ode15s(@Model_before_SB,0:0.1:300,y0,[],xb);
Yn = (deval(sol,0:0.1:60))';


sol_SB = ode15s(@Model_after_SB,60.1:0.1:600,Yn(end,:),[],xb);
Yn_SB = (deval(sol_SB,60.1:0.1:600))';

YnSmad4 = (deval(sol,0:0.1:300))';
YnTrimer = (deval(sol,0:0.1:150))';

Smad2n = (Yn(:,7) + Yn(:,9) +2*Yn(:,13) +Yn(:,15) +2*Yn(:,17))';
Smad2n_SB = (Yn_SB(:,7) + Yn_SB(:,9) +2*Yn_SB(:,13) +Yn_SB(:,15) +2*Yn_SB(:,17))';
Smad2_total = (Yn(:,6)+Yn(:,7)+Yn(:,8)+Yn(:,9)+2*Yn(:,12)+2*Yn(:,13)+Yn(:,14)+Yn(:,15)+2*Yn(:,16)+2*Yn(:,17))';
pSmad2_total = (Yn(:,8)+Yn(:,9)+2*Yn(:,12)+2*Yn(:,13)+Yn(:,14)+Yn(:,15)+2*Yn(:,16)+2*Yn(:,17))';
Smad2_total_SB = (Yn_SB(:,6)+Yn_SB(:,7)+Yn_SB(:,8)+Yn_SB(:,9)+2*Yn_SB(:,12)+2*Yn_SB(:,13)+Yn_SB(:,14)+Yn_SB(:,15)+2*Yn_SB(:,16)+2*Yn_SB(:,17))';
pSmad2_total_SB = (Yn_SB(:,8)+Yn_SB(:,9)+2*Yn_SB(:,12)+2*Yn_SB(:,13)+Yn_SB(:,14)+Yn_SB(:,15)+2*Yn_SB(:,16)+2*Yn_SB(:,17))';
Smad4nuc = (YnSmad4(:,11) + YnSmad4(:,15) + YnSmad4(:,17))';

all_Smad2n = [Smad2n Smad2n_SB];
all_Smad4n = Smad4nuc;
pS224nuc = (YnTrimer(:,17))';

end

