function [m_new, sim_data_size] = OptAllocation(AlphaBetaHist, AlphaBetaTarget, Delta, T, input_cost, input_dim, nonzero)

    % AlphaBetaHist = AlphaBetaHist/sum(AlphaBetaHist);

    H = Delta * eye(length(AlphaBetaHist));
    f =  -(T + Delta) * AlphaBetaTarget + T * AlphaBetaHist;
    

    Aeq = ones(1, length(AlphaBetaHist)); Aeq((end-length(input_cost)+1):end) = input_cost; beq = 1;

    lb = zeros(length(AlphaBetaHist), 1);

    options = optimoptions('quadprog', 'Display','off');
    x0 = ones(size(lb))/sum(Aeq);
    AlphaBetaOpt = quadprog(H, f, [], [], Aeq, beq, lb, [], x0, options);

    opt_beta = AlphaBetaOpt((end-length(input_cost)+1):end);

    prob_temp = [1 - sum(opt_beta .* input_cost); (opt_beta .* input_cost)]; prob_temp(prob_temp < 0) = 0; prob_temp = prob_temp./sum(prob_temp);

    tot_data_size = mnrnd(Delta/input_cost(1), prob_temp);

    m_new = tot_data_size((end-input_dim+1):end);

    sim_resid = Delta - sum(input_cost' .* m_new);

    AlphaOpt = AlphaBetaOpt(nonzero); AlphaOpt(AlphaOpt < 1e-4) = 0;

    sim_data_size = zeros(size(nonzero));

    if sim_resid > 0
        sim_data_size = mnrnd(sim_resid, AlphaOpt/sum(AlphaOpt));
    end
  

end

