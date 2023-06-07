function [sig, ivar_np1, E_t] = mixed_linear_plasti(eps, ivar_n,dt)
EMod = 210000;
Y_0  = 500;
HMod = 10000;
r = 0.0;

e11 = eps;
ep11_n = ivar_n(1);
alpha_n = ivar_n(2);
kappa_n = ivar_n(3);
ivar_np1 = zeros(3,1);

%Predictor Corrector Scheme
 phi_tr = norm(EMod*(e11-ep11_n)-(1-r)*HMod*kappa_n)-(Y_0+r*HMod*alpha_n);
    if phi_tr < 0
        ep11_up = ep11_n;
        alpha_up = alpha_n;
        kappa_up = kappa_n;
        sig = EMod*(e11-ep11_up);
        E_t = EMod;
    else
        
        dlambda = phi_tr/(EMod+HMod);
        sig_trial = EMod*(e11-ep11_n)-(1-r)*HMod*kappa_n;
        kappa_up = kappa_n + dlambda*sign(sig_trial);
        ep11_up = ep11_n + dlambda*sign(sig_trial);
%         stress = (1-(EMod*dlambda)/(norm(sig_trial)))*sig_trial;
        sig = EMod*(e11-ep11_up);
%         sig = sig_trial + HMod*dlambda*sign(sig_trial);
        alpha_up= alpha_n+dlambda;
        E_t = EMod*HMod/(EMod+HMod);
        
%         c1 = EMod*(1-(EMod*dlambda)/norm(sig_trial) );
%         c2 = 2*EMod^2*( dlambda/norm(sig_trial) -  1/(EMod+HMod)    );
%         E_t =EMod + c1 + c2*sign(sig_trial);
%         E_t = 1;
%          c1      = 2*G*( 1-(2*G*dlambda) / (norm(sigdevred_trial,'fro')) );
%     c2      = 4*G^2 *(dlambda/norm(sigdevred_trial,'fro')-(1/(2*G + 2/3*H)));
%     ct  = K*IdyI + c1*IsymDev + c2*ndyn;
    end
% Update internal variables into output structure
    ivar_np1(1) = ep11_up;
    ivar_np1(2) = alpha_up;
    ivar_np1(3) = kappa_up;
    






























end
