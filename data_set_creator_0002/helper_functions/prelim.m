epsilon_max_n = -epsilon_max;
epsilon_max = - epsilon_max;
step_l = epsilon_max_n/grid_res_x;
id=0;
vz_id=2;
sims = zeros(grid_res_x+1,grid_res_x+1,grid_res_x+1);
x_array = 0:step_l:epsilon_max_n;
level=1;