save_points = step_vec+1;
save_points2 = step_vec(rev_pos+1:end)+1;

past_time.eps_k = 0;
past_time.sig_k = 0;

[hist_surr,~,past_time] = propagator_initialization(e11,s11,[save_points(1:rev_pos)],hist_flag,past_time); 
% init_flag = 1;
% [hist_surr] = propagator(0,sig_k,hist_surr,hist_flag,init_flag,past_time);
for ds_entry = 1 : length(save_points2)
    counter2 = counter2 +1;
    xi = e11(save_points2(ds_entry));
    sig =  s11(save_points2(ds_entry));
    D2(counter2).xi = xi;
    D2(counter2).sig = sig;
    if k_mn1_timestep_flag == 1
        [hist_surr] = propagator(xi,sig,hist_surr,hist_flag,0,past_time);
    end
    D2(counter2).hist = hist_surr;
    if k_mn1_timestep_flag == 0
    [hist_surr] = propagator(xi,sig,hist_surr,hist_flag,0,past_time);
    end
    past_time.eps_k = xi;
    past_time.sig_k = sig;%     D2(counter2).tau = (e11(reversal_points))';

end
if reduced_flag == 0
    for ds_entry = 1 : length(save_points)
        counter = counter +1;
        Data{counter}.eps = e11(save_points);
        Data{counter}.sig = s11(save_points);
    end
end