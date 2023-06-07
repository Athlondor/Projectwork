function [sig, ivar_np1, E_t] = mat_linEl(eps, ivar_n,dt)
E=210000;
sig = E*eps;
E_t = E;
ivar_np1 = ivar_n;
end