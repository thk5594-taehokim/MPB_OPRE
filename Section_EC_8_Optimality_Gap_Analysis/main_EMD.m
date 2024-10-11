%% MAIN CODE FOR IMPLEMENTING ALGORITHM 7 (Table 1)

clear; clc

% We summarize the code to run Algorithm 7 and obtain the results in Table 1.

% Baseline

parfor (AI = 1:100)

    EMD_constant(AI); % Baseline with constant learning rates
    EMD_decreasing(AI); % Baseline with decreasing learning rates

end

data_summary_two_sided('Baseline_constant');
data_summary_two_sided('Baseline_decreasing');

% Scenario 1

parfor (AI = 1:100)

    EMD_constant(AI+100); % Scenario 1 with constant learning rates
    EMD_decreasing(AI+100); % Scenario 1 with decreasing learning rates

end

data_summary_two_sided('Scenario1_constant');
data_summary_two_sided('Scenario1_decreasing');

%% Additional numerical results to address the reviewer's concern

% Baseline

parfor (AI = 1:100)

    gamma = 0.5;
    EMD_constant_gamma(AI, gamma); % Baseline with constant learning rates

end

data_summary_two_sided('Baseline_constant_gamma', 0.5);

% Scenario 1

parfor (AI = 1:100)

    gamma = 0.5;
    EMD_constant_gamma(AI+100, gamma); % Scenario 1 with constant learning rates

end

data_summary_two_sided('Scenario1_constant_gamma', 0.5);