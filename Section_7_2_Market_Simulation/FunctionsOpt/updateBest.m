function [mpb, pref_vec, i_b, fav_set, adv_set, PCS, FNR, ACC] = updateBest(Y, PMF, par)

    % In this code, we update the MPB (mpb), favorable set (fav_set), adversarial set (adv_set), conditional optima (i_b) and
    % preference probabilities (pref_vec).
    % Further, we compute PCS, FNR, and ACC. 
    

    [~, i_b] = min(Y);
    
    pref_vec = sum((min(Y) == Y) .* PMF, 2);
    [~, mpb] = max(pref_vec);
    
    fav_set = find(i_b == mpb);
    adv_set = find(i_b ~= mpb);

    if nargin > 2
        fav_true = par.fav_set; true_opt = par.true_opt;
    
        PCS = mpb == true_opt;
        FNR = sum(PMF .* fav_true .* (i_b == mpb))/sum(PMF .* fav_true);
        ACC = sum(PMF .* ((i_b ~= mpb) .* (~fav_true)) + PMF .* ((i_b == mpb) .* fav_true));
    end

end

