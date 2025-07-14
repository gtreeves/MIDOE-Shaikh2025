%script that goes to each schmierer folder and collects saved ISRES runs
%from the folder with BestMin < 0.4

% a = BestMin(BestMin<0.4);
% delF = max(a) - fval;
% lambda1 = 10^-2;
% 
% alpha1 = sqrt(2*delF/lambda1);
% 
% neigV = vecnorm(eigV);

clear
clc
close all
% addpath /scratch/user/razeen/Manuplus/ISRES_plus/Functions/

mat_dir   =  'G:\Shared drives\Reeveslab\Trainees\Razeen Shaikh\sloppyStiff\2025_04_22\Results729';
% '/Users/razeenshaikh/Library/CloudStorage/GoogleDrive-razeen@tamu.edu/Shared drives/Reeveslab/Trainees/Razeen Shaikh/sloppyStiff/Results_v0_FRAP_7_2';
% 'G:\Shared drives\Reeveslab\Trainees\Razeen Shaikh\sloppyStiff\Results_v9';
addpath(mat_dir)
dbname    = "2025-04-22-db_7_2_9.mat";

%% Run from here

try
   load(['Mats/',dbname],'dat')
catch
   fprintf('%s does not exist yet\n',dbname) 
end

Files = extractFileLocations(mat_dir,'mat',false);

% optArray = struct('G',[],'lambda',[],'pf',[],'varphi',[],'tmax', ...
%     [],'mm',[],'alphaa',[],'gammaa',[],'nIslands',[],  ...
%     'migGen',[],'yeslin',[],'yesnew',[], 'pPar',[],      ...
%     'pEvo',[],'oneByParents',[]);
                      

%% Find list of files not in the db

if exist('dat','var')
    for i=1:length(dat)
       i0 = find(strcmp(Files,dat(i).fileLocation)); 
       Files(i0) = [];
    end
    fprintf('# of new files = %i\n',length(Files))
end

if isempty(Files)
   return 
end

%% Go through all files one by one and extract relevant info and add to the 
%  database

tic
clear datnew

nfiles  = length(Files);
b = load(Files(1),'opts');
b.options = rmfield(b.opts,'model');
fnames = allFieldNames(b.options);
%fnames = [fieldnames(evo);fieldnames(plus)];
%fnames  = fieldnames(optArray);
nfnames = length(fnames);
%datnew  = optArray;


c = 1;
i = 1;
datnew = [];
while i<=nfiles
    if mod(i,10) == 0
       fprintf('Running: %i/%i\n',i,nfiles) 
    end
    
    try
        b = load(Files(i),'opts','BestMin','xb');
%         if b.BestMin < 0.4
        datnew(c).('fileLocation') = Files{i};
        datnew(c).('BestMin') = b.BestMin;
        datnew(c).('xb') = b.xb;
        for j=1:nfnames 
           val = findField(b,(fnames{j}));
           if  ~isempty(val)
               datnew(c).(fnames{j}) = val;
           else
              datnew(c).(fnames{j}) = -1;              
           end        
        end
        c = c+1;
%         end
    catch ME     
        disp(ME)
%         c = c-1;
    end
    i = i+1;
    
end


toc


%% save
if exist('dat','var')
    dat = [dat, datnew];
else
    dat = datnew;
end


%% remove duplicates

BestMin = [dat.BestMin];
[~,i0]  = unique(BestMin);
dat     = dat(i0);


%% Save
save(dbname)

%%
BM = [dat.BestMin];
BM_ = BM < 1;
dat_ = dat(BM_);
for i=1:length(dat_)
    DBxb_(i,:) = dat(i).xb;
end

