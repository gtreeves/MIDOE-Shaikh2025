clear
clc
close all

load('Mats/dsat_v3.2.mat','dat')
stat2plot  = {'Min'};

opts.G      = 1000;
opts.yeslin = true;
opts.yesnew = true;

opts.startlin = 1;
opts.endlin = 250;
opts.startnew = 251;
opts.endnew = 1000;
opts.nlin = 2;
opts.nnewt = 1;
opts.nIslands = 1;
% opts.liveUpdates = false;
% opts.nlin = 5;
% opts.nIslands = 1;
% opts.reshuffGen = 100;
% opts.reshuffGen = 250;
% opts.nlinPar = 2;
% opts.sortPrevParamsByError = false;
% % opts1.lambda = 350;

[nU,nUall] = findUnique(dat,opts,true);

% T = findNumberOfFiles(dat,opts)

%% Get F, Phi and Isort values.

Stats     = getStats(dat,opts,{'Stats'});


%% Get ranks
G           = nUall.G(1);
nIslands    = nUall.nIslands(1);
lambda      = nUall.lambda(1);
mue         = nUall.mue(1);
nfiles      = length(Stats);
ipop        = zeros(1000,G);

Ireco = nan(nfiles,G); Imuta = Ireco; Ilin = Ireco; Inewt = Ireco;
for i=1:nfiles
    fprintf('%i\n',i)
    stats   = Stats{i};
    F       = stats.F;
    Phi     = stats.Phi;
    Isort   = stats.Isort;
    
    Nlin    = stats.lin.Nlin';
    Nnewt   = stats.newt.Nnewt';
    Nreco   = stats.evo.Nreco';
    Nmuta   = stats.evo.Nmuta';
    

    for j=2:G
        phi = Phi(:,:,j);
        phi = sum(phi,2);
        v   = phi<=0;
        Ir = []; Im = []; In = []; Il = [];
        i0 = repmat(1:mue,nIslands,1);
        i0 = ([0:lambda:(nIslands-1)*lambda]'+i0)';
        i0 = i0(:)';
        isort = Isort(i0,j);
        for k=1:nIslands
            nr    = Nreco(k,j);         ir = 1:nr;
            nm    = Nmuta(k,j);         im = nr+1:nr+nm;
            nn    = Nnewt(k,j);         in = nr+nm+1:nr+nm+nn;
            nl    = Nlin(k,j);          il = lambda-nl+1:lambda;

            Ir = [Ir, lambda*(k-1)+ir]; 
            Im = [Im, lambda*(k-1)+im]; 
            In = [In, lambda*(k-1)+in];
            Il = [Il, lambda*(k-1)+il];
        end
        
%         [~,i0] = intersect(isort,Ir);
%         Ireco(i,j) = length(i0);
%         [~,i0] = intersect(isort,Im);
%         Imuta(i,j) = length(i0);
%         [~,i0] = intersect(isort,In);
%         Inewt(i,j) = length(i0);
%         [~,i0] = intersect(isort,Il);
%         Ilin(i,j) = length(i0);
        
        Imuta(i,j) = min(F(v(Im),j));
        if ~isempty(F(v(Ir),j))
            Ireco(i,j) = min(F(v(Ir),j));
        end     
        if ~isempty(F(v(In),j))
            Inewt(i,j) = min(F(v(In),j));
        end
        if ~isempty(F(v(Il),j))
            Ilin(i,j)  = min(F(v(Il),j));
        end
        

    end

%     Inewt(isnan(Inewt)) = 0;
%     %plot([Ireco;Imuta,Inewt,Ilin])
%     set(gca,'DefaultLineLineWidth',2)
%     plot(Ireco); hold on; plot(Imuta); plot(Inewt); plot(Ilin)
%     legend('reco','muta','newt','lin')
%     set(gca,'fontsize',24)
    


    %disp('last line')
end
%%
Ireco = log10(Ireco);
Imuta = log10(Imuta);
Inewt = log10(Inewt);
Ilin  = log10(Ilin);


%% make plots
close all

out25     = prctile(Ilin,25);
out50     = prctile(Ilin,50);
out75     = prctile(Ilin,75);
irange    = 1:G;
xrange    = 1:G;
liwd      = 2;
figure('Position',[100,100,1000,800])
% p1a = plot(xrange(irange),out25(irange),'color',[0,0.50,0],'LineWidth',liwd); hold on
% p1b = plot(xrange(irange),out75(irange),'color',[0,0.50,0],'LineWidth',liwd);
p1c = plot(xrange(irange),out50(irange),'color',[0,0.50,0],'LineWidth',liwd);
% x = [irange,fliplr(irange)];
% y = [out25(irange),fliplr(out75(irange))];
% fill(x,y,[0,0.40,0],'FaceAlpha',0.35)
hold on


out25     = prctile(Inewt,25);
out50     = prctile(Inewt,50);
out75     = prctile(Inewt,75);
irange    = 1:G;
xrange    = 1:G;
liwd      = 2;
% p1d = plot(xrange(irange),out25(irange),'color',[0.5,0,0],'LineWidth',liwd); hold on
% p1e = plot(xrange(irange),out75(irange),'color',[0.5,0,0],'LineWidth',liwd);
p1f = plot(xrange(irange),out50(irange),'color',[0.5,0,0],'LineWidth',liwd);
% x = [irange,fliplr(irange)];
% y = [out25(irange),fliplr(out75(irange))];
% fill(x,y,[0.4,0,0],'FaceAlpha',0.35)


out25     = prctile(Ireco,25);
out50     = prctile(Ireco,50);
out75     = prctile(Ireco,75);
irange    = 1:G;
xrange    = 1:G;
liwd      = 2;
% p1g = plot(xrange(irange),out25(irange),'color',[0,0,0.5],'LineWidth',liwd); hold on
% p1h = plot(xrange(irange),out75(irange),'color',[0,0,0.5],'LineWidth',liwd);
p1i = plot(xrange(irange),out50(irange),'color',[0,0,0.5],'LineWidth',liwd);
% x = [irange,fliplr(irange)];
% y = [out25(irange),fliplr(out75(irange))];
% fill(x,y,[0,0,0.4],'FaceAlpha',0.35)


out25     = prctile(Imuta,25);
out50     = prctile(Imuta,50);
out75     = prctile(Imuta,75);
irange    = 1:G;
xrange    = 1:G;
liwd      = 2;
% p1j = plot(xrange(irange),out25(irange),'color',[0.5,0.50,0],'LineWidth',liwd); hold on
% p1k = plot(xrange(irange),out75(irange),'color',[0.5,0.50,0],'LineWidth',liwd);
p1l = plot(xrange(irange),out50(irange),'color',[0.5,0.50,0],'LineWidth',liwd);
% x = [irange,fliplr(irange)];
% y = [out25(irange),fliplr(out75(irange))];
% fill(x,y,[0.40,0.40,0],'FaceAlpha',0.35)







xlim([1,1000])
legend([p1c p1f p1i p1l],{'lin','newt','reco','muta'})
%legend([p1c p1f],{'lin','newt'})

set(gca,'fontsize',32)
ylabel('Min fitness')
xlabel('Generation')



%
% Print original opts on the plot
%
names = fieldnames(opts);
txt0   = cell(length(names),1);
for i=1:length(names)   
   txt0{i} = [names{i},' = ',num2str(opts.(names{i}))];
end
text(0.5,0.75,txt0,'Units','normalized','fontsize',22)






