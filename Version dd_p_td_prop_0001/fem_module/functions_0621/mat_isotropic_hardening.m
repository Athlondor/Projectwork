function [sig, ivar_np1, E_t] = mat_isotropic_hardening(eps, ivar_n,dt)
EMod = 210000;
Y_0  = 500;%500 ;
HMod = 10000;
eps_p_n = ivar_n(1);
alpha_n = ivar_n(2);
% eps_n = ivar_n(3);
phi_tr = norm(EMod*(eps-eps_p_n))-(Y_0+HMod*alpha_n);
    if phi_tr < 0
        eps_p_np1 = eps_p_n;
        alpha_np1 = alpha_n;
        sig= EMod*(eps-eps_p_np1);
        E_t = EMod;        
    else
%         sig_n = EMod*(eps_n-eps_p_n);
%         eps_t = (eps -eps_n);
     %   dlambda = -(2*sig_n*EMod*eps_t)/(2*Y_0*HMod-2*HMod^2*alpha_n-2*EMod*sig_n);
%         dlambda = sign(sig_n)*EMod*eps_t/(EMod+HMod);
%         eps_p_np1 = eps_p_n+dlambda*sign(sig_n);
%         alpha_np1= alpha_n-dlambda;
%         sig =  EMod*(eps-eps_p_np1);
     %   E_t = EMod*(1- EMod/(Y_0*HMod-HMod^2*alpha_np1-EMod*sig)*norm(sig));
       % E_t2 = EMod-EMod^2*(sign(sig)/(EMod+2*HMod));
        E_t = EMod*HMod/(EMod+HMod);
        
        
        dlambda = phi_tr/(EMod+HMod);
        sig_trial = EMod*(eps-eps_p_n);
        eps_p_np1=eps_p_n + dlambda*sign(sig_trial);
        sig = (1-(EMod*dlambda)/(norm(sig_trial)))*sig_trial;
         alpha_np1= alpha_n+dlambda;
    end
    ivar_np1(1) = eps_p_np1;
    ivar_np1(2) = alpha_np1;
%     ivar_np1(3) = eps;
end