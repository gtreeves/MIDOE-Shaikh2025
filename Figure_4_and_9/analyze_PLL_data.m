clc
clear
close all

rng('default')
c = distinguishable_colors(50);
c = c([1:8,10,12,14,17:18,21,23:24,26:27,29:30,32:35,37:38,40,44,45:46],:);
colors = c(randperm(size(c,1)),:);

labels = {'k_{TGF \beta}','k_{phos}','k_{onSB}','k_{on}','k_{dephos}','CIF','k_{in}','k_{ex}','k_{off}','k_{offSB}'};


for k=1:10
    filename = ['Smadv0',num2str(k),'.fig']; %for Smad_v0 (figure 4)
    % filename = ['Smadv1',num2str(k),'.fig']; %for Smad_v0 (figure 9)
    f = openfig(filename);

    
    dataXY = findobj(f, 'Type','scatter'); 
    X = reshape([dataXY.XData],[100 4]);
    Y = reshape([dataXY.YData],[100 4]);
    
    

    g = figure;
    g.Units = 'inches';
    g.Position(3:4) = [2 2]; %W,H
    axis square
    
    plot(mean(X,2),smooth(mean(Y,2),'moving'),'-','LineWidth',1,'Color','k')
    hold on
    yline(1.6)
    yline(min(mean(Y,2)))
    for i=1:4
        scatter(X(:,i),Y(:,i),5,colors(i,:),'filled')
    end

    ax = gca;
    ax.XScale = 'log';
    % ax.YScale = 'log';

    ylim([0.2 2.5])
    xlim([1e-4 1e4])
    xticks([1e-4 1e-3 1e-2 1e-1 1e0 1e1 1e2 1e3 1e4])
    xticklabels([-4 -3 -2 -1 0 1 2 3 4])
    yticks(0:0.5:2)
    title(labels(k))
    xtickangle(90)

    saveas(g,['v7_pretty',num2str(k),'.fig'])
    exportgraphics(g,['v7',num2str(k),'.eps'],'ContentType','vector')
    close all
end