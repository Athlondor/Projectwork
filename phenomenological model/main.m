
% --------------------------------------------------------------------- %
% Main function for sma functional fatigue
% 
%
% --------------------------------------------------------------------- %

%% SMA Functional fatiuge
close all;
clear;

%% initializiation
sdv = zeros(2,1);

%% material parameters
E_A = 72; % GPa
E_M = 24;  % GPa
L_ini= 0.079; % GPa
Y_ini =  0.064 ; % GPa/m
theta_0 = 233.15; % K
gamma =  0.001 ; % N s m^-4
c_m = 5.405*10^-3 ; % GPa/K Aus Thorstens diss
C_m = 0.1562 ; %GPa/K Aus Thorstens diss


L_sat = 0.825*L_ini;
delta_l = 0.15;
Y_sat = 0.65*Y_ini;
delta_y = 0.15;
X_min_sat = 0.0065;
% X_max_sat = l_e;
delta_x = 0.15;

l_e = 0.1  ; % m
X_max_sat = 1;
A_e = 0.49*pi*10^(-6)  ; % m^2

eps_tr = 0.025;


%% strain driven
u_max = 0.05;
t_end = 1;
dt = 0.01;
epsilon = 0;
u_pre = 0;
theta = 233.15;
i_lc = 1;
x_1_n =0.0*l_e;
x_2_n = 0.0*l_e;
n_p = 1;
X_min_1 = 0;
X_max_2= l_e;

%%
  emax = 0.05;
  eend = 0.01;
  
%   loadcurve = [0 1 0.5];
  
%     lam = [0:step_l:emax-step_l,emax:-step_l:eend];
lam = [0, emax, eend];
    create_time_vec;
    e11=load_steplin(dt,t,[0, emax, eend]);









    