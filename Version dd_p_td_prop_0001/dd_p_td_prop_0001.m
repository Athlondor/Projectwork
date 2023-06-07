%___________________Data-driven Truss FEM for plasticity Code______________
%**************************************************************************
%|-------------------PhD thesis Marius Harnisch M.Sc.------------------|
%|-----------------supervised by Dr.-Ing. Thorsten Bartel-----------------|
%|----------------Date of creation: 22.08.2022----------------------------|
%|----------------List of Modifications:----------------------------------|
%|                                                                        |
%|                                                                        |
%**************************************************************************
% Note: This Version has been created after the Version
% "dd_p_td_0122_2_mc_prop" and aims to combine all previous branches into
% one central code that contains all different implementations of the dd
% plasti codes up to this point (22.08.2022). In the future, all extensions
% will be worked into this central code!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;
clc;
addpath('inputs_prop_0001');
addpath('functions_prop_0001');
addpath('data_sets_prop_0001');
addpath('propagators');
% addpath('propagators_prop_0001');
addpath('fem_module');
%% Problem defintion (input, numerical parameters)
%--------------------------------------------------------------------------
% Read problem input from GiD input file
% %file_name = 'test_uneindeutigkeit.dat';
% file_name = 'test6.dat';
% file_name = 'test_u.dat';
% file_name = 'fachwerk_test3.dat';
% file_name = 'simple_bridge.dat';
% file_name = 'crane.dat';
%file_name = 'truss_bruecke.dat';
% file_name = 'simple_test.dat'; !!!
% file_name = 'bridge_u.dat';
% file_name = 'simple_bridge.dat';
% file_name = 'crane_u.dat';
file_name = 'test6_2.dat';
%--------------------------------------------------------------------------
% Load data-set
% 
load("D_09-May-2023_hist5_930_cycles1_matflag1_kmn1");
load("D_09-May-2023_hist5_22650_cycles1_matflag1_kmn1");
% load("D_30300");
D=D2;
% for i = 1 : 3660
%     D(i).hist = D(i).phi;
% end
add_zero;

%--------------------------------------------------------------------------
% Choose Plot Settings
plot_flag =0; % 1 = plots, 0 = no plots. GiD File is created either way
plot_it_flag = 0; % Plot the iterations of each time step?
t_elem = 1; % Test element of which stress strain path shall be saved
fem_flag =1; % 1 = FEM results for given loadcurve is calculated and plotted
mat_flag = 1; % material model of the optional FEM result calculation 
              % 1 = purely isotropic material, 2 = purely kinematic
              % material
              % 3 = mixed isotopric/kinematic with r = 0.5
kd_flag = 1; %  0 = brute force search, 1 = kd tree search
%--------------------------------------------------------------------------
A_e = 0.01; % cross sectional area of each truss
%--------------------------------------------------------------------------
% Numerical/Time parameters
stopTime = 2;
dt       =0.02;
% dt = 1
max_iter = 40; % maximum iterations 
%--------------------------------------------------------------------------
% Numerical parameters for distance function
% krho = 1; % slope indicator

% kxi = 21000; %final strain
% ksig = 1/21000; %final stress

% ktau = 210000; %load reversal strain (NOTE: In paper tau is the stress)
% kphi = 1/210000;   %load reversal stress (NOTE: In paper, phi is the strain)

kxi = 21000; %final strain
ksig = 18*1/21000; %final stress
kxi = 21000000;
ksig = 5/2100;
ksig = 10/210;

kxi = 21000000; 
ksig=1/21;

kxi = 210000;
ksig = 1/210;

%% disp controlled
% kxi = 210000;
% ksig = 1/210000;

%%

% ksig = 1/2100
% kxi = 1;
% ktau = 20; %load reversal strain
% kphi = 50;   %load reversal stress
% ktau = 2100000;
% keta = 1/2100;
keta = 1;
hist_flag =5; % 1: History surrogate = tau, phi, rho
               % 2: History surrogae = phi
               
               % 3: History surrogae = tau
[~,koeff_matrix] = propagator(0,0,0,hist_flag,1,1);
% koeff_matrix = 30;
% koeff_matrix = 30;
% kxi = 210000;
% ksig = 1/2100;
%--------------------------------------------------------------------------
% Loadcurve Definition
global nlr
% nlr = 1; % dimension of history surrogate saved in the data set
loadcurve = [0 1.05 0.5 1.2 0.8] ; %rudimental loadcurve definition for 
                                   %proof of concept
 loadcurve = [0 1.2 -1.36 1.48 -1.55 1.65];
  loadcurve = [0 1.2 -1.36 1.48];
  loadcurve = [0 1.15 0.4];
