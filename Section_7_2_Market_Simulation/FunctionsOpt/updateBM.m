function BM = updateBM(k, B, mpb, pref_vec, i_b, fav_set, adv_set, weight, type)

    % This code computes the balance weight matrix
    
    BM = zeros(k, B);

    dif_pref = max(pref_vec) - pref_vec;

    x_minus = 1:length(pref_vec);
    x_minus(mpb) = [];

    temp_1 = min(dif_pref(x_minus));

    switch type

        case {"MPB", "MPB-PS"}

            BM(:, fav_set) = min(dif_pref/2, temp_1) * ones(1, length(fav_set));
            BM(:, adv_set) = dif_pref * ones(1, length(adv_set));
        
            BM(mpb, :) = Inf;            
            BM = BM./weight;
            BM = max(BM, 1);

        case "COCBA"
        
            BM = ones(k, B);
        
        case "MPB-ACC"

            BM(:, fav_set) = min(dif_pref/2, temp_1) * ones(1, length(fav_set));
            BM(:, adv_set) = dif_pref * ones(1, length(adv_set));

            BM = BM./weight;
            BM = max(BM, 1);
            BM(:, fav_set) = 1;
            BM(mpb, :) = 1;

        case "MPB-FNR"

            BM(:, fav_set) = min(dif_pref/2, temp_1) * ones(1, length(fav_set));
            BM(:, adv_set) = dif_pref * ones(1, length(adv_set));
        
            BM = BM./weight;
            BM = max(BM, 1);
            BM(mpb, :) = 1;
    end

    ind = i_b + (0:(size(BM,2)-1)) * size(BM, 1);
    BM(ind) = Inf; % make the balance weight at the conditional optima infinity

    
    

end

