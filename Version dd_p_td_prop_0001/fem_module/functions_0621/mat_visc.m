function [sig, ivar_np1, E_t] = mat_visc(eps, ivar_n,dt)
E_8 = 1000;
eta = 250;
E = 500;
sig = E_8*eps+E*eps-E*(dt*E*eps+eta*ivar_n)/(eta+dt*E);
E_t = E_8+E-dt*E^2/(eta+dt*E);
ivar_np1 = (dt*E*eps+eta*ivar_n)/(eta+dt*E);
end