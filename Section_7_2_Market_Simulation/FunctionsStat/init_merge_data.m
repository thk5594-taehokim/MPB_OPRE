function stat_tot = init_merge_data(macro_data)

    stat_tot = [];
    stat_tot.PCS = zeros(size(macro_data.PCS));
    stat_tot.FNR = zeros(size(macro_data.FNR));
    stat_tot.ACC = zeros(size(macro_data.ACC));
    stat_tot.N = 0;
    stat_tot.N_tot = zeros(size(macro_data.N_batch));

end

