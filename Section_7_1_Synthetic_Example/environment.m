function [opt_sol, val] = environment(A, delta)

if nargin < 2
    delta = 0;
end

% [~, idx] = min(max(A));
% [~, dro_sol] = max(A(:, idx));

val = sum(min(A) == A, 2);
[~, opt_sol] = max(val);
%opt_sol = datasample(find(val == max(val)), 1);

end

