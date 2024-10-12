function [rho, tot_S] = compute_VFA(Y_update, S, N)


[Y_min, x_b] = min(Y_update);


%[~, theta_size] = size(Y_update);

S_N = S./N;
% S_min = diag(S_N(x_b, :))';
ind = x_b + (0:(size(S,2)-1)) * size(S, 1);
S_min = S_N(ind);

tot_S = S_min + S_N;
rho = (Y_update - Y_min).^2./tot_S;
% rho(rho == 0) = Inf;
rho(ind) = Inf;



end

