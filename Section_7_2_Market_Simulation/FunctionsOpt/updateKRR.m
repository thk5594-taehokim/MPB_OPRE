function [posterior_mean, posterior_cov, posterior_var] = updateKRR(posterior_mean, posterior_cov, posterior_var, Ybar, SigmaM, S, N, gp_par, idx)

    % In this code, we update the posterior mean, cov, var via direct
    % computation. This will be used only for initializiation. 

    gp_beta_vec = gp_par.gp_beta; k = gp_par.k; B = gp_par.B; 
        
        
    for j = 1:length(idx)

        i = idx(j);

        sampled_pair = N(i, :) > 0;
        
        design_cov = SigmaM{i}(sampled_pair, sampled_pair) + diag(S(i, sampled_pair)./N(i, sampled_pair));

        CovSigmaM = (design_cov\SigmaM{i}(sampled_pair, :));

        posterior_mean(i, :) = gp_beta_vec(i) + CovSigmaM' * (Ybar(i, sampled_pair)'-gp_beta_vec(i));

        if nargout > 1
            posterior_cov{i} = SigmaM{i} - SigmaM{i}(:, sampled_pair)*CovSigmaM;       
            posterior_cov{i} = posterior_cov{i}/2 + posterior_cov{i}'/2; % Make it as symmetric matrix
            posterior_var(i, :) = diag(posterior_cov{i});
        end

    end


end

