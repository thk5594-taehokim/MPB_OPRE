%% OCBA_IU
function main_server(AI)

rng(AI);

% global T_end k B MPBopt cond_opt R

for example_number = 1:2
    dataname = strcat('macro_', num2str(AI), '_Example', num2str(example_number), '.mat');
          
       
    macrorep = 100;

    T_end = 80000;
    k = 10;
    B = 50;
    R = 1;
    n_0 = 5;
    
    warm_start = k * B * n_0 + 1;
    
    switch example_number
        case 1
            xb_fig = sort([5 5 5 5 5 5 5 5 10]);
            weight = 8 * ones(1, B);
            weight((B-19):(B-10)) = 16;
            weight((B-9):end) = 10;
            normal_vs_nonnormal = 1;

        case 2
            xb_fig = ([5 5 5 5 5 5 5 10 5]);
            weight = 8 * ones(1, B);
            weight((B-19):(B-15)) = 16;
            weight((B-4):end) = 20; 
            normal_vs_nonnormal = 1;

    end
    tie_vec = zeros(5, T_end);
    PCS_tot = zeros(6,T_end);
    
    FNR_tot = zeros(6, T_end);
    FPR_tot = zeros(6, T_end);
    
    TFDR_tot = zeros(6, T_end);

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
        
        S = (4 + 2 * rand(k, B));

        [~, MPBopt] = max(sum((min(A) == A).*weight, 2));

        [~, cond_opt] = min(A);
        cond_opt = cond_opt == MPBopt;

        %warm up
        obj_EA = SampleStat;
        init(obj_EA, k, B, T_end);
        obj_EA.S = S.^2;
        obj_EA.A = A;
        obj_EA.normality = normal_vs_nonnormal;

        obj_EA.weight = weight;
        
        t_warm = 1; 
        while min(min(obj_EA.N)) < n_0
            DS_EA(obj_EA);
            update(obj_EA, t_warm, MPBopt, cond_opt, 0);
            t_warm = t_warm + 1;
        end
        obj_worst = copy(obj_EA); obj_Alg1 = copy(obj_EA); obj_Alg2 = copy(obj_EA); obj_Alg3 = copy(obj_EA); obj_Alg4 = copy(obj_EA);

        % After warmup

        for t = warm_start: T_end

            % EA policy

            DS_EA(obj_EA); update(obj_EA, t, MPBopt, cond_opt, 0);

            % C-OCBA

            DS_worst(obj_worst); update(obj_worst, t, MPBopt, cond_opt, 1);

            % Algorithm 1

            DS_opt_rate(obj_Alg1, 1); update(obj_Alg1,t, MPBopt, cond_opt, 1);

            % Algorithm 2

            DS_opt_rateTS(obj_Alg2, 1); update(obj_Alg2, t, MPBopt, cond_opt, 1);

            % Algorithm 3

            DS_opt_rate(obj_Alg3, 2); update(obj_Alg3, t, MPBopt, cond_opt, 1);

            % Algorithm 4

            DS_opt_rate(obj_Alg4, 3); update(obj_Alg4, t, MPBopt, cond_opt, 1);

        end

        PCS_tot = PCS_tot + [obj_EA.PCS; obj_worst.PCS; obj_Alg1.PCS; obj_Alg2.PCS; obj_Alg3.PCS; obj_Alg4.PCS]/macrorep;
        FNR_tot = FNR_tot + [obj_EA.FNR; obj_worst.FNR; obj_Alg1.FNR; obj_Alg2.FNR; obj_Alg3.FNR; obj_Alg4.FNR]/macrorep;
        FPR_tot = FPR_tot + [obj_EA.FPR; obj_worst.FPR; obj_Alg1.FPR; obj_Alg2.FPR; obj_Alg3.FPR; obj_Alg4.FPR]/macrorep;       
        TFDR_tot = TFDR_tot + [obj_EA.TFDR; obj_worst.TFDR; obj_Alg1.TFDR; obj_Alg2.TFDR; obj_Alg3.TFDR; obj_Alg4.TFDR]/macrorep;
        
        tie_vec = tie_vec + [obj_worst.tie; obj_Alg1.tie; obj_Alg2.tie; obj_Alg3.tie; obj_Alg4.tie]/macrorep;

    end
    
    save(dataname, 'PCS_tot', 'FPR_tot', 'FNR_tot', 'TFDR_tot');
end


