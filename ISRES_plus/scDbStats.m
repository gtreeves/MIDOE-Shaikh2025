clear
clc
close all

load('Mats/dsat_v2.mat','dat')


clear opts
% opts.mm = 'min';
opts.nIslands = 1;
% opts.nlin = 3;

% opts.G = 500;
% opts.nlin = 2;
% opts.endlin  = 50;
% % % opts.startnew = 1;
% % % opts.endnew  = 75;
% % % opts.nlin = 2;
% % % opts.nnewt = 1;
% opts.yesnew  = true;
% opts.endnew = 50;
% opts.endlin = 75;
% opts.nlin = 3;

[nU,nUall] = findUnique(dat,opts);

%
% get table
%
%%


%%
tic
T  = findNumberOfFiles(dat,opts)
toc