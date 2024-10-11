function EMD_constant(NAI)
    
    % This code implements Algorithm 7 in Section EC.8 with constant gamma.
    % To enhance the computational speed, we parallelize the code. 
    % For each scenario, we have 1000 macroruns. We split them into 100 jobs with 10 macroruns.

    % For Baseline, EMD_constant(NAI) runs 10 macroruns at each NAI and NAI
    % ranges from 1 to 100. For Scenario 1, NAI ranges from 101 to 200. (we
    % will tune the range by introducing new variable AI). 

    % This code runs long-run experiments (iteration count > 10^6) to
    % obtain a tight bound.
    % Depending on computational devices, it may take over 30 days. 

    if NAI <= 100
        i = 1; % Baseline 
        AI = NAI;
        load("idx_stat.mat", "adv_idx_baseline", "idx_baseline", "true_M_baseline", "pref_prob_base"); % loading some statistics frequently used
    else
        i = 2; % Scenario 1
        AI = NAI - 100; % we tune the index 
        load("idx_stat.mat", "adv_idx_scen1", "idx_scenario1", "true_M_scen1", "pref_prob_scen1"); % loading some statistics frequently used
    end
    
    switch i 

        case 1

            opt_stat.idx_tot = idx_baseline;
            opt_stat.adv_idx_tot = adv_idx_baseline;
            opt_stat.pref_prob = pref_prob_base;
            opt_stat.d_j = max(opt_stat.pref_prob) - opt_stat.pref_prob;
            opt_stat.fav_set = 42:50;
            opt_stat.Mtrue = true_M_baseline;
            gamma = 1;
            iter_max = 5*10^6; % maximum iteration 

        case 2

            opt_stat.idx_tot = idx_scenario1;
            opt_stat.adv_idx_tot = adv_idx_scen1;
            opt_stat.pref_prob = pref_prob_scen1;
            opt_stat.d_j = max(opt_stat.pref_prob) - opt_stat.pref_prob;
            opt_stat.fav_set = 36:50;
            opt_stat.Mtrue = true_M_scen1;
            gamma = 1;
            iter_max = 10^6; % maximum iteration 
    end

    file_name = strcat('configuration_data/macro_', num2str(AI), '.mat'); 
    load(file_name, 'mu_tot', 'sig_tot'); % load known mean & variance configuration at each scenario
    
    k = 10; B = 50; kB = k*B; % total size

    for r2 = 1:10
        opt_stat.mu = mu_tot(:, :, r2, i);
        opt_stat.sig = sig_tot(:, :, r2, i);
        order_idx_tot = zeros(k, B);

        for b = 1 : B
            [~, order_idx_tot(:, b)] = sort(opt_stat.mu(:, b)); 
        end
        opt_stat.order_tot = order_idx_tot;
        alpha_0 = ones(kB, 1)/kB;
        alpha_old = alpha_0;
        alpha_best = alpha_0;
        [f_best, grad_old] = Algorithm6(alpha_0, opt_stat);
        
        iter = 1;

        numer = 0; % numerator in the upper bound expect log(kB)
        denom = 0; % denominator in the upper bound
        
        while iter <= iter_max % the entropic mirror descent starts
            
            temp = alpha_old.*exp(gamma*grad_old);
            alpha_new = temp/sum(temp);
            
            [f_new, grad_new, ~] = Algorithm6(alpha_new, opt_stat);

            numer = numer - gamma * sum(grad_old.*(alpha_old - alpha_new)) - sum(alpha_new.*log(alpha_new./alpha_old));
            denom = denom + gamma;

            upper_gap = (log(kB) + numer)/denom;

            if f_new > f_best
                alpha_best = alpha_new;
                f_best = f_new;
            end
           
            alpha_old = alpha_new;
            grad_old = grad_new;
            iter = iter+1;

        end

        iter_size = iter;
        f_best = Algorithm6(alpha_best, opt_stat); % historical optimal value 
        alpha_opt_sol = reshape(alpha_best, k, B); % optimal solution 
        LDRtilde_at_alpha_opt = f_best; % record the optimal value among historical values
        LDRtilde_upper = f_best + upper_gap; % record the upper bound
        gap_upper_bound = upper_gap; % record the upper bound of the optimality gap

        if i == 1
            save(strcat('EMD_macro_data/Baseline_constant/macro_', num2str((AI-1)*10+r2), '.mat'), 'LDRtilde_at_alpha_opt', 'alpha_opt_sol', 'iter_size', 'LDRtilde_upper', 'gap_upper_bound');
        elseif i == 2
            save(strcat('EMD_macro_data/Scenario1_constant/macro_', num2str((AI-1)*10+r2), '.mat'), 'LDRtilde_at_alpha_opt', 'alpha_opt_sol', 'iter_size', 'LDRtilde_upper', 'gap_upper_bound');
        end
    end
    

end
