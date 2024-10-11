function PredSample = InputPredictiveSampling(obj, n)

    % INPUT ARGUMENTS

    % s: input distribution index (1 <= s<= d)
    % n: number of predictive samples
    
    % OUTPUT

    % PredSample : Sample from input predictive distribution (d x
    % TestSize matrix)
 
    % I need to change obj.TestSize here, however, it might affect the
    % other part. Hence, I copy ``obj" and modify its TestSize.

    obj_temp = copy(obj); obj_temp.TestSize = n;

    InputSample = InputPosteriorSampling(obj_temp);

    PredSample = InputDataGen(InputSample);

    % PredSample = InputDataGen(InputSample(s, :));

   
        
end