function [f, grad, M_argmin, LDR_Gi] = Algorithm6(alpha, opt_stat)

    % This function implements Algorithm 6 in Section EC.8 to evaluate the
    % the function F(alpha) and its supergradient \partial F(alpha) at
    % fixed \alpha.
    % In this code, we fix k = 10 and B = 50

    % INPUT
    % alpha: given alpha in the probability simplex (kxB = 10x50 = 500
    % dimensional vector)
    % opt_stat: it stores some statistics related to the problem
    % configuration to enhance the computational speed

    % OUTPUT
    % f: we return a function value, F(alpha)
    % grad: we return a gradient of F, \partial F(alpha)
    % M_argmin: a kxB matrix indicating the false selection scenario s.t.
    % F(alpha) = \sum_{(i, \theta_b) \in I(M_argmin)}
    % \widetilde{G}_i(\theta_b).
    % LDR_Gi: 1*(k-1) vector where i-th elements is \widetilde{LDR}_i.

    k = 10;
    B = 50;
    
    mu = opt_stat.mu;
    S = opt_stat.sig;
    order_tot = opt_stat.order_tot;
    idx_tot = opt_stat.idx_tot;
    fav_set = opt_stat.fav_set;
    adv_idx_tot = opt_stat.adv_idx_tot;
    d_j = opt_stat.d_j;
    M0 = opt_stat.Mtrue;

    alpha_mat = reshape(alpha, k, B);
    ldr_tot = zeros(k, B);
    grad_ldr_tot = zeros(k, k, B);

    for b = 1 : B
        order_idx = order_tot(:, b);
        A_sorted = mu(order_idx, b);
        sig = S(order_idx, b);
    
        par.mu = A_sorted;
        par.sig = sig;
        par.type = 1;
    
        [ldr, grad_ldr] = confungrad(alpha_mat(order_idx, b), par); % confungrad(alpha, par) evaluates the LDR and its gradient at alpha (par includes model parameters e.g. mean&variance)
        
        ldr_tot(order_idx, b) = ldr;
        grad_ldr_tot(order_idx, order_idx, b) = grad_ldr;
    end
    
    upper_num = size(idx_tot, 2);
    val_mat = cell(k-1, upper_num);
    
    LDR_Gi = zeros(1, k-1);
    idx_sub = zeros(1, k-1);

    for i = 1 : (k-1) % find \tilde{A}_i for each i; we fix the index of the MPB = 10

        upper_num2 = ceil(d_j(i)/2);
        max_num = min(upper_num, upper_num2);
        val = zeros(1, max_num + 1);
        
        v2 = ldr_tot(i, fav_set);

        idx_temp = 1:(k-1);
        idx_temp(i) = [];
        
        v1_fav = min(ldr_tot(idx_temp, fav_set));
        v1_adv = ldr_tot(i, adv_idx_tot{i}); % adv_idx_tot: a set of indices of input parameters s.t. fav set of solution i & adv set of the MPB
        
        for N_2 = 0:max_num % same N_2 in Algorithm 6
            if N_2 == 0
                temp = sort([v1_fav v1_adv]);
                val(N_2+1) = sum(temp(1:d_j(i)));               
            else
                temp_1 = v1_fav(idx_tot{2, N_2});
                temp_2 = repmat(v1_adv, size(temp_1, 1), 1);
                
                temp_tot = [temp_1 temp_2];
                temp_tot_sorted = sort(temp_tot, 2);
                
                N_1 = max(d_j(i) - 2 * N_2, 0); % same N_1 in Algorithm 6

                if N_2 == 1
                    val_mat{i, N_2} = v2(idx_tot{1, N_2})' + sum(temp_tot_sorted(:, 1:N_1), 2);
                else
                   val_mat{i, N_2} = sum(v2(idx_tot{1, N_2}), 2) + sum(temp_tot_sorted(:, 1:N_1), 2);
                end
                val(N_2+1) = min(val_mat{i, N_2});

            end
        end
        [LDR_Gi(i), idx_sub(i)] = min(val);
    end

    [f, sol_idx] = min(LDR_Gi); % this informs us that M_argmin satisfying N_2 = sol_idx-1 (N_2 starts from 0, MATLAB index starts from 1)
    

    %% we compute the gradient as below:

    if nargout > 1 

        % first we find M_argmin (M^min in Algorithm 6)

        M_argmin = M0; % M0: true M matrix

        idx_temp = 1:9; idx_temp(sol_idx) = [];
        adv_idx = adv_idx_tot{sol_idx}; 
        
        [v1_fav, v1_idx] = min(ldr_tot(idx_temp, fav_set));
        v1_fav_min_idx = idx_temp(v1_idx);
        fav_subidx = (fav_set-1) * 10 + v1_fav_min_idx; % index of min G_{i}(\theta_b) s.t. (i, \theta_b) in V_{sol_idx, 1} for a fixed \theta_b

        N_2 = idx_sub(sol_idx)-1; 

        v1_adv = ldr_tot(sol_idx, adv_idx);

        if N_2 == 0 % when the number of V_{2, j} = 0, i.e., I(M_argmin) consists of \theta_b \in V_{1, j} 

            [~, id] = sort([v1_fav v1_adv]);
            
            id = id(1:d_j(sol_idx));
            id_fav = id(id<= length(v1_fav));
            id_adv =  id(id> length(v1_fav)) - length(v1_fav);
            M_argmin(:, [fav_set(id_fav) adv_idx(id_adv)]) = 0;

            M_argmin(fav_subidx(id_fav)) = 1;
            M_argmin(sol_idx, adv_idx(id_adv)) = 1;

        else
            idx_v1 = idx_tot{2, N_2};           
            idx_v2 = idx_tot{1, N_2};

            N_1 = max(d_j(sol_idx) - 2 * N_2, 0); 
            [~, id2] = min(val_mat{sol_idx, N_2});

            idx_v1 = idx_v1(id2, :);
            idx_v2 = idx_v2(id2, :);
            
            M_argmin(:, fav_set(idx_v2)) = 0; % idx_v2: index of misspecified \theta_b
            M_argmin(sol_idx, fav_set(idx_v2)) = 1; % (sol_idx, fav_set(idx_v2))s are misspecified pairs.

            if N_1 > 0 
                v1_fav2 = v1_fav(idx_v1);
                [~, id] = sort([v1_fav2 v1_adv]);

                id = id(1:N_1);
                id_fav = idx_v1(id(id<= length(v1_fav2)));
                id_adv =  id(id> length(v1_fav2)) - length(v1_fav2);
                M_argmin(:, [fav_set(id_fav) adv_idx(id_adv)]) = 0;
    
                M_argmin(fav_subidx(id_fav)) = 1;
                M_argmin(sol_idx, adv_idx(id_adv)) = 1;
            end
        end
        
        grad = zeros(k*B, 1);

        for b = 1 : B
            grad((k*(b-1)+1):k*b)= grad_ldr_tot(:, M_argmin(:, b) == 1, b);
        end
    end

end

