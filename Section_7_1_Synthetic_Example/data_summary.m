%% CODE TO SUMMARIZE THE SIMULATION DATA

macrorep = 100;

for i = 1:4
    if i == 1
        T_end = 50000;
        idx = 2500:5000:T_end;
        idx2 = idx;
    elseif i == 2
        T_end = 20000;
        idx = 2500:500:T_end;
        idx2 = 2500:2500:T_end;
    elseif i == 3
        T_end = 100000;
        idx = 2500:5000:T_end;
        idx2 = [2500:10000:T_end T_end];
    elseif i == 4
        T_end = 80000;
        idx = 2500:5000:T_end;
        idx2 = idx;
    end

    FNR_full = zeros(6, T_end);
    TFDR_full = zeros(6, T_end);
    PCS_full = zeros(6, T_end);
    zero_ratio_full = zeros(6, T_end);

    cnt = 0;
    for r = 1 : macrorep
        fname = strcat('Result/macro', num2str(r), '_Example', num2str(i), '.mat');
        if isfile(fname)
            cnt = cnt+1;
            load(fname);
            FNR_full(1:6, :) = FNR_full(1:6, :) + FNR_tot;
            TFDR_full(1:6, :) = TFDR_full(1:6, :) + TFDR_tot;
            PCS_full(1:6, :) = PCS_full(1:6, :) + PCS_tot;
            zero_ratio_full(1:6, :) = zero_ratio_full(1:6, :) + adv_ratio_tot;
        end
    end

    FNR_full = FNR_full/cnt;
    TFDR_full = TFDR_full/cnt;
    PCS_full = PCS_full/cnt;
    zero_ratio_full = zero_ratio_full/cnt;

    %% Datasets associated with Figure 1 

    save(strcat('Summary_data/ResultStat_Example', num2str(i), '.mat'), 'FNR_full', 'TFDR_full', 'PCS_full', 'zero_ratio_full'); 

    % csv files to generate figures in Latex
    title_pfs = {'n_vec', 'PFS_EA', 'PFS_COCBA', 'PFS_Alg1', 'PFS_Alg2', 'PFS_Alg3', 'PFS_Alg4'};
    T = array2table([idx'/1000 1- PCS_full(:, idx)']);
    T.Properties.VariableNames = title_pfs;
    writetable(T, strcat('Summary_data/PFS_Example', num2str(i), '_final.csv'));

    title_fnr = {'n_vec', 'FNR_EA', 'FNR_COCBA', 'FNR_Alg1', 'FNR_Alg2', 'FNR_Alg3', 'FNR_Alg4'};
    T = array2table([idx2'/1000 FNR_full(:, idx2)']);
    T.Properties.VariableNames = title_fnr;
    writetable(T, strcat('Summary_data/FNR_Example', num2str(i), '_final.csv'));

    title_acc = {'n_vec', 'ACC_EA', 'ACC_COCBA', 'ACC_Alg1', 'ACC_Alg2', 'ACC_Alg3', 'ACC_Alg4'};
    T = array2table([idx2'/1000 TFDR_full(:, idx2)']);
    T.Properties.VariableNames = title_acc;
    writetable(T, strcat('Summary_data/ACC_Example', num2str(i), '_final.csv'));

    %% Datasets associated with Figure 2

    if i == 1 || i == 3 

        title_pfs = {'n_vec', 'zero_EA', 'zero_COCBA', 'zero_Alg1', 'zero_Alg2', 'zero_Alg3', 'zero_Alg4'};
        T = array2table([idx'/1000 zero_ratio_full(:, idx)']);
        T.Properties.VariableNames = title_pfs;
        writetable(T, strcat('Summary_data/zero_Example', num2str(i), '.csv'));

    end

end