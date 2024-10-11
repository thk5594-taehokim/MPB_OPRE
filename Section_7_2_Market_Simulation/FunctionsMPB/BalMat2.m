function [BM, adv_delta, fav_delta] = BalMat2(obj)

%val, mpb, weight, i_b, type, delta_idx, crit_idx

% INPUT
% val : perforamance at each alternative (k x 1 vector)
% mpb : current MPB (scalar)
% weight : probability weights at each theta_b (1 x B vector)
% i_b : conditional optima at each theta_b (1 x B vector)
% type : 1 : basic type 2 : full characterize, 
%        delta_idx: delta-based version.

% OUTPUT
% BM : balance amtrix (k x B matrix)
% tie : indicator of tie (1: there is a tie, 0: otherwise)
% adv_delta: indices of input parameters in the adversarial set
%             & delta-optimal (1 x length(adv_delta) vector)
% fav_delta :indices of input parameters in the favorable set
%             & delta-optimal (1 x length(fav_delta) vector)



% delta_idx = [];

pref_vec = obj.pref_vec;
mpb = obj.mpb_est;
weight = obj.weight;
type = obj.BalMatType;
i_b = obj.i_b;


dif_pref = pref_vec(mpb) - pref_vec; % dif_pref: differences between the preferences probability of the MPB and each system
x_minus = 1:length(pref_vec);
x_minus(mpb) = []; % suboptimal system indices

% tie_set = sum(dif_pref == 0);
% tie = tie_set > 1;


temp_1 = min(dif_pref(x_minus));

adv_delta = 1:length(weight);

BM = zeros(length(pref_vec), length(weight));

[delta_idx, crit_idx] = delta_set_idx(obj);

if strcmp(type, 'mean_delta')

    x_b2 = i_b; x_b2(delta_idx) = 0;
    fav_delta = find(x_b2 == mpb);
    adv_set = find(i_b ~= mpb);
    fav_set = find(i_b == mpb);

    adv_delta([fav_set crit_idx]) = [];

    BM(:, fav_set) = min(dif_pref/2, temp_1) * ones(1, length(fav_set));
    BM(:, adv_set) = dif_pref * ones(1, length(adv_set));

else
    x_b2 = i_b; x_b2(delta_idx) = 0;
    fav_delta = find(x_b2 == mpb);
    adv_delta = crit_idx;
    adv_set = find(i_b ~= mpb);
    fav_set = find(i_b == mpb);

    BM(:, fav_set) = min(dif_pref/2, temp_1) * ones(1, length(fav_set));
    BM(:, adv_set) = dif_pref * ones(1, length(adv_set));
end

BM(mpb, :) = Inf;

ind = i_b + (0:(size(BM,2)-1)) * size(BM, 1);
BM(ind) = Inf;
BM = BM./weight;

BM = max(BM, 1);


BM(x_minus, fav_delta) = 1;
BM(mpb, adv_delta) = 1;




end

