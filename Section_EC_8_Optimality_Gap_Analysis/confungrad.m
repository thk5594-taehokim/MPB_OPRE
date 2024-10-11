function [c,DC] = confungrad(alpha, par)

% INPUT
% alpha: kx1 sampling ratio vector
% par: class object includes mean&variance at each system

% OUTPUT
% c:(k)x1 vectors consisting of each system's LDR (LDR at the best = 0)
% DC: gradient matrix (kxk) whose element is given as \partial i-th
% system's LDR/\partial \alpha_j.


mu = par.mu;
sig = par.sig;

[row, col] = size(mu);

if row == 1
    k = col;
    mu = mu';
else
    k = row;
end

x_tilde = zeros(1, k);
c = zeros(k, 1);

i_min = find(alpha > 1e-10, 1); % to prevent the zero in computation


alpha2  = alpha/sum(alpha);

for i = (i_min+1):k
    beta = [alpha2(i_min)/sig(i_min)^2; alpha2(i)/sig(i)^2;alpha2((i_min+1):i-1)./sig((i_min+1):i-1).^2];
    mu_new = [mu(i_min); mu(i);mu((i_min+1):i-1)];
    beta_cum = cumsum(beta);
    crit_val = cumsum(mu_new.*beta)./beta_cum;
    crit_val = crit_val(2:(i-i_min+1));
    x = crit_val(find(crit_val <= mu((i_min+1):i), 1, 'first'));
    x_tilde(i) = x;
    G_i = alpha(i_min)/2/sig(i_min)^2 * (x- mu(i_min))^2 + alpha(i)/2/sig(i)^2 * (x- mu(i))^2 + sum((alpha((i_min+1):(i-1))./sig((i_min+1):(i-1)).^2/2) .* max(0, x - mu((i_min+1):(i-1))).^2);
    c(i) = G_i;
end




if nargout > 1
    DC = zeros(k, k);
    for i = 1:k
        DC(i, :) = max(x_tilde - mu(i), 0).^2/2/sig(i)^2;
        if i > 1
            DC(i, i) = (x_tilde(i) - mu(i)).^2/2/sig(i)^2;
        end
    end
end

end

 