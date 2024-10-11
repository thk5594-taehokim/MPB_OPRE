function [ratio] = LikelihoodRatio(obj, VoS_MC_sample, s)
% Computes the likelihood ratio between the two posterior distributions for
% VoS calculation. 
% VoS_MC_sample is a scalar valued observation (generated from the 
% predictive distribution) from the sth input process
    ratio = IntegralRatio(obj, VoS_MC_sample, s);
    
    ratio = ratio * exppdf(VoS_MC_sample
end

