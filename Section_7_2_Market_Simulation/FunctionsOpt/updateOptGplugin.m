function [opt_G_new] = updateOptGplugin(mu_tot, sig_tot, idx_par, opt_G)

    % In this code, we update the LDR functions, where idx_par is the
    % updated pair. Note that we need to update all LDRs when we use the
    % KRR.

    opt_G_new = opt_G;

    [~, i_b_tot] = min(mu_tot(:, idx_par));

    for i = 1 : length(idx_par)

        j = idx_par(i);

        % N_marg = N(:, j);

        mu = mu_tot(:, j); sig = sig_tot(:, j);

        i_b = i_b_tot(i);

        opt_G_new(:, j) = (mu - mu(i_b)).^2./2./(sig + sig(i_b));
        opt_G_new(i_b, j) = Inf;

    end

end

