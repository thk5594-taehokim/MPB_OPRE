function DS_opt_rateTS(obj, type)

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

% k = obj.k;
mpb = obj.mpb_sol; 
[~, x_b] = min(obj.Y);
% mpb_vec =  sum(min(obj.Y) == obj.Y, 2);
% mpb_idx = find(mpb_vec == max(mpb_vec));
var_S = obj.S;

[rho] = compute_VFA(obj.Y, var_S, obj.N);


obj.LDR = rho;

b_argmax_c = find(x_b ~= mpb);
A_TS = obj.Y;
A_TS(mpb, b_argmax_c) = obj.Y(mpb, b_argmax_c) + (sqrt(var_S(mpb, b_argmax_c))./sqrt(obj.N(mpb, b_argmax_c)) .* randn(1, length(b_argmax_c)));
mpb_vec_TS =  sum((min(A_TS) == A_TS).*obj.weight, 2);


[~, x_b_TS] = min(A_TS);
[rho_TS] = compute_VFA(A_TS, var_S, obj.N);

mpb_TS = mpb;

[vom_TS, ~] = BalMat(mpb_vec_TS, mpb_TS, obj.weight, x_b_TS, type);
tot_max_TS = vom_TS.*rho_TS;
[idx_x, idx_b] = find(tot_max_TS == min(min(tot_max_TS))> 0);
idx_x = idx_x(1);
idx_b = idx_b(1);
idx_1 = [idx_x, idx_b];
idx_2 = [x_b_TS(idx_b), idx_b];
x_idxopt = 1:obj.k;
x_idxopt([x_b_TS(idx_b) mpb]) = [];
if obj.N(idx_2(1), idx_2(2))^2/var_S(idx_2(1), idx_2(2)) < sum(obj.N(x_idxopt, idx_b).^2./var_S(x_idxopt, idx_b))
    idx = idx_2;
else
    idx = idx_1;
end
% end



Y_r = simulator(idx, obj);

temp = obj.N(idx(1), idx(2));
temp_Y = obj.Y(idx(1), idx(2));

obj.Y(idx(1), idx(2)) = temp_Y * temp/(temp+1) + Y_r/(temp+1);
obj.N(idx(1), idx(2)) = temp + 1;


end
