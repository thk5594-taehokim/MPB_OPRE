function DS_static(obj, batch)

    var_S = obj.S;
    
    [rho] = compute_VFA(obj.Y, var_S, obj.N);
    obj.LDR = rho;
    
    alpha_est = obj.alpha_opt;
    
    alpha_diff = (sum(obj.N, 1:2) + batch) * alpha_est - obj.N;
    
    [idx_x, idx_b] = find(alpha_diff == max(max(alpha_diff))> 0);
    idx_x = idx_x(1);
    idx_b = idx_b(1);
    
    idx = [idx_x, idx_b];
    
    Y_r = simulator(idx, obj);
    
    temp = obj.N(idx(1), idx(2));
    temp_Y = obj.Y(idx(1), idx(2));
    
    obj.Y(idx(1), idx(2)) = temp_Y * temp/(temp+1) + Y_r/(temp+1);
    obj.N(idx(1), idx(2)) = temp + 1;
end

