clear
clc
close all

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% CONTROLS
path = './';
%path = '../../Results/Mats/SSE_calc_error/Trials_newton_step';
Files = extractFileLocations(path,'mat',false);

matfile  = Files(end-5);

startAt     = 1;        % generation to start plotting at
nPlots      = 4;
savePlots   = false;
yespop      = true;
yeseta      = true;

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


load(matfile);
fhandle = @calc_error;

struct2vars(Stats) 
struct2vars(options) 


% Plot comparison across generations and islands!
g0      = round(linspace(startAt,G,nPlots));
count   = 1;
if yespop
    figure('position',[0,0,3000,3000],'Visible',true)
    for g1=g0
        nPos = 1:lambda;
        for j=1:nIslands
            i1 = Isort(nPos,g1);
            i1 = i1(1);
            xb     = X(i1,:,g1);
            params              = [xb, addParams]; 
            [Fnew,penalty,Soln] = fhandle(params,'dsat');
            nPos = nPos + lambda;

            subplot(nPlots,nIslands,count)
            plotComparison(Soln.dlNuc,Soln.dlCactNuc,Soln.T)
            set(gca,'fontsize',14)
            
            title({['Island = ',num2str(j),', Error = ',num2str(Fnew),', Gen = ',num2str(g1)]})
            count = count +1;   
        end 
    end
end


% analyzing eta!
if yeseta
    etaA(:,:)   = Eta(:,1,:);
    xaxis       = 1:G;
    j0          = 1 + round(rand(10,1)*(nIslands*lambda-1));

    figure('visible',true)
    for j = j0
        plot(xaxis,etaA(j,:))
        hold on
    end
    
    xlabel('Generation g')
    ylabel('Eta of first parameter')
    title('Eta versus g')
    legend(num2str(j0))
    set(gca,'fontsize',14)
    
    if savePlots
        if ~exist([R_folder,num2str(number)],'dir')
          mkdir([R_folder,num2str(number)]) 
        end
        saveas(gcf,[R_folder,num2str(number),'/eta_',num2str(number)],'tiff')
    end
    close

end

