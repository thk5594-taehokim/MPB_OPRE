function [obj] = update_stat(obj, macrorep, PCS_path, FNR_path, ACC_path, N)

    obj.PCS = obj.PCS + PCS_path/macrorep;
    obj.FNR = obj.FNR + FNR_path/macrorep;
    obj.ACC = obj.ACC + ACC_path/macrorep;
    obj.N_batch = obj.N_batch + N/macrorep;

end
