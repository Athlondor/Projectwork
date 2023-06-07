function [stress, sdvup] = elasticity(sdv,epsilon,mat_param) %#codegen
%% One-dimensional constitutive model for linear plasticity with linear isotropic hardening and kinematic hardening

% Extract Material parameters
EMod = mat_param(1);
% Extract internal variables
e11 = epsilon;
%Predictor Corrector Scheme
stress = EMod*e11;
    sdvup = [];
    
end