# Selection of the Most Probable Best

This project shares the codes for "Selection of the Most Probable Best (2024)" written by Taeho Kim, Kyoung-Kuk Kim, and Eunhye Song. The arxiv version of the paper can be found at https://arxiv.org/pdf/2207.07533. Please contact Taeho Kim (thk5594@gmail.com) if you have any inquiries about this project. 

## Description

This project consists of four folders, each containing the MATLAB codes we used to implement and visualize the numerical results for each section (Sections 7.1, 7.2, EC.8, and EC.9 of the paper). All codes are written in MATLAB and exploit parallel computing with the "parfor" function to speed up the experiments.  

### Simulation Experiments

Run the following code in each folder to implement the simulation experiments for each section of the main paper.

1. Section_7_1_Synthetic_Example/main.m
2. Section_7_2_Market_Simulation/main_market.m
3. Section_EC_8_Optimality_Gap_Analysis/main_EMD.m
4. Section_EC_9_Synthetic_Example_Unequal_Weight/main.m

The simulated datasets will be saved in the following folders for each experiment.

1. Section_7_1_Synthetic_Example/Result
2. Section_7_2_Market_Simulation/sim_data
3. Section_EC_8_Optimality_Gap_Analysis/EMD_macro_data
4. Section_EC_9_Synthetic_Example_Unequal_Weight/Result

Due to the file size limit, the first macro-runs of each dataset have already been saved in the folder.

### Summarizing the Simulation Outputs and Visualization

You can implement the following files to aggregate the simulated data and obtain the summary statistics.

1. Section_7_1_Synthetic_Example/data_summary.m
2. Section_7_2_Market_Simulation/data_summary.m
3. Section_EC_8_Optimality_Gap_Analysis/data_summary_two_sided.m (please see main_EMD.m)
4. Section_EC_9_Synthetic_Example_Unequal_Weight/data_summary.m

Further, the summary data will be saved in the folder named as:

1. Section_7_1_Synthetic_Example/summary_data
2. Section_7_2_Market_Simulation/summary_data
3. Section_EC_8_Optimality_Gap_Analysis/summary_data
4. Section_EC_9_Synthetic_Example_Unequal_Weight/summary_data

For 1, 2, and 4, our codes save the summary statistics as CSV files to generate the figures in Latex. For 3, the two-sided bound results are saved as mat file, and the summary of the results is displayed on the command window.


## Replicating

Please follow the steps in the "Description" section in sequence to replicate the results in the paper.



