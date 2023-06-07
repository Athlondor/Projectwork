function [B_e, detJ] =  B_matrix(xi_1,xi_2,Xe)
%_________________Routine to create B Matrix on element level______________
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%**************************************************************************
%|-------------------Master thesis Marius Harnisch B.Sc.------------------|
%|-----------------supervised by Dr.-Ing. Thorsten Bartel-----------------|
%|----------------Date of creation: 09.06.2020----------------------------|
%|----------------List of Modifications:----------------------------------|
%**************************************************************************
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input: xi_1 & xi_2: Masterelement coordinates for which the B Marix
%                    should be created. 
%                Xe: reference coordinates of the current element as 
%                    [ndim x nen]
%--------------------------------------------------------------------------
%Output:
%       B_e  : B Matrix of current element at given Masterelement
%              coordinates.Strain can be calculated via operation 
%              Eps_e = B_e'*u(gdof) 
%--------------------------------------------------------------------------
%     N_2 = (1-xi_1)*(1-xi_2)*0.25;
%     N_3 = (1+xi_1)*(1-xi_2)*0.25;
%     N_4 = (1+xi_1)*(1+xi_2)*0.25;
%     N_1 = (1-xi_1)*(1+xi_2)*0.25;
    
    gamma_2 = [-(1-xi_2)*0.25, -(1-xi_1)*0.25];
    gamma_3 = [ (1-xi_2)*0.25, -(1+xi_1)*0.25];
    gamma_4 = [ (1+xi_2)*0.25,  (1+xi_1)*0.25];
    gamma_1 = [-(1+xi_2)*0.25,  (1-xi_1)*0.25];
    
%     N_1 = 0.25*(xi_1-1)*(xi_2-1);
%     N_2 = 0.25*(xi_1+1)*(1-xi_2);
%     N_3 = 0.25*(xi_1+1)*(xi_2+1);
%     N_4 = 0.25*(1-xi_1)*(xi_2+1);
%     
%     gamma_1 = [0.25*(xi_2-1), 0.25*(xi_1-1)];
%     gamma_2 = [0.25*(-xi_2+1), 0.25*(-xi_1-1)];
%     gamma_3 = [0.25*(xi_2+1), 0.25*(xi_1+1)];
%     gamma_4 = [0.25*(-xi_2-1), 0.25*(-xi_1+1)];
%     
    
    
    Gamma = [gamma_1', gamma_2', gamma_3', gamma_4'];
    Jacobian = Gamma*Xe';   %only with second B_e
   % Jacobian = Xe*Gamma';  %only with first or third B_e
    detJ = det(Jacobian); 
    invJ = inv(Jacobian);
%     B_e = [gamma_1*invJ(:,1),       0         , gamma_1*invJ(:,2);
%                    0        , gamma_1*invJ(:,2), gamma_1*invJ(:,1);
%            gamma_2*invJ(:,1),       0          , gamma_2*invJ(:,2);
%                    0        , gamma_2*invJ(:,2), gamma_2*invJ(:,1);
%            gamma_3*invJ(:,1),       0          , gamma_3*invJ(:,2);
%                    0        , gamma_3*invJ(:,2), gamma_3*invJ(:,1);
%            gamma_4*invJ(:,1),       0          , gamma_4*invJ(:,2);
%                    0        , gamma_4*invJ(:,2), gamma_4*invJ(:,1)];
    B_e = [gamma_1*invJ(1,:)',       0         , gamma_1*invJ(2,:)';
                   0        , gamma_1*invJ(2,:)', gamma_1*invJ(1,:)';
           gamma_2*invJ(1,:)',       0          , gamma_2*invJ(2,:)';
                   0        , gamma_2*invJ(2,:)', gamma_2*invJ(1,:)';
           gamma_3*invJ(1,:)',       0          , gamma_3*invJ(2,:)';
                   0        , gamma_3*invJ(2,:)', gamma_3*invJ(1,:)';
           gamma_4*invJ(1,:)',       0          , gamma_4*invJ(2,:)';
                   0        , gamma_4*invJ(2,:)', gamma_4*invJ(1,:)'];
%    B_e = [invJ(1,:)*gamma_1', 0, invJ(1,:)*gamma_2', 0, invJ(1,:)*gamma_3', 0, invJ(1,:)*gamma_4', 0;
%            0, invJ(2,:)*gamma_1', 0, invJ(2,:)*gamma_2', 0, invJ(2,:)*gamma_3', 0, invJ(2,:)*gamma_4';
%            invJ(2,:)*gamma_1', invJ(1,:)*gamma_1',invJ(2,:)*gamma_2', invJ(1,:)*gamma_2',invJ(2,:)*gamma_3', invJ(1,:)*gamma_3',invJ(2,:)*gamma_4', invJ(1,:)*gamma_4'];



%     B_e = [-0.25*(1-xi_2)*invJ(1,1)-0.25*(1-xi_1)*invJ(2,1),0,0.25*(1-xi_2)*invJ(1,1)-0.25*(1+xi_1)*invJ(2,1),0,0.25*(1+xi_2)*invJ(1,1)+0.25*(1+xi_1)*invJ(2,1),0,-0.25*(1+xi_2)*invJ(1,1)+0.25*(1-xi_1)*invJ(2,1),0;
%            0,-0.25*(1-xi_2)*invJ(1,2)-0.25*(1-xi_1)*invJ(2,2),0,0.25*(1-xi_2)*invJ(1,2)-0.25*(1+xi_1)*invJ(2,2),0,0.25*(1+xi_2)*invJ(1,2)+0.25*(1+xi_1)*invJ(2,2),0,-0.25*(1+xi_2)*invJ(1,2)+0.25*(1-xi_1)*invJ(2,2);
%            -0.25*(1-xi_2)*invJ(1,2)-0.25*(1-xi_1)*invJ(2,2),-0.25*(1-xi_2)*invJ(1,1)-0.25*(1-xi_1)*invJ(2,1),0.25*(1-xi_2)*invJ(1,2)-0.25*(1+xi_1)*invJ(2,2),0.25*(1-xi_2)*invJ(1,1)-0.25*(1+xi_1)*invJ(2,1),0.25*(1+xi_2)*invJ(1,2)+0.25*(1+xi_1)*invJ(2,2),0.25*(1+xi_2)*invJ(1,1)+0.25*(1+xi_1)*invJ(2,1),-0.25*(1+xi_2)*invJ(1,2)+0.25*(1-xi_1)*invJ(2,2),-0.25*(1+xi_2)*invJ(1,1)+0.25*(1-xi_1)*invJ(2,1)];
 %    B_e = B_e';
 end