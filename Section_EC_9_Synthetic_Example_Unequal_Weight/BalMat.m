function [BM, tie, b_argmax_c, b_idx] = BalMat(val, opt, weight, x_b, type)

% INPUT
% val : perforamance at each alternatove
% opt : current optimum
% x_b : conditional optimum
% type : 1 : basic type 2 : full characterize

% OUTPUT
% BM : balance amtrix

if nargin < 5
    type = 1;
end


dif = val(opt) - val;
x_minus = 1:length(val);
x_minus(opt) = [];

tie_set = sum(dif == 0);
tie = tie_set > 1;

b_idx = find(x_b == opt);
temp_1 = min(dif(x_minus));



b_argmax_c = 1:length(x_b);
b_argmax_c(b_idx) = [];



BM = zeros(length(val), length(x_b));
BM(:, b_idx) = min(dif/2, temp_1) * ones(1, length(b_idx));
ind = x_b + (0:(size(BM,2)-1)) * size(BM, 1);


BM(:, b_argmax_c) = dif * ones(1, length(b_argmax_c));
BM(opt, :) = Inf;
BM(ind) = Inf;
BM = BM./weight;

BM = max(BM, 1);

if type == 2
    BM(x_minus, b_idx) = 1;
    BM(opt, b_argmax_c) = 1;
elseif type == 3
    BM(opt, b_argmax_c) = 1;
end

end

