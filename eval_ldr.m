function [GW, x_opt, G_j] = eval_ldr(alpha, par)
mu = par.mu;
sig = par.sig;
W = par.W';
type = par.type;

k = length(mu);
G_j = zeros(k, 1); G_j(1) = Inf;
x_opt = Inf * ones(k, 1);
for i = 2:k
    if ~(W(i) == Inf)
        if i == 2
            G_j(i) = (mu(1) - mu(2))^2/2/(sig(1)^2/alpha(1) + sig(2)^2/alpha(2));
            x_opt(i) = (alpha(1)/sig(1)^2 * mu(1) + alpha(2)/sig(2)^2 * mu(2))/(alpha(1)/sig(1)^2 + alpha(2)/sig(2)^2);
        elseif i > 2
            if type == 1 
                beta = [alpha(1)/sig(1)^2; alpha(i)/sig(i)^2;alpha(2:i-1)./sig(2:i-1).^2];
                mu_new = [mu(1); mu(i);mu(2:i-1)];
                beta_cum = cumsum(beta);
                crit_val = cumsum(mu_new.*beta)./beta_cum;
                crit_val = crit_val(2:i);
                x = crit_val(find(crit_val <= mu(2:i), 1, 'first'));
                x_opt(i) = crit_val(2);
                G_j(i) = alpha(1)/2/sig(1)^2 * (x- mu(1))^2 + alpha(i)/2/sig(i)^2 * (x- mu(i))^2 + sum((alpha(2:(i-1))./sig(2:(i-1)).^2/2) .* max(0, x - mu(2:(i-1))).^2);
            else
                beta = [alpha(1)/sig(1)^2; alpha(i)/sig(i)^2];
                mu_new = [mu(1);mu(i)];
                x = sum(beta.*mu_new)/sum(beta);
                G_j(i) = alpha(1)/2/sig(1)^2 * (x- mu(1))^2 + alpha(i)/2/sig(i)^2 * (x- mu(i))^2;
            end
        end
    else
        G_j(i) = Inf;
    end
end
GW = G_j.*W;


end

