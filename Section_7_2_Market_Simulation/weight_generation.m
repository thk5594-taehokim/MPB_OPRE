rng(2);

K = 11;
B = K^2;

lambda_min = 1; lambda_max = 3; % range of lambda
theta_min = 1; theta_max = 2; % rang of theta

lambda_supp  = linspace(lambda_min, lambda_max, K);     
theta_supp = linspace(theta_min, theta_max, K);
    
[X1, X2] = meshgrid(lambda_supp, theta_supp);
input_par = zeros(2, B);
input_par(1, :) = reshape(X1, 1, B); input_par(2, :) = reshape(X2, 1, B);


lambda1 = 1.6; lambda2 = 1.4;
m0 = 100;

data1 = exprnd(lambda1, 1, m0);
data2 = exprnd(lambda2, 1, m0);

LL = -1./input_par(1, :) * sum(data1) -log(input_par(1, :)) * m0 -1./input_par(2, :) * sum(data2) - log(input_par(2, :)) * m0;

LL = LL - max(LL);

weight = exp(LL)./sum(exp(LL));

