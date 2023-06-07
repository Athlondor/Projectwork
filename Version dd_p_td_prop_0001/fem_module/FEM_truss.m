%________________________Data-driven FEM Algorithm_________________________
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%**************************************************************************
%|-------------------Ph.D. thesis Marius Harnisch M.Sc.------------------|
%|-----------------supervised by Dr.-Ing. Thorsten Bartel-----------------|
%|----------------Date of creation: 09.06.2020----------------------------|
%|----------------List of Modifications:----------------------------------|
%| 01.04.2021: Clean Up and restructering, minor improvements, better
%              readibility etc.
%**************************************************************************
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clear all;
close all;
clc;
addpath('inputs');
addpath('functions');
%% INPUTS and PARAMETERS
% Read problem input from GiD input file
%file_name = 'test_uneindeutigkeit.dat';
%file_name = 'test6.dat';
file_name = 'truss_bruecke.dat';
file_name2 = convertStringsToChars(file_name(1:end-4)+"_plast");

[nnp,ndim,nen,nel,coord,conn,drlt,neum] = read_input(file_name);
 
 
 %ndim, ndf, nnp, nel, x, elem, ~, drlt, neum, ~, ~] = input_minimal_beam()
 %[coord,conn,drlt,neum] =  load_GiDcf_input( x, elem,drlt, neum)
 
 
