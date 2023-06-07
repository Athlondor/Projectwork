function [eps_star_kp1,sig_star_kp1,spp1] = min_distance_plasti(D,rho_k,tau_k,eps_k,sig_k,krho,ktau,kxi,ksig)
%_________________Routine to search for closest data point_________________
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%**************************************************************************
%|-------------------Master thesis Marius Harnisch B.Sc.------------------|
%|-----------------supervised by Dr.-Ing. Thorsten Bartel-----------------|
%|----------------Date of creation: 11.06.2020----------------------------|
%|----------------List of Modifications:----------------------------------|
%**************************************************************************
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dist_n = (krho*(rho_k-D(1).rho)^2+ktau*(tau_k-D(1).tau)^2+((eps_k-D(1).xi)'*kxi*(eps_k-D(1).xi)) +((sig_k-D(1).sig)'*ksig*(sig_k-D(1).sig)));
min_index = 1;
% for i = 1 :  size(D,2)
%     for j = 1 : size(D,2)
%     WE      = (eps_k-D(i).eps)'*EVoigt2D*(eps_k-D(i).eps);
%     WE_star = (sig_k-D(j).sig)'*inv(EVoigt2D)*(sig_k-D(j).sig);
%  %    dist = sqrt(WE+WE_star);
%     dist = (WE+WE_star);
%         if dist < dist_n
%             min_index_i = i;
%             min_index_j = j;
%             dist_n = dist;
%         else
%         end
%     end
% end
for i = 1 :  size(D,2)

    WE      = (eps_k-D(i).xi)'*kxi*(eps_k-D(i).xi);
    WE_star = (sig_k-D(i).sig)'*ksig*(sig_k-D(i).sig);
    WE_rho = (rho_k-D(i).rho)^2*krho;
    WE_tau = (tau_k-D(i).tau)^2*ktau;
 %    dist = sqrt(WE+WE_star);
    dist = (WE+WE_star+WE_rho+WE_tau);
        if dist < dist_n
            min_index = i;
            dist_n = dist;
        else
        end
   
end
eps_star_kp1 = D(min_index).xi;
sig_star_kp1 = D(min_index).sig;
spp1 = min_index;
end