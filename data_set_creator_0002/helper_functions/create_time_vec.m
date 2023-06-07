loadcurve = lam;
s_length = zeros(1,length(loadcurve)-1);
for ts = 1 : length(loadcurve)-1
        s_length(ts) = abs(loadcurve(ts+1)-loadcurve(ts));
    end
    total_s = sum(s_length(:));
    r_length = s_length./total_s;
    t_vec = zeros(1,length(lam));
%     t_vec(1) = 0;
if lam(2) == lam(3)
    tot_s = (tmax-dt)/dt;
else
    tot_s = tmax/dt;
end
%     for ts = 1 : length(r_length)
%         t(ts+1) = t(ts) + r_length(ts)*stopTime; 
%     end
for ts = 1 : length(r_length)
    t_vec(ts+1) = t_vec(ts) + r_length(ts)*tot_s; 
end
step_vec = round(t_vec);
% time_vec=round(t,2);
time_vec = step_vec * dt;
t= time_vec;