% figure 3b
% use the PLL sets for og trimer model to make a trise-steady state scatter
% plot
%
clc
clear
close all

load("bounds.mat")

filename = 'sloppy_stiff_PLL_v7_2.csv';
i = 0;j = 0;k = 0;
TRISE_all_Smad4n = 0;TRISE_allSmad2_Smad4nuc = 0;TRISE_pS224n = 0;
SS_all_Smad4n = 0;SS_allSmad2_Smad4nuc = 0; SS_pS224n = 0;
DT_all_Smad4n = 0;DT_allSmad2_Smad4nuc = 0;DT_pS224n = 0;
TAU_all_Smad4n = 0;TAU_allSmad2_Smad4nuc = 0;TAU_pS224n = 0;
DY_all_Smad4n = 0;DY_allSmad2_Smad4nuc = 0;DY_pS224n = 0;
OS_all_Smad4n = 0;OS_allSmad2_Smad4nuc = 0;OS_pS224n = 0;
A_all_Smad4n = 0; A_allSmad2_Smad4nuc = 0; A_pS224n = 0; BestMin = 0;
writetable(table(i,j,k,TRISE_all_Smad4n,TRISE_allSmad2_Smad4nuc,TRISE_pS224n,SS_all_Smad4n,SS_allSmad2_Smad4nuc,SS_pS224n,...
    DT_all_Smad4n,DT_allSmad2_Smad4nuc,DT_pS224n,TAU_all_Smad4n,TAU_allSmad2_Smad4nuc,TAU_pS224n,...
    DY_all_Smad4n,DY_allSmad2_Smad4nuc,DY_pS224n,OS_all_Smad4n,OS_allSmad2_Smad4nuc,OS_pS224n, ...
    A_all_Smad4n,A_allSmad2_Smad4nuc,A_pS224n,BestMin),filename);

%% Analyze PLL
tp = 0:0.1:300;
for i = 1:length(files)
    load(files(i),'PLL_')
    % count = 1;
    disp('loaded')
    for k = 1:10

        for j = 1:100
            try
                xb = PLL_(k).PLL(j).PLL_Stats.xb;
                xb = 10.^xb;
                BestMin = PLL_(k).PLL(j).PLL_Stats.BestMin;
                [all_Smad4n,allSmad2_Smad4nuc,pS224nuc] = predict_next_experiment_Smadv0(xb);
                %
                model_predictions_all_Smad4n = calc_prediction_stats_v7(all_Smad4n,tp);
                model_predictions_allSmad2_Smad4nuc = calc_prediction_stats_v7(allSmad2_Smad4nuc,tp);
                model_predictions_pS224n = calc_prediction_stats_v7(pS224nuc,tp);
                %
                TRISE_all_Smad4n = model_predictions_all_Smad4n.trise;
                TRISE_allSmad2_Smad4nuc = model_predictions_allSmad2_Smad4nuc.trise;
                TRISE_pS224n = model_predictions_pS224n.trise;

                SS_all_Smad4n = model_predictions_all_Smad4n.ss;
                SS_allSmad2_Smad4nuc = model_predictions_allSmad2_Smad4nuc.ss;
                SS_pS224n = model_predictions_pS224n.ss;

                DT_all_Smad4n = model_predictions_all_Smad4n.dead_time;
                DT_allSmad2_Smad4nuc = model_predictions_allSmad2_Smad4nuc.dead_time;
                DT_pS224n = model_predictions_pS224n.dead_time;

                TAU_all_Smad4n = model_predictions_all_Smad4n.tau;
                TAU_allSmad2_Smad4nuc = model_predictions_allSmad2_Smad4nuc.tau;
                TAU_pS224n = model_predictions_pS224n.tau;

                DY_all_Smad4n = model_predictions_all_Smad4n.dely;
                DY_allSmad2_Smad4nuc = model_predictions_allSmad2_Smad4nuc.dely;
                DY_pS224n = model_predictions_pS224n.dely;

                OS_all_Smad4n = model_predictions_all_Smad4n.overshoot; %overshoot
                OS_allSmad2_Smad4nuc = model_predictions_allSmad2_Smad4nuc.overshoot; %overshoot
                OS_pS224n = model_predictions_pS224n.overshoot; %overshoot

                A_all_Smad4n = model_predictions_all_Smad4n.A;
                A_allSmad2_Smad4nuc = model_predictions_allSmad2_Smad4nuc.A;
                A_pS224n = model_predictions_pS224n.A;

                writetable(table(i,j,k,TRISE_all_Smad4n,TRISE_allSmad2_Smad4nuc,TRISE_pS224n,SS_all_Smad4n,SS_allSmad2_Smad4nuc,SS_pS224n,...
                    DT_all_Smad4n,DT_allSmad2_Smad4nuc,DT_pS224n,TAU_all_Smad4n,TAU_allSmad2_Smad4nuc,TAU_pS224n,...
                    DY_all_Smad4n,DY_allSmad2_Smad4nuc,DY_pS224n,...
                    OS_all_Smad4n,OS_allSmad2_Smad4nuc,OS_pS224n, ...
                    A_all_Smad4n,A_allSmad2_Smad4nuc,A_pS224n,BestMin),filename,"WriteVariableNames",false,"WriteRowNames",true,"WriteMode","append");

            catch ME
                disp(['i = ',num2str(i),'; j = ',num2str(j),'; k = ',num2str(k)])
                disp(ME)
            end
        end
        %
        disp('calculated')

    end
    disp('file striked out')
    clearvars PLL_
    %
end

