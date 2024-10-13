%% This code generates Figure 3 

data_summary_withoutKRR;
data_summary_withKRR;

color_mat = colororder;

figure;

subplot(1, 3, 1);

h = semilogy(T_vec, 1 - StatTotEA.PCS); h.Color = color_mat(1, :); h.LineStyle = ':'; h.LineWidth = 1.5; hold on;
% h = semilogy(T_vec, 1 - StatTotEA_KRR.PCS); h.Color = color_mat(1, :); h.LineWidth = 1.5; hold on;
h = semilogy(T_vec, 1 - StatTotCOCBA.PCS); h.Color = color_mat(2, :); h.LineStyle = ':'; h.LineWidth = 1.5; hold on;
% h = semilogy(T_vec, 1 - StatTotCOCBA_KRR.PCS); h.Color = color_mat(2, :); h.LineWidth = 1.5; hold on;
h = semilogy(T_vec, 1 - StatTotAlg1.PCS); h.Color = color_mat(3, :); h.LineStyle = ':'; h.LineWidth = 1.5; hold on;
% h = semilogy(T_vec, 1 - StatTotAlg1_KRR.PCS); h.Color = color_mat(3, :); h.LineWidth = 1.5; hold on;
h = semilogy(T_vec, 1 - StatTotAlg2.PCS); h.Color = color_mat(4, :); h.LineStyle = ':'; h.LineWidth = 1.5; hold on;
h = semilogy(T_vec, 1 - StatTotAlg2_KRR.PCS); h.Color = color_mat(4, :); h.LineWidth = 1.5; hold on;

h = semilogy(T_vec, 1 - StatTotAlg3.PCS); h.Color = color_mat(5, :); h.LineStyle = ':'; h.LineWidth = 1.5; hold on;
% h = semilogy(T_vec, 1 - StatTotAlg3_KRR.PCS); h.Color = color_mat(5, :); h.LineWidth = 1.5; hold on;
h = semilogy(T_vec, 1 - StatTotAlg4.PCS); h.Color = color_mat(6, :); h.LineStyle = ':'; h.LineWidth = 1.5; hold on;
% h = semilogy(T_vec, 1 - StatTotAlg4_KRR.PCS); h.Color = color_mat(6, :); h.LineWidth = 1.5; hold on;


ylim([10^(-3) 1]);
xlim([T_vec(1) T_vec(end)]);
xlabel('Simulation Budget'); ylabel('PFS');
legend({"EA", "EA (GP)", "COCBA", "COCBA(GP)", "Alg 1", "Alg 2", "Alg 2 (GP)", "Alg 3", "Alg 4"}, 'Location', 'best');
% legend({"EA", "COCBA", "Alg 1", "Alg 2", "Alg 2 (KRR)", "Alg 3", "Alg 4"}, 'Location', 'best');

subplot(1, 3, 2)

h = semilogy(T_vec, 1 - StatTotEA.FNR); h.Color = color_mat(1, :); h.LineStyle = ':'; h.LineWidth = 1.5; hold on;
% h = semilogy(T_vec, 1 - StatTotEA_KRR.FNR); h.Color = color_mat(1, :); h.LineWidth = 1.5; hold on;
h = semilogy(T_vec, 1 - StatTotCOCBA.FNR); h.Color = color_mat(2, :); h.LineStyle = ':'; h.LineWidth = 1.5; hold on;
% h = semilogy(T_vec, 1 - StatTotCOCBA_KRR.FNR); h.Color = color_mat(2, :); h.LineWidth = 1.5; hold on;
h = semilogy(T_vec, 1 - StatTotAlg1.FNR); h.Color = color_mat(3, :); h.LineStyle = ':'; h.LineWidth = 1.5; hold on;
% h = semilogy(T_vec, 1 - StatTotAlg1_KRR.FNR); h.Color = color_mat(3, :); h.LineWidth = 1.5; hold on;
h = semilogy(T_vec, 1 - StatTotAlg2.FNR); h.Color = color_mat(4, :); h.LineStyle = ':'; h.LineWidth = 1.5; hold on;
h = semilogy(T_vec, 1 - StatTotAlg2_KRR.FNR); h.Color = color_mat(4, :); h.LineWidth = 1.5; hold on;
h = semilogy(T_vec, 1 - StatTotAlg3.FNR); h.Color = color_mat(5, :); h.LineStyle = ':'; h.LineWidth = 1.5; hold on;
% h = semilogy(T_vec, 1 - StatTotAlg3_KRR.FNR); h.Color = color_mat(5, :); h.LineWidth = 1.5; hold on;
h = semilogy(T_vec, 1 - StatTotAlg4.FNR); h.Color = color_mat(6, :); h.LineStyle = ':'; h.LineWidth = 1.5; hold on;
% h = semilogy(T_vec, 1 - StatTotAlg4_KRR.FNR); h.Color = color_mat(6, :); h.LineWidth = 1.5; hold on;


