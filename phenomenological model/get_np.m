function n_p = get_np(x_max, x)

    % Initialisierung von n_p mit 0
    n_p = 0;
    x_list = unique(x_max);

    for i = 1:numel(x_list)
        if x_list(i) < x
            n_p = n_p +1;
        end
        
    end




%    if step == 1 || x(cycle,step) <= x(cycle,step-1)
%
%            if x_list(i) < x(cycle,step)
%            n_p = n_p +1;
%            end
%        end