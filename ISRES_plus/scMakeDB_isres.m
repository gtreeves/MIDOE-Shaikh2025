clear
clc
close all

mat_dir   = '../Results/isres/dsat/';
dbname    = 'dsat-isres.mat';


%% Run from here

try
   load(['Mats/',dbname],'dat')
catch
   fprintf('%s does not exist yet\n',dbname) 
end

Files   = extractFileLocations(mat_dir,'mat',true);
i0      = contains(Files,'2021');
Files   = Files(i0);
                      

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
b = load(Files(1));
fields = {'G','Gm','lambda','mm','mu','pf','varphi'};
b = rmfieldexcept(b,fields);

fnames = allFieldNames(b);

fnames(strcmp(fnames,'fileLocation')) = [];
nfnames = length(fnames);

c = 1;
i = 1;
datnew = [];
while i<=nfiles
    if mod(i,10) == 0
       fprintf('Running: %i/%i\n',i,nfiles) 
    end    
    try
        b = load(Files(i));
        datnew(c).('fileLocation') = Files{i};
        datnew(c).('BestMin') = min(b.Statistics(:,1));
        datnew(c).('Gm') = b.Gm;        
        for j=1:nfnames 
           val = findField(b,(fnames{j}));
           if  ~isempty(val)
               datnew(c).(fnames{j}) = val;
           else
              datnew(c).(fnames{j}) = -1;              
           end        
        end
    catch ME     
        disp(ME)
        c = c-1;
    end
    i = i+1;
    c = c+1;
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

%% Functions
function b = makeStructForIsres(file)

load(file)
b.BestMin = min(Statistics(:,1));
b.Gm = Gm;

b.options.evo.G = G;
b.options.evo.lambda = lambda;
b.options.evo.alphaa = 0.2;
b.options.evo.gammaa = 0.85;
b.options.evo.mue = mu;
b.options.evo.pf = pf;
b.options.evo.varphi = varphi;
b.options.evo.mm = 'min';

b.options.plus.useFullNewtonStep = false;
b.options.plus.sortPrevParamsByError = false;
b.options.plus.yeslin = false;
b.options.plus.yesnew = false;

b.options.model.modelname = 'dsat';
b.options.model.addParams = [-100,-1.3010];

b.options.liveUpdates = true;

end






















