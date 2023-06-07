% sdv = zeros(2,1);
% matparam = zeros(3,1);
% matparam(1) = 210000;
% matparam(2) = 500;
% matparam(3) = 10000;
% epsilon = 1e-6;
% cd('/home/mharnisch/Schreibtisch/workingdirectory/PhD/data_set_creator/1D/data_set_creator_0002/material_laws');
% codegen -report linear_plasti.m -args {sdv,epsilon,matparam} -test test_plasti
%%

sdv = zeros(2,1);
matparam = zeros(3,1);
matparam(1) = 210000;
matparam(2) = 500;
matparam(3) = 10000;
epsilon = 1e-6;
init_flag = false;
mat_flag = 1;
% [stress, sdvup,matparam] = material_box(init_flag,sdv,epsilon,mat_flag,matparam)
codegen -report material_box.m -args {init_flag,sdv,epsilon,mat_flag,matparam} 