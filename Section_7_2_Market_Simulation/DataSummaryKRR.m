addpath('./FunctionsMPB');
addpath('./FunctionsOpt');
addpath('./FunctionsStat');


idx_case = 1;

dir_name_static = strcat('sim_data');

macro_size = 10;

load(strcat(dir_name_static, '/Market_GP_macrorep', num2str(1), '.mat'), "stat_EA", "stat_COCBA", "stat_Alg1", "stat_Alg2", "stat_Alg3", "stat_Alg4", "T_vec");

StatTotEA_KRR = init_merge_data(stat_EA);
StatTotCOCBA_KRR = init_merge_data(stat_EA);
StatTotAlg1_KRR = init_merge_data(stat_EA);
StatTotAlg2_KRR = init_merge_data(stat_EA);
StatTotAlg3_KRR = init_merge_data(stat_EA);
StatTotAlg4_KRR = init_merge_data(stat_EA);

for r = 1 : macro_size

    load(strcat(dir_name_static, '/Market_GP_macrorep', num2str(r), '.mat'));

    StatTotEA_KRR = merge_data(StatTotEA_KRR, stat_EA, macro_size);
    StatTotCOCBA_KRR = merge_data(StatTotCOCBA_KRR, stat_COCBA, macro_size);
    StatTotAlg1_KRR = merge_data(StatTotAlg1_KRR, stat_Alg1, macro_size);
    StatTotAlg2_KRR = merge_data(StatTotAlg2_KRR, stat_Alg2, macro_size);
    StatTotAlg3_KRR = merge_data(StatTotAlg3_KRR, stat_Alg3, macro_size);
    StatTotAlg4_KRR = merge_data(StatTotAlg4_KRR, stat_Alg4, macro_size);


end

% figure;
% 
% subplot(1, 3, 1)
% 
% semilogy(T_vec, 1 - StatTotEA_GP.PCS); hold on;
% semilogy(T_vec, 1 - StatTotCOCBA_GP.PCS); hold on;
% semilogy(T_vec, 1 - StatTotAlg1_GP.PCS); hold on;
% semilogy(T_vec, 1 - StatTotAlg2_GP.PCS); hold on;
% semilogy(T_vec, 1 - StatTotAlg3_GP.PCS); hold on;
% semilogy(T_vec, 1 - StatTotAlg4_GP.PCS); hold on;
% 
% ylim([10^(-3) 1]);
% xlim([T_vec(1) 3000]);
% ylabel('PFS');
% legend({"EA (GP)", "COCBA(GP)", "Alg 1 (GP)", "Alg 2 (GP)", "Alg 3 (GP)", "Alg 4 (GP)"})
% 
% subplot(1, 3, 2)
% 
% semilogy(T_vec, 1 - StatTotEA_GP.FNR); hold on;
% semilogy(T_vec, 1 - StatTotCOCBA_GP.FNR); hold on;
% semilogy(T_vec, 1 - StatTotAlg1_GP.FNR); hold on;
% semilogy(T_vec, 1 - StatTotAlg2_GP.FNR); hold on;
% semilogy(T_vec, 1 - StatTotAlg3_GP.FNR); hold on;
% semilogy(T_vec, 1 - StatTotAlg4_GP.FNR); hold on;
% 
% ylim([10^(-3) 1]);
% xlim([T_vec(1) 3000]);
% ylabel('FNR');
% legend({"EA (GP)", "COCBA(GP)", "Alg 1 (GP)", "Alg 2 (GP)", "Alg 3 (GP)", "Alg 4 (GP)"})
% 
% subplot(1, 3, 3)
% 
% semilogy(T_vec, 1 - StatTotEA_GP.ACC); hold on;
% semilogy(T_vec, 1 - StatTotCOCBA_GP.ACC); hold on;
% semilogy(T_vec, 1 - StatTotAlg1_GP.ACC); hold on;
% semilogy(T_vec, 1 - StatTotAlg2_GP.ACC); hold on;
% semilogy(T_vec, 1 - StatTotAlg3_GP.ACC); hold on;
% semilogy(T_vec, 1 - StatTotAlg4_GP.ACC); hold on;
% 
% 
% % semilogy(T_vec, 1-PCStot_post_zero); hold on;
% ylim([10^(-3) 1]);
% xlim([T_vec(1) 3000]);
% ylabel('1-ACC');
% legend({"EA (GP)", "COCBA(GP)", "Alg 1 (GP)", "Alg 2 (GP)", "Alg 3 (GP)", "Alg 4 (GP)"})



