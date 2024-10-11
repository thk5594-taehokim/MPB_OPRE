%% This code implements the market simulation experiments in Section 7.2 and generates Figure 3

% main_MPB(AI) and main_MPB_KRR(AI) run 1000 macroruns for a fixed AI.
% Hence, to realize 10^6 simulation outputs, we parallelize the
% experiments by setting AI = 1 ~ 100. 

parfor (AI = 1 : 100)

    main_MPB(AI); % run EA, COCBA, Algorithms 1~4 without KRR
        
    main_MPB_KRR(AI); % run EA, COCBA, Algorithms 1~4 with KRR
end

DataSummaryTot; % this summarize the simulated data and generate figures