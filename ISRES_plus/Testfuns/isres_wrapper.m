function isres_wrapper(fhandle,funname,lu,options,i)



[xb,BestMin,Gm,Stats,options] = isres_plus(fhandle,lu,options);
struct2vars(options)
if ~exist(['./',funname],'dir')
    mkdir(funname)
end

filename = [funname,'/Results_isres-plus_',funname,'_',datestr(now,'yyyy-mm-dd-HH-MM-SS'),'-',char(randi([97,106],1,2)),num2str(i)];
save([filename,'.mat'])

end