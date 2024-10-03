function [rho, tot_S, S_new, ind] = compute_VFA(Y_update, S, N)


[Y_min, x_b] = min(Y_update);


%[~, theta_size] = size(Y_update);

% alpha = N./sum(sum(N));
S_N = S./N;
% S_min = diag(S_N(x_b, :))';
ind = x_b + (0:(size(S,2)-1)) * size(S, 1);
S_min = S_N(ind);
S_new = S(ind);
tot_S = S_min + S_N;
rho = (Y_update - Y_min).^2./tot_S;
rho(ind) = Inf;




end

