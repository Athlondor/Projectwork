step_l = epsilon_max/grid_res_x;
%sims = zeros(grid_res_x+1,grid_res_x+1,grid_res_x+1);
x_array = 0:step_l:epsilon_max;
%level=1;
for i =1 : grid_res_x
    pointer = 1;
    level=1;
    load_tree=zeros(1,1);
    eps_max = x_array(i+1);
    load_tree(level,1) = eps_max;
    level = 2;
    load_tree(level,:) =0;
%     [eps_left]= search_all_left(eps_max,step_l,vz_id);

%     [eps_left] = search_all_left(eps_max,step_l,vz_id,full_cycle,epsilon_max);
    epsilon_start = load_tree(level-1,pointer);
    [eps_left] = search_all_left_v2(epsilon_start,epsilon_max,step_l,vz_id);
     branch = load_tree(1:level-1,pointer);
                        for p = 1: length(eps_left)
                            if length(eps_left) == 1
                                load_tree(level,pointer) = eps_left(1);
                            else
                             branch2 = [branch; eps_left(p)];
                             if p == 1
                                 load_tree(:,pointer) = branch2;
                             else 
                          load_tree = [load_tree(:,1:pointer-1),branch2,load_tree(:,pointer:end)];
                             end
                            end
                          pointer = pointer +1;
                        end
    ready = false;
    %load_tree(level,1) = eps_left;
    pointer = 1;
    if level == n_cycle
        ready = true;
    end
    while ~ready
            pointer = 1;
            if level == n_cycle
                            ready = true;
                            break;
                        end
            level = level +1;
            load_tree(level,:) =0;
            for j= 1 : length(load_tree(level-1,:))
                epsilon_start = load_tree(level-1,pointer);
               % epsilon_max2 = eps_max;
                [eps_right] = search_all_right(epsilon_start,epsilon_max,step_l,vz_id);
                branch = load_tree(1:level-1,pointer);
%                         for p = 1: length(eps_right)
%                            load_tree(:,p) = branch;
%                         end
%                         for m = 1: length(eps_right)
%                            load_tree(level,m) = eps_right(m);
%                          %   load_tree(level,p) = eps_right(p);
%                         end
                       for p = 1: length(eps_right)
                                if length(eps_right) == 1
                                            load_tree(level,pointer) = eps_right(1);
                                 else
                                         branch2 = [branch; eps_right(p)];
                                         if p == 1
                                             load_tree(:,pointer) = branch2;
                                         else 
                                            load_tree = [load_tree(:,1:pointer-1),branch2,load_tree(:,pointer:end)];
                                         end
                                end
                              pointer = pointer +1;
                       end
            end
                        if level == n_cycle
                            ready = true;
                            break;
                        end
                        level = level+1;
                        load_tree(level,:) =0;
                        pointer = 1;
                 for k = 1 : length(load_tree(level-1,:))
               
                    eps_max =  load_tree(level-1,pointer);
                    
%                  [eps_left]= search_all_left(eps_max,step_l,vz_id);
                 epsilon_start = load_tree(level-1,pointer);
                 [eps_left] = search_all_left_v2(epsilon_start,epsilon_max,step_l,vz_id);
                  branch = load_tree(1:level-1,pointer);
                        for p = 1: length(eps_left)
                            if length(eps_left) == 1
                                load_tree(level,pointer) = eps_left(1);
                            else
                             branch2 = [branch; eps_left(p)];
                             if p == 1
                                 load_tree(:,pointer) = branch2;
                             else 
                          load_tree = [load_tree(:,1:pointer-1),branch2,load_tree(:,pointer:end)];
                             end
                            end
                          pointer = pointer +1;
                        end
                     %   for m = 1: length(eps_left)
                     %       if length(eps_left) == 1
                     %      load_tree2(level,k) = eps_left(1);
                    %        else
                    %       end
                         %   load_tree(level,p) = eps_right(p);
                    %    end
                end
            
    end
for lb = 1: size(load_tree,2)
   lam = zeros(size(load_tree,1)+2,1);
    lam(2:end-1) = load_tree(:,lb);
    if mod(size(load_tree,1),2) == 0 % even number of load-reversals (= n_cycle)
        lam(end) = epsilon_max; % then load to maximum
    else
        if full_cycle == 1 % if full cycle 
            lam(end) = -epsilon_max; %then reverse to negative maximum
        else % if not
            lam(end) = 0; %then reverse to zero
        end
    end
    lam_temp = [];
    rev_pos = 1;
    for i = 1 : length(lam)-1
        path = lam(i) :  sign(lam(i+1)-lam(i))*step_l : lam(i+1);
        if i <= length(lam) - 2
        rev_pos = rev_pos + length(path)-1;
        end
        lam_temp = [lam_temp,path(2:end)];
    end
    lam_temp = [0,lam_temp];
    lam = lam_temp';
    
    
    
    
    
    
    
    
  %  lam = [0   emax eend];
  s_length = zeros(1,length(lam)-1);
    for ts = 1 : length(lam)-1
        s_length(ts) = abs(lam(ts+1)-lam(ts));
    end
    total_s = sum(s_length(:));
    r_length = s_length./total_s;
    t = zeros(1,length(lam));
    tot_s = tmax/dt;
%     t(1) = 0;
    for ts = 1 : length(r_length)
        t(ts+1) = t(ts) + r_length(ts)*tot_s; 
    end
%     t=round(t,2);
step_vec = round(t);
% time_vec=round(t,2);
time_vec = step_vec * dt;
t= time_vec;

