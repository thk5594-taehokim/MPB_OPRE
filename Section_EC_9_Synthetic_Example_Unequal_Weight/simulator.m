function [Y_r] = simulator(idx, obj)

% global normal_vs_nonnormal

if obj.normality
    Y_r = (randn * sqrt(obj.S(idx(1), idx(2))) + obj.A(idx(1), idx(2)));
else
    Y_r = exprnd(sqrt(obj.S(idx(1), idx(2))), 1) - sqrt(obj.S(idx(1), idx(2))) + obj.A(idx(1), idx(2));
end

end