function [stress, sdvup] = sm_alloy_wires(sdv,epsilon,mat_param)

    %% One-dimensional constitutive model for shape memory alloy wires 
    % with functional fatigue properties

    % Extract Material parameters
    EMod = mat_param(1);
    Y_0 = mat_param(2);
    HMod = mat_param(3);
    r = mat_param(4);
    % Extract internal variables
    e11 = epsilon;
    ep11_n = sdv(1);
    alpha_n = sdv(2);
    kappa_n = sdv(3);
    sdvup = zeros(3,1);


