function [stat_tot] = merge_data(stat_tot, macro_data, macro_size)

    stat_tot.PCS = stat_tot.PCS + macro_data.PCS/macro_size;
    stat_tot.FNR = stat_tot.FNR + macro_data.FNR/macro_size;
    stat_tot.ACC = stat_tot.ACC + macro_data.ACC/macro_size;
    stat_tot.N = stat_tot.N + sum(macro_data.N_batch, 'all')/macro_size;
    stat_tot.N_tot = stat_tot.N_tot + macro_data.N_batch/macro_size;

    

end

