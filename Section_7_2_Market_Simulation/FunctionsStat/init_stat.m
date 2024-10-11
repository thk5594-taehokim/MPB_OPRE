function [obj] = init_stat(obj, T_vec, k, B)

    obj.PCS = zeros(size(T_vec));
    obj.FNR = zeros(size(T_vec));
    obj.ACC = zeros(size(T_vec));

    obj.N_batch = zeros(k, B);


end

