clear
clc
close all

% load('/Users/prasadbandodkar/Desktop/ISRES/Results/v3.3/dsat/set5/2/Results/Results_isres-plus_dsat_2022-05-11-19-12-31-eh3.mat')
% folder = '/Users/prasadbandodkar/Desktop/ISRES/Results/v3.3/dsat/set4/1/Results/';
% files = extractFileLocations(folder,'mat');
% load(files(5));

load('Results_isres-plus_manu_2022-05-12-18-21-20-gg1.mat')


%
% Calculate the values of betarand
%
options.plus
struct2vars(options.evo)
struct2vars(options.plus)

struct2vars(Stats.lin) 

betarand = nan(G,1);
for g=1:G
    nlin = Nlin(g);
    if nlin ~= 0 && nCorrectedBounds(g) == 2
        xlin = squeeze(Stats.X(lambda-nlin+1:lambda,:,g));
        minval = Stats.Min(g);
        [~,i0] = min(minval);       
        xPar   = Stats.X(i0,:,g);         % Note that this is an approx. value for xPar
        brgrad      = (xlin - xPar)/(betamax{g}(1)*Dlin(g)*betalin);
        brand       = brgrad(1,:)./brgrad(1,:)/norm(brgrad(1,:));
        betarand(g) = brand(1);
    end
end


figure
subplot(1,2,1)
plot(Slin,'*')
title('Slin')
subplot(1,2,2)
plot(betarand,'*')
ylim([0,1])
title('betarand')