%sc_run
clear
clc
close all

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% CONTROLS

runselect   = false;
fhandle     = @calc_error;
modelname   = 'dsat';
year        = '2020';
month       = '09';
day         = '28';


%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

addpath('Plots')
matfolder   = ['.',filesep,'Results',filesep,'Mats'];

matfolder = './';
Filenames   = extractFileLocations(matfolder,'mat',false);
Filenames   = Filenames(end-1);
total       = num2str(length(Filenames));

for i=1:length(Filenames)
    
    
    matfile     = char(Filenames(i));    
    c           = strsplit(matfile,{'.','_'});
     
    if runselect
        if ~(strcmp(modelname,c{end-7}) && strcmp(c{end-6}, year) && strcmp(c{end-5}, month) ...
            && strcmp(c{end-4}, day))
            continue     
        end
    end
    
    disp(['Running: ',num2str(i),'/',total]);
    %disp(['Running: ', matfile])
    load(matfile);
    
    params               = [xb, addParams];
    
    [Fnew,penalty,~,Soln1] = fhandle(params,modelname);
    
    
    
    % plotting
    h = figure('position',[500,500,1450,500],'Visible','on'); 
    c = strsplit(matfile,{filesep,'.','_'}); 
    subplot(1,2,1)
    plotComparison(Soln1.dlNuc,Soln1.dlCactNuc,Soln1.T)    
    title(['Error = ',num2str(Fnew)],'fontsize',12)
    %makeTimeCourseMovie(Soln.totalDorsal)
    
    subplot(1,2,2)
    plot(Soln1.dlNuc.NC14(:,end))
    hold on
    plot(Soln1.dlCactNuc.NC14(:,end))
    title(['Penalty = ',num2str(penalty)],'fontsize',12)
    legend('Dl in nuc','DlCact in nuc')
    xvals = [40,40,40,40];
    yvals = [2,1.75,1.5,1.25];
    cvals = {['gamma = ',num2str(gammaa)];['alpha = ',num2str(alphaa)];
             ['betalin = ',num2str(betalin)];['betaprev = ',num2str(betaprev)]};
    text(xvals,yvals,cvals,'fontsize',12)
    
    %sgtitle({['Model: ',c{end-7}];['Filename: ',char(join(string(c(end-6:end-1)),'-'))]})
    sgtitle({['Model: ',c{end-7}];['Filename: ', matfile]},'Interpreter','None','fontsize',14)


    %
    % Save Figure
    %
    c = strsplit(matfile,{filesep,'.'});
    c{3} = 'Figs';
    folder = strjoin(c(1:end-2),'/');
    folder = ['.',folder];
    if ~exist('folder','dir')
       mkdir(folder)
    end
    filename = [folder,'/',c{end-1},'.png']; 
    saveas(gcf,filename)
    
    close all
    
    %
    % removing negfb here
    %
     if strcmp(modelname,'negfb')
        [Fnew,penalty,~,Soln2] = fhandle([params(1:end-2),-100,log10(0.05)]);

        % plotting
        subplot(2,2,3)
        plotComparison(Soln2.dlNuc,Soln2.dlCactNuc,Soln2.T)
        c = strsplit(matfile,{'/','.','_'});
        title([c{5},' ',c{6},'  Error = ',num2str(Fnew),' Negfb removed'])
        %makeTimeCourseMovie(Soln.totalDorsal)

        subplot(2,2,4)
        plot(Soln2.dlNuc.NC14(:,end))
        hold on
        plot(Soln2.dlCactNuc.NC14(:,end))
        title([c{5},' ',c{6},'  Error = ',num2str(Fnew),' Negfb removed'])
        legend('Dl in nuc','DlCact in nuc')

        figure
        a = Soln1.dlNuc.NC14(:,end);
        a = a/max(a);
        b = Soln2.dlNuc.NC14(:,end);
        b = b/max(b);
        plot(a); hold on; plot(b);
        legend('with ngfb','w/o negfb')
        title([c{5},' ',c{6},'  Error = ',num2str(Fnew),' Negfb removed'])
        legend('Dl in nuc','DlCact in nuc')
    end
    
    
    %c = strsplit(matfile,{'/','.'});
    
    %saveas(gcf,['./',char(c(end-1))],'png')
end


function name = chartitle(c)
    
    name = [];
    for i=1:length(c)
       name = [name,'_',char(c(i))]; 
    end
    
end


