function DS_opt_rate(obj, type)

% INPUT argument
% Y : sample mean
% N : number of allocated sample size
% flag : 0 if variance is known 1 if variance is unknown
% sig : simulation variance
% type : 1 : original 2 : full set idenficiation

% OUTPUT argument
% Y_new, N_new : updated parameter values based on dynamic sampling policy
% vom : Balance matrix
% tie : 1 = tie exists 0 : tie does not eixst
k = obj.k;

var_S = obj.S;
[~, x_b] = min(obj.Y);

[rho] = compute_VFA(obj.Y, var_S, obj.N);
[vom, ~] = BalMat(obj.mpb_vec, obj.mpb_sol, obj.weight, x_b, type);

% obj.tie = obj.tie + tie1;
obj.LDR = rho;
tot_max = vom.* rho;
[idx_x, idx_b] = find(tot_max == min(min(tot_max)) > 0);

idx_x =idx_x(1);
idx_b = idx_b(1);
idx_1 = [idx_x, idx_b];
idx_2 = [x_b(idx_b), idx_b];

x_vec = 1:k;
x_idxopt = x_vec;
if type == 1
    x_idxopt([idx_2(1) obj.mpb_sol]) = [];
else
    x_idxopt(idx_2(1)) = [];
end

% x_idxopt(idx_2(1)) = [];

if obj.N(idx_2(1), idx_2(2))^2/var_S(idx_2(1), idx_2(2)) < sum(obj.N(x_idxopt, idx_b).^2./var_S(x_idxopt, idx_b))
    idx = idx_2;
else
    idx = idx_1;
end

Y_r = simulator(idx, obj);

temp = obj.N(idx(1), idx(2));
temp_Y = obj.Y(idx(1), idx(2));

obj.Y(idx(1), idx(2)) = temp_Y * temp/(temp+1) + Y_r/(temp+1);
obj.N(idx(1), idx(2)) = temp + 1;


end
