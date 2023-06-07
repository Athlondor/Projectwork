function [D,koeff_matrix] = create_data_set(data,hist_flag)
data_size = length(data);
counter = 1;
for i = 1 : data_size
    past_time.sig = 0;
    past_time.eps = 0;
    load_path = [data{i}.eps',data{i}.sig]; % N x 2 matrix, where row 1 is the strain and row 2 the stress
    init_flag = 1;
    [hist_surr,koeff_matrix] = propagator(0,0,0,hist_flag,init_flag,past_time);
    path_size = size(load_path,1);
    init_flag = 0;
    for k = 1 : path_size
        eps_k = load_path(k,1);
        sig_k = load_path(k,2);
        D(counter).xi = eps_k;
        D(counter).sig = sig_k;
        D(counter).hist = hist_surr;
        [hist_surr] = propagator(eps_k,sig_k,hist_surr,hist_flag,init_flag,past_time);
        past_time.eps_k = eps_k;
        past_time.sig_k = sig_k;
        counter = counter + 1;
    end
    



end