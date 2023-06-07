function [hist_surr_new,koeff_matrix,past_time] = propagator_initialization(e11,s11,grid_points,hist_flag,past_time)
eps_list = e11(grid_points);
sig_list = s11(grid_points);
[hist_surr,koeff_matrix] = propagator(0,0,0,hist_flag,1,past_time);
    init_flag = 0;
for k = 1 : length(eps_list)
        eps_k = eps_list(k);
        sig_k = sig_list(k);
        [hist_surr] = propagator(eps_k,sig_k,hist_surr,hist_flag,init_flag,past_time);
        past_time.eps_k = eps_k;
        past_time.sig_k = sig_k;
end
hist_surr_new = hist_surr;
% switch hist_flag
%     case 1
%     case 2 % only stress with maximum absolute value is saved
%         hist_surr_new = zeros(1,1);
%         koeff_matrix = 30;
%         [~,b]= max(abs((s11(reversal_points))));
%         hist_surr_new(1) = s11(reversal_points(b));
%     case 3 % only strain with maximum absolute value is saved
%         hist_surr_new = zeros(1,1);
%         koeff_matrix = 30;
%         [~,b]= max(abs((e11(reversal_points))));
%         hist_surr_new(1) = e11(reversal_points(b));
%     case 4
%     otherwise
%         error('Error: Unknown History Surrogate (hist_flag) \\ Error in Function "propagator" in line ');
% end

    
    
    
    
    
    
    
end