% start and end-time of loading, time-scale, no. of steps
ta=t(1);
te=t(end);
time=ta:dt:te;
steps=size(time,2);
e11=load_steplin(dt,t,lam);

s11      =zeros(steps,1);
ep11    = zeros(steps,1);
alpha  = zeros(steps,1);

[~, sdv,matparam] = material_box(true,[],[],mat_flag,[]);

save_point = find(time == t(end-1));
for rs_p = 1 : n_cycle
  test_vec = time - t(rs_p+1);
reversal_points(rs_p) = find(abs(test_vec)<=10^-8);
end
% find the array positions of the data which shall be saved in the data-set
% (the previous prescribed strains)
save_points = 0;
if mod(n_cycle,2) == 1 % uneven
% [el]= search_all_left(e11(reversal_points(end)),step_l,vz_id);
[el]= search_all_left_v2(e11(reversal_points(end)),epsilon_max,step_l,vz_id);
    if size(el) == 1
        save_points = steps(end);
    else
        save_points(1) = steps(end);
        lenge = length(el)-1;
        save_length = (steps(end) - reversal_points(end))/(lenge+1);
        for k =  1 : lenge
            save_points(k+1) = save_points(k) - save_length;
        end
        save_points2 = round(save_points);
        save_points = round([1:save_length:steps]);
    end
elseif mod(n_cycle,2) == 0 % even
[el]= search_all_right(e11(reversal_points(end)),epsilon_max,step_l,vz_id);
        if size(el) == 1
        save_points = steps(end);
        else
        lenge = length(el)-1;
        save_points = zeros(lenge+1,1);
        save_points(end) = steps(end);
        save_length = (steps(end) - reversal_points(end))/(lenge+1);
        for k =  0 : lenge-1
            save_points(end-(k+1)) = save_points(end-k) - save_length;
        end
        save_points2 = round(save_points);
        save_points = round([1:save_length:steps]);
    end
else
    error('Something went wrong....');
end
%save_points = zeros(1,0);
%for t = 1 : length(el)
%   save_points(t) = max(find(abs(e11(:)-el(t))<=10^-9));
%end
save_points = step_vec+1;
save_points2 = step_vec(rev_pos+1:end)+1;
for n=1:steps-1
    [stress, sdvup] = material_box(false,sdv,e11(n+1),mat_flag,matparam);
    s11(n+1) = stress;
    sdv = sdvup;
    
    
%     phi_tr = norm(EMod*(e11(n+1)-ep11(n)))-(Y_0+HMod*alpha(n));
%     %phi_tr = -1;
%     if phi_tr < 0
%         ep11(n+1) = ep11(n);
%         alpha(n+1) = alpha(n);
%         s11(n+1) = EMod*(e11(n+1)-ep11(n+1));
%                 
%     else
%         
%         
%        dlambda = phi_tr/(EMod+HMod);
%         sig_trial = EMod*(e11(n+1)-ep11(n));
%         ep11(n+1) = ep11(n) + dlambda*sign(sig_trial);
%         s11(n+1) = (1-(EMod*dlambda)/(norm(sig_trial)))*sig_trial;
%         alpha(n+1) = alpha(n)+dlambda;
%     end
%     
    
    
    
    
end
% past_time.eps_k = e11(reversal_points(end));
% past_time.sig_k = s11(reversal_points(end));
% hist_surr = propagator_initialization(e11,s11,reversal_points,hist_flag,past_time); % TO CODE
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
    past_time.sig_k = sig;
    %     D2(counter2).tau = (e11(reversal_points))';
%     %D(counter2).rho = sign(s11(reversal_points));
%     
%     D2(counter2).rho = zeros(n_cycle,1);
%     D2(counter2).rho(1:2:end) = -1;
%     D2(counter2).rho(2:2:end) = 1;
%     D2(counter2).phi = (s11(reversal_points));

end
end
   end              
% function [eps_left]= search_all_left(e_max,step_l,vz_id)
% break_ind = 0;
% count = 0;
% if vz_id == 1
%    eps_test =-step_l; 
% elseif vz_id == 2
%     eps_test =-step_l;
% end
%     while break_ind == 0
%         count = count+1;
%         if vz_id == 1
%         eps_test = eps_test + step_l;
%         elseif vz_id == 2
%             eps_test = eps_test + step_l;
%         end
%         if norm(norm(eps_test)-norm(e_max)) > 10^-8
%        eps_left(count) =  eps_test;
%         else 
%             break_ind = 1;
%         end
%     end
% end
% function [eps_right]= search_all_right(epsilon_start,epsilon_max,step_l,vz_id)
% break_ind = 0;
% count = 0;
% if vz_id == 1 % positive
% %eps_test =epsilon_start - step_l;
% eps_test =epsilon_start;
% elseif vz_id ==2 %negative
%    % eps_test = epsilon_start + step_l;
%    eps_test =epsilon_start;
% end
%     while break_ind == 0
%         count = count+1;
%         if vz_id == 1
%         eps_test = eps_test + step_l;
%         elseif vz_id == 2
%                 eps_test = eps_test + step_l;
%             end
%         if norm(eps_test) < norm(epsilon_max) |norm(norm(eps_test) - norm(epsilon_max)) < 10^-8
%         %if norm(norm(eps_test)-norm(epsilon_max)) <= 10^-8    
%        eps_right(count) =  eps_test;
%         else 
%             break_ind = 1;
%         end
%     end
% end    
    