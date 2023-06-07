function [D2,counter2]= time_discrete_dataset_extension(vz_id,D2,counter2,n_cycle,epsilon_max,grid_res_x,orig_ncycle,mat_flag,full_cycle,k_mn1_timestep_flag)
% counter2 = counter;
global tmax dt hist_flag
    if n_cycle == 1
            if vz_id == 1 % positive
                positive_extension_ncycle_1;
            else % negative
                negativ_extension_ncycle_1;
            end
    else
            if vz_id == 1 % positive
                positive_extension;
            else % negative
                negative_extension;
            end
    end
end