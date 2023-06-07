function [D, Emod] = dataset_creator(nsp, eps_max)
%Routine to create artificial Data Sets for the data-driven algorithm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------Master thesis Marius Harnisch-----------------------%
%-----------------supervised by Dr.-Ing. Thorsten Bartel------------------%
%----------------Date of creation: 09.06.2020-----------------------------%
%----------------List of Modifications:-----------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input: nsp     : Number of sample points/Number of data-paris contained in the
%                 data-set
%       eps_max : Maximum strain in which the data-set is build. The
%                 data-set will generate nsp data-pairs in the region
%                 [-eps_max, eps_max]
%--------------------------------------------------------------------------
%Output:
%       D  : Data-set as a struct, containing the scalar fields D().sig and
%            D().eps
%       Emod : Young's modolus which was used to calculate the stresses.
%              Often used for the distance function of the data-driven
%              algo.

%% Definition of material model
nu = 0.3;
Emod = 210000;
lambda = nu*Emod/((1-2*nu)*(1+nu));
mu = Emod/(2*(1+nu));
tdm=3;
E4 = zeros(tdm,tdm,tdm,tdm);
I = eye(tdm,tdm);
% for i = 1:tdm
%     for j = 1:tdm
%         for k = 1:tdm
%             for l = 1:tdm
%                 E4(i,j,k,l) = lambda*I(i,j)*I(k,l) + 2.0*mu*(0.5*(I(i,k)*I(j,l) +I(i,l)*I(j,k)));
%             end
%         end
%     end
% end
EVoigt2D = [E4(1,1,1,1), E4(2,2,1,1), E4(1,2,1,1);
            E4(1,1,2,2), E4(2,2,2,2), E4(1,2,2,2);
            E4(1,1,1,2), E4(2,2,1,2), E4(1,2,1,2)];
%% Routine to create data base
% nsp = 51; %Number of sample points, uneven
% eps_max = 0.05; %maximum of strain
for i = 1 : nsp
    D(i).sig = zeros(1,1);
    D(i).eps = zeros(1,1);
end
        for i = 1 : nsp
            eps_test = (-1+ (2*(i-1))/(nsp))*eps_max;
            sig_test = Emod*eps_test;
            D(i).sig = sig_test;
            D(i).eps = eps_test;
        end
        %Emod = 1;
end