ylim([10^(-3) 1]);
xlim([T_vec(1) T_vec(end)]);
xlabel('Simulation Budget'); ylabel('FNR');
% legend({"EA", "EA (GP)", "COCBA", "COCBA(GP)", "Alg 1", "Alg 1 (GP)", "Alg 2", "Alg 2 (GP)", "Alg 3", "Alg 3 (GP)", "Alg 4", "Alg 4 (GP)"}, 'Location', 'best');

legend({"EA", "COCBA", "Alg 1", "Alg 2", "Alg 2 (KRR)", "Alg 3", "Alg 4"}, 'Location', 'best');

subplot(1, 3, 3)

h = semilogy(T_vec, 1 - StatTotEA.ACC); h.Color = color_mat(1, :); h.LineStyle = ':'; h.LineWidth = 1.5; hold on;
% h = semilogy(T_vec, 1 - StatTotEA_KRR.ACC); h.Color = color_mat(1, :); h.LineWidth = 1.5; hold on;
h = semilogy(T_vec, 1 - StatTotCOCBA.ACC); h.Color = color_mat(2, :); h.LineStyle = ':'; h.LineWidth = 1.5; hold on;
% h = semilogy(T_vec, 1 - StatTotCOCBA_KRR.ACC); h.Color = color_mat(2, :); h.LineWidth = 1.5; hold on;
h = semilogy(T_vec, 1 - StatTotAlg1.ACC); h.Color = color_mat(3, :); h.LineStyle = ':'; h.LineWidth = 1.5; hold on;
% h = semilogy(T_vec, 1 - StatTotAlg1_KRR.ACC); h.Color = color_mat(3, :); h.LineWidth = 1.5; hold on;
h = semilogy(T_vec, 1 - StatTotAlg2.ACC); h.Color = color_mat(4, :); h.LineStyle = ':'; h.LineWidth = 1.5; hold on;
h = semilogy(T_vec, 1 - StatTotAlg2_KRR.ACC); h.Color = color_mat(4, :); h.LineWidth = 1.5; hold on;
h = semilogy(T_vec, 1 - StatTotAlg3.ACC); h.Color = color_mat(5, :); h.LineStyle = ':'; h.LineWidth = 1.5; hold on;
% h = semilogy(T_vec, 1 - StatTotAlg3_KRR.ACC); h.Color = color_mat(5, :); h.LineWidth = 1.5; hold on;
h = semilogy(T_vec, 1 - StatTotAlg4.ACC); h.Color = color_mat(6, :); h.LineStyle = ':'; h.LineWidth = 1.5; hold on;
% h = semilogy(T_vec, 1 - StatTotAlg4_KRR.ACC); h.Color = color_mat(6, :); h.LineWidth = 1.5; hold on;


% semilogy(T_vec, 1-PCStot_post_zero); hold on;
ylim([10^(-3) 1]);
xlim([T_vec(1) T_vec(end)]);
    xlabel('Simulation Budget'); ylabel('1-ACC');
% legend({"EA", "EA (GP)", "COCBA", "COCBA(GP)", "Alg 1", "Alg 1 (GP)", "Alg 2", "Alg 2 (GP)", "Alg 3", "Alg 3 (GP)", "Alg 4", "Alg 4 (GP)"}, 'Location', 'best');

