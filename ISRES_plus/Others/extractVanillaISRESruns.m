clear
clc
close all

opts.yeslin = false;
opts.yesnew = false;

matfiles = extractFileLocations('Mats/','mat',false);
files    = [];
for i=1:length(matfiles)
    if contains(matfiles(i),'db_Dl_Cact1')
        matfiles(i)
        load(matfiles(i),'dat')
        i0 = findInDb(dat,opts);
        files = [files, {dat(i0).fileLocation}];
    end
end

files = files';


%% copy vanilla isres files from their respective folders to a diff folder

destloc = '../Results/Dl_Cact-isres/';
mkdir(destloc);
for i=1:length(files)
    copyfile(files{i},destloc)
end












