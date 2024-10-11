i = 1; % 1 : Baseline, 2: Scenario 1

switch i
    case 1

        load("idx_stat.mat", "adv_idx_baseline", "idx_baseline", "true_M_baseline", "pref_prob_base"); % loading some statistics frequently used

        opt_stat.idx_tot = idx_baseline;
        opt_stat.adv_idx_tot = adv_idx_baseline;
        opt_stat.pref_prob = pref_prob_base;
        opt_stat.d_j = max(opt_stat.pref_prob) - opt_stat.pref_prob;
        opt_stat.fav_set = 42:50;
        opt_stat.Mtrue = true_M_baseline;
    case 2

        load("idx_stat.mat", "adv_idx_scen1", "idx_scenario1", "true_M_scen1", "pref_prob_scen1"); % loading some statistics frequently used
            
        opt_stat.idx_tot = idx_scenario1;
        opt_stat.adv_idx_tot = adv_idx_scen1;
        opt_stat.pref_prob = pref_prob_scen1;
        opt_stat.d_j = max(opt_stat.pref_prob) - opt_stat.pref_prob;
        opt_stat.fav_set = 36:50;
        opt_stat.Mtrue = true_M_scen1;
end

macrorep = 100;
k = 10; B = 50; kB = k*B;

LDR_WG_at_alpha_lower = zeros(1, 1000);
LDRtilde_at_alpha_lower = zeros(1, 1000);
M_argmin_tot = zeros(k, B, 1000);

for AI = 1 : macrorep

    file_name = strcat('configuration_data/macro_', num2str(AI), '.mat');
    load(file_name);
    LDR_WG_at_alpha_lower((10*AI-9):(10*AI)) = LDR_Gtilde(:, i);

    for r2 = 1 : 10
        opt_stat.mu = mu_tot(:, :, r2, i);
        opt_stat.sig = sig_tot(:, :, r2, i);
        order_idx_tot = zeros(k, B);
        for b = 1 : B
            [~, order_idx_tot(:, b)] = sort(opt_stat.mu(:, b)); 
        end
        opt_stat.order_tot = order_idx_tot;

        alpha_Gtilde_opt = reshape(alpha_Gtilde(:, :, r2, i), kB, 1);
        [ldr, ~, M_argmin, LDR_Gi] = Algorithm6(alpha_Gtilde_opt, opt_stat);
        LDRtilde_at_alpha_lower((AI-1)*10+r2) = ldr;
        M_argmin_tot(:, :, (AI-1)*10+r2) = M_argmin;
    end
end

if i == 1
    save('summary_data/LDRtilde_lower_stat_Baseline.mat', "LDRtilde_at_alpha_lower", "LDR_WG_at_alpha_lower", "M_argmin_tot", '-mat');
elseif i == 2
    save('summary_data/LDRtilde_lower_stat_Scenario1.mat', "LDRtilde_at_alpha_lower", "LDR_WG_at_alpha_lower",  "M_argmin_tot", '-mat');
end