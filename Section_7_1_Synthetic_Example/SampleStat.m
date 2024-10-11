classdef SampleStat < matlab.mixin.Copyable
    properties
        Y % mean surface
        N % number of allocated samples
        S %variance
        A % mean surface
        A_TS
        LDR % LDR matrix

        PCS %PCS vector
        ESS %expected set size
        k % solution set size
        B % parameter size
        ESS2 %expected set size at MPB
        
        FNR % false negative rate
        FPR % false positive rate
        TFDR % total false discovery rate
        
        PEF %exact type set PCS
        PIF %including type set PCS, PIF
        tie % number of tie
        mpb_vec % mpb prob vector
        mpb_sol % opt MPB
        normality % normal or not

        zero_ratio

        alpha_opt % optimal alpha

        idx
    end
    methods
        function init(obj, k, B, T_end)
            obj.Y = zeros(k, B);
            obj.N = zeros(k, B);
            obj.k = k;
            obj.B = B;
            obj.PCS = zeros(1, T_end);
            obj.FNR = zeros(1, T_end);
            obj.FPR = zeros(1, T_end);
            obj.TFDR = zeros(1, T_end);
            obj.tie = zeros(1, T_end);

            obj.idx = zeros(2, T_end);

            obj.zero_ratio = zeros(1, T_end);
        end
        function update(obj, t, MPBopt, cond_opt, type)
            % update PCS, ESS, PEF, PIF, tie based on sample
            % estimates
%             if ~(type == 2)
            temp_Y = obj.Y;
            temp =  sum(min(temp_Y) == temp_Y, 2);
            obj.mpb_vec  = temp;
            mpb_idx = find(temp == max(temp));
            flag_tie = (length(mpb_idx) > 1);
            obj.tie(t) = obj.tie(t) + flag_tie;
            
            if ~flag_tie
                obj.mpb_sol = mpb_idx(1);
                [~, argmin_x] = min(temp_Y);
            elseif flag_tie && type == 0 
                obj.mpb_sol = datasample(mpb_idx, 1);
                [~, argmin_x] = min(temp_Y);
            elseif flag_tie && type == 1
                temp_rho = min(obj.LDR(mpb_idx, :), [], 2);
                [~, k_idx] = max(temp_rho);
                obj.mpb_sol = mpb_idx(k_idx);
                [~, argmin_x] = min(temp_Y);
            end

            

            temp_PCS = obj.PCS(t);
            temp_FNR = obj.FNR(t);
            temp_FPR = obj.FPR(t);
            temp_TFDR = obj.TFDR(t);
            
            
            fav_set = argmin_x == MPBopt;
            adv_set = ~fav_set;
            
            obj.PCS(t) = temp_PCS + ~flag_tie*(obj.mpb_sol == MPBopt);
            fnr_temp = sum(adv_set(cond_opt));
            fpr_temp = sum(fav_set(~cond_opt));
            obj.FNR(t) = temp_FNR + fnr_temp/sum(cond_opt);
            obj.FPR(t) = temp_FPR + fpr_temp/sum(~cond_opt);
            
            obj.TFDR(t) = temp_TFDR + (fnr_temp + fpr_temp)/length(cond_opt);


            obj.zero_ratio(t) = obj.zero_ratio(t) + (sum(obj.N(obj.mpb_sol, cond_opt == 0)))/sum(obj.N, 'all');
        end
    end
end