%   loadcurve =[0, 1.463157762038080, 0.877894657222848];
%   loadcurve = [0, 1.05, -1.3,1.4];
%   loadcurve = [0, 1.2, -1.5, 1.8]
%    loadcurve = [0 1.2 -1.36 1.48 -1.55 1.65];
%   loadcurve = [0, 3, 0.5];
%   loadcurve = [0 1.03 0.5 1.09 0.5 1.14];
%loadcurve = 1e-3*[0 1 0.5];

% loadcurve = [0, 1.05, 0.5];
% loadcurve = [0, 1, -0.9];
% loadcurve = [0, 1, -1.2];
% loadcurve = [0,0.5,0];
%% isotropic hardening
% loadcurve = [0, 1.1,-1.33];
% loadcurve = [0, 1.1,-1.33, 1.60];
% loadcurve = [0, 1.1,-1.33, 1.60, -1.9];
% loadcurve = [0, 1.1,-1.33, 1.60, -1.9, 2.0];

% isotropic hardening #2
%  loadcurve = [0, 1.1,-1.15, 1.2];

%% STRAIN CONTROLLED
% loadcurve = [0, 1, -1,1];
%% kinematic hardening
% loadcurve = [0, 1.1,-1.15];
% loadcurve = [0, 1.1,-1.15, 1.20];
% loadcurve = [0, 1.1,-1.15, 1.20, -1.2];
%% simple bridge
% isotropic hardening 
% loadcurve = [0, 1.0,-1.2, 1.3];
% loadcurve = [0, 1.0,-1.2, 1.3,-1.5];
% 
% % kinematic hardening
% loadcurve = [0, 1.0,-0.9, 0.9];
% loadcurve = [0, 1.0,-0.9, 0.9,-0.8];
% % isotropic hardening#2
% loadcurve = [0, 0.8,-0.9, 1.1];
% loadcurve = [0, 0.9,-1.05, 1.25,-1.45];
%%
%--------------------------------------------------------------------------
create_time_vec;
if dt == 5
    time_vec = [0 5 15];
end
%% k-d tree 
if kd_flag == 1
for i = 1 : size(koeff_matrix,1)
scaled_hist_data = 1;
end
koeff_matrix = keta*koeff_matrix;
data=[sqrt(0.5*kxi)*[D(:).xi];sqrt(0.5*ksig)*[D(:).sig];sqrt(koeff_matrix)*[D(:).hist]]';
kd_tree = KDTreeSearcher(data);
else
    kd_tree =[];
