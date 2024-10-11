function [D_kl] = div_KL(theta_0, theta)
    %DIV_KL Summary of this function goes here
    % theta_0: reference parameter
    % theta: parameter
    
    D_kl = log(theta) - log(theta_0) + theta_0./theta - 1;

end

