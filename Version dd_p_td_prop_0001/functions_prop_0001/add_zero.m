D(end+1) = D(end);
D(end).xi = 0;
D(end).sig = 0;
D(end).hist = zeros(length(D(1).hist),1);
% D(end).tau = zeros(size(D(end).phi,1),1);
% D(end).phi = zeros(size(D(end).phi,1),1);