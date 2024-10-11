%% This code is the main code. Each main_server.m implements 100 macroruns for all scenarios.

parfor (AI = 1:100)

    main_server(AI);

end

% simulated data is saved at the folder named "Result"


%% Once we obtain the simulated data, we can summarize the data by using the following code

data_summary;

% the summary dataset can be found at the folder named "Summary_data".
