function [eps_left]= search_all_left(e_max,step_l,vz_id,full_cycle,epsilon_max)
%% THIS FUNCTION IS RETIRED AND IS NOT IN USE ANYMORE
%  It has been replaced by the "search_all_left_v2.m" function
%%
% if full_cycle 
%     e_max = -vz_id*epsilon_max;
% end
break_ind = 0;
count = 0;
if vz_id == 1
   eps_test =-step_l; 
elseif vz_id == 2
    eps_test =-step_l;
end
if full_cycle
    eps_test = -epsilon_max - step_l;
end
    while break_ind == 0
        count = count+1;
        if vz_id == 1
        eps_test = eps_test + step_l;
        elseif vz_id == 2
            eps_test = eps_test + step_l;
        end
        if norm((eps_test)-(e_max)) > 10^-8
       eps_left(count) =  eps_test;
        else 
            break_ind = 1;
        end
    end
end