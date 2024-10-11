function [idx_set, idx_crit] = delta_set_idx(obj)

    idx_crit = [];

    i_b = obj.i_b;

    switch obj.BalMatType

        case 'mean_delta'

            Ydiff = obj.Y - min(obj.Y);
            Ydiff(Ydiff == 0) = Inf;
            idx_set = find(min(Ydiff) < obj.delta & i_b == obj.mpb_est);
            idx_crit = find(i_b ~= obj.mpb_est & min(Ydiff) < obj.delta);
            
        case 'KL_delta'

            KL_temp = obj.m_vec' * obj.KL_input;
            % idx_set = find(KL_temp > obj.inputLDR & i_b == obj.mpb_est);

            Ydiff = obj.Y - min(obj.Y);
            Ydiff(Ydiff == 0) = Inf;
            idx_set = find(min(Ydiff) < obj.delta & i_b == obj.mpb_est);

            i_b0 = i_b; i_b0(idx_set) = 0; 
            [~, idx_crit] = min(KL_temp(:, i_b0 ~= obj.mpb_est));

            % i_b0 = obj.i_b; i_b0(idx_set) = 0; 
            % adv_delta = find(i_b0 ~= obj.mpb_est);

            % [~, idx_crit] = min(KL_temp(:, i_b0 ~= obj.mpb_est));

    end

end
    
