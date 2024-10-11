%% Experiment settings for both MPB w/ and w/o KRR.

init_setting;

input_dim = 1; % dimension of input parameter: needed for the KRR

budget_threshold = 5000;
batch_size = 5; % for each simulation replication, we draw 5 samples. 

macrorep = 1000; % macrorep for each job

load('./market_data/u_part_tot.mat'); % part-worth utility
load('./market_data/mean_est.mat'); % mean estimation
load('./market_data/pb_weight.mat');

weight = weight(end:-1:1);
mean_val = -revenue_market_share; % true mean value = negative revenue market share

market_setting.company_profile = TotProf;
market_setting.PPI_scen = PPI_scen;

market_setting.MyUWithoutPrice = u_part_tot(:, 1:16) * MyProfile(:, 1:16)';
market_setting.MyPrice = MyProfile(:, end);

market_setting.u_price = u_part_tot(:, end);

for i = 1 : 4
    market_setting.OtherUWithoutPrice{i} = u_part_tot(:, 1:16) * TotProf{i}.all_prof(:, 1:16)';
    market_setting.OtherPrice{i} = TotProf{i}.all_prof(:, end);
end


[k, B] = size(mean_val); % (solution, discretization size)
n_0 = 5; % initial sample size
                    
