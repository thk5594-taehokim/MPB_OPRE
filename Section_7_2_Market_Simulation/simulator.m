function [output] = simulator(idx, market_setting, R)

%%

% idx: (i, \theta_b)
% market_setting: market statistics
% R: number of replications

if nargin < 3
    R = 1; 
end

output = zeros(1, R);

company_profile = market_setting.company_profile;
PPI_scen = market_setting.PPI_scen;

MyCompUWithoutPrice = market_setting.MyUWithoutPrice;
MyPrice = market_setting.MyPrice;

OtherUWithoutPrice = market_setting.OtherUWithoutPrice;
OtherPrice = market_setting.OtherPrice;

UPrice = market_setting.u_price;


i = idx(1); b = idx(2);
PPI = PPI_scen(b);
UPrice = UPrice * PPI;

num_pop = size(UPrice, 1);

idx_mat = zeros(length(company_profile), R);

for j = 1 : length(company_profile)
    idx_mat(j, :) = sum(rand(R, 1) >= [0 cumsum(company_profile{j}.prob)], 2); % multinomial random variables
end

u_tot2 = zeros(num_pop, 5);

for r = 1 : R
    
    u_tot2(:, 1) = MyCompUWithoutPrice(:, i);
    price_vec = zeros(1, 5);
    price_vec(1) = MyPrice(i);

    for j = 1 : length(company_profile)
        u_tot2(:, j+1) = OtherUWithoutPrice{j}(:, idx_mat(j, r));
        price_vec(j+1) = OtherPrice{j}(idx_mat(j, r)); 
    end
    

    u_tot = u_tot2 + UPrice * price_vec;
    
    u_tot = [u_tot zeros(size(u_tot, 1), 1)]; % the last column: utility of no purchase
    
    u_prob = exp(u_tot); u_prob = u_prob./sum(u_prob, 2); % linear choice model

    u_cdf = [zeros(num_pop, 1) cumsum(u_prob, 2)];
    
    flag = 0;


    while flag == 0
        u_vec = rand(num_pop, 1);
        prod_vol = zeros(1, 6); % Product volume vector: first : my company, 2nd~5th: Firms 1~4, end: # of no_purchase
        for l = 1:6
            prod_vol(l) = sum(u_cdf(:, l) <= u_vec & u_vec < u_cdf(:, l+1));
        end
        
        if sum(prod_vol(1:(end-1))) > 0
            output(r) = - prod_vol(1) * price_vec(1)./sum(prod_vol(1:(end-1)) .* price_vec); % negative revenue market share
            flag = 1;
        end
    end
end

end

