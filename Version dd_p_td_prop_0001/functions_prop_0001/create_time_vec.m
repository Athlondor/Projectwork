 for ts = 1 : length(loadcurve)-1
        s_length(ts) = abs(loadcurve(ts+1)-loadcurve(ts));
    end
    total_s = sum(s_length(:));
    r_length = s_length./total_s;
    t(1) = 0;
    tot_s = stopTime/dt;
%     for ts = 1 : length(r_length)
%         t(ts+1) = t(ts) + r_length(ts)*stopTime; 
%     end
for ts = 1 : length(r_length)
    t(ts+1) = t(ts) + r_length(ts)*tot_s; 
end
step_vec = round(t);
% time_vec=round(t,2);
time_vec = step_vec * dt;