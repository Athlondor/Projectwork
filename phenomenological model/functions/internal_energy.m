function fun = internal_energy(x)

%% material parameters
E_A = 72; % GPa
E_M = 24;  % GPa
%L_ini= 0.079; % GPa
%Y_ini =  0.064 ; % GPa/m
%theta_0 = 233.15; % K
%gamma =  0.001 ; % N s m^-4
c_m = 5.405*10^-3 ; % GPa/K Aus Thorstens diss
C_m = 0.1562 ; %GPa/K Aus Thorstens diss


%L_sat = 0.825*L_ini;
%delta_l = 0.15;
%Y_sat = 0.65*Y_ini;
%delta_y = 0.15;
%X_min_sat = 0.0065;
% X_max_sat = l_e;
%delta_x = 0.15;

l_e = 0.1  ; % m
%X_max_sat = 1;
A_e = 0.49*pi*10^(-6)  ; % m^2

eps_tr = 0.025;

E_bar = E_A*(l_e - x(2) + x(1))+E_M* (x(2)-x(1));

fun = E_A*E_M*A_e/(2*E_bar) * ( 0 - u_pre + eps_tr*(x(1) + x(2) - l_e )  )^2 ...
      -theta*log(theta)*(c_m*l_e)*A_e - theta*(C_m*l_e + C_aC_m*(x(2)-x(1)) )*A_e;

end