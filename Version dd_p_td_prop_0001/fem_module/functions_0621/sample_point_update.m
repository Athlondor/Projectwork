function [eps_kp1,sig_kp1,D_sample_e_p1] =  sample_point_update(D_sample_e,D,ue_max,eta_e_max,ue_re,eta_e_re,Xe,krho,ktau,kxi,kphi,ksigma)
    %_________________Routine to update the stress and strain______________
    %__________________________of the data set_____________________________
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%**************************************************************************
%|-------------------Master thesis Marius Harnisch B.Sc.------------------|
%|-----------------supervised by Dr.-Ing. Thorsten Bartel-----------------|
%|----------------Date of creation: 11.06.2020----------------------------|
%|----------------List of Modifications:----------------------------------|
%**************************************************************************
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input: D_sample_e : Locations of the stress-strain pairs in the data-set of
%          D       : Data-set
%           u_e    : Displacements of the element nodes
%           eta_e_max  : Lagrange parameters of the element nodes
%          EVoigt2D: Young's modulus
%           Xe     : Reference coordinates of the element nodes
%--------------------------------------------------------------------------
%Output:  eps_kp1       : not relevant
%         sig_kp1       : not relevant
%         D_sample_e_p1 : updated locations of the stress-strain pairs in
%                         the data-set for the element
%       
%--------------------------------------------------------------------------
% quadrature loop
l_e = sqrt(  (Xe(1,1)-Xe(1,2))^2 + (Xe(2,1)-Xe(2,2))^2  );
T_e = 1/l_e *[Xe(1,2) - Xe(1,1), Xe(2,2)-Xe(2,1),          0    ,            0;
                  0            ,      0         ,Xe(1,2) - Xe(1,1), Xe(2,2)-Xe(2,1)];
B_e = 1/l_e* [ -1 1]';
    %recalculate stress and strain based on the solution of the current
    %iteration
    sig_star = D(D_sample_e).sig;
    tau_k = B_e'*(T_e*ue_max);
    phi_k = sig_star + kxi'*(B_e'*(T_e*eta_e_max));
    rho_k = 1;
    xi_k = B_e'*(T_e*ue_re);
    sig_k = sig_star + kxi'*(B_e'*(T_e*eta_e_re));
    %calculate and minimize distance of sig_k and eps_k with respect to the
    %data set
   % [eps_star_kp1,sig_star_kp1,spp1] = min_distance_plasti(D,rho_k,eps_k,tau_k,sig_k_re,krho,ktau,kxi,ksigma);
    [eps_star_kp1,sig_star_kp1,spp1] = min_distance_plasti2(D,rho_k,tau_k,xi_k,phi_k,sig_k,krho,ktau,kxi,kphi,ksigma);
eps_kp1 =xi_k;
sig_kp1 = sig_k;
D_sample_e_p1 = spp1;
 end