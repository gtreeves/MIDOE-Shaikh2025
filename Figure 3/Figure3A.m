clc
clear
close all

T = readtable("data_psuedo_manifold.csv");

a = 18; %magenta parameter set
T1 = T(T.LOC == a,:);
BM = T1.cBM;
T1theta = T1(:,2:11);
theta = T1theta.Variables;


Y = tsne(theta./mean(theta,1),'NumDimensions',2,'Distance','seuclidean','Exaggeration',4,'Perplexity',30);

F1 = figure;
F1.Units = 'inches';
F1.Position(3:4) = [3 3]; %W,H

rng default
scatter(Y(:,1),Y(:,2),[],log10(BM),'filled')
colorbar
% c = hsv;
% c = flipud(c);
% colormap(c);
colormap hsv
ylim([-40 40])
xlim([-40 40])
axis square
xlabel('tSNE1')
ylabel('tSNE2')
set(gca,'FontSize',8,'FontName','Arial')
exportgraphics(F1,[num2str(a),'.eps'],'ContentType','vector')