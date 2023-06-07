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
step_vec = round(t);
time_vec = step_vec * dt;
t= time_vec;