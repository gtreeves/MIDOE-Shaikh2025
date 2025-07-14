clear
clc 
close all


mat_dir   = '../Results/v3.3/reci/';


Files   = extractFileLocations(mat_dir,'mat',true);
i0      = contains(Files,'Results_isres');
Files   = Files(i0);


for i=1:length(Files)    
    try
        b    = load(Files(i));
        blin = findField(b,'betalin');
        if isempty(blin)
            b.options.plus.betalin = 1;
            savefile(Files(i),b)
        end 
    catch
        disp(['Error in :', char(Files(i))])
    end
end


function savefile(file,b)
    struct2vars(b)
    save(file)
end