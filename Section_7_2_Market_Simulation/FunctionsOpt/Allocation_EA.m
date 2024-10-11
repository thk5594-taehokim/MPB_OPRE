function [PCS_path, FNR_path, ACC_path, N] = Allocation_EA(T_vec, par)

    PCS_path = zeros(size(T_vec));
    FNR_path = zeros(size(T_vec));
    ACC_path = zeros(size(T_vec));

    weight = par.weight;
    market_setting = par.market_setting; 
    Y = par.Y; S2 = par.S2; N = par.N;
    batch_size = par.batch_size;

    [~, ~, ~, ~, ~, PCS, FNR, ACC] = updateBest(Y, weight, par);

    PCS_path(1) = PCS;  
    FNR_path(1) = FNR;
    ACC_path(1) = ACC;

    for i = 2 : length(T_vec)

        [idx_x, idx_y] = find(N == min(N, [], 'all'));
        idx = [idx_x(1), idx_y(1)];

        Ynew = simulator(idx, market_setting, batch_size);
        Y(idx(1), idx(2)) = (Y(idx(1), idx(2)) * N(idx(1), idx(2)) + mean(Ynew))/(N(idx(1), idx(2)) + 1);
        S2(idx(1), idx(2)) = (S2(idx(1), idx(2)) * N(idx(1), idx(2)) + mean(Ynew.^2))/(N(idx(1), idx(2)) + 1);
        N(idx(1), idx(2)) = N(idx(1), idx(2)) + 1;

        [~, ~, ~, ~, ~, PCS, FNR, ACC] = updateBest(Y, weight, par);

        PCS_path(i) = PCS;  
        FNR_path(i) = FNR;
        ACC_path(i) = ACC;

    end

end

