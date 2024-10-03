function DS_EA(obj)

% INPUT argument
% Y : sample mean
% N : number of allocated sample size
% mu : second moment
% S : sample variance
% flag : 0 if variance is known 1 if variance is unknown
% sig : simulation variance

% OUTPUT argument
% Y_new, N_new, mu_new, S_new : updated parameter values based on EA policy


[idx_x, idx_y] = find(obj.N == min(min(obj.N)));
idx = [idx_x(1), idx_y(1)];
Y_r = simulator(idx, obj);

temp = obj.N(idx(1), idx(2));
temp_Y = obj.Y(idx(1), idx(2));

obj.Y(idx(1), idx(2)) = temp_Y * temp/(temp+1) + Y_r/(temp+1);
obj.N(idx(1), idx(2)) = temp + 1;
obj.idx(:, sum(obj.N, 'all')) = idx;
end

