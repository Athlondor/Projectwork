%% Own Implementation of SMA 
close all;
clear;

% Initialisierung
sdv = zeros(2, 1);

% Geometrie
A_e = 0.49 * pi * 10^(-6); % m^2
l_e = 0.1; % m
V_e = A_e * l_e; % m^3

% Materialparameter
E_A = 72*10^9;      % Pa    [Austenit Young's Modulus]      check
E_M = 24*10^9;      % Pa    [Martensit Young's Modulus]     check
L_ini = 0.079*10^9; % Pa    [Latent Heat]                   check
L_sat = 0.825 * L_ini; % Pa                                 check
Y_ini = 0.064*10^9; % Pa/m  [Yield Limit]                   check
Y_sat = 0.65 * Y_ini; % Pa/m                                check
gamma = 0.001; % N s m^-4                                   check

% Eigene Recherche
dichte = 6.7*10^3; % kg/m3
m_e = V_e * dichte; % kg
c_m = 453; % J / (kg K)
C_m = c_m * m_e; % J/K

% c_m = 5.405 * 10^-3 *10^9; % Pa/K [specific heat capacity]
% C_m = 0.1562 *10^9; % Pa/K

% Damping Parameter
delta_l = 0.15; %                                           check
delta_y = 0.15; %                                           check
delta_x = 0.15; %                                           check

% Reference Temperature
theta_0 = 233.15; % K                                       check
eps_tr = 0.025; 

% Phasefront Parameter
X_min_sat = 0.0065; %check
X_max_sat = l_e;
X_min_1 = 0;
X_max_2 = l_e;


% strain driven
u_max = 0.05;
u_pre = 0;
theta = 301;
i_lc = 0;
x_1_n = 0;
x_2_n = l_e;


%% Maximum Strains/Loading_Cycle

ncy = 3;                 % Anzahl der Load-Cycles
load_max = 0.02;         % Maximale Dehnung des ersten Zyklus
load_min = 0.00;         % Minimale Dehnung des ersten Zyklus    
load_steps = 50;        % Anzahl der Timesteps/Zyklus
cycle_incr_max = 0.01;   % Wert, um den sich die max Dehnun/Zyklus erhöht
%cycle_incr_max = 1.2*10^-3;
cycle_incr_min = 0;      % Wert, um den sich die min Dehnung/Zyklus erhöht

eps = Loading_cycle(ncy, load_max, load_min, load_steps, cycle_incr_max, cycle_incr_min);


% Initialisierung
x_tau_1 = zeros(ncy,load_steps);
x_tau_2 = zeros(ncy,load_steps);
x_tau_1(1,1) = x_1_n;
x_tau_2(1,1) = x_2_n;
u = zeros(ncy,load_steps);
sig_list = zeros(ncy,load_steps);
eps_list = zeros(ncy,load_steps);
max_positions = NaN(1,ncy);  % Array zur Speicherung der maximalen Positionen

% Plotting Initialisierung
plotting = false;
legend_entries = cell(ncy,1);

% Zeitvektor
t = 1:1:load_steps;
dt = 1/load_steps;

%% DEBUGGING PARAMETER
n_p_list = zeros(ncy,load_steps);


%% Looping
for cycle = 1:ncy
    eps_cycle = eps(cycle,:);

    for step = 1:load_steps

        % Aktualisierung von n_p
        n_p = get_np(max_positions, x_1_n);
        n_p_list(cycle,step) = n_p;

        u_pre = l_e * eps_cycle(step);
        Y = Y_sat - (Y_sat - Y_ini) * exp(-delta_y * (i_lc - n_p));
        L = L_sat - (L_sat - L_ini) * exp(-delta_l * (i_lc - n_p));
        C_aC_m = L * (1 - theta_0 / theta) / theta_0;

        fun = @(x) (E_A * E_M * A_e / (2 * (E_A * (l_e - x(2) + x(1)) + E_M * (x(2) - x(1))))) ...
            * (0 - u_pre + eps_tr * (x(1) + x(2) - l_e))^2 ...
            - theta * log(theta) * (c_m * l_e) * A_e - theta * (C_m * l_e + C_aC_m * (x(2) - x(1))) * A_e ...
            + Y * A_e * l_e * norm(x(1) - x_1_n) + Y * A_e * l_e * norm(x(2) - x_2_n) ...
            + gamma * A_e * l_e / (2 * dt) * (x(1) - x_1_n)^2 + gamma * A_e * l_e / (2 * dt) * (x(2) - x_2_n)^2;

        A = [-1, 0; 1, -1; 0, 1];
        % b = [0; 0; l_e];
        b = [-X_min_1; 0; l_e];
        x0 = [x_1_n, x_2_n];
        % x0 = [ 0 0];
        % options = optimoptions('fmincon','Display','iter','Algorithm','sqp');
        % nonlcon = @unitdisk;
        
        lb = [0,0];
        ub= [l_e,l_e];
        x = fmincon(fun, x0, A, b,[],[],lb,ub);
        
        % Aktualisierung der Phasenfront
        x_1_n = x(1);
        x_2_n = x(2);
        x_tau_1(cycle,step) = x_1_n;
        x_tau_2(cycle,step) = x_2_n;
        u(cycle,step) = u_pre;
        X_min_1 = X_min_sat * (1 - exp(-delta_x * i_lc));
        % X_max_2 = X_max_sat * (1 - exp(-delta_x * i_lc));

        % Berechnung der Normalkraft / Spannung
        E_bar = (E_A * (l_e - x_2_n + x_1_n) + E_M * (x_2_n - x_1_n));
        N = (E_A * E_M * A_e / E_bar) * (u_pre - 0 - eps_tr * (x_1_n + x_2_n - l_e));
        sig = N / A_e;
        sig_list(cycle,step) = sig;
        eps_list(cycle,step) = eps_cycle(step);


    end

    % Aktualisierung der Parameter
    i_lc = i_lc + 1;
    max_position = max(x_tau_1(cycle,:));   % Maximale Position der Phasenfront im aktuellen Zyklus
    max_positions(cycle) = max_position;    % Speichern der maximalen Position im Array

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
    xlabel('Zeit');
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


