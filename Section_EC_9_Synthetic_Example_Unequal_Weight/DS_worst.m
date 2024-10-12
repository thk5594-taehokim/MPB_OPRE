function DS_worst(obj)



% INPUT argument
% Y : sample mean
% N : number of allocated sample size
% mu : second moment
% S : sample variance
% flag : 0 if variance is known 1 if variance is unknown
% sig : simulation variance

% OUTPUT argument
% Y_new, N_new, mu_new, S_new : updated parameter values based on EA policy
k = obj.k;

var_S = obj.S;

[~, x_b] = min(obj.Y);
[rho] = compute_VFA(obj.Y, var_S, obj.N);
obj.LDR = rho;
[idx_x, idx_b] = find(rho == min(min(rho)) > 0);
x_idxopt = 1 : k;
x_idxopt(x_b(idx_b)) = [];
if obj.N(x_b(idx_b), idx_b)^2/var_S(x_b(idx_b), idx_b) < sum(obj.N(x_idxopt, idx_b).^2./var_S(x_idxopt, idx_b))
    idx = [x_b(idx_b), idx_b];
else
    idx = [idx_x, idx_b];
end

Y_r = simulator(idx, obj);

temp = obj.N(idx(1), idx(2));
temp_Y = obj.Y(idx(1), idx(2));

obj.Y(idx(1), idx(2)) = temp_Y * temp/(temp+1) + Y_r/(temp+1);
obj.N(idx(1), idx(2)) = temp + 1;

end

