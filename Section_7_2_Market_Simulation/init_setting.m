%% Initilaization of population, companies, economic risk

% Economic risk/ CPI scenario described in Section 7.2

PPI_scen = linspace(0.8, 1.2, 20);

 % number of people;
num_option = 5;
num_level = 3;
num_part = num_option * num_level;

company_num = 4;
TotProf = cell(1, company_num);

price_utility_tot = zeros(num_level, num_option, company_num);
ProdProfile = cell(1, company_num);
ProbProfile = cell(1, company_num);
CompBrand = zeros(1, company_num);

UBrand = [500 350 250 150];

ProbProfile{1} = [0.5 0.3 0.2];
ProbProfile{2} = [0.4 0.4 0.2];
ProbProfile{3} = [0.3 0.3 0.2 0.2];
ProbProfile{4} = [0.2 0.2 0.2 0.2 0.2];


% company 1
price_utility_tot(:, :, 1) = [50 40 60 30 20;100 80 80 60 30;150 120 120 90 40];

ProdProfile{1} = zeros(num_level, num_option, 3);
ProdProfile{1}(2, 1, 1) = 1; ProdProfile{1}(3, 2, 1) = 1; ProdProfile{1}(2, 3, 1) = 1; ProdProfile{1}(3, 4, 1) = 1; ProdProfile{1}(3, 5, 1) = 1;
ProdProfile{1}(2, 1, 2) = 1; ProdProfile{1}(2, 2, 2) = 1; ProdProfile{1}(3, 3, 2) = 1; ProdProfile{1}(3, 4, 2) = 1; ProdProfile{1}(2, 5, 2) = 1;
ProdProfile{1}(3, 1, 3) = 1; ProdProfile{1}(3, 2, 3) = 1; ProdProfile{1}(3, 3, 3) = 1; ProdProfile{1}(3, 4, 3) = 1; ProdProfile{1}(3, 5, 3) = 1;

%company 2

price_utility_tot(:, :, 2) = [50 40 40 30 20;100 80 60 60 30;150 120 80 90 40];

ProdProfile{2} = zeros(num_level, num_option, 3);
ProdProfile{2}(2, 1, 1) = 1; ProdProfile{2}(2, 2, 1) = 1; ProdProfile{2}(3, 3, 1) = 1; ProdProfile{2}(3, 4, 1) = 1; ProdProfile{2}(3, 5, 1) = 1;
ProdProfile{2}(3, 1, 2) = 1; ProdProfile{2}(2, 2, 2) = 1; ProdProfile{2}(2, 3, 2) = 1; ProdProfile{2}(2, 4, 2) = 1; ProdProfile{2}(3, 5, 2) = 1;
ProdProfile{2}(3, 1, 3) = 1; ProdProfile{2}(1, 2, 3) = 1; ProdProfile{2}(3, 3, 3) = 1; ProdProfile{2}(3, 4, 3) = 1; ProdProfile{2}(3, 5, 3) = 1;

% company 3

price_utility_tot(:, :, 3) = [60 50 60 40 30;120 100 80 60 40;180 150 100 80 50];

ProdProfile{3} = zeros(num_level, num_option, 4);
ProdProfile{3}(2, 1, 1) = 1; ProdProfile{3}(2, 2, 1) = 1; ProdProfile{3}(2, 3, 1) = 1; ProdProfile{3}(2, 4, 1) = 1; ProdProfile{3}(2, 5, 1) = 1;
ProdProfile{3}(2, 1, 2) = 1; ProdProfile{3}(2, 2, 2) = 1; ProdProfile{3}(3, 3, 2) = 1; ProdProfile{3}(1, 4, 2) = 1; ProdProfile{3}(1, 5, 2) = 1;
ProdProfile{3}(1, 1, 3) = 1; ProdProfile{3}(3, 2, 3) = 1; ProdProfile{3}(1, 3, 3) = 1; ProdProfile{3}(1, 4, 3) = 1; ProdProfile{3}(2, 5, 3) = 1;
ProdProfile{3}(1, 1, 4) = 1; ProdProfile{3}(2, 2, 4) = 1; ProdProfile{3}(2, 3, 4) = 1; ProdProfile{3}(1, 4, 4) = 1; ProdProfile{3}(1, 5, 4) = 1;

% company 4

price_utility_tot(:, :, 4) = [70 50 50 30 30;140 100 100 60 40;210 150 150 90 50];

