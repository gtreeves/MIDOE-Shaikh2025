clear
clc
close all

mat_dir   = '../Results/v3.3/manu/';

Files   = extractFileLocations(mat_dir,'mat',true);
i0      = contains(Files,'Results_isres');
Files   = Files(i0);


n = length(Files);
tic
for i=1:length(Files)
    if mod(i,50) == 0
        disp([num2str(i),'/',num2str(n)])
    end
    try
        b    = load(Files(i));
        opts = findField(b,'opts');
        if ~isempty(opts)
            options = b.opts;
            b = rmfield(b,'opts');
            b = rmfield(b,'options');
            b.options = options;
            savefile(Files(i),b)
        end 
    catch
        disp('error')
    end
end
toc

function savefile(file,b)
    struct2vars(b)
    save(file)
end