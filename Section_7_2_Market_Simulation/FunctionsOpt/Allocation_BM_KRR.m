function [PCS_path, FNR_path, ACC_path, N] = Allocation_BM_KRR(T_vec, par, type)

    PCS_path = zeros(size(T_vec));
    FNR_path = zeros(size(T_vec));
    ACC_path = zeros(size(T_vec));

    %% Parameter Setting

    k = par.k; B = par.B; weight = par.weight;
    market_setting = par.market_setting; 
    Y = par.Y; S2 = par.S2; N = par.N; % Y: sample mean, S2: sample second moment, N: number of sampled simulated at each (i, \theta_b)
    batch_size = par.batch_size;
    input_par = par.input_par;

    gp_sd_vec = zeros(k, 1); gp_length_scale_vec = cell(k, 1); gp_beta_vec = zeros(k, 1); SigmaM_vec = cell(k, 1); K_pred = cell(k, 1);

    posterior_mean = zeros(k, B); posterior_cov = cell(k, 1); posterior_var = zeros(size(S2));

    %% Sample update

    % Initialize the GP for each solution

    for i = 1 : k
    
        initial_gp = fitrgp(input_par', Y(i, :)');
        
        % fitting parameters
        gp_sd_vec(i) = initial_gp.KernelInformation.KernelParameters(end);
        gp_length_scale_vec{i} = initial_gp.KernelInformation.KernelParameters(1:(end-1))';
        gp_beta_vec(i) = initial_gp.Beta;
        posterior_mean(i, :) = gp_beta_vec(i);

        SigmaM_vec{i} = gp_var_matrix(gp_sd_vec(i),gp_length_scale_vec{i}, input_par'); 
        % SigmaM_vec{i} = SigmaM_vec{i} + diag(diag(SigmaM_vec{i})) * 0.05;

    end

    gp_par = []; gp_par.gp_beta = gp_beta_vec; gp_par.k = k; gp_par.B = B; gp_par.K_pred = K_pred;

    % S: represent the sample variance scaled by batch_size (sample
    % variance of batch sample)
    
    S = (S2 - Y.^2)/batch_size;

    % Initialize the posterior mean, variance, and the LDR

    [posterior_mean, posterior_cov, posterior_var] = updateKRR(posterior_mean, posterior_cov, posterior_var, Y, SigmaM_vec, S, N, gp_par, 1:k);

    Ghat = zeros(k, B);
    Ghat = updateOptGplugin(posterior_mean, S./N, 1:B, Ghat);

    [mpb, pref_vec, i_b, fav_set, adv_set, PCS, FNR, ACC] = updateBest(posterior_mean, weight, par);

    PCS_path(1) = PCS;  
    FNR_path(1) = FNR;
    ACC_path(1) = ACC;

    for i = 2 : length(T_vec)        
      

        BM = updateBM(k, B, mpb, pref_vec, i_b, fav_set, adv_set, weight, type); % Compute balance weight matrix

        [idx_x, idx_y] = find((BM.* Ghat == min(BM.*Ghat, [], 'all'))); % Find the solution-parameter pair having the smallest W*G

        idx_sub = [idx_x(1), idx_y(1)]; % minimal W*G
        idx_opt = [i_b(idx_sub(2)), idx_sub(2)]; % conditional optimum
        idx = idx_sub;
        idx_minus = 1:k; 
        
        if strcmp(type, "MPB") || strcmp(type, "MPB-PS")
            idx_minus([idx_opt(1) mpb]) = [];            
        else
            idx_minus(idx_opt(1)) = [];
        end

        % Check the global balance condition

        if N(idx_opt(1), idx_opt(2))^2/S(idx_opt(1), idx_opt(2)) < sum(N(idx_minus, idx_opt(2)).^2./S(idx_minus, idx_opt(2)))
            idx = idx_opt;
        end

        % Simulate and update statistics

        Ynew = simulator(idx, market_setting, batch_size); 
        Yprev = Y(idx(1) ,idx(2)); S_prev = S(idx(1), idx(2)); N_prev = N(idx(1), idx(2));

        Y(idx(1), idx(2)) = (Y(idx(1), idx(2)) * N(idx(1), idx(2)) + mean(Ynew))/(N(idx(1), idx(2)) + 1);
        S2(idx(1), idx(2)) = (S2(idx(1), idx(2)) * N(idx(1), idx(2)) + mean(Ynew.^2))/(N(idx(1), idx(2)) + 1);       
        S(idx(1), idx(2)) = (S2(idx(1), idx(2)) - Y(idx(1), idx(2)).^2)/batch_size;

        % some statistics will be used to the Sherman-Morrison-Woodburry

        lambda_x = 1/((N_prev+1)/S(idx(1), idx(2)) - N_prev/S_prev);
        Ydata = (1 + N_prev/S_prev * lambda_x) * mean(Ynew) + N_prev * (1 - lambda_x/S_prev) * Yprev;
        Ydata = Ydata/(N_prev+1);

        N(idx(1), idx(2)) = N(idx(1), idx(2)) + 1;
        
        [posterior_mean, posterior_cov, posterior_var] = updateKRR2(posterior_mean, posterior_cov, posterior_var, lambda_x, Ydata, idx);

        % Evalate the MPB, PCS, FNR, ACC with the updated posterior mean

        [mpb, pref_vec, i_b, fav_set, adv_set, PCS, FNR, ACC] = updateBest(posterior_mean, weight, par);
        Ghat = updateOptGplugin(posterior_mean, S./N, 1:B, Ghat);


        PCS_path(i) = PCS;  
        FNR_path(i) = FNR;
        ACC_path(i) = ACC;

    end

end

