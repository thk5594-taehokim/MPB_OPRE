function [Ratio] = IntegralRatio(obj, VoS_MC_sample, s)

    % INPUT ARGUMENTS

    % VoS_MC_sample: MC sample drawn from the input predictive; ES: I think
    % in the current implementation, this is assumed to be a scalar (I'm
    % fine with that for now).
    % model (n x 1 vector)
    % s: input distribution index (1 <= s<= d)

    % OUTPUT

    % Ratio: ratio between integradn (n x 1 vector)

    par_min = obj.input_true_range(s, 1); par_max = obj.input_true_range(s, 2);

    % n = length(VoS_MC_sample);


    data_set = obj.input_data{s}; % collected input dataset

    m_i = length(data_set);

    data_sum_current = sum(data_set);

    data_sum_pred = data_sum_current + sum(VoS_MC_sample, 1);
    
    BatchSize = size(VoS_MC_sample, 1);

    denominator = gamcdf(1/par_min, m_i - 1, 1/data_sum_current) ...
        - gamcdf(1/par_max, m_i - 1, 1/data_sum_current);

    numerator = gamcdf(1/par_min, (m_i + BatchSize - 1) * ones(size(data_sum_pred)) , 1./data_sum_pred) ...
        - gamcdf(1/par_max, (m_i + BatchSize - 1) * ones(size(data_sum_pred)), 1./data_sum_pred);

    % Ratio = (numerator./denominator) * gamma(m_i + BatchSize - 1)/gamma(m_i - 1) ./ (data_sum_pred.^BatchSize) .* (data_sum_current./data_sum_pred).^(m_i-1);

    Ratio = (numerator./denominator) *  prod((m_i-1):(m_i + BatchSize - 2)) ./ (data_sum_pred.^BatchSize) .* (data_sum_current./data_sum_pred).^(m_i-1);


    

end

