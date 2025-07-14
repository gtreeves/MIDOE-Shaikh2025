function [] = initialize_table(filename)

% filename = 'test.txt';
LOC= nan(1,1); thetacBM = nan(1,10); cBM = nan(1,1); REP_cCV_all = nan(1,7); all_Metrics = nan(1,7);

writetable(table(LOC,thetacBM,cBM,REP_cCV_all,all_Metrics),filename);

end