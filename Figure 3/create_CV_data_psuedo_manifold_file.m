clc
clear
close all

v0 = load('Smad_v0.mat','dat');
model0 = v0.dat;

filename = 'compute_psuedo_manifold.csv';
initialize_table(filename);


for i =1:length(model0)
    XB(i,:) = model0(i).xb;
    BM(i) = model0(i).BestMin;
end

plot_BM = BM(BM<1.6);
plot_sets = log10(XB(BM<1.6,:));

THETAall = [];
CBMall = [];
CVaLL = [];
COUNT = [];
sampling_density = 1;
% figure
for i = 1:size(plot_sets,1)
    % try
        loc = i;
        [all_Smad2n,all_Smad4n,pS224n] = modelfits_predictions_Smadv0(10.^plot_sets(i,:));




        [Do,gmapprox,isnull,Io] = calc_goodness_of_fit_metrics(all_Smad2n,10.^plot_sets(i,:));

        if ~isnull
            %calcuate the eigen vectors and eigen values
            [eigV,eigH] = eig(Io); %remember if this is computationally too intensive you can use eigs and only get 3 eigen values
            deigH = spdiags(eigH);

            EigH(i,:) = deigH;

            % hold on
            % semilogy(i,deigH/max(deigH),'k','LineStyle','none','Marker','_','MarkerSize',4)
            % semilogy(i,min(deigH/max(deigH)),'b','LineStyle','none','Marker','_','MarkerSize',4)
            % xticklabels('')
            % title('Eigenvalues')
            % set(gca,'FontSize',14)
            % continue
            %}

            lambda = [eigH(1,1); eigH(2,2); eigH(3,3)];

            %eigen vectora along eigenvalues
            vec = [eigV(:,1)'; eigV(:,2)'; eigV(:,3)'];

            %This is the main part of the code
            %
            % "Put" the fmincon PD parameter set at the center of the ellipsoid and
            % sample in a 3D space around it
            theta_star = 10.^plot_sets(i,:);

            fmax = 1.6; %best fit value + 99% quantile of the chi2 distribution
            %For this model the objective fuction is the SSE normalized by errorbars,
            %so Fmax = 1 is within a SD

            alpha = sqrt(2.*(fmax - BM(i))./lambda);

            a = -1 + (1 + 1)*rand(sampling_density,3);
            theta = a(:,1)*alpha(1)*vec(1,:) + a(:,2)*alpha(2)*vec(2,:) + a(:,3)*alpha(3)*vec(3,:) + theta_star;

            %discard negative theta
            v = any(theta < 0,2);
            thetac = theta(~v,:);
            count_samples = sum(~v);
            % compute_predictions_thetac_smad7(thetac,i);
            % try
            [thetacBM,cBM,cCV_all,all_Metrics] = compute_predictions_thetac2(thetac,i);
            
            sz = length(cBM);
            LOC = ones(sz,1).*loc;
            REP_cCV_all = ones(sz,1).*cCV_all;
            writetable(table(LOC,thetacBM,cBM',REP_cCV_all,all_Metrics),...
                filename,"WriteVariableNames",false,"WriteRowNames",true,"WriteMode","append");

        end


end

%%
function [Do,gmapprox,isnull,Io] = calc_goodness_of_fit_metrics(predictions,k)

%     pred = calc_model_profile(k,yesplot);
Jo = preJac_Smad_v0(predictions,k);
Io = transpose(Jo)*Jo; %approximate hessian
% [U,S,V] = svd(Io);

Do = trace(pinv(Io)); %parameter uncertainty
isnull = 0;
eigHapprox = eig(Io);
% eigHapprox(1:2,:) = [1e-20 1e-20];
if all(eigHapprox > 0)
    PDapprox = 1;
    gmapprox = geomean(eigHapprox);
    gm_min3_max3approx = geomean(eigHapprox(1:3))/geomean(eigHapprox(end-2:end));
    gm_min_maxapprox = min(eigHapprox)./max(eigHapprox);

else
    i = 1;
    isnull = 1;
    PDapprox = 0;
    gmapprox = 0;
    % gm_min3_max3approx = [];
    % gm_min_maxapprox = [];
end
end

%%
%%
function J = preJac_Smad_v0(pred,k)


h = 1e-5;
J = zeros(length(pred),length(k));


for i = 1:length(k)
    
    k(i) = k(i) + h;
    [pred_h,~] = modelfits_predictions_Smadv0(k);
    J(:,i) = (pred_h - pred)'/h;
    k(i) = k(i) - h;
end

% J = transpose(J);
end