clear
clc
close all

Files = extractFileLocations('/Users/prasadbandodkar/Desktop/ISRES/Results/v2/dsat/11/Results','mat');
% Files = extractFileLocations('/Users/prasadbandodkar/Desktop/ISRES/Results/v2/dsat/10/Results','mat');
file  = Files(1);

load(file)
struct2vars(options.evo)
struct2vars(options.plus)
struct2vars(Stats)

%%
clc
close all

startG = 99;
endG  = 102;

for i=startG:endG
    f = F(:,i);
    phi = Phi(:,:,i);
    phi(phi<0) = 0;
    phi = sum(phi.^2,2);
    eta = Eta(:,:,i);
    x = X(:,:,i);
    max(eta,[],'all')
    v0 = phi<=0;
    I = Isort(:,i);


    inr = 1:mue-1;
    inm = mue:lambda-nlin-nnewt;
    inn = lambda-nlin-nnewt+1:lambda-nlin;
    inl = lambda-nlin+1:lambda;
    
    if i<=100
        [~,ilin] = intersect(I,inl)
        [~,inew] = intersect(I,inn)
    end

    %plot(f(inr),'LineWidth',2); hold on;
    %plot(f(inl)); hold on; plot(1,f(inn),'linewidth',10);
    plot(f); hold on;
    max(f)


end