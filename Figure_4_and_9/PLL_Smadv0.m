clc
clear
close all

load("bounds.mat")
Nparams = length(bounds);
NPLL = size([bounds.lb],1);
f = @objective_Smad_v0; %figure 4 data
% f = @objective_Smad_v1; %figure 9 data
% k = rand(1,10); %initial guess
for i = 1:Nparams

    lbP = bounds(i).lb;
    ubP = bounds(i).ub;

    parfor j = 1:NPLL
        [xb,BestMin,PLL_Stats] = perform_PLL(f,log10(lbP(j,:)),log10(ubP(j,:)));    

        PLL(j).X = 10.^(xb);
        PLL(j).BESTMIN = BestMin;
        PLL(j).PLL_Stats = PLL_Stats; 
    end

    PLL_(i).PLL = PLL;
      

end

if ~exist("Results_v7_2","dir")
    mkdir("Results_v7_2")
end

filename = ['.',filesep,'Results_v7_2',filesep,'trimer_PLL',datestr(now,'yyyy-mm-dd-HH-MM-SS'),'-',char(randi([97,106],1,2)),num2str(randi(10))];
save([filename,'.mat'],'-v7.3') 