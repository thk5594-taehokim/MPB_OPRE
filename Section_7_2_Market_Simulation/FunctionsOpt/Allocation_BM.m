function [PCS_path, FNR_path, ACC_path, N] = Allocation_BM(T_vec, par, type)

    PCS_path = zeros(size(T_vec));
    FNR_path = zeros(size(T_vec));
    ACC_path = zeros(size(T_vec));

    %% Parameter Setting

    k = par.k; B = par.B; weight = par.weight;
    market_setting = par.market_setting; 
    Y = par.Y; S2 = par.S2; N = par.N; % Y: sample mean, S2: sample second moment, N: number of sampled simulated at each (i, \theta_b)
    batch_size = par.batch_size;


    %% Sample update

    [mpb, pref_vec, i_b, fav_set, adv_set, PCS, FNR, ACC] = updateBest(Y, weight, par); % update some statistics and compute PCS, FNR, ACC

    PCS_path(1) = PCS;  
    FNR_path(1) = FNR;
    ACC_path(1) = ACC;


    Ghat = zeros(k, B);
    S = S2 - Y.^2; % S: sample variance
    
    % according to the update formula for normal-gamma model 

    gamma_pos = 1/2 + 1/2 * N * batch_size; 
    w_pos = 1/2 * N * batch_size .* S;
    var_S = w_pos./gamma_pos;

    Ghat = updateOptGplugin(Y, var_S./N, 1:B, Ghat); % compute pairwise LDR G

    for i = 2 : length(T_vec)        

        if strcmp(type, "MPB-PS") % For Algorithm 2, we need to do posterior sampling

            % posterior sampling from normal-gamma model 

            Ypost = Y; 
            gamma_temp = gamma_pos(mpb, adv_set); w_temp = w_pos(mpb, adv_set);
            S_new = 1./gamrnd(gamma_temp, 1./w_temp); % conditional distribution of precision follows the gamma distribution
            Ypost(mpb, adv_set) = Y(mpb, adv_set) + (sqrt(S_new)./sqrt(N(mpb, adv_set)* batch_size) .* randn(1, length(adv_set))); % given S, the mean follows normal distribution
            
            Ghat_post = updateOptGplugin(Ypost, var_S./N, adv_set, Ghat); % update LDR according to the updates due to the posterior samples

            [~, pref_vec_post, i_b, fav_set_post, adv_set_post] = updateBest(Ypost, weight);

            BM = updateBM(k, B, mpb, pref_vec_post, i_b, fav_set_post, adv_set_post, weight, type); % update balance weight as well

            [idx_x, idx_y] = find((BM.* Ghat_post == min(BM.*Ghat_post, [], 'all'))); % check pairwise balance condition

        else

            BM = updateBM(k, B, mpb, pref_vec, i_b, fav_set, adv_set, weight, type);

            [idx_x, idx_y] = find((BM.* Ghat == min(BM.*Ghat, [], 'all'))); % check pairwise balance condition

        end


        idx_sub = [idx_x(1), idx_y(1)];
        idx_opt = [i_b(idx_sub(2)), idx_sub(2)]; 
        idx = idx_sub;
        idx_minus = 1:k; 
        
        if strcmp(type, "MPB") || strcmp(type, "MPB-PS")
            idx_minus([idx_opt(1) mpb]) = [];            
        else
            idx_minus(idx_opt(1)) = [];
        end

        if N(idx_opt(1), idx_opt(2))^2/var_S(idx_opt(1), idx_opt(2)) < sum(N(idx_minus, idx_opt(2)).^2./var_S(idx_minus, idx_opt(2))) % check global balance condition
            idx = idx_opt;
        end
        
        % update sample statistics

        Ynew = simulator(idx, market_setting, batch_size);
        Y(idx(1), idx(2)) = (Y(idx(1), idx(2)) * N(idx(1), idx(2)) + mean(Ynew))/(N(idx(1), idx(2)) + 1);
        S2(idx(1), idx(2)) = (S2(idx(1), idx(2)) * N(idx(1), idx(2)) + mean(Ynew.^2))/(N(idx(1), idx(2)) + 1);
        N(idx(1), idx(2)) = N(idx(1), idx(2)) + 1;
        S(idx(1), idx(2)) = S2(idx(1), idx(2)) - Y(idx(1), idx(2)).^2;

        % update statsitics for normal-gamma model

        gamma_pos(idx(1), idx(2)) = 1/2 + 1/2 * N(idx(1), idx(2)) * batch_size;
        w_pos(idx(1), idx(2)) = 1/2 * N(idx(1), idx(2)) * batch_size * S(idx(1), idx(2));
        var_S(idx(1), idx(2)) = w_pos(idx(1), idx(2))./gamma_pos(idx(1), idx(2));
        

        [mpb, pref_vec, i_b, fav_set, adv_set, PCS, FNR, ACC] = updateBest(Y, weight, par);
        Ghat = updateOptGplugin(Y, var_S./N, idx(2), Ghat);

        PCS_path(i) = PCS;  
        FNR_path(i) = FNR;
        ACC_path(i) = ACC;

    end

end

