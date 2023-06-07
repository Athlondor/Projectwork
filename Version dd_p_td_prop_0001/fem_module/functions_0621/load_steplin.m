function stretch=load_steplin(dt,t,lam)
%LOAD_STEPLIN creates a stepwise linear function between given tuples of 
%time and value. 
%   The array that is returned is discretized due to the give timestep
%   size dt. The parameters t and lam have to be of the same size.
%
%   by Raphael Holtermann, 06/15/2011


%determine number of sections between given points of time
sections = numel(t);

%preallocate empty array
ysec = [];

%calculate linear function for every section
for sec=1:sections-1
    %define timeline
    xsec=t(sec):dt:t(sec+1);
    
    %eliminate the first element from section2 on, so that the first value
    %in the array doesn't double the last one from the previous section
    if sec > 1
        xsec = xsec(2:end);
    end
    
    %linear interpolation between given lambda(sec) and lambda(sec+1)
    ysec=[ysec (lam(sec+1)-lam(sec))/(t(sec+1)-t(sec))*(xsec-t(sec))+lam(sec)]; 
end

%write output
stretch = ysec;
    
end
