function [posterior_mean, posterior_cov, posterior_var] = updateKRR2(posterior_mean, posterior_cov, posterior_var, lambda_x, Ydata, idx)


    % In this code, we update the posterior mean, cov, var via
    % Sherman-Morrison-Woodburry formula

    SigPost = posterior_cov{idx(1)};

    posterior_mean(idx(1), :) = (posterior_mean(idx(1), :)' + (Ydata - posterior_mean(idx(1), idx(2)))./(lambda_x + SigPost(idx(2), idx(2))) * SigPost(:, idx(2)))';
    posterior_cov{idx(1)} = SigPost - SigPost(:, idx(2)) * SigPost(:, idx(2))'/(lambda_x + SigPost(idx(2), idx(2)));

    posterior_var(idx(1), :) = diag(posterior_cov{idx(1)});

end

