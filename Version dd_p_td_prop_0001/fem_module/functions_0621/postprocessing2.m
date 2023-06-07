function [sig_te,eps_te] = postprocessing2(step,coord,conn,nel,nen,nqp, ndim, D,D_sample, u,te,EVoigt2D,eta,Ae,elem)
scale_factor = 1;

figure(6);
clf;
width=1.5*550;
height=1.5*400;
set(gcf,'position',[835,300,width,height]);
for e = 1:nel
    % reference volume of e-th element
    Xe = coord(conn(e,2:end),2:end)';
    l_e = sqrt(  (Xe(1,1)-Xe(1,2))^2 + (Xe(2,1)-Xe(2,2))^2  );
    % average 
        edof = zeros(ndim, nen);
        edof(1,:) = conn(e,2:end).*ndim -ndim +1;
        for d = 2 : ndim
            edof(d,:) = edof(d-1,:) + 1;
        end
        gdof = reshape( edof, ndim*nen, 1);
        u_e = u(edof);
        xe = Xe + scale_factor * u_e;
        ue = u(gdof);
        eps_k = elem(e).eps;
        sig_k = elem(e).sig;
        breite = 0.001*sqrt(Ae);
        node1 = xe(:,1);
        node2 = xe(:,2);
        cosalpha = (node2(1)-node1(1))/norm(node2-node1);
        sinalpha = (node2(2)-node1(2))/norm(node2-node1);
        node3 = node2 +[sinalpha*breite; cosalpha*breite];
        node4 = node1 +[sinalpha*breite; cosalpha*breite];
        x_e=[node1 node2 node3 node4];
        patch(xe(1,:), xe(2,:), [sig_k,sig_k],'EdgeColor','interp','Marker','o','MarkerFaceColor','flat','LineWidth',2);
        hold on
    if e == te
        sig_te = sig_k;
        eps_te = eps_k;
    else
    end
end


%=========================================================================
% post-processing - visualising results
%=========================================================================

title('\sigma^{*}');
%caxis([-10000 10000]);
h = colorbar;
%axis([-0.1 1.1 -0.1 1.1]);
hold off

%fname = sprintf('pictures/plate_with_hole_%03d.png', step);
%print(gcf, '-dpng', fname); 
