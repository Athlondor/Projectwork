%% Own Implementation of SMA 
close all;
clear;

% Initialisierung
sdv = zeros(2, 1);

% Materialparameter
E_A = 72*10^9; % Pa
E_M = 24*10^9; % Pa
L_ini = 0.079*10^9; % Pa
Y_ini = 0.064*10^9; % Pa/m
theta_0 = 300.15; % K
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
theta = 300.15;
i_lc = 1;
% x_1_n = 0.0037 * l_e;
% x_2_n = 0.0087 * l_e;

x_1_n = 0.0 * l_e;
x_2_n = 1.0 * l_e;
n_p = 0;
X_min_1 = 0;
X_max_2 = l_e;

%% Maximum Strains/Loading_Cycle

ncy = 4;                 % Anzahl der Load-Cycles
load_max = 0.05;         % Maximale Dehnung des ersten Zyklus
load_min = 0.00;         % Minimale Dehnung des ersten Zyklus    
load_steps = 20;         % Anzahl der Timesteps/Zyklus
cycle_incr_max = 0.005;  % Wert, um den sich die max Dehnun/Zyklus erhöht
cycle_incr_min = 0;      % Wert, um den sich die min Dehnung/Zyklus erhöht

eps = Loading_cycle(ncy, load_max, load_min, load_steps, cycle_incr_max,cycle_incr_min);


% Initialisierung
x_tau_1 = zeros(ncy,load_steps);
x_tau_2 = zeros(ncy,load_steps);
u = zeros(ncy,load_steps);
sig_list = zeros(ncy,load_steps);
eps_list = zeros(ncy,load_steps);
max_positions = zeros(1,ncy);  % Array zur Speicherung der maximalen Positionen

% Plotting Initialisierung
plotting = true;
legend_entries = cell(ncy,1);

% Zeitvektor
t = 1:1:load_steps;



%% Looping
for cycle = 1:ncy
    eps_cycle = eps(cycle,:);

    for step = 1:load_steps
        u_pre = l_e * eps_cycle(step);

        % Aktualisierung von n_p
        n_p = increase_np(max_positions, 0, x_1_n);
        display(n_p);

        % Aktualisierung von Y und L
        Y = Y_sat - (Y_sat - Y_ini) * exp(-delta_y * i_lc - n_p);
        L = L_sat - (L_sat - L_ini) * exp(-delta_l * i_lc - n_p);
        C_aC_m = L * (1 - theta_0 / theta) / theta_0;

        % Minimierungsproblem
        fun = @(x) (E_A * E_M * A_e / (2 * (E_A * (l_e - x(2) + x(1)) + E_M * (x(2) - x(1))))) ...
            * (0 - u_pre + eps_tr * (x(1) + x(2) - l_e))^2 ...
            - theta * log(theta) * (c_m * l_e) * A_e - theta * (C_m * l_e + C_aC_m * (x(2) - x(1))) * A_e ...
            + Y * A_e * l_e * norm(x(1) - x_1_n) + Y * A_e * l_e * norm(x(2) - x_2_n) ...
            + gamma * A_e * l_e / (2 * dt) * (x(1) - x_1_n)^2 + gamma * A_e * l_e / (2 * dt) * (x(2) - x_2_n)^2;

        A = [-1, 0; 1, -1; 0, 1];
        % b = [0; 0; l_e];
        b = [X_min_1; 0; X_max_2];
        x0 = [x_1_n, x_2_n];
        x = fmincon(fun, x0, A, b);

        x_1_n = x(1);
        x_2_n = x(2);
        x_tau_1(cycle,step) = x(1);
        x_tau_2(cycle,step) = x(2);
        u(cycle,step) = u_pre;
        X_min_1 = X_min_sat * (1 - exp(-delta_x * i_lc));
        X_max_2 = X_max_sat * (1 - exp(-delta_x * i_lc));
        E_bar = (E_A * (l_e - x(2) + x(1)) + E_M * (x(2) - x(1)));
        N = (E_A * E_M * A_e / E_bar) * (u_pre - 0 - eps_tr * (x(1) + x(2) - l_e));
        sig = N / A_e;
        sig_list(cycle,step) = sig;
        eps_list(cycle,step) = eps_cycle(step);


    end

    % Aktualisierung der Parameter
    i_lc = i_lc + 1;
    max_position = max(x_tau_1(cycle,:));  % Maximale Position der Phasenfront im aktuellen Zyklus
    max_positions(cycle) = max_position;  % Speichern der maximalen Position im Array

end


if plotting

    legend_entry = strings(ncy,1);
    color = zeros(ncy,3);
    cyc = 1:1:ncy;

    % MAX Phasenfrontenposition
    figure(1);
    hold on;
    scatter(cyc, max_positions, 'filled')
    xlabel('Zyklen');
    ylabel('Max Positions x_{\tau}');
    title('Max-Position der Phasenfront');
    hold off;

    % Phasenfrontenentwicklung
    figure(2);
    hold on;
    for cycle = 1:ncy
        color(cycle,:) = rand(1,3);  % Generiere eine zufällige Farbe
        legend_entry(cycle,:) = sprintf('Zyklus %d', cycle);
        plot(eps_list(cycle,:), x_tau_1(cycle,:), 'r-', 'LineWidth', 1.5);
        plot(eps_list(cycle,:), x_tau_2(cycle,:), 'b-', 'LineWidth', 1.5);
    end
    xlabel('Dehnung');
    ylabel('x_{\tau}');
    legend('x_{\tau_1}', 'x_{\tau_2}');
    title('Phasenfrontenentwicklung');
    hold off;

    % Spannungsverlauf - Zeit
    figure(3);
    hold on;
    for cycle = 1:ncy
        plot(t, sig_list(cycle,:), 'Color', color(cycle,:), 'DisplayName',legend_entry(cycle,:), 'LineWidth', 1.5);
    end
    xlabel('Zeit');
    ylabel('Spannung');
    title('Spannungsverlauf');
    legend('Location', 'Best');
    hold off;

    % Dehnungsverlauf - Zeit
    figure(4);
    hold on;
    for cycle = 1:ncy
        plot(t, eps_list(cycle,:), 'Color', color(cycle,:), 'DisplayName',legend_entry(cycle,:), 'LineWidth', 1.5);
    end
    xlabel('Zeit');
    ylabel('Dehnung');
    title('Dehnungsverlauf');
    legend('Location', 'Best');
    hold off;

    % Spannung - Dehnung
    figure(5);
    hold on;
    for cycle = 1:ncy
        plot(eps_list(cycle,:), sig_list(cycle,:), 'LineWidth', 1.5, 'Color', color(cycle,:), 'DisplayName',legend_entry(cycle,:));
    end
    xlabel('Dehnung');
    ylabel('Spannung');
    title('Spannungs-Dehnungs-Verlauf');
    legend('Location', 'Best');
    hold off;

end % End of plotting Case


