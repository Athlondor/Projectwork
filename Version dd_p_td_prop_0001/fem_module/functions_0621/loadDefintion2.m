function [fsur_new, u_new,eta_new] = loadDefintion2(time,time_vec,drlt_re,neum_re, drlt, neum, neumDofs,drltDofs, fsur,u,eta, ndim )
%%
%_________________Load-Definition for Data-driven FEM Algorithm____________
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%***Routine to apply the forces/displacements of the current time step*****
%|-------------------Master thesis Marius Harnisch B.Sc.------------------|
%|-----------------supervised by Dr.-Ing. Thorsten Bartel-----------------|
%|----------------Date of creation: 10.06.2020----------------------------|
%|----------------List of Modifications:----------------------------------|
%**************************************************************************
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input: time     : current time step
%       stopTime : Total time 
%       drlt     : Values for the dirichlet BC's
%       neum     : Values for the Neumann BC's
%       neumDofs : dofs belonging to the Neumann BC's
%       drltDofs : dofs belonging to the Dirichlet BC's
%       fsur     : External force vector
%       u        : displacement vector
%       eta      : vector of lagrange parameters
%       ndim     : number of dimensions
%--------------------------------------------------------------------------
%Output: fsur_new : updated external force vector
%        u_new    : updated displacements
%        eta_new  : updated lagrange parameters
%    
%%
%time_vec = [0 stopTime];
%Extract total displacement value for Dirichlet boundary conditions and
%interpolate the value for the current time step
    
    numdrlt = size(drlt,1);
    numx1 = sum(drlt(:,2));
    numx2 = sum(drlt(:,3));
    disp  = zeros(numx1+numx2,1);
    eta_d = zeros(numx1+numx2,1);
    i = 1;
    if ndim == 2
    for k = 1 : numdrlt
        if drlt(k,2) == 1 && drlt(k,3) == 1
            disp(i) = interp1(time_vec,[0 drlt(k,4) drlt_re(k,4)],time,'linear');
          disp(i+1) = interp1(time_vec,[0 drlt(k,5) drlt_re(k,5)],time,'linear');
             eta_d(i) = 0;
           eta_d(i+1) = 0;
            i = i+1;
        elseif drlt(k,2) == 1
            disp(i) = interp1(time_vec,[0 drlt(k,4) drlt_re(k,4)],time,'linear');
             eta_d(i) = 0;
        elseif drlt(k,3) == 1 
            disp(i) = interp1(time_vec,[0  drlt(k,5) drlt_re(k,5)],time,'linear');
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
            force(l) = interp1(time_vec,[0 neum(j,2) neum_re(j,2)],time,'linear');
          force(l+1) = interp1(time_vec,[0 neum(j,3) neum_re(j,3)],time,'linear');
            l = l+1;
        elseif neum(j,2) ~= 0
            force(l) = interp1(time_vec,[0 neum(j,2) neum_re(j,2)],time,'linear');
        elseif neum(j,3) ~= 0 
            force(l) = interp1(time_vec,[0 neum(j,3) neum_re(j,3)],time,'linear');
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
end