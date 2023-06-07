function [eps_right]= search_all_right(epsilon_start,epsilon_max,step_l,vz_id)
break_ind = 0;
count = 0;
if vz_id == 1 % positive
%eps_test =epsilon_start - step_l;
eps_test =epsilon_start;
elseif vz_id ==2 %negative
   % eps_test = epsilon_start + step_l;
   eps_test =epsilon_start;
end
    while break_ind == 0
        count = count+1;
        if vz_id == 1
            eps_test = eps_test + step_l;
        elseif vz_id == 2
            eps_test = eps_test + step_l;
        end
        if norm(eps_test) < norm(epsilon_max) || norm(norm(eps_test) - norm(epsilon_max)) < 10^-8
        %if norm(norm(eps_test)-norm(epsilon_max)) <= 10^-8    
            eps_right(count) =  eps_test;
        else 
            break_ind = 1;
        end
    end
end