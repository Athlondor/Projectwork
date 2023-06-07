function [B_e,He,Xue,Xeta_e] =  element_routine(Xe,kxi,ksig,D,D_sample_e,A_e)
    %_________________Routine to create B Matrix on element level______________
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%**************************************************************************
%|-------------------Master thesis Marius Harnisch B.Sc.------------------|
%|-----------------supervised by Dr.-Ing. Thorsten Bartel-----------------|
%|----------------Date of creation: 09.06.2020----------------------------|
%|----------------List of Modifications:----------------------------------|
%**************************************************************************
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input: Xe       : Elemental reference coodinates
%       EVoigt2D : Young's modulus
%        D       : Data-set
%     D_sample_e : Locations of the stress-strain pairs in the data-set of
%                  the current element
%         A_e    : Cross-section of the element (truss)
%--------------------------------------------------------------------------
%Output: B_e : B_matrix with which the strain can be calculauted
%         H_e: Elemental stiffness matrix
%        Xue : Elemental eigen-strain field vector
%     Xeta_e : Elemental interal force vector
%       
%--------------------------------------------------------------------------
l_e = sqrt(  (Xe(1,2)-Xe(1,1))^2 + (Xe(2,2)-Xe(2,1))^2  );
T_e = 1/l_e *[Xe(1,2) - Xe(1,1), Xe(2,2)-Xe(2,1),          0    ,            0;
                  0            ,      0         ,Xe(1,2) - Xe(1,1), Xe(2,2)-Xe(2,1)];
B_e = 1/l_e* [ -1 1]';
    %extract current sample point of the data set
    eps_star = D(D_sample_e).xi;
    sig_star = D(D_sample_e).sig;
    %relative Volume of current quadrature point
    %dV = detJ*qp(q,3);
    dV = A_e*l_e;
    He_l     =  dV*B_e*kxi*B_e';
    Xue_l    =   dV*B_e*kxi*eps_star;
    Xeta_e_l =   dV*B_e*sig_star;
    He = T_e'*He_l*T_e;
    Xue = T_e'*Xue_l;
    Xeta_e = T_e'*Xeta_e_l;
 end