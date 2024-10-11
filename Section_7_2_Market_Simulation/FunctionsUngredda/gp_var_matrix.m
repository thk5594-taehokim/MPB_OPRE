function [Sigma] = gp_var_matrix(sigma,length_scale,X)
% This function returns a gram matrix of the squared exponential kernel for X
    n = size(X,1);
    Sigma = eye(n);
    
    for it = 1:(n-1)
        X_diff = X((it+1):n,:) - repmat(X(it,:),(n-it),1);
        Sigma((it+1):n,it) = exp(-0.5*sum(X_diff.^2./length_scale.^2,2));
    end
    Sigma = Sigma + tril(Sigma,-1)';
    Sigma = sigma^2*Sigma;
end

