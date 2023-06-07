step_l = epsilon_max/grid_res_x;
counter = 0;
counter2 = 0;
vz_id=1;
%sims = zeros(grid_res_x+1,grid_res_x+1,grid_res_x+1);
x_array = 0:step_l:epsilon_max;
% grid_list = (0:step_l:epsilon_max);
% grid_list = (-epsilon_max : step_l : epsilon_max);