if td_switch == 1
new_ncycle = n_cycle;
for td_extra = 1 : n_cycle - 1
    new_ncycle = new_ncycle -1;
    disp(['Calculating the data-set entries with only ',num2str(new_ncycle), ' load reversal point(s) unequal 0 for positive strains']);
[D2,counter2] = time_discrete_dataset_extension(vz_id,D2,counter2,new_ncycle,epsilon_max,grid_res_x,n_cycle,mat_flag,full_cycle,k_mn1_timestep_flag);
end
disp(['Calculating the data-set entries with no load reversal point(s) for positive strains']);
end