% Choose numerical solution variables (stopTime should be equal to dt to
% solve problem in 1 step
stopTime = 1;
dt       =0.01;
tol = 1e-8;
ndm = 2; % number of dimension 
ndf = 2; % number of degrees of freedom
nqp= 1; % number of stress-strain pairs saved in the data-set
A_e = 0.01; % cross sectional area of each truss
max_iter = 30; % maximum iterations 
movie_switch = 0; % 1 = live plots of the deformation during calculation
el = 3; % Test elem of which quantities are plotted
test_gauss = 0; %Gauss point of the element. If 0, the first gauss point is chosen.
test_node = 0; %Node of which the displacement is plotted. If 0, the first node of el will be plotted.
%% Starting point of the FEM Algorithm %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%Inizialization&%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Divide degree's of freedom (dof) in free dofs and constraint dofs
[ drltDofs, freeDofs, neumDofs ] = dofSeparation( nnp, ndim, drlt, neum );
%Initialize displacements
u                   = zeros(ndim*nnp, 1);
uold = u; % for initialization purposes

%create and prepare the GiD output file
writeGiDMesh(file_name, ndim,ndim,nnp,nen,nel,1,coord,conn);
writeGiDMesh(file_name2, ndim,ndim,nnp,nen,nel,1,coord,conn);
% initialize quantities of the test element for postprocessing purposes
for i = 1 : (stopTime/dt)
    testelem(i).sig  = zeros(1);
    testelem(i).eps  = zeros(1);
    testelem(i).time = 0;
end
%--------------------------------------------------------------------------
%---------------Starting of time loop--------------------------------------
%--------------------------------------------------------------------------
time = 0;
step = 0;
%plot_initial_config(coord,conn,nel,neum,drlt,ndim); %some more plots %some more plots
for e = 1:nel % initialize internal variables
    for q = 1:nqp
    elem(e).ivar_n = zeros(nqp,3);
    elem(e).ivar_np1 = zeros(nqp,3);
    end
end
while (time <= stopTime-dt)
for e = 1:nel
    elem(e).ivar_n = elem(e).ivar_np1;
end
    time = time + dt;
    step = step + 1 ;
    fprintf(1,'step= %2d time= %8.4e dt= %8.4e\n', step, time, dt); % mandatory command ouput
%Get boundary conditions for this time step (forces and prescribed
%displacements) LOAD PATH DEFINITION
%1. Primitive Load-Path definition: The prescribed maximum forces and displacements (given via
%GiD Input) will be linearly applied in the time intervall [0 x*stopTime].
% Then, the boundary conditions are linearly released down to
% re_fact*(force or disp)  in the time intervall [x*stopTime stopTime].
fsur                = zeros(ndim*nnp, 1);
re_fact = 0.5; % 
time_vec =[0 0.5*stopTime stopTime]; 
drlt_re = drlt;
neum_re = neum;
drlt_re(:,2:5) = re_fact*drlt(:,2:5);
neum_re(:,2:3) = re_fact*neum(:,2:3);
[fsur, u,~] = loadDefintion2(time,time_vec,drlt_re,neum_re, drlt, neum, neumDofs,drltDofs, fsur,u,u, ndim );
u_d = u;
% 2. Non primitive Load-Path defintion
     %t.b.a
    break_indicator = 0;
    iter = 0;
   while (break_indicator ~= 1 && iter <= max_iter)

        % Initialise global matrices
        K    = zeros( ndim*nnp, ndim*nnp ); % stiffness matrix
        fint = zeros(ndim*nnp,1); %internal force vector
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
            
            % initialise elemental quantities
            Ke     = zeros(nen*ndim, nen*ndim);
            finte    = zeros(nen*ndim,1);
            % Reference coordinates of the element nodes, in the element 
            % numbering Xe =[ndim x nen]
            Xe = coord(conn(e,2:end),2:end)';
            % current element
            u_e = u(gdof);
            %Subroutine to calculate the elemental matrices
            [Ke,finte,elem] = element_routine(Xe,Ke,finte,A_e,u_e,nqp,elem,e,dt);
            %Allocate the local matrices into global ones
            K(gdof,gdof)   = K(gdof,gdof) + Ke;
            fint(gdof)     = fint(gdof) + finte;   
        end %end of element loop  1
        
% Solve the system of equations


rsd = fint(freeDofs)-fsur(freeDofs);

rsn = norm(rsd) + norm(u_d(drltDofs)-u(drltDofs));

fprintf(1,' %2d.  residuum norm= %e\n', iter , rsn);

if rsn > tol
    if iter == 1
       rhs = -(rsd+K(freeDofs,drltDofs)*(u_d(drltDofs)-uold(drltDofs)));
       u(drltDofs) = u_d(drltDofs);
    else
       rhs = - rsd;
   end
    du = zeros(size(u));
    du(freeDofs) = K(freeDofs,freeDofs)\rhs;
    u(freeDofs) = u(freeDofs)+du(freeDofs);
else 
    break;
end
    if iter == 20
        error('no convergence in newton scheme')
    end
   end    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Post Processing !     


% Compute the reaction forces at the Dirichlet boundary
% fprintf('Solution : Reaction force vector\n\n');
fext(freeDofs) = fsur(freeDofs);
fext(drltDofs) = K(drltDofs,freeDofs)*u(freeDofs) + K(drltDofs,drltDofs)*u(drltDofs);
frea(drltDofs) = fext(drltDofs);
% frea

    result(step+1).step = step;
    el = 3;
    if test_gauss == 0
    tq = 1;
    else
        tq = test_gauss;
    end
    if test_node == 0
    nnode = conn(el,2);
    else
        nnode = test_node;
    end
    result(step+1).sig = elem(el).sig(tq,1);
    result(step+1).eps = elem(el).eps(tq,1);
    result(step+1).epsv = elem(el).ivar_np1(tq,1);
    result(step+1).u = u(2*nnode-1 : 2*nnode);
    idx = find(fsur~=0, 1, 'first');
    result(step+1).f = fsur(idx);
    result(step+1).time = (step+1)*dt;
    
% toc
time = (step+1)*dt;
uold = u;
        
        
        iter = iter + 1;
%Write the stresses and strains in the prepared output file for GiD
         writeGiDResults(file_name, ndim,ndim,nnp,nen,nel,conn, 1,u,time,coord,elem);
         writeGiDResults3(file_name2, ndim,ndim,nnp,nen,nel,conn, 1,u,time,coord,elem);
 if movie_switch == 1       
        [~,~]=postprocessing2(step,coord,conn,nel,nen,1, ndim, 1,1,u,1,1,1,A_e,elem);%just some postprocessing plotting
 end
        
 end% end of iteration loop
 %% Plotting
    plot_results(result);
     if movie_switch == 0
     [~,~]=postprocessing2(step,coord,conn,nel,nen,1, ndim, 1,1,u,1,1,1,A_e,elem);%just some postprocessing plotting
     end