ProdProfile{4} = zeros(num_level, num_option, 5);
ProdProfile{4}(1, 1, 1) = 1; ProdProfile{4}(1, 2, 1) = 1; ProdProfile{4}(1, 3, 1) = 1; ProdProfile{4}(1, 4, 1) = 1; ProdProfile{4}(1, 5, 1) = 1;
ProdProfile{4}(1, 1, 2) = 1; ProdProfile{4}(2, 2, 2) = 1; ProdProfile{4}(1, 3, 2) = 1; ProdProfile{4}(2, 4, 2) = 1; ProdProfile{4}(2, 5, 2) = 1;
ProdProfile{4}(1, 1, 3) = 1; ProdProfile{4}(1, 2, 3) = 1; ProdProfile{4}(1, 3, 3) = 1; ProdProfile{4}(2, 4, 3) = 1; ProdProfile{4}(2, 5, 3) = 1;
ProdProfile{4}(2, 1, 4) = 1; ProdProfile{4}(1, 2, 4) = 1; ProdProfile{4}(2, 3, 4) = 1; ProdProfile{4}(1, 4, 4) = 1; ProdProfile{4}(1, 5, 4) = 1;
ProdProfile{4}(2, 1, 5) = 1; ProdProfile{4}(1, 2, 5) = 1; ProdProfile{4}(1, 3, 5) = 1; ProdProfile{4}(1, 4, 5) = 1; ProdProfile{4}(1, 5, 5) = 1;


for i = 1 : company_num
    price_utility_temp = price_utility_tot(:, :, i);
    TotProf{i}.price_utility = price_utility_temp;
    TotProf{i}.num_prod = size(ProdProfile{i}, 3);
    TotProf{i}.all_prof = zeros(TotProf{1}.num_prod, num_part + 2);
    for r = 1:TotProf{i}.num_prod
        TotProf{i}.all_prof(r, 1:num_part) = reshape(ProdProfile{i}(:, :, r), 1, num_part);
        TotProf{i}.all_prof(r, end) = sum(price_utility_temp.*ProdProfile{i}(:, :, r), 'all');
    end
    TotProf{i}.all_prof(:, num_part+1) = UBrand(i);
    TotProf{i}.prob = ProbProfile{i};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% My Firm %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

price_utility = [40 60 60 30 20; 80 90 90 60 30; 120 120 120 90 40];

utility_brand = 450;

num_option = 5;
num_level = 3;
num_part = num_option*num_level;
prod_num = 7;

prod_1 = zeros(num_level, num_option); prod_1(3, 1) = 1; prod_1(3, 2) = 1; prod_1(3, 3) = 1; prod_1(3, 4) = 1; prod_1(3, 5) = 1;
prod_2 = zeros(num_level, num_option); prod_2(2, 1) = 1; prod_2(2, 2) = 1; prod_2(2, 3) = 1; prod_2(2, 4) = 1; prod_2(2, 5) = 1;
prod_3 = zeros(num_level, num_option); prod_3(1, 1) = 1; prod_3(1, 2) = 1; prod_3(1, 3) = 1; prod_3(1, 4) = 1; prod_3(1, 5) = 1;
prod_4 = zeros(num_level, num_option); prod_4(3, 1) = 1; prod_4(3, 2) = 1; prod_4(2, 3) = 1; prod_4(2, 4) = 1; prod_4(2, 5) = 1;
prod_5 = zeros(num_level, num_option); prod_5(3, 1) = 1; prod_5(3, 2) = 1; prod_5(1, 3) = 1; prod_5(1, 4) = 1; prod_5(1, 5) = 1;
prod_6 = zeros(num_level, num_option); prod_6(2, 1) = 1; prod_6(2, 2) = 1; prod_6(3, 3) = 1; prod_6(3, 4) = 1; prod_6(1, 5) = 1;
% prod_7 = zeros(num_level, num_option); prod_7(1, 1) = 1; prod_7(3, 2) = 1; prod_7(3, 3) = 1; prod_7(3, 4) = 1; prod_7(3, 5) = 1;
prod_7 = zeros(num_level, num_option); prod_7(2, 1) = 1; prod_7(2, 2) = 1; prod_7(1, 3) = 1; prod_7(1, 4) = 1; prod_7(3, 5) = 1;

MyProfile = zeros(prod_num , num_part + 2);
MyProfile(:, num_part+1) = utility_brand;

MyProfile(1, 1:num_part) = reshape(prod_1, 1, num_part);
MyProfile(2, 1:num_part) = reshape(prod_2, 1, num_part);
MyProfile(3, 1:num_part) = reshape(prod_3, 1, num_part);
MyProfile(4, 1:num_part) = reshape(prod_4, 1, num_part);
MyProfile(5, 1:num_part) = reshape(prod_5, 1, num_part);
MyProfile(6, 1:num_part) = reshape(prod_6, 1, num_part);
MyProfile(7, 1:num_part) = reshape(prod_7, 1, num_part);
% MyProfile(8, 1:num_part) = reshape(prod_8, 1, num_part);

MyProfile(:, num_part+2) = [sum(price_utility.*prod_1, 'all'); sum(price_utility.*prod_2, 'all'); sum(price_utility.*prod_3, 'all'); sum(price_utility.*prod_4, 'all'); sum(price_utility.*prod_5, 'all'); sum(price_utility.*prod_6, 'all'); sum(price_utility.*prod_7, 'all')];%; sum(price_utility.*prod_8, 'all')];






