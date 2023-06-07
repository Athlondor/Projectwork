
%Define boundarys in which the phase space shall be sampled
step_l = epsilon_max/grid_res_x;
grid_list = (0:step_l:epsilon_max);
for imax = 1 : grid_res_x
    if full_cycle
          start = -length(grid_list)+1;
    else
          start = 1;
    end
    for iend = start:imax
        counter2 = counter2 +1;
        emax = step_l*imax;
        eend = iend*step_l;
%emax = 0.005; %0.0500000000000000000000000000
%eend = 0.006;
%     t   = tmax*[0   0.5 1];
%     lam = [0   emax eend];
  if emax == eend
    lam = [0 : step_l:emax, eend];
%     t   = tmax*[0   0.5 1];%     lam = [0 emax];

    create_time_vec
    t(end) = t(end)+dt;
    step_vec(end) = step_vec(end)+1;
   else
    lam = [0:step_l:emax-step_l,emax:-step_l:eend];
    create_time_vec 
   end
% prescribed load/time step

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
for n=1:steps-1
     %% material_box
    [stress, sdvup] = material_box(false,sdv,e11(n+1),mat_flag,matparam);
    s11(n+1) = stress;
    sdv = sdvup;
    
%     sig_trial = EMod*(e11(n+1)-ep11(n));
%     phi_tr = norm(sig_trial)-(Y_0+HMod*alpha(n));
% 
%     if phi_tr < 0
%         ep11(n+1) = ep11(n);
%         alpha(n+1) = alpha(n);
%         s11(n+1) = EMod*(e11(n+1)-ep11(n+1));
%                 
%     else        
%         
%         dlambda = phi_tr/(EMod+HMod);
%         sig_trial = EMod*(e11(n+1)-ep11(n));
%         ep11(n+1) = ep11(n) + dlambda*sign(sig_trial);
%         s11(n+1) = (1-(EMod*dlambda)/(norm(sig_trial)))*sig_trial;
%         alpha(n+1) = alpha(n)+dlambda;
%     end
%     
%     
    
    
    
end
rev_pos = find(lam == emax);
% s_points = t/dt;
% reversal_points = round(steps/2);
save_points = step_vec(1:rev_pos)+1;
save_points2 = step_vec(rev_pos+1:end)+1;
% el = 1 : find(abs(grid_list - lam(2))<1e-10)-1;
% e2 = find(abs(grid_list - lam(3))<1e-10):el(end);
% reversal_points = round(steps/2);
% if size(el) == 1
%         save_points = 1;
%         save_points2 = 1;
% else
%         lenge = length(el)-1;
%         lenge2 = length(e2)-1;
%         save_length = (reversal_points(end)-1)/(lenge+1);
%         save_length2 = (steps - reversal_points(end))/(lenge2+1);
%         save_points = round([1:save_length:(length(el)+1)*save_length]);
%         save_points2 = round(round(steps/2)+save_length2:save_length2:steps);
% end
% if lam(3) == lam(2)
%     save_points2 = save_points(end);
%     save_points(end) = [];
% end



past_time.eps_k = 0;
past_time.sig_k = 0;
hist_surr = propagator_initialization(e11,s11,save_points,hist_flag,past_time); % TO CODE
past_time.eps_k = e11(save_points(end));
past_time.sig_k = s11(save_points(end));
if lam(end) == lam(end-1)
    past_time.eps_k = 0;
    past_time.sig_k = 0;
    hist_surr = propagator_initialization(e11,s11,save_points(1:end-1),hist_flag,past_time); % TO CODE
    if k_mn1_timestep_flag == 1
        [hist_surr] = propagator(e11(end),s11(end),hist_surr,hist_flag,0,past_time);
    end
    past_time.eps_k = e11(save_points(end));
    past_time.sig_k = s11(save_points(end));
else
    for k = 1 : length(save_points2)
        xi = e11(save_points2(k));
        sig = s11(save_points2(k));
        if k ~= length(save_points2) || k_mn1_timestep_flag
         [hist_surr] = propagator(xi,sig,hist_surr,hist_flag,0,past_time);   
        end
        past_time.eps_k = xi;
        past_time.sig_k = sig;
    end
end
xi = e11(end);
sig =  s11(end);
D2(counter2).xi = xi;
D2(counter2).sig = sig;
D2(counter2).hist = hist_surr;
    end
end