legend({"EA", "COCBA", "Alg 1", "Alg 2", "Alg 2 (KRR)", "Alg 3", "Alg 4"}, 'Location', 'best');

x0=10;
y0=10;
width=1500;
height=400;
set(gcf,'position',[x0,y0,width,height])


saveas(gcf, 'summary_data/MarketShare_PFS', 'fig');
saveas(gcf, 'summary_data/MarketShare_PFS', 'png');
saveas(gcf, 'summary_data/MarketShare_PFS', 'epsc');


%% SAVE THE SUMMARY DATA AS CSV FILES

rep_size = 200;

T_idx = T_vec(1:rep_size:end)'/1000;

PFS_EA = round(1 - StatTotEA.PCS(1:rep_size:length(T_vec))', 4);
PFS_COCBA = round(1 - StatTotCOCBA.PCS(1:rep_size:length(T_vec))', 4);
PFS_Alg1 = round(1 - StatTotAlg1.PCS(1:rep_size:length(T_vec))', 4);
PFS_Alg2 = round(1 - StatTotAlg2.PCS(1:rep_size:length(T_vec))', 4);
PFS_Alg3 = round(1 - StatTotAlg3.PCS(1:rep_size:length(T_vec))', 4);
PFS_Alg4 = round(1 - StatTotAlg4.PCS(1:rep_size:length(T_vec))', 4);
PFS_Alg5 = round(1 - StatTotAlg2_KRR.PCS(1:rep_size:length(T_vec))', 4);

T = table(T_idx, PFS_EA, PFS_COCBA, PFS_Alg1, PFS_Alg2, PFS_Alg3, PFS_Alg4, PFS_Alg5);
writetable(T, 'summary_data/MarketShare_KRR_PFS_final.csv');

FNR_EA = round(1 - StatTotEA.FNR(1:rep_size:length(T_vec))', 4);
FNR_COCBA = round(1 - StatTotCOCBA.FNR(1:rep_size:length(T_vec))', 4);
FNR_Alg1 = round(1 - StatTotAlg1.FNR(1:rep_size:length(T_vec))', 4);
FNR_Alg2 = round(1 - StatTotAlg2.FNR(1:rep_size:length(T_vec))', 4);
FNR_Alg3 = round(1 - StatTotAlg3.FNR(1:rep_size:length(T_vec))', 4);
FNR_Alg4 = round(1 - StatTotAlg4.FNR(1:rep_size:length(T_vec))', 4);
FNR_Alg5 = round(1 - StatTotAlg2_KRR.FNR(1:rep_size:length(T_vec))', 4);

T = table(T_idx, FNR_EA, FNR_COCBA, FNR_Alg1, FNR_Alg2, FNR_Alg3, FNR_Alg4, FNR_Alg5);
writetable(T, 'summary_data/MarketShare_KRR_FNR_final.csv');

ACC_EA = round(1 - StatTotEA.ACC(1:rep_size:length(T_vec))', 4);
ACC_COCBA = round(1 - StatTotCOCBA.ACC(1:rep_size:length(T_vec))', 4);
ACC_Alg1 = round(1 - StatTotAlg1.ACC(1:rep_size:length(T_vec))', 4);
ACC_Alg2 = round(1 - StatTotAlg2.ACC(1:rep_size:length(T_vec))', 4);
ACC_Alg3 = round(1 - StatTotAlg3.ACC(1:rep_size:length(T_vec))', 4);
ACC_Alg4 = round(1 - StatTotAlg4.ACC(1:rep_size:length(T_vec))', 4);
ACC_Alg5 = round(1 - StatTotAlg2_KRR.ACC(1:rep_size:length(T_vec))', 4);
T = table(T_idx, ACC_EA, ACC_COCBA, ACC_Alg1, ACC_Alg2, ACC_Alg3, ACC_Alg4, ACC_Alg5);
writetable(T, 'summary_data/MarketShare_KRR_ACC_final.csv');
