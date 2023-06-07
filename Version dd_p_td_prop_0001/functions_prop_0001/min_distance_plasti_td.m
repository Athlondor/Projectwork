function [eps_star_kp1,sig_star_kp1,spp1] = min_distance_plasti_td(D,eps_k,sig_k,kxi,ksig,keta,hist_surr,e,hist_flag,koeff_matrix)
%_________________Routine to search for closest data point_________________
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%**************************************************************************
%|-------------------Master thesis Marius Harnisch M.Sc.------------------|
%|-----------------supervised by Dr.-Ing. Thorsten Bartel-----------------|
%|----------------Date of creation: 26.10.2021----------------------------|
%|----------------List of Modifications:
%|-- Added a history surrogate such that the algorithm is now capable-----|
%|-- of dealing with multiple load cycles in a time discrete fashion------|
%|-- (Function is based on min_distance_plasti2 from 26.10.2021)----------|
%**************************************************************************
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    WE_eta = (hist_surr-D(1).hist)'*koeff_matrix*(hist_surr-D(1).hist);
    WE      = (eps_k-D(1).xi)'*kxi*(eps_k-D(1).xi);
    WE_star = (sig_k-D(1).sig)'*ksig*(sig_k-D(1).sig);
    dist_n = keta*WE_eta+WE+WE_star;
min_index = 1;
for i = 1 :  size(D,2)
    WE      = (eps_k-D(i).xi)'*kxi*(eps_k-D(i).xi);
    WE_star = (sig_k-D(i).sig)'*ksig*(sig_k-D(i).sig);
    WE_eta = (hist_surr-D(i).hist)'*koeff_matrix*(hist_surr-D(i).hist);
    dist = WE+WE_star+keta*WE_eta;
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