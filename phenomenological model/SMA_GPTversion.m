%% Own Implementation of SMA 
close all;
clear;

% Initialisierung
sdv = zeros(2, 1);

% Materialparameter
E_A = 72; % GPa
E_M = 24; % GPa
L_ini = 0.079; % GPa
Y_ini = 0.064; % GPa/m
theta_0 = 233.15; % K
gamma = 0.001; % N s m^-4
c_m = 5.405 * 10^-3; % GPa/K
C_m = 0.1562; % GPa/K

l_e = 0.1; % m
L_sat = 0.825 * L_ini;
delta_l = 0.15;
Y_sat = 0.65 * Y_ini;
delta_y = 0.15;
X_min_sat = 0.0065;
X_max_sat = l_e;
delta_x = 0.15;


A_e = 0.49 * pi * 10^(-6); % m^2
eps_tr = 0.025;

% strain driven
u_max = 0.05;
t_end = 1;
dt = 0.01;
epsilon = 0;
u_pre = 0;
theta = 233.15;
i_lc = 1;
x_1_n = 0.1 * l_e;
x_2_n = 0.2 * l_e;
n_p = 1;
X_min_1 = 0;
X_max_2 = l_e;

% Zeitvektor
t = 0:dt:t_end;

% Laden
x_tau_1 = zeros(size(t));
x_tau_2 = zeros(size(t));
u = zeros(size(t));
sig_list = zeros(size(t));
eps_list = zeros(size(t));

%% Maximum Strains/Loading_Cycle

ncy = 5;                 % Anzahl der Load-Cycles
load_max = 0.06;         % Maximale Dehnung des ersten Zyklus
load_min = 0.00;         % Minimale Dehnung des ersten Zyklus    
load_steps = 20;         % Anzahl der Timesteps/Zyklus
cycle_incr_max = 0.005;  % Wert, um den sich die max Dehnun/Zyklus erhöht
cycle_incr_min = 0;      % Wert, um den sich die min Dehnung/Zyklus erhöht

eps = Loading_cycle(ncy, load_max, load_min, load_steps, cycle_incr_max,cycle_incr_min);

%% Looping
for cycle = 1:ncy
    eps_cycle = eps(cycle,:);

for step = 1:load_steps
    u_pre = l_e * eps_cycle(step);
    Y = Y_sat - (Y_sat - Y_ini) * exp(-delta_y * i_lc - n_p);
    L = L_sat - (L_sat - L_ini) * exp(-delta_l * i_lc - n_p);
    C_aC_m = L * (1 - theta_0 / theta) / theta_0;
    
    fun = @(x) (E_A * E_M * A_e / (2 * (E_A * (l_e - x(2) + x(1)) + E_M * (x(2) - x(1))))) ...
        * (0 - u_pre + eps_tr * (x(1) + x(2) - l_e))^2 ...
        - theta * log(theta) * (c_m * l_e) * A_e - theta * (C_m * l_e + C_aC_m * (x(2) - x(1))) * A_e ...
        + Y * A_e * l_e * norm(x(1) - x_1_n) + Y * A_e * l_e * norm(x(2) - x_2_n) ...
        + gamma * A_e * l_e / (2 * dt) * (x(1) - x_1_n)^2 + gamma * A_e * l_e / (2 * dt) * (x(2) - x_2_n)^2;

    A = [-1, 0; 1, -1; 0, 1];
    % b = [0; 0; l_e];
    b = [ X_min_1; 0; X_max_2];
    x0 = [x_1_n, x_2_n];
    x = fmincon(fun, x0, A, b);

    x_1_n = x(1);
    x_2_n = x(2);
    x_tau_1(step) = x_1_n;
    x_tau_2(step) = x_2_n;
    u(step) = u_pre;
    X_min_1 = X_min_sat * (1 - exp(-delta_x * i_lc));
    X_max_2 = X_max_sat * (1 - exp(-delta_x * i_lc));
    E_bar = (E_A * (l_e - x_2_n + x_1_n) + E_M * (x_2_n - x_1_n));
    N = (E_A * E_M * A_e / E_bar) * (u_pre - 0 - eps_tr * (x(1) + x(2) - l_e));
    sig = N / A_e;
    sig_list(step) = sig;
    eps_list(step) = eps_cycle(step);

    % Aktualisierung der Parameter
    %i_lc = i_lc + 1;
end

end

% Korrigiere die Länge von t
t = linspace(0, t_end, length(x_tau_1));

% Plots
figure;
plot(t, x_tau_1, 'r-', 'LineWidth', 1.5);
hold on;
plot(t, x_tau_2, 'b-', 'LineWidth', 1.5);
xlabel('Zeit');
ylabel('x_{\tau}');
legend('x_{\tau_1}', 'x_{\tau_2}');
title('Phasenfrontposition');

figure;
plot(t, sig_list, 'k-', 'LineWidth', 1.5);
xlabel('Zeit');
ylabel('Spannung');
title('Spannungsverlauf');

figure;
plot(t, eps_list, 'g-', 'LineWidth', 1.5);
xlabel('Zeit');
ylabel('Dehnung');
title('Dehnungsverlauf');


