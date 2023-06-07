function [stress, sdvup,matparam] = material_box(init_flag,sdv,epsilon,mat_flag,matparam) %#codegen
%% Material Box to be used in the Data Set creation
% In order to implement a new material model, two steps have to be carried
% out
% 1. In the "init_flag" case distinction, the structure of the internal
% variables and the material parameters have to be defined. The structure
% of the internal variable can be chosen on own behalf as long as all
% information is assigned to the "sdvup" variable, which will be fed to the
% material law, and as long as the sdvup variable is consistently treated
% in your material routine.
%Possible structure might of course be arrays, but the can
% also be of struct type (e.g. sdvup.plasti_strain = 0} or of cell type (
% e.g. sdvup{1} = your_struct_here). 
% Note: The empty variable "stress = []" has to be defined for matlab to
% not abort with an error.



% 2.  In the "mat_flag" case distinction, your material routine has to be
% implementd. The function can be of various as long as the output consists
% of the stress value (scalar) and your self defined sdvup structure. An
% example is given in the "linear_plasti" function.

if init_flag% initialization of internal state variables
    stress = 0;
    switch mat_flag
        case 1 % linear plasticity with isotropic hardening
            sdvup = zeros(2,1);
            matparam = zeros(3,1);
            matparam(1) = 210000;
            matparam(2) = 500;
            matparam(3) = 10000;
%             stress = [];
        case 2 % Your initilization of internal variables here
            sdvup = zeros(3,1);
            matparam = zeros(4,1);
            matparam(1) = 210000; % Youngs Modulus
            matparam(2) = 500; % Initial Yield Limit
            matparam(3) = 10000; % (isotopric) hardening modulus
            matparam(4)  = 0; % r = 1: isotropic hardening, r=0: kinematic hardening
        case 3 % Elasticity 
            sdvup = [];
            matparam = zeros(1,1);
            matparam(1) = 210000;
    end
else
    switch mat_flag
        case 1 % linear plasticity with isotropic hardening
            [stress,sdvup] = linear_plasti(sdv,epsilon,matparam);
%             [stress,sdvup] = linear_plasti_mex(sdv,epsilon,matparam);
        case 2 % Your material model here
            [stress,sdvup] = mixed_plasti(sdv,epsilon,matparam);
        case 3 % linear elasticity
            [stress,sdvup]= elasticity(sdv,epsilon,matparam);
    end
    
end
end