sdv = zeros(2,1);
matparam = zeros(3,1);
matparam(1) = 210000;
matparam(2) = 500;
matparam(3) = 10000;
epsilon = 1e-6;

 [stress, sdvup] = linear_plasti(sdv,epsilon,matparam)