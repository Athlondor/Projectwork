function [sig_te,eps_te] = postprocessing(step,coord,conn,nel,nen,nqp, ndim, D,D_sample_eps,D_sample_sig, u,te,EVoigt2D,eta)


%----------------------------------------------------------------------
% volume average of state variables within elements
%----------------------------------------------------------------------
if nqp == 4
qp(1,:) = [-sqrt(3)/3, -sqrt(3)/3,  1  , 0.25];
qp(2,:) = [ sqrt(3)/3, -sqrt(3)/3,  1  , 0.25];
qp(3,:) = [ sqrt(3)/3,  sqrt(3)/3,  1  , 0.25]; 
qp(4,:) = [-sqrt(3)/3,  sqrt(3)/3,  1  , 0.25];
elseif nqp == 9
a = 0.77459667;
 qp(1,:) = [-a,-a,  25/81  , 1/9];
 qp(2,:) = [ a,-a,  25/81  , 1/9];
 qp(3,:) = [ a,a,  25/81  , 1/9]; 
 qp(4,:) = [-a,a,  25/81  , 1/9];
 qp(5,:) = [0,-a,  40/81  , 1/9];
 qp(6,:) = [a,0,  40/81  , 1/9];
 qp(7,:) = [0,a,  40/81  , 1/9];
 qp(8,:) = [-a,0,  40/81  ,1/9];
 qp(9,:) = [0,0,  64/81  , 1/9];
end
for i = 1 : nel
    PPaverage(i).sig = zeros(3,1);
    PPaverage(i).eps = zeros(3,1);
end
for e = 1:nel
    % reference volume of e-th element
    V = 0;
    Xe = coord(conn(e,2:end),2:end)';
    % average 
    D_sample_sig_e = D_sample_sig(nqp*e-nqp+1 : nqp*e);
    for q = 1:nqp
        [~,detJ] =  B_matrix(qp(q, 1),qp(q, 2),Xe);
        dV =detJ*qp(q,3);
        V = V + dV;
    end
    for q = 1:nqp
         edof = zeros(ndim, nen);
        edof(1,:) = conn(e,2:end).*ndim -ndim +1;
        for d = 2 : ndim
            edof(d,:) = edof(d-1,:) + 1;
        end
        gdof = reshape( edof, ndim*nen, 1);
        ue = u(gdof);
        eta_e = eta(gdof);
        xi_1 = qp(q, 1);
        xi_2 = qp(q, 2);
        [B_e,~] =  B_matrix(xi_1,xi_2,Xe);
        %recalculate stress and strain such that the BVP is fullfilled
        sp = D_sample_sig_e(q);
        sig_star = D(sp).sig;
        eps_k = B_e'*ue;
        sig_k = sig_star + EVoigt2D'*(B_e'*eta_e);
        PPaverage(e).sig = PPaverage(e).sig+ sig_k * qp(q,4)*V;
        PPaverage(e).eps = PPaverage(e).eps + eps_k*qp(q,4)*V;
    end
    PPaverage(e).sig = PPaverage(e).sig / V;
    PPaverage(e).eps = PPaverage(e).eps / V;
    if e == te
        sig_te = PPaverage(e).sig;
        eps_te = PPaverage(e).eps;
    else
    end
end


%=========================================================================
% post-processing - visualising results
%=========================================================================

scale_factor = 1;

figure(2);
clf;
for e=1:nel
    Xe = coord(conn(e,2:end),2:end)';
    
    % dofs belonging to element e
    edof = zeros(ndim, nen);
    edof(1,:) = conn(e,2:end).*ndim -ndim +1;
    for d = 2 : ndim
        edof(d,:) = edof(d-1,:) + 1;
    end
    ue = u(edof);
        
    xe = Xe + scale_factor * ue;
    
    % extract stress and strain tensor
     sig_pl = PPaverage(e).sig;
     eps_pl = PPaverage(e).eps;
    
  
    % plot deformed configuration  
    patch(xe(1,:), xe(2,:), sig_pl(1))
    hold on
end
title('\sigma_{11}');
%caxis([-10000 10000]);
h = colorbar;
axis([-0.1 3.5 -0.2 2.5]);
hold off

fname = sprintf('pictures/plate_with_hole_%03d.png', step);
print(gcf, '-dpng', fname); 
