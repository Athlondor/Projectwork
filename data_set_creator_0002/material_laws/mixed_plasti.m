function [stress, sdvup] = mixed_plasti(sdv,epsilon,mat_param) %#codegen
%% One-dimensional constitutive model for linear plasticity with linear isotropic hardening and kinematic hardening

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

%Predictor Corrector Scheme
 phi_tr = norm(EMod*(e11-ep11_n)-(1-r)*HMod*kappa_n)-(Y_0+r*HMod*alpha_n);
    if phi_tr < 0
        ep11_up = ep11_n;
        alpha_up = alpha_n;
        kappa_up = kappa_n;
        stress = EMod*(e11-ep11_up);
                
    else
        
        dlambda = phi_tr/(EMod+HMod);
        sig_trial = EMod*(e11-ep11_n)-(1-r)*HMod*kappa_n;
        kappa_up = kappa_n + dlambda*sign(sig_trial);
        ep11_up = ep11_n + dlambda*sign(sig_trial);
%         stress = (1-(EMod*dlambda)/(norm(sig_trial)))*sig_trial;
        stress = EMod*(e11-ep11_up);
        alpha_up= alpha_n+dlambda;
    end
% Update internal variables into output structure
    sdvup(1) = ep11_up;
    sdvup(2) = alpha_up;
    sdvup(3) = kappa_up;
    
end