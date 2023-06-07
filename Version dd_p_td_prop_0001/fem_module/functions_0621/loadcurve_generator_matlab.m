function [fsur_new, u_new,eta_new] = loadcurve_generator_matlab(t_end, NOC,time, drlt, neum, neumDofs,drltDofs, fsur,u,eta, ndim)
%--------------------------------------------------------------------------
%   Input variables:
%   ----------------
%   u_end    : Total displacement which shall be reached at the end of 
%              of the load curve
%   t_end    : Total time in seconds of the loadcurve
%   NOC      : Number of cycles. Number of cycles in which the total disp.
%              shall be divided.
%   dt_rough : The time increment used for the non-critical calculations
%   dt_fine  : The time increment used for the calculations where a higher
%              displacement is prescribed than in the prior load cylce 
%   rad_perc : Radius (in percent of half a cycle) around the spike of the 
%              cycle in which the fine time increment shall be used. 
%              Possible values: [0 1]
% 
%--------------------------------------------------------------------------
%10.06.2021: Loadcurve_generator_v3 was rewritten to be used in a Matlab
%Implementation of a truss FEM Code!
%clc;
%close all;
u_end = 1;
%time = 0;
load_pairs = zeros(2,2*NOC);
NS = zeros(NOC,1);
NS(1) = 0;
delta_cycle = t_end/(2*NOC-1);
for i = 2 : NOC
    NS(i) = NS(i-1) + 2*delta_cycle;
end
DS = zeros(NOC,2);
x_value = delta_cycle : 2*delta_cycle : t_end;
y_value = x_value*u_end/t_end;
DS(:,1) = x_value;
DS(:,2) = y_value;
load_pairs(1,3:2:end) = NS(2:end); 
load_pairs(1,2:2:end) = x_value; 
load_pairs(2,2:2:end) = y_value; 

time_vec = load_pairs(1,:);
load_vec = load_pairs(2,:);

    
    numdrlt = size(drlt,1);
    numx1 = sum(drlt(:,2));
    numx2 = sum(drlt(:,3));
    disp  = zeros(numx1+numx2,1);
    eta_d = zeros(numx1+numx2,1);
    i = 1;
    if ndim == 2
    for k = 1 : numdrlt
        if drlt(k,2) == 1 && drlt(k,3) == 1
            disp(i) = interp1(time_vec,drlt(k,4)*load_vec,time,'linear');
          disp(i+1) = interp1(time_vec,drlt(k,5)*load_vec,time,'linear');
             eta_d(i) = 0;
           eta_d(i+1) = 0;
            i = i+1;
        elseif drlt(k,2) == 1
            disp(i) = interp1(time_vec,drlt(k,4)*load_vec,time,'linear');
             eta_d(i) = 0;
        elseif drlt(k,3) == 1 
            disp(i) = interp1(time_vec,drlt(k,5)*load_vec,time,'linear');
             eta_d(i) = 0;
        end
        i=i+1;
    end
    elseif ndim == 3 
        error('Load Interpolation not implemented for 3D problems!');
    end
%Extract total force value for Neumann boundary conditions (fsur) and
%interpolate the value for the current time step
 numNeumDofs = size(neum,1);
    numy1 = sum(neum(:,2)~=0);
    numy2 = sum(neum(:,3)~=0);
    force = zeros(numy1+numy2,1);
    l = 1;
 if ndim ==2
    for j = 1 : numNeumDofs
        if neum(j,2) ~= 0 && neum(j,3) ~= 0
            force(l) = interp1(time_vec,neum(j,2)*load_vec,time,'linear');
          force(l+1) = interp1(time_vec,neum(j,3)*load_vec,time,'linear');
            l = l+1;
        elseif neum(j,2) ~= 0
            force(l) = interp1(time_vec,neum(j,2)*load_vec,time,'linear');
        elseif neum(j,3) ~= 0 
            force(l) = interp1(time_vec,neum(j,3)*load_vec,time,'linear');
        end
        l=l+1;
    end
    elseif ndim == 3 
        error('Load interpolation not implemented for 3D problems!');
    end
%Write the force/displacement values in the global vectors at the
%corresponding node
fsur_new = fsur;
u_new = u;
eta_new = eta;
fsur_new(neumDofs) = force;
u_new(drltDofs)    = disp;
eta_new(drltDofs)  = eta_d;































%% Plotting
axis([0 t_end, 0 u_end]);
hold on;
plot(load_pairs(1,:),load_pairs(2,:),'k-','LineWidth',2);
hold on;
% for i = 1 : 1 : NOC
% circle(load_pairs(1,2*i),load_pairs(2,2*i),1.5*0.5*sqrt((load_pairs(1,2*i)-load_pairs(1,2*i-1))^2+load_pairs(2,2*i)^2),t_end,u_end);
% hold on;
% end

plot([0 t_end],[0 u_end],'b--');
hold on;
% c=date;
% disp(['------------------',c,'-----------------------------------------------'])
% disp(['----------------------------------------------------------------------------'])
% disp('Chosen parameters')
% disp('-----------------')
% disp(['Total time                     : ',num2str(t_end)])
% disp(['Total displacement             : ',num2str(u_end)])
% disp(['Total number of cycles (NOC)   : ',num2str(NOC)])
% disp(['Rougth time step               : ',num2str(dt_rough)])
% disp(['Fine time step                 : ',num2str(dt_fine)])
% disp(['Percentage of fine time steps  : ',num2str(rad_perc)])
% disp(['---------------------------------------------------------------------------']);
% disp(['Number of fine time steps      : ',num2str(fine_step_counter)]);
% disp(['Number of rough time steps     : ',num2str(rough_step_counter)]);
% disp(['Total Number of time steps     : ',num2str(total_step_counter)]);
% disp(['Width of initial cycle         : ',num2str(fine_steps+rough_steps)]);