end
%% Starting point of the Data-driven FEM Algorithm %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%Inizialization&%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
initialization;
initial_plots1; %just some initial plotting
starting_points;%create initial starting points (data-set entry closest to 0)
%--------------------------------------------------------------------------
%---------------Starting of time loop--------------------------------------
%--------------------------------------------------------------------------
while (time < stopTime)
   
        step = step + 1 ;
        time = step*dt;
        fprintf(1,'step= %2d time= %8.4e dt= %8.4e\n', step, time, dt); % mandatory command ouput
        %Get boundary conditions for this time step (forces and prescribed
        %displacements)
        fsur_end             = zeros(ndim*nnp,1);
      %  [fsur_end, u_end,eta_end] = loadDefinition_td(time,stopTime, drlt, neum, neumDofs,drltDofs, fsur_end,u_end,eta_end, ndim,time_vec,loadcurve);
        [fsur_end, u_end,eta_end] = loadDefintion3(loadcurve,time,time_vec, drlt, neum, neumDofs,drltDofs, fsur_end,u_end,u_end, ndim );
    %----------------------------------------------------------------------
    %------------Starting point of data-driven solution approach-----------
    %----------------------------------------------------------------------
    break_indicator = 0;
    iter = 0;
    while (break_indicator ~= 1 && iter <= max_iter)
        % Initialise global matrices
        H    = zeros( ndim*nnp, ndim*nnp ); % stiffness matrix
        Xu   = zeros(ndim*nnp,1); %eigen-strain field vector
        Xeta = zeros(ndim*nnp,1); %internal force vector
        %------------------------------------------------------------------
        %----------------------- element loop 1----------------------------
        %------------------------------------------------------------------ 
  
        for e = 1  : nel
            %get the DOF's of the current element via the connectivity list
            %in the shape edof = [ndim x nen]
            edof = zeros(ndim, nen);
            edof(1,:) = conn(e,2:end).*ndim -ndim +1;
            for d = 2 : ndim
                edof(d,:) = edof(d-1,:) + 1;
            end
            % dofs belonging to element e in the ordering of global u [ndf*nen x 1]
            gdof = reshape( edof, ndim*nen, 1);
            
            % Reference coordinates of the element nodes, in the element 
            % numbering Xe =[ndim x nen]
            Xe = coord(conn(e,2:end),2:end)';
            % extract position in the data-set of the data pair of the
            % current element
            D_sample_e = D_sample(e);
            %Subroutine to calculate the elemental matrices
            [B_e,He,Xue,Xeta_e] = element_routine(Xe,kxi,ksig,D,D_sample_e,A_e);
            %Allocate the local matrices into global ones
            H(gdof,gdof)   = H(gdof,gdof) + He;
            Xu(gdof)       = Xu(gdof) + Xue;
            Xeta(gdof)     = Xeta(gdof) + Xeta_e; 
        end %end of element loop  1
        
        %solve for lagrange parameters and displacements
        res = Xu(freeDofs)-H(freeDofs,drltDofs)*u_end(drltDofs);
        res2 = fsur_end(freeDofs)- Xeta(freeDofs);
        u_end(freeDofs)   = H(freeDofs,freeDofs) \(res);
        eta_end(freeDofs) = H(freeDofs,freeDofs) \(res2);
        current_time.u = u_end;
        current_time.eta = eta_end;
         %------------------------------------------------------------------
        %------------------------element loop 2----------------------------
        %------------------------------------------------------------------
        %save current sample point list for exit criterion later
        D_sample_n = D_sample;
       %rsd = norm(eta_lr);
        for e = 1 : nel
            %get the DOF's of the current element via the connectivity list
            %in the shape edof = [ndim x nen]
            edof = zeros(ndim, nen);
            edof(1,:) = conn(e,2:end).*ndim -ndim +1;
            for d = 2 : ndim
                edof(d,:) = edof(d-1,:) + 1;
            end
            % dofs belonging to element e in the ordering of global u [ndf*nen x 1]
            gdof = reshape( edof, ndim*nen, 1);
             % extract position in the data-set of the data pair of the
            % current element
            D_sample_e = D_sample(e);
            % Reference coordinates of the element nodes, in the element 
            % numbering Xe =[ndim x nen]
            Xe = coord(conn(e,2:end),2:end)';
            % Routine to search for the closest data-set point w.r.t. the
            % stresses/strains fullfilling compatibility and equilibrium
            [eps_k,sig_k,D_sample_e] = sample_point_update(D_sample_e,D,u_end(gdof),eta_end(gdof),Xe,kxi,ksig,keta,history{e}.hist_surr,e,hist_flag,koeff_matrix,kd_tree,kd_flag);
            current_time.sig_k(e) = sig_k;
            current_time.eps_k(e) = eps_k;
            %write updated sample point position in global sample point
            %array
            D_sample(e) = D_sample_e;
            if plot_flag == 1 && plot_it_flag == 1
            intermediate_plot; % some more plotting
            end
           
           if e == t_elem
               testelem(step+1).time = time;
               testelem(step+1).sig  = sig_k;
              testelem(step+1).eps  = eps_k;
           end
           
        end %end of element loop 2
        
        %The closest stresses and strains of the data set should now have
        %been found, check if all points have been picked twice
        all_distance = sum(abs(D_sample-D_sample_n));
        fprintf(1,'res= %2d\n', all_distance);
        if all_distance == 0 %&& rsd < 1e-8
            break_indicator = 1;
        else
        end
        iter = iter + 1;
        if plot_flag == 1 && plot_it_flag == 1
        [~,~]=postprocessing2(step,coord,conn,nel,nen,1, ndim, D,D_sample_n,u_end,1,kxi,eta_end,A_e);%just some postprocessing plotting
        end
        D_sample_nn = D_sample_n;
        
    end% end of iteration loop
    if plot_flag == 1 && plot_it_flag == 0
        [~,~]=postprocessing2(step,coord,conn,nel,nen,1, ndim, D,D_sample_n,u_end,1,kxi,eta_end,A_e);%just some postprocessing plotting
            intermediate_plot2;
    end
     %------------------------PROPAGATOR----------------------------------
      [history,current_time,past_time] = ...
       propagator_dd(history,current_time,nel,past_time,time,hist_flag);
    %--------------------------------------------------------------------
     writeGiDResults(file_name, ndim,ndim,nnp,nen,nel,conn, kxi,u_end,time,coord,eta_end,D_sample,D);
end %end of time loop
%% Post Processing
 end_plots;
add_plots = 0;
% save("results_lr4_grid25_dt005","results")
if fem_flag == 1
fem_module;
end
