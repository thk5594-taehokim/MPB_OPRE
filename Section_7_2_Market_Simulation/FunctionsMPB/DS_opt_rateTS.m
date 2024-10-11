function DS_opt_rateTS(obj)

% INPUT argument
% obj : object (SampleStat_Synthetic.m)
% obj.Y : sample mean
% obj.N : number of allocated sample size
% obj.S : simulation variance

% Output

% idx : (i, b) pair to be simulated


mpb = obj.mpb_est;
temp_Y = obj.Y;
temp_N = obj.N;
[~, i_b] = min(temp_Y); % i_b: index of conditional optimum

var_S = obj.S;

type = obj.BalMatType;

totLDR = compute_LDR(temp_Y, var_S, temp_N, obj.delta);

obj.LDR = totLDR;


[delta_idx, crit_idx] = delta_set_idx(obj); i_b(delta_idx) = 0; 

A_TS = temp_Y;

switch type
    
    case 'mean_delta'

        % adv_delta = 1:size(obj.S, 2);
        % adv_delta([obj.fav_set crit_idx]) = []; %find(i_b ~= mpb & i_b ~= crit_idx); % adv_delta: adversarial set with delta_optimal input paramter

        % A_TS(:, adv_delta) = temp_Y(:, adv_delta) + sqrt(var_S(:, adv_delta)./temp_N(:, adv_delta)) .* randn(obj.k, length(adv_delta));

        % IZ_delta_set = find(i_b == 0); % delta IZ set

        % Posterior sampling for the pairs in the indifference set

        A_TS(mpb, crit_idx) = temp_Y(mpb, crit_idx) + sqrt(var_S(mpb, crit_idx)./temp_N(mpb, crit_idx)) .* randn(1, length(crit_idx));

    case 'KL_delta'

        adv_delta = find(i_b ~= mpb);

        A_TS(mpb, adv_delta) = temp_Y(mpb, adv_delta) + sqrt(var_S(mpb, adv_delta)./temp_N(mpb, adv_delta)) .* randn(1, length(adv_delta));

        A_TS(mpb, crit_idx) = temp_Y(mpb, crit_idx);

end

obj_TS = copy(obj); obj_TS.Y = A_TS;
% W_delta = obj.weight;

update(obj_TS, 1); i_b_TS = obj_TS.i_b;

% mpb_vec_TS =  sum((min(A_TS) == A_TS).*W_delta, 2); [~, mpb_TS] = max(mpb_vec_TS);
    
    
rho_TS = compute_LDR(A_TS, var_S, temp_N, obj.delta); % i_b_TS: conditional optima based on posterior sample, rho_TS: LDR at each (i, b)

% [delta_idx_TS, idx_crit] = delta_set_idx(obj_TS);

% [BM_TS, ~] = BalMat(mpb_vec_TS, mpb_TS, W_delta, i_b_TS, type, delta_idx_TS, idx_crit); % BM_TS: balance matrix based on Posterior Samples

[BM_TS, ~] = BalMat2(obj_TS);


% Posterior sampling for the case when the MPB dominates the other
% in terms of the preference prbability


totLDR_TS = BM_TS.*rho_TS;
[idx_x, idx_b] = find(totLDR_TS == min(min(totLDR_TS)) > 0);
idx_x = idx_x(1); idx_b = idx_b(1);
idx_1 = [idx_x, idx_b];
idx_2 = [i_b_TS(idx_b), idx_b];

x_idxopt = 1:obj.k;
x_idxopt(idx_2(1)) = [];

if temp_N(idx_2(1), idx_2(2))^2/var_S(idx_2(1), idx_2(2)) < sum(temp_N(x_idxopt, idx_b).^2./var_S(x_idxopt, idx_b))
    idx = idx_2;
else
    idx = idx_1;
end



Y_r = simulator([idx(1); obj.input_par(:, idx(2))] , obj);

temp = obj.N(idx(1), idx(2));
temp_Y = obj.Y(idx(1), idx(2));
obj.Y(idx(1), idx(2)) = temp_Y * temp/(temp+1) + mean(Y_r)/(temp+1);
obj.N(idx(1), idx(2)) = temp + 1;


end


