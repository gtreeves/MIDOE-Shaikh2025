clc
clear
close all


v0 = load('Smad_v0.mat','dat');
v1 = load('Smad_v1.mat','dat');
model0 = v0.dat;
model1 = v1.dat;

for i =1:length(model0)
    XB(i,:) = model0(i).xb;
    BM(i) = model0(i).BestMin;
end

for i =1:length(model1)
    XBv1(i,:) = model1(i).xb;
    BMv1(i) = model1(i).BestMin;
end

plot_BM = BM(BM<1);
plot_sets = log10(XB(BM<1,:));

plot_BMv1 = BMv1(BMv1<2);
plot_setsv1 = log10(XBv1(BMv1<2,:));

% Compute the 95% quantile
quantile_95 = quantile(plot_BM, 0.99);  % Alternative: prctile(data, 95);
quantile_95v1 = quantile(plot_BMv1, 0.99);  % Alternative: prctile(data, 95);

confidence_threshold_v0 = plot_BM(1) + quantile_95
confidence_threshold_v1 = plot_BMv1(1) + quantile_95v5