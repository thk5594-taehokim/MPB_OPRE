function [approx_PMF, LogLikelihood] = grid_approximation(obj)
%GRID_APPROXIMATION returns PMFs of exponential distributions with
%prespecified supports.

% lambda: arrival rate
% theta: mean service time
% lambda_supp: support for lambda
% theta_supp: support for theta
% data_lambda: dataset drawn by lambda distribution
% data_theta: dataset drwan by theta distribution


% 
input_par = obj.input_par;

approx_PMF = zeros(1, length(input_par));

for i = 1 : obj.d

    data_set = obj.input_data{i}; m = length(data_set);
    
    approx_PMF = approx_PMF - m * log(input_par(i, :)) - sum(data_set)./input_par(i, :);
    
end

LogLikelihood = approx_PMF;

approx_PMF = approx_PMF - max(approx_PMF);

% approx_PMF_tot = approx_PMF_tot - max(approx_PMF_tot);

approx_PMF = exp(approx_PMF);
% approx_PMF_tot = exp(approx_PMF_tot);

approx_PMF = approx_PMF./sum(approx_PMF);


end

