function [obj] = summarize_stat(obj, true_opt, obj2)

    obj.PCS = mean(obj2.est_opt_path == true_opt, 2);
    obj.N = mean(obj2.N_batch, 3);

    

end
