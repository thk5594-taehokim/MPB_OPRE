function main_server(AI)

    rng(AI); % to reproducibility

    % Example 1: Baseline, Example 2~4 corresponds to Scnenario 1~3,
    % respectively.
   
    
    for example_number = 1:4
        
        dataname = strcat('Result/macro', num2str(AI), '_Example', num2str(example_number), '.mat');
       
        macrorep = 100;
    
        n_0 = 5; % initial simulation allocation for "warm start".
        
        switch example_number
            case 1
                xb_fig = sort([9 6 5 5 5 5 5 5 5]);
                normal_vs_nonnormal = 1;
                T_end = 50000;
                k = 10;
                B = 50;
                R = 1;
            case 2
                xb_fig = sort([15 5 5 5 5 5 5 5]);
                normal_vs_nonnormal = 1;
                T_end = 20000;
                T_end2 = 6000;
                k = 10;
                B = 50;
                R = 1;
            case 3
                xb_fig = sort([9 6 5 5 5 5 5 5 5]);
                normal_vs_nonnormal = 1;
                T_end = 100000;
                k = 10;
                B = 50;
                R = 1;
            case 4
                xb_fig = sort([9 6 5 5 5 5 5 5 5]);
                normal_vs_nonnormal = 0;
                T_end = 80000;
                k = 10;
                B = 50;
                R = 1;
        end
        
        warm_start = k * B * n_0 + 1;
        PCS_tot = zeros(6,T_end);
        
        FNR_tot = zeros(6, T_end);
        FPR_tot = zeros(6, T_end);
        
        TFDR_tot = zeros(6, T_end);

        adv_ratio_tot = zeros(6, T_end);

        mu_tot = zeros(k, B, macrorep);
        sig_tot = zeros(k, B, macrorep);

        for r = 1 : macrorep
    
            A = zeros(k, B);
            
            cum_xb = cumsum(xb_fig);
            idx_size = 1:k;
            temp = 1; 
            for b = 1 : B
                idx_x = idx_size;
                if cum_xb(temp) < b
                    temp = temp + 1;
                end
                temp_1 = temp;
                if temp == length(xb_fig)
                    temp_1 = k;
                end
                idx_x(temp_1) = [];
                A(temp_1, b) = 1;
                A(idx_x, b) = randperm(k-1)+1;
            end
    
            MPBopt = environment(A);
    
            [~, cond_opt] = min(A);
            cond_opt = cond_opt == MPBopt;
            switch example_number
                case {1, 2, 4, 5, 6}
                    S = (4 + 2 * rand(k, B));
                case 3
                    S = (8 + 4 * rand(k, B));
            end
    
            mu_tot(:, :, r) = A;
            sig_tot(:, :, r) = S;
    
            %warm up
            obj_EA = SampleStat;
            init(obj_EA, k, B, T_end);
            obj_EA.S = S.^2;
            obj_EA.A = A;
            obj_EA.normality = normal_vs_nonnormal;
    
            t_warm = 1; 
            while min(min(obj_EA.N)) < n_0
                DS_EA(obj_EA);
                update(obj_EA, t_warm, MPBopt, cond_opt, 0);
                t_warm = t_warm + 1;
            end
            obj_EA.LDR = compute_VFA(obj_EA.Y, obj_EA.S, obj_EA.N);
            obj_COCBA = copy(obj_EA); obj_Alg1 = copy(obj_EA); obj_Alg2 = copy(obj_EA); obj_Alg3 = copy(obj_EA); obj_Alg4 = copy(obj_EA); 
    
            % After warmup
    
            for t = warm_start: T_end

                % EA policy
    
                DS_EA(obj_EA); update(obj_EA, t, MPBopt, cond_opt, 0);
    
                % C-COBA
    
                DS_worst(obj_COCBA); update(obj_COCBA, t, MPBopt, cond_opt, 1);
    
                % Algorithm 1
    
                DS_opt_rate(obj_Alg1, 1, 0); update(obj_Alg1,t, MPBopt, cond_opt, 1);
    
                % Algorithm 2 (Posterior sampling)
    
                DS_opt_rateTS(obj_Alg2, 1); update(obj_Alg2, t, MPBopt, cond_opt, 1);
    
                % Algorithm 3 (ACC)
    
                DS_opt_rate(obj_Alg3, 2, 0); update(obj_Alg3, t, MPBopt, cond_opt, 1);
    
                % Algorithm 4 (FNR)
    
                DS_opt_rate(obj_Alg4, 3, 0); update(obj_Alg4, t, MPBopt, cond_opt, 1);
                
            end

            PCS_tot = PCS_tot + [obj_EA.PCS; obj_COCBA.PCS; obj_Alg1.PCS; obj_Alg2.PCS; obj_Alg3.PCS; obj_Alg4.PCS]/macrorep;         
            FNR_tot = FNR_tot + [obj_EA.FNR; obj_COCBA.FNR; obj_Alg1.FNR; obj_Alg2.FNR; obj_Alg3.FNR; obj_Alg4.FNR]/macrorep;
            FPR_tot = FPR_tot + [obj_EA.FPR; obj_COCBA.FPR; obj_Alg1.FPR; obj_Alg2.FPR; obj_Alg3.FPR; obj_Alg4.FPR]/macrorep;
            
            TFDR_tot = TFDR_tot + [obj_EA.TFDR; obj_COCBA.TFDR; obj_Alg1.TFDR; obj_Alg2.TFDR; obj_Alg3.TFDR; obj_Alg4.TFDR]/macrorep;

            adv_ratio_tot = adv_ratio_tot + [obj_EA.zero_ratio; obj_COCBA.zero_ratio; obj_Alg1.zero_ratio; obj_Alg2.zero_ratio; obj_Alg3.zero_ratio; obj_Alg4.zero_ratio]/macrorep;
            
        end

        save(dataname, 'PCS_tot', 'FNR_tot', 'TFDR_tot', 'FPR_tot', 'adv_ratio_tot');
    end
end
