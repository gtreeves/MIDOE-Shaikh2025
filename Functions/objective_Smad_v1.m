% noGFP equations
%noSmad4 pulses smad4_dynamics_2
%normalized fitting with max
function [F,Phi] = objective_Smad_v1(k)

k     = 10.^(k);
nsets = size(k,1);
F     = zeros(nsets,1);
Phi   = zeros(nsets,1); %no penalty
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
ES2c = 60.6;
ES2n = 28.5; %nuc. EGFP-SMAD2
EpS2c = 0;
EpS2n = 0; %nuc. EGFP-SMAD2
EpS2cEpS2c = 0;
EpS2nEpS2n = 0; %2*nuc. EGFP-SMAD2
EpS2cpS2c = 0;
EpS2npS2n = 0; %nuc. EGFP-SMAD2
EpS2cS4c = 0;
EpS2nS4n = 0; %nuc. EGFP-SMAD2
EpS2cEpS2cS4c = 0;
EpS2nEpS2nS4n = 0; %2*nuc. EGFP-SMAD2
EpS2cpS2cS4c = 0;
EpS2npS2nS4n = 0; %nuc. EGFP-SMAD2 %--nuc. trimer

y0 = [R TGFb Ract Rinact SB S2c S2n pS2c pS2n S4c S4n pS22c pS22n pS24c pS24n pS224c pS224n];
parfor i = 1:nsets

    try

        ktgf = k(i,1);
        kphos = k(i,2);
        konSB = k(i,3);
        kon = k(i,4);
        kdephos = k(i,5);
        CIF = k(i,6);
        kin = k(i,7);
        kex = k(i,8);
        koff = k(i,9);
        koffSB = k(i,10);

        ka =[ktgf kphos konSB kon kdephos CIF kin kex koff koffSB];
        % nParams = length(ka);
        %% Calc errors
        %
        % EGFP-Smad2 nuclear concentrations
        %
        % y0(2) = 0.066; y0(5) = 1000;
        sol = ode15s(@Smad_model_trimer_screen_smad4,0:0.1:60,y0,[],ka);
        %         if max(sol.x) < 45
        %             error('ode15s failed')
        %         end
        Yn = (deval(sol,tspan1))';

        % y0(2) = 0.066; y0(5) = 1000;
        sol_SB = ode15s(@Smad_model_trimer_screen_smad4_SB,60:0.1:600,Yn(end,:),[],ka);
        %         if max(sol_SB.x) < 150
        %             error('ode15s failed')
        %         end
        Yn_SB = (deval(sol_SB,tspan2))';

        Smad2n = (Yn(:,7) + Yn(:,9) +2*Yn(:,13) +Yn(:,15) +2*Yn(:,17));
        Smad2n_SB = (Yn_SB(:,7) + Yn_SB(:,9) +2*Yn_SB(:,13) +Yn_SB(:,15) +2*Yn_SB(:,17));


        %
        % EGFP-Smad2 cytoplasmic concentrations
        %
        % [~,Yc] = ode15s(@(t,y)diffun(t,y,ka),tspan1,y0);
        % [~,Yc_SB] = ode15s(@(t,y)diffunSB(t,y,ka),tspan2,Yc(end,:));
        %
        % Smad2c = (Yc(:,7) + Yc(:,9) + Yc(:,12) +Yc(:,14) +2*Yc(:,15))';
        % Smad2c_SB = (Yc_SB(:,7) + Yc_SB(:,9) + Yc_SB(:,12) +Yc_SB(:,14) +2*Yc_SB(:,15))';

        error_all_Smad2n = (sum(((Smad2n - nuc_data)./errorbar_left).^2,'all')+sum(((Smad2n_SB - nuc_data_SB)./errorbar_right).^2,'all'))./(max(nuc_data) - min(nuc_data));
        %{
    figure
    plot(tspan1,Smad2n);hold on; plot(tspan1,nuc_data)

    figure
    plot(tspan2,Smad2n_SB);hold on; plot(tspan2,nuc_data_SB)
        %}
        %% smad4
        % y0(2) = 0.066*5/2; y0(5) = 0;
        solSmad4 = ode15s(@Smad_model_trimer_screen_smad4,0:0.1:500,y0,[],ka);
        %         if max(sol.x) < 45
        %             error('ode15s failed')
        %         end
        YnSmad4 = (deval(solSmad4,tspan3))';
        Smad4nuc = YnSmad4(:,11) + YnSmad4(:,15) + YnSmad4(:,17);
        error_all_Smad4n = (sum(((Smad4nuc - smad4data_avg)./smad4data_std).^2,'all'))./(max(smad4data_avg) - min(smad4data_avg));
        % error_all_Smadc = sum(((Smad2c - cyt_data)./errorbar_left).^2,'all')+sum(((Smad2c_SB - cyt_data_SB)./errorbar_right).^2,'all');
        %{
    figure
    plot(t_smad4,Smad4nuc);hold on; plot(t_smad4,smad4_avg)
        %}
        %
        %     catch MEgu
        %         disp(ME)
        %         error_all_Smadn = 1e6;
        %     end
        %pSmad24n complex
        %
        % Smad24n_calc = calc_Smad24n(ka);
        % error_Smad_complex = sum(((Smad24n_calc - Smad24n)./sd).^2,'all');
        %% Calc error
        F(i) =  error_all_Smad2n + error_all_Smad4n;% + error_Smad_complex;%+ sum((ycalc_e(:,:,i) - yvalse).^2) + sum((ycalc_f(:,:,i) - yvalsf).^2);
    catch ME
        F(i) = 1e7;
    end
end

end
