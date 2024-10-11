function [PCS_path, FNR_path, ACC_path, N] = Allocation_BM_KRRpost(T_vec, par, type)

    PCS_path = zeros(size(T_vec));
    FNR_path = zeros(size(T_vec));
    ACC_path = zeros(size(T_vec));

    %% Parameter Setting

    k = par.k; B = par.B; weight = par.weight;
    market_setting = par.market_setting; 
    Y = par.Y; S2 = par.S2; N = par.N;
    batch_size = par.batch_size;
    input_par = par.input_par;

    gp_sd_vec = zeros(k, 1); gp_length_scale_vec = cell(k, 1); gp_beta_vec = zeros(k, 1); SigmaM_vec = cell(k, 1); K_pred = cell(k, 1);

    posterior_mean = zeros(k, B); posterior_cov = cell(k, 1); posterior_var = zeros(size(S2));

    %% Sample update

    % Initialize the KRR for each solution

    for i = 1 : k
    
        initial_gp = fitrgp(input_par', Y(i, :)');
        
        % fitting parameters
        gp_sd_vec(i) = initial_gp.KernelInformation.KernelParameters(end);
        gp_length_scale_vec{i} = initial_gp.KernelInformation.KernelParameters(1:(end-1))';
        gp_beta_vec(i) = initial_gp.Beta;

        SigmaM_vec{i} = gp_var_matrix(gp_sd_vec(i),gp_length_scale_vec{i}, input_par'); 

    end

    gp_par = []; gp_par.gp_beta = gp_beta_vec; gp_par.k = k; gp_par.B = B; gp_par.K_pred = K_pred;
    
    % S: represent the sample variance scaled by batch_size (sample
    % variance of batch sample)

    S = (S2 - Y.^2)/batch_size; 

    % Initialize the posterior mean, variance, and the LDR

    [posterior_mean, posterior_cov, posterior_var] = updateKRR(posterior_mean, posterior_cov, posterior_var, Y, SigmaM_vec, S, N, gp_par, 1:k);

    Ghat = zeros(k, B);
    % Ghat = updateOptGplugin(posterior_mean, posterior_var, 1:B, Ghat);
    Ghat = updateOptGplugin(posterior_mean, S./N, 1:B, Ghat);

    [mpb, ~, ~, ~, adv_set, PCS, FNR, ACC] = updateBest(posterior_mean, weight, par);

    % Initialize Normal-Gamma model parameter for the simulation outputs;

    gamma_post = 1/2 * N * batch_size;
    w_post = 1/2 * N * batch_size .* (S * batch_size);

    PCS_path(1) = PCS;  
    FNR_path(1) = FNR;
    ACC_path(1) = ACC;

    for i = 2 : length(T_vec)        
       

        posterior_mean_updated = posterior_mean; Sigma_MPB = posterior_cov{mpb};

        Sigma_Post = Sigma_MPB;

        % Posterior Sampling from Normal-Gamma

        PostSampPair = adv_set;

        gamma_temp = gamma_post(mpb, PostSampPair); w_temp = w_post(mpb, PostSampPair);
        S_new = 1./gamrnd(gamma_temp, 1./w_temp)/batch_size; % scaled by the batch size
        Y_new = Y(mpb, PostSampPair) + (sqrt(S_new)./sqrt(N(mpb, PostSampPair)) .* randn(1, length(PostSampPair))); 

        % Update posterior mean and variances of the GP

        lambda_x = 1./(N(mpb, PostSampPair)./S_new - N(mpb, PostSampPair)./S(mpb, PostSampPair));

        for id_adv = 1:length(PostSampPair)

            adv_pair = PostSampPair(id_adv);

            % Update formula based on Sherman-Morrison-Woodburry
                     
            Y_update = Y_new(id_adv) + N(mpb, adv_pair) * lambda_x(id_adv)/S(mpb, adv_pair) * (Y_new(id_adv) - Y(mpb, adv_pair));
            posterior_mean_updated(mpb, :) = (posterior_mean_updated(mpb, :)'...
                + (Y_update - posterior_mean_updated(mpb, adv_pair))./(lambda_x(id_adv) + Sigma_Post(adv_pair, adv_pair)) * Sigma_Post(:, adv_pair))';
            Sigma_Post = Sigma_Post - Sigma_Post(:, adv_pair) * Sigma_Post(adv_pair, :)./(lambda_x(id_adv) + Sigma_Post(adv_pair, adv_pair));

        end

        % Update the new LDR via the updated posterior mean and variance 

        Ghat_post = updateOptGplugin(posterior_mean_updated, S./N, 1:B, Ghat);

        [mpb_post, pref_vec_post, i_b, fav_set_post, adv_set_post] = updateBest(posterior_mean_updated, weight);

        BM = updateBM(k, B, mpb_post, pref_vec_post, i_b, fav_set_post, adv_set_post, weight, type); % Compute balance weight matrix

        [idx_x, idx_y] = find((BM.* Ghat_post == min(BM .* Ghat_post, [], 'all'))); % Find the solution-parameter pair having the smallest W*G
        
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

        % some statistics used for the updates (Sherman-Morrison-Woodburry)

        lambda_x = 1/((N_prev+1)/S(idx(1), idx(2)) - N_prev/S_prev);
        Ydata = (1 + N_prev/S_prev * lambda_x) * mean(Ynew) + N_prev * (1 - lambda_x/S_prev) * Yprev;
        Ydata = Ydata/(N_prev+1);

        N(idx(1), idx(2)) = N(idx(1), idx(2)) + 1;
        
        gamma_post(idx(1), idx(2)) = 1/2 * N(idx(1), idx(2)) * batch_size;
        w_post(idx(1), idx(2)) = 1/2 * N(idx(1), idx(2)) * batch_size * (S(idx(1), idx(2)) * batch_size);
        
        [posterior_mean, posterior_cov, posterior_var] = updateKRR2(posterior_mean, posterior_cov, posterior_var, lambda_x, Ydata, idx);

        % Evalate the MPB, PCS, FNR, ACC with the updated posterior mean

        [mpb, ~, ~, ~, adv_set, PCS, FNR, ACC] = updateBest(posterior_mean, weight, par);
        Ghat = updateOptGplugin(posterior_mean, S./N, 1:B, Ghat);

        PCS_path(i) = PCS;  
        FNR_path(i) = FNR;
        ACC_path(i) = ACC;

    end

end

