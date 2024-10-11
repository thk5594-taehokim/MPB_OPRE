function [PCS_path, FNR_path, ACC_path, N] = Allocation_EA_KRR(T_vec, par)


    %% Parameter setting
    PCS_path = zeros(size(T_vec));
    FNR_path = zeros(size(T_vec));
    ACC_path = zeros(size(T_vec));


    k = par.k; B = par.B; weight = par.weight;
    market_setting = par.market_setting; 
    Y = par.Y; S2 = par.S2; N = par.N;
    batch_size = par.batch_size;
    input_par = par.input_par;

    gp_sd_vec = zeros(k, 1); gp_length_scale_vec = cell(k, 1); gp_beta_vec = zeros(k, 1); SigmaM_vec = cell(k, 1); K_pred = cell(k, 1);

    posterior_mean = zeros(k, B); posterior_cov = cell(k, 1); posterior_var = zeros(size(S2));

    %% Initial update

    S = (S2 - Y.^2)/batch_size;

    for i = 1 : k
    
        initial_gp = fitrgp(input_par', Y(i, :)');
        
        % fitted parameters
        gp_sd_vec(i) = initial_gp.KernelInformation.KernelParameters(end);
        gp_length_scale_vec{i} = initial_gp.KernelInformation.KernelParameters(1:(end-1))';
        gp_beta_vec(i) = initial_gp.Beta;

        SigmaM_vec{i} = gp_var_matrix(gp_sd_vec(i),gp_length_scale_vec{i}, input_par'); 
    end

    gp_par = []; gp_par.gp_beta = gp_beta_vec; gp_par.k = k; gp_par.B = B; gp_par.K_pred = K_pred;
    [posterior_mean, posterior_cov, posterior_var] = updateKRR(posterior_mean, posterior_cov, posterior_var, Y, SigmaM_vec, S, N, gp_par, 1:k);

    [~, ~, ~, ~, ~, PCS, FNR, ACC] = updateBest(posterior_mean, weight, par);

    PCS_path(1) = PCS;  
    FNR_path(1) = FNR;
    ACC_path(1) = ACC;

     

    for i = 2 : length(T_vec)

        [idx_x, idx_y] = find(N == min(N, [], 'all'));
        idx = [idx_x(1), idx_y(1)];

        Ynew = simulator(idx, market_setting, batch_size); 
        Yprev = Y(idx(1) ,idx(2)); S_prev = S(idx(1), idx(2)); N_prev = N(idx(1), idx(2));

        % update sample statistics

        Y(idx(1), idx(2)) = (Y(idx(1), idx(2)) * N(idx(1), idx(2)) + mean(Ynew))/(N(idx(1), idx(2)) + 1);
        S2(idx(1), idx(2)) = (S2(idx(1), idx(2)) * N(idx(1), idx(2)) + mean(Ynew.^2))/(N(idx(1), idx(2)) + 1);       
        S(idx(1), idx(2)) = (S2(idx(1), idx(2)) - Y(idx(1), idx(2)).^2)/batch_size;

        % some statistics will be used to the Sherman-Morrison-Woodburry

        lambda_x = 1/((N_prev+1)/S(idx(1), idx(2)) - N_prev/S_prev);
        Ydata = (1 + N_prev/S_prev * lambda_x) * mean(Ynew) + N_prev * (1 - lambda_x/S_prev) * Yprev;
        Ydata = Ydata/(N_prev+1);

        N(idx(1), idx(2)) = N(idx(1), idx(2)) + 1;

        [posterior_mean, posterior_cov, posterior_var] = updateKRR2(posterior_mean, posterior_cov, posterior_var, lambda_x, Ydata, idx);

        [~, ~, ~, ~, ~, PCS, FNR, ACC] = updateBest(posterior_mean, weight, par);

        PCS_path(i) = PCS;  
        FNR_path(i) = FNR;
        ACC_path(i) = ACC;

    end

end

