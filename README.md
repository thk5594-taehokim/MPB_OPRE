# Selection of the Most Probable Best

This project presents the codes for "Selection of the Most Probable Best (2024)" written by Taeho Kim, Kyoung-Kuk Kim, and Eunhye Song. The arxiv version of the paper can be found at https://arxiv.org/pdf/2207.07533. Please contact Taeho Kim (thk5594@gmail.com) if you have any questions about this project. 

## Description

This project consists of four folders, each containing the MATLAB codes we used to implement and visualize the numerical results for each section (Sections 7.1, 7.2, EC.8, and EC.9 of the paper). All codes are written in MATLAB, and we exploit parallel computing with the "parfor" function to speed up the experiments.  

### Simulation Experiments

To implement the simulation experiments, run the following code in each folder.

1. Section_7_1_Synthetic_Example/main.m
2. Section_7_2_Market_Simulation/main_market.m
3. Section_EC_8_Optimality_Gap_Analysis/main_EMD.m
4. Section_EC_9_Synthetic_Example_Unequal_Weight/main.m

The simulated datasets will be saved in the following folders for each experiment.

1. Section_7_1_Synthetic_Example/Result
2. Section_7_2_Market_Simulation/sim_data
3. Section_EC_8_Optimality_Gap_Analysis/EMD_macro_data
4. Section_EC_9_Synthetic_Example_Unequal_Weight/Result

Those datasets we obtained have already been saved in the folder. 

### Summarizing the Simulation Outputs and Visualization

To aggregate the simulated data and obtain the summary statistics, it is sufficient to implement the following files.




