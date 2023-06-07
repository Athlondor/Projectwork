function [ drltDofs, freeDofs, neumDofs ] = dofSeparation( nnp, ndim, drlt, neum )
%_________________Routine to seperate the Degrees of freedom_______________
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%**************************************************************************
%|-------------------Master thesis Marius Harnisch B.Sc.------------------|
%|-----------------supervised by Dr.-Ing. Thorsten Bartel-----------------|
%|----------------Date of creation: 09.06.2020----------------------------|
%|----------------List of Modifications:----------------------------------|
%**************************************************************************
%Disclaimer: The code has been taken from the course "Non-linear finite
%element method" of the Institute of Mechanics, TU Dortmund from WS19/20
%and has beend modified by the author of this thesis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input: nnp : number of node points
%       ndim: number of dimensions
%       drlt: Dirichlet conditions
%       neum: Neumann conditions
%--------------------------------------------------------------------------
%Output:
%       drltDofs : Dofs belonging to the Dirichlet BC's
%       freeDofs : Dofs having no BC's
%       neumDofs : Dofs belonging to the Neumann BC's
    % separate dof types
    allDofs = (1:1:nnp*ndim)';

    % dofs with Dirichlet boundary conditions
    numdrlt = size(drlt,1);
    numx1 = sum(drlt(:,2));
    numx2 = sum(drlt(:,3));
    drltDofs = zeros(numx1+numx2,1);
    i = 1;
    if ndim == 2
    for k = 1 : numdrlt
        node = drlt(k,1);
        if drlt(k,2) == 1 && drlt(k,3) == 1
            drltDofs(i) = ndim*node-1;
            drltDofs(i+1) = node*ndim;
            i = i+1;
        elseif drlt(k,2) == 1
            drltDofs(i) = ndim*node-1;
        elseif drlt(k,3) == 1 
            drltDofs(i) = ndim*node; 
        end
        i=i+1;
    end
    elseif ndim == 3 
        error('DOF seperation not implemented for 3D problems!');
    end
    % free dofs
    freeDofs = setdiff(allDofs, drltDofs); 

    % dofs with Neumann boundary conditions
    numNeumDofs = size(neum,1);
    numy1 = sum(neum(:,2)~=0);
    numy2 = sum(neum(:,3)~=0);
    neumDofs = zeros(numy1+numy2,1);
%     for i=1:numNeumDofs
%         node = neum(i,1);
%         ldof = neum(i,3);
%         neumDofs(i) = (node-1)*ndim + ldof;
%     end
l = 1;
 if ndim ==2
    for j = 1 : numNeumDofs
        node = neum(j,1);
        if neum(j,2) ~= 0 && neum(j,3) ~= 0
            neumDofs(l) = ndim*node-1;
            neumDofs(l+1) = node*ndim;
            l = l+1;
        elseif neum(j,2) ~= 0
            neumDofs(l) = node*ndim-1;
        elseif neum(j,3) ~= 0 
            neumDofs(l) = node*ndim; 
        end
        l=l+1;
    end
    elseif ndim == 3 
        error('DOF seperation not implemented for 3D problems!');
    end

end

