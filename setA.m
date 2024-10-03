%% MODEL CONFIGURATION

global normal_vs_nonnormal

A = zeros(k, B);

switch example_number 
    case 1 %Baseline
        xb_fig = sort([9 6 5 5 5 5 5 5 5]);
        cum_xb = cumsum(xb_fig);

        idx_size = 1:k;
        temp = 1; 
        for b = 1 : B
            idx_x = idx_size;
            if cum_xb(temp) < b
                temp = temp + 1;
            end
            temp_1 = temp;
            if temp == length(xb_fig)
                temp_1 = k;
            end
            idx_x(temp_1) = [];
            A(temp_1, b) = 1;
            A(idx_x, b) = randperm(k-1)+1;
        end
        [~, val_opt] = environment(A);
        normal_vs_nonnormal = 1;
        S = (4 + 2 * rand(k, B));
    case 2 % clear dominance vs weak dominance
        xb_fig = sort([15 5 5 5 5 5 5 5]);
        cum_xb = cumsum(xb_fig);

        idx_size = 1:k;
        temp = 1; 
        for b = 1 : B
            idx_x = idx_size;
            if cum_xb(temp) < b
                temp = temp + 1;
            end
            temp_1 = temp;
            if temp == length(xb_fig)
                temp_1 = k;
            end
            idx_x(temp_1) = [];
            A(temp_1, b) = 1;
            A(idx_x, b) = randperm(k-1)+1;
        end
        [~, val_opt] = environment(A);
        normal_vs_nonnormal = 1;
        S = (4 + 2 * rand(k, B));
        
    case 3
        xb_fig = sort([9 6 5 5 5 5 5 5 5]);
        cum_xb = cumsum(xb_fig);

        idx_size = 1:k;
        temp = 1; 
        for b = 1 : B
            idx_x = idx_size;
            if cum_xb(temp) < b
                temp = temp + 1;
            end
            temp_1 = temp;
            if temp == length(xb_fig)
                temp_1 = k;
            end
            idx_x(temp_1) = [];
            A(temp_1, b) = 1;
            A(idx_x, b) = randperm(k-1)+1;
        end
        [~, val_opt] = environment(A);
        normal_vs_nonnormal = 1;
        S = (8 + 4 * rand(k, B));
        
    case 4
        xb_fig = sort([9 6 5 5 5 5 5 5 5]);
        cum_xb = cumsum(xb_fig);

        idx_size = 1:k;
        temp = 1; 
        for b = 1 : B
            idx_x = idx_size;
            if cum_xb(temp) < b
                temp = temp + 1;
            end
            temp_1 = temp;
            if temp == length(xb_fig)
                temp_1 = k;
            end
            idx_x(temp_1) = [];
            A(temp_1, b) = 1;
            A(idx_x, b) = randperm(k-1)+1;
        end
        [~, val_opt] = environment(A);
        normal_vs_nonnormal = 0;
        S = (4 + 2 * rand(k, B));
        
end



