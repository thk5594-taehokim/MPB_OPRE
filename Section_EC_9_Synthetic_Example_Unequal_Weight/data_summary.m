macrorep = 100;

for i = 1:2
    if i == 1
        T_end = 80000;
        idx = 2500:5000:T_end;
        idx2 = idx;
    elseif i == 2
        T_end = 80000;
        idx = 2500:5000:T_end;
        idx2 = idx;
    else
        T_end = 40000;
    end

    FNR_full = zeros(6, T_end);
    TFDR_full = zeros(6, T_end);
    PCS_full = zeros(6, T_end);

    for r = 1 : macrorep
        fname = strcat('Result/macro', num2str(r), '_Example', num2str(i), '.mat');
        
        load(fname);
        FNR_full(1:6, :) = FNR_full(1:6, :) + FNR_tot/macrorep;
        TFDR_full(1:6, :) = TFDR_full(1:6, :) + TFDR_tot/macrorep;
        PCS_full(1:6, :) = PCS_full(1:6, :) + PCS_tot/macrorep;

    end
    
    save(strcat('summary_data/ResultStat_Example', num2str(i+4), '.mat'), 'FNR_full', 'TFDR_full', 'PCS_full');

    title_pfs = {'n_vec', 'PFS_EA', 'PFS_COCBA', 'PFS_Alg1', 'PFS_Alg2', 'PFS_Alg3', 'PFS_Alg4'};
    T = array2table([idx'/1000 1- PCS_full(:, idx)']);
    T.Properties.VariableNames = title_pfs;
    writetable(T, strcat('summary_data/PFS_Example', num2str(i+4), '_final.csv'));

    title_fnr = {'n_vec', 'FNR_EA', 'FNR_COCBA', 'FNR_Alg1', 'FNR_Alg2', 'FNR_Alg3', 'FNR_Alg4'};
    T = array2table([idx2'/1000 FNR_full(:, idx2)']);
    T.Properties.VariableNames = title_fnr;
    writetable(T, strcat('summary_data/FNR_Example', num2str(i+4), '_final.csv'));

    title_acc = {'n_vec', 'ACC_EA', 'ACC_COCBA', 'ACC_Alg1', 'ACC_Alg2', 'ACC_Alg3', 'ACC_Alg4'};
    T = array2table([idx2'/1000 TFDR_full(:, idx2)']);
    T.Properties.VariableNames = title_acc;
    writetable(T, strcat('summary_data/ACC_Example', num2str(i+4), '_final.csv'));
end
