clear
clc
close all

% mat_dir   = '../Results/v3.2/testfuns/**/g05/';
mat_dir   = '../Results/v3.3/g02/';
dbname    = 'g02_v3.3.mat';


%% Run from here

try
   load(['Mats/',dbname],'dat')
catch
   fprintf('%s does not exist yet\n',dbname) 
end

Files   = extractFileLocations(mat_dir,'mat',true);
i0      = contains(Files,'Results_isres');
Files   = Files(i0);
                      
% remove filenames that are not unique
% datestamp = strings(length(Files),1);
% for i=1:length(Files)
%     filename = strsplit(Files(i),{filesep,'.','_'});
%     filename = strsplit(filename(end-1),'-');
%     filename = strjoin(filename(1:end-1),'-');
%     datestamp(i) = filename;
% end
% [~,i0] = unique(datestamp);
% Files  = Files(i0);

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
b = load(Files(1),'options');
if isfield(b.options,'model')
    b.options = rmfield(b.options,'model');
end
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
%         if (contains(dbname,'manu') || contains(dbname,'reci')) && contains(dbname,'v3.3') && ~contains(dbname,'trial')
%             b = load(Files(i),'opts','BestMin','Gm');
%         else
%             b = load(Files(i),'options','BestMin','Gm');
%         end
        b = load(Files(i),'options','BestMin','Gm');
%         b = correctLinNewtParamsForVanilla(Files(i),b);
        datnew(c).('fileLocation') = Files{i};
        datnew(c).('BestMin') = b.BestMin;
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
% 
% BestMin = [dat.BestMin];
% [~,i0]  = unique(BestMin);
% dat     = dat(i0);


%% Save
save(dbname)

%% Functions
function b = correctLinNewtParamsForVanilla(file,b)

if contains(file,'v1/dsat/1') || contains(file,'v1/dsat/2')
    b.options.plus.sortPrevParamsByError = false;
    b.options.plus.useFullNewtonStep     = false;
end



end

















