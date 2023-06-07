function [eps_kp1,sig_kp1,D_sample_e_p1] =  sample_point_update(D_sample_e,D,ue_re,eta_e_re,Xe,kxi,ksig,keta,hist_surr,e,hist_flag,koeff_matrix,kd_tree,kd_flag)
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

sig_star = D(D_sample_e).sig;
sig_k = sig_star + kxi'*(B_e'*(T_e*eta_e_re));
xi_k = B_e'*(T_e*ue_re);
%% query search for case of kd tree
if kd_flag == 1
querry = [sqrt(0.5*kxi)*xi_k, sqrt(0.5*ksig)*sig_k,[sqrt(koeff_matrix)*hist_surr]'];
[spp1] = knnsearch(kd_tree,querry);
else
%%
    [eps_star_kp1,sig_star_kp1,spp1] = min_distance_plasti_td(D,xi_k,sig_k,kxi,ksig,keta,hist_surr,e,hist_flag,koeff_matrix);
end
eps_kp1 =xi_k;
sig_kp1 = sig_k;
D_sample_e_p1 = spp1;
 end