classdef SampleStat < matlab.mixin.Copyable
    properties
        Y % mean surface
        N % number of allocated samples
        S %variance
        A % mean surface
        PCS %PCS vector
        ESS %expected set size
        k
        B
        ESS2 %expected set size at MPB
        
        FNR % false negative rate
        FPR % false positive rate
        TFDR % total false discovery rate
        
        PEF %exact type set PCS
        PIF %including type set PCS, PIF
        tie % number of tie
        mpb_vec % mpb prob vector
        mpb_sol % opt MPB
        
        weight 
        LDR

        normality % normal or not
    end
    methods
        function init(obj, k, B, T_end)
            obj.Y = zeros(k, B);
            obj.N = zeros(k, B);
            obj.k = k;
            obj.B = B;
            obj.PCS = zeros(1, T_end);
            obj.ESS = zeros(1, T_end);
            obj.ESS2 = zeros(1, T_end);
            obj.PEF = zeros(1, T_end);
            obj.PIF = zeros(1, T_end);

            obj.FNR = zeros(1, T_end);
            obj.FPR = zeros(1, T_end);
            obj.TFDR = zeros(1, T_end);
            obj.tie = zeros(1, T_end);
        end
        function update(obj, t, MPBopt, cond_opt, type)
            % update PCS, ESS, PEF, PIF, tie based on sample

            W = obj.weight;
            temp_Y = obj.Y;
            
            temp =  sum((min(temp_Y) == temp_Y).*W, 2);
            obj.mpb_vec  = temp;
            [pp, obj.mpb_sol] = max(temp);
            [~, argmin_x] = min(temp_Y);
            mpb_idx = find(temp == pp);
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
            

            obj.PCS(t) = temp_PCS + ~flag_tie * (obj.mpb_sol == MPBopt);
            obj.FNR(t) = temp_FNR + sum(W.*cond_opt.*adv_set)/sum(cond_opt.*W);
            obj.FPR(t) = temp_FPR + sum(W.*(~cond_opt).*fav_set)/sum((~cond_opt).*W);
            
            obj.TFDR(t) = temp_TFDR + (sum(W.*cond_opt.*adv_set) + sum(W.*(~cond_opt).*fav_set))/sum(W);
        end
    end
end