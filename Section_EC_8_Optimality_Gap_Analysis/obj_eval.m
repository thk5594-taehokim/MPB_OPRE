function [f_min, ldr_tot] = obj_eval(alpha, opt_stat)
    
    alpha_mat = reshape(alpha, 10, 50);
    mu = opt_stat.mu;
    S = opt_stat.sig;
    M_argmin = opt_stat.M_argmin;
    order_tot = opt_stat.order_tot;

    ldr_tot = zeros(10, 50);
    for b = 1 : 50
        order_idx = order_tot(:, b);
        A_sorted = mu(order_idx, b);
        sig = S(order_idx, b);

        par.mu = A_sorted;
        par.sig = sig;
        par.type = 1;

        ldr = confungrad(alpha_mat(order_idx, b), par);
        ldr_tot(order_idx, b) = ldr;
    end
    [f_min] = sum(ldr_tot.*M_argmin, 1:2);
end