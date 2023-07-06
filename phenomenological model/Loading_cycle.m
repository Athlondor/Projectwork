function strain_array = Loading_cycle(ncy,load_max,load_min, load_steps, cycle_incr_max, cycle_incr_min)

% Array initialisieren
strain_array = zeros(ncy, load_steps);

% Schleife über die Load-Cycles
for i = 1:ncy
    % Load_end auf Load_min des folgenden Zyklus setzen
    load_end = load_min + cycle_incr_min;

    % Wachstum initialisieren
    increase = 2*load_max - (load_end + load_min);
    rel_incr = (load_max - load_min)/increase;
    steps_inc = round(rel_incr * load_steps);

    strain_array(i,1:steps_inc) = linspace(load_min, load_max, steps_inc); 

   
    strain_array(i,steps_inc+1:end) = linspace(load_max, load_end, (load_steps-steps_inc)); 
        

    load_max = load_max + cycle_incr_max;
    load_min = load_end;

end

% Ergebnis anzeigen
disp(strain_array);


end