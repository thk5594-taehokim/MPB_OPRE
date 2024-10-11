function main_MPB_KRR(AI)
    
    ExpSetting; % Initialize basic settings

    dir_name = strcat('sim_data');

    if ~isfolder(dir_name)
        mkdir(dir_name)
    end
    
   
    addpath('./FunctionsMPB');
    addpath('./FunctionsOpt');
    addpath('./FunctionsStat');
    addpath('./FunctionsUngredda');
    
    %% Market setting, true conditional optima, and other parameters to check the PCS and related statistics
    
    temp =  sum((min(mean_val) == mean_val).*weight, 2);    
    [~, true_opt] = max(temp);
    [~, i_b] = min(mean_val);

        
    T_vec = (B * k * n_0):budget_threshold; % sample budget
    
    par.k = k; par.B = B; par.n_0 = n_0; par.i_b = i_b;
    par.input_par = PPI_scen; par.weight = weight;
    par.fav_set= (i_b == true_opt); par.true_opt = true_opt;
    par.market_setting = market_setting;par.batch_size = batch_size;

    n0_mat = n_0 * ones(k, B); 
    par.n0_mat = n0_mat;
    
     %% Initializing the summary statistics

    stat_EA = []; stat_EA = init_stat(stat_EA, T_vec, k, B);

    stat_COCBA = []; stat_COCBA = init_stat(stat_COCBA, T_vec, k, B);

    stat_Alg1 = []; stat_Alg1 = init_stat(stat_Alg1, T_vec, k, B);

    stat_Alg2 = []; stat_Alg2 = init_stat(stat_Alg2, T_vec, k, B);

    stat_Alg3 = []; stat_Alg3 = init_stat(stat_Alg3, T_vec, k, B);

    stat_Alg4 = []; stat_Alg4 = init_stat(stat_Alg4, T_vec, k, B);
    
    for r = 1 : macrorep

        rng((AI-1) * macrorep + r);

        Y = zeros(k, B); % sample mean at each (i, \theta_b)
        S2 = zeros(k, B); % sample second momemnt at each (i, \theta_b)
        N = n_0 * ones(k, B); % number of budget allocated to (i, \theta_b)
    
        for b = 1 : B
            for i = 1 : k
                sim_data_temp = simulator([i b], market_setting, n_0 * batch_size);
                Y(i, b) = mean(sim_data_temp);
                S2(i, b) = mean(sim_data_temp.^2);
            end
        end

        par.Y = Y; par.S2 = S2; par.N = N; 
    
        [PCS_path, FNR_path, ACC_path, N] = Allocation_EA_KRR(T_vec, par);
        stat_EA = update_stat(stat_EA, macrorep, PCS_path, FNR_path, ACC_path, N);

        [PCS_path, FNR_path, ACC_path, N] = Allocation_BM_KRR(T_vec, par, "COCBA");
        stat_COCBA = update_stat(stat_COCBA, macrorep, PCS_path, FNR_path, ACC_path, N);

        [PCS_path, FNR_path, ACC_path, N] = Allocation_BM_KRR(T_vec, par, "MPB");
        stat_Alg1 = update_stat(stat_Alg1, macrorep, PCS_path, FNR_path, ACC_path, N);

        [PCS_path, FNR_path, ACC_path, N] = Allocation_BM_KRRpost(T_vec, par, "MPB-PS");
        stat_Alg2 = update_stat(stat_Alg2, macrorep, PCS_path, FNR_path, ACC_path, N);

        [PCS_path, FNR_path, ACC_path, N] = Allocation_BM_KRR(T_vec, par, "MPB-ACC");
        stat_Alg3 = update_stat(stat_Alg3, macrorep, PCS_path, FNR_path, ACC_path, N);

        [PCS_path, FNR_path, ACC_path, N] = Allocation_BM_KRR(T_vec, par, "MPB-FNR");
        stat_Alg4 = update_stat(stat_Alg4, macrorep, PCS_path, FNR_path, ACC_path, N); 


    end
    

   
    save(strcat(dir_name, '/Market_GP_macrorep', num2str(AI), '.mat'), "stat_EA", "stat_COCBA", "stat_Alg1", "stat_Alg2", "stat_Alg3", "stat_Alg4", "T_vec");
end

