addpath('./FunctionsMPB');
addpath('./FunctionsOpt');
addpath('./FunctionsStat');


idx_case = 1;

dir_name_static = strcat('sim_data');

macro_size = 10;

load(strcat(dir_name_static, '/Market_macrorep', num2str(1), '.mat'), "stat_EA", "stat_COCBA", "stat_Alg1", "stat_Alg2", "stat_Alg3", "stat_Alg4", "T_vec");

StatTotEA = init_merge_data(stat_EA);
StatTotCOCBA = init_merge_data(stat_EA);
StatTotAlg1 = init_merge_data(stat_EA);
StatTotAlg2 = init_merge_data(stat_EA);
StatTotAlg3 = init_merge_data(stat_EA);
StatTotAlg4 = init_merge_data(stat_EA);

for r = 1 : macro_size

    load(strcat(dir_name_static, '/Market_macrorep', num2str(r), '.mat'));

    StatTotEA = merge_data(StatTotEA, stat_EA, macro_size);
    StatTotCOCBA = merge_data(StatTotCOCBA, stat_COCBA, macro_size);
    StatTotAlg1 = merge_data(StatTotAlg1, stat_Alg1, macro_size);
    StatTotAlg2 = merge_data(StatTotAlg2, stat_Alg2, macro_size);
    StatTotAlg3 = merge_data(StatTotAlg3, stat_Alg3, macro_size);
    StatTotAlg4 = merge_data(StatTotAlg4, stat_Alg4, macro_size);


end

% figure;
% 
% subplot(1, 3, 1)
% 
% semilogy(T_vec, 1 - StatTotEA.PCS); hold on;
% semilogy(T_vec, 1 - StatTotCOCBA.PCS); hold on;
% semilogy(T_vec, 1 - StatTotAlg1.PCS); hold on;
% semilogy(T_vec, 1 - StatTotAlg2.PCS); hold on;
% semilogy(T_vec, 1 - StatTotAlg3.PCS); hold on;
% semilogy(T_vec, 1 - StatTotAlg4.PCS); hold on;
% 
% % semilogy(T_vec, 1-PCStot_post_zero); hold on;
% ylim([10^(-3) 1]);
% xlim([T_vec(1) 3000]);
% ylabel('PFS');
% legend({"EA", "COCBA", "Alg 1", "Alg 2", "Alg 3", "Alg 4"})
% 
% subplot(1, 3, 2)
% 
% semilogy(T_vec, 1 - StatTotEA.FNR); hold on;
% semilogy(T_vec, 1 - StatTotCOCBA.FNR); hold on;
% semilogy(T_vec, 1 - StatTotAlg1.FNR); hold on;
% semilogy(T_vec, 1 - StatTotAlg2.FNR); hold on;
% semilogy(T_vec, 1 - StatTotAlg3.FNR); hold on;
% semilogy(T_vec, 1 - StatTotAlg4.FNR); hold on;
% 
% % semilogy(T_vec, 1-PCStot_post_zero); hold on;
% ylim([10^(-3) 1]);
% xlim([T_vec(1) 3000]);
% ylabel('FNR');
% legend({"EA", "COCBA", "Alg 1", "Alg 2", "Alg 3", "Alg 4"})
% 
% 
% subplot(1, 3, 3)
% 
% semilogy(T_vec, 1 - StatTotEA.ACC); hold on;
% semilogy(T_vec, 1 - StatTotCOCBA.ACC); hold on;
% semilogy(T_vec, 1 - StatTotAlg1.ACC); hold on;
% semilogy(T_vec, 1 - StatTotAlg2.ACC); hold on;
% semilogy(T_vec, 1 - StatTotAlg3.ACC); hold on;
% semilogy(T_vec, 1 - StatTotAlg4.ACC); hold on;
% 
% % semilogy(T_vec, 1-PCStot_post_zero); hold on;
% ylim([10^(-3) 1]);
% xlim([T_vec(1) 3000]);
% ylabel('1-ACC');
% legend({"EA", "COCBA", "Alg 1", "Alg 2", "Alg 3", "Alg 4"})








