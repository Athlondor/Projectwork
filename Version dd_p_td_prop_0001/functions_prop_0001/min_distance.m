function [eps_star_kp1,sig_star_kp1,spp1] = min_distance(D,eps_k,sig_k,EVoigt2D)
%_________________Routine to search for closest data point_________________
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%**************************************************************************
%|-------------------Master thesis Marius Harnisch B.Sc.------------------|
%|-----------------supervised by Dr.-Ing. Thorsten Bartel-----------------|
%|----------------Date of creation: 11.06.2020----------------------------|
%|----------------List of Modifications:----------------------------------|
%**************************************************************************
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dist_n = (((eps_k-D(1).eps)'*EVoigt2D*(eps_k-D(1).eps)) +((sig_k-D(1).sig)'*inv(EVoigt2D)*(sig_k-D(1).sig)));
min_index_i = 1;
min_index_j = 1;
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

    WE      = (eps_k-D(i).eps)'*EVoigt2D*(eps_k-D(i).eps);
    WE_star = (sig_k-D(i).sig)'*inv(EVoigt2D)*(sig_k-D(i).sig);
 %    dist = sqrt(WE+WE_star);
    dist = (WE+WE_star);
        if dist < dist_n
            min_index = i;
            dist_n = dist;
        else
        end
   
end
eps_star_kp1 = D(min_index).eps;
sig_star_kp1 = D(min_index).sig;
spp1 = min_index;
end