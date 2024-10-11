function data_summary_two_sided(type, gamma)

% This code summarize the two-sided bound for each scenario and gamma
% selection

if strcmp(type, 'Baseline_constant_gamma') || strcmp(type, 'Scenario1_constant_gamma')
    type_name = strcat(type, '_', num2str(gamma));
else
    type_name = type;
end

tot_LDRtilde_at_alpha_opt = zeros(1, 1000);
tot_LDRtilde_upper = zeros(1, 1000);
tot_alpha_opt = zeros(10, 50, 1000);
tot_lower_upper_bound = zeros(2, 1000);

idx_set = []; % a set of macro run indices whose computations are completed.

for r = 1 : 1000
    if strcmp(type, 'Baseline_constant_gamma') || strcmp(type, 'Scenario1_constant_gamma')
       fname = strcat('EMD_macro_data/', type, '/gamma_', num2str(gamma), '/macro_', num2str(r), '.mat');
    else
       fname = strcat('EMD_macro_data/', type, '/macro_', num2str(r), '.mat');
    end
    if isfile(fname)
        load(fname);
        tot_LDRtilde_at_alpha_opt(r) = LDRtilde_at_alpha_opt;
        tot_LDRtilde_upper(r) = LDRtilde_upper;
        tot_alpha_opt(:, :, r) = alpha_opt_sol;
        idx_set = [idx_set r];
        tot_lower_upper_bound(1, r) = LDRtilde_at_alpha_opt;  % Lower bound (maximum among historical objective values)
        tot_lower_upper_bound(2, r) = LDRtilde_upper; % Upper bound
    end
end



switch type
    case {'Baseline_constant', 'Baseline_decreasing', 'Baseline_constant_gamma'}
        load('summary_data/LDRtilde_lower_stat_Baseline.mat');
    case {'Scenario1_constant', 'Scenario1_decreasing', 'Scenario1_constant_gamma'}
        load('summary_data/LDRtilde_lower_stat_Scenario1.mat');
end

tot_lower_upper_bound(1, idx_set) = max(tot_lower_upper_bound(1, idx_set), LDRtilde_at_alpha_lower(idx_set)); % Lower bound computation (taking max(maximum among historical objective values, the LDR at optimal allocation based on the lower bound))

figure;
histogram(1 - LDRtilde_at_alpha_lower(idx_set)./tot_lower_upper_bound(2, idx_set));
switch type
    case {'Baseline_constant', 'Baseline_decreasing'}
        xlabel('Baseline', 'FontSize', 12, 'FontWeight','bold');
    case {'Scenario1_constant', 'Scenario1_decreasing'}
        xlabel('Scneario 1', 'FontSize', 12, 'FontWeight','bold');
end

ylabel('Frequency', 'FontSize', 12, 'FontWeight','bold');
title('Relative optimality gap using the upper bounds', 'FontSize', 12);

figure;

histogram(1 - LDRtilde_at_alpha_lower(idx_set)./tot_lower_upper_bound(1, idx_set));
switch type
    case {'Baseline_constant', 'Baseline_decreasing'}
        xlabel('Baseline', 'FontSize', 12, 'FontWeight','bold');
    case {'Scenario1_constant', 'Scenario1_decreasing'}
        xlabel('Scneario 1', 'FontSize', 12, 'FontWeight','bold');
end

ylabel('Frequency', 'FontSize', 12, 'FontWeight','bold');
title('Relative optimality gap using the lower bound', 'FontSize', 12);

rel_gap_upper = 1 - LDRtilde_at_alpha_lower(idx_set)./tot_lower_upper_bound(2, idx_set);
rel_gap_lower = max(1 - LDRtilde_at_alpha_lower(idx_set)./tot_lower_upper_bound(1, idx_set), 0);
zero_ratio_rel_gap = sum(rel_gap_lower == 0);

save(strcat("summary_data/LDRtilde_stat_", type_name, ".mat"), 'tot_LDRtilde_upper', 'tot_LDRtilde_at_alpha_opt', 'tot_lower_upper_bound', 'tot_alpha_opt',...
    'rel_gap_upper', 'rel_gap_lower', 'zero_ratio_rel_gap', 'idx_set');

%% Print the summary statistics

fprintf('Case: %s \n', type);
fprintf('Number of completed macroruns: %d\n', length(idx_set));
fprintf('Two-sided bound from Prop EC.2.: [%.3e, %.3e]\n', mean(tot_lower_upper_bound(1, idx_set)), mean(tot_lower_upper_bound(2, idx_set)));
fprintf('Relative Opt Gap (mean): [%.3f, %.3f]\n', mean(rel_gap_lower), mean(rel_gap_upper));
fprintf('Relative Opt Gap (max): [%.3f, %.3f]\n', max(rel_gap_lower), max(rel_gap_upper));
fprintf('Relative Opt Gap (min): [%.3f, %.3f]\n', min(rel_gap_lower), min(rel_gap_upper));

[~, upper_idx] = max(rel_gap_upper - rel_gap_lower);
[~, lower_idx] = min(rel_gap_upper - rel_gap_lower);
fprintf('Relative Opt Gap (max interval): [%.3f, %.3f]\n', rel_gap_lower(upper_idx), rel_gap_upper(upper_idx));
fprintf('Relative Opt Gap (min interval): [%.3f, %.3f]\n', rel_gap_lower(lower_idx), rel_gap_upper(lower_idx));

% writematrix(rel_gap','rel_gap_baseline.dat');
% saveas(gca, 'gap_histogram_Baseline', 'fig');
% saveas(gca, 'gap_histogram_Baseline', 'epsc');
% saveas(gca, 'gap_histogram_Baseline', 'png');

end

