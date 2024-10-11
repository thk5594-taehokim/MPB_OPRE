function [K] = gp_cov_matrix(sigma,length_scale,X1,X2)
% This function returns a cov matrix of the squared exponential kernel for
% X1 & X2; the assumption is X1 \neq X2
    n1 = size(X1,1);
    n2 = size(X2,1);
    
    K = zeros(n1, n2);
    
    for it = 1:n1
        X_diff = X1(it,:)-X2;
        K(it, :) = sigma^2*exp(-0.5*sum(X_diff.^2./length_scale.^2,2));
    end
end

