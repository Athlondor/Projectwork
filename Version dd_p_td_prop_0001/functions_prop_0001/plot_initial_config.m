function  plot_initial_config(coord,conn,nel,neum,drlt,ndim)

%=========================================================================
% post-processing - visualising results
%=========================================================================

scale_factor = 1;

figure(1);
width=1.5*550;
height=1.5*400;
set(gcf,'position',[835,300,width,height]);
clf;
    x_min=10;
    x_max=0;
    y_min=10;
    y_max=0;
for e=1:nel
    Xe = coord(conn(e,2:end),2:end)';
    xe = Xe;
    x_min_test = min(xe(1,:)); 
    y_min_test = min(xe(2,:)); 
    x_max_test = max(xe(1,:)); 
    y_max_test = max(xe(2,:)); 
    if x_min_test < x_min
        x_min = x_min_test;
    end
    if x_max_test > x_max 
        x_max = x_max_test;
    end
    if y_min_test < y_min
        y_min = y_min_test;
    end
    if y_max_test > y_max
        y_max = y_max_test;
    end
    % plot deformed configuration  
    patch(xe(1,:), xe(2,:), 0)
    hold on
end
scatter(coord(:,2),coord(:,3),'k','LineWidth',2);
title('\sigma_{11}');
caxis([-20000 20000]);
%h = colorbar;
x_range = x_max-x_min;
y_range = y_max -y_min;
%axis([(x_min-0.5*x_range) (x_max+0.5*x_range) (y_min-0.5*y_range) (y_max+0.5*y_range)]);
for i = 1 : size(neum,1)
    force_vec = [ 0 0 0];
    x_0 = [0 0 0];
    x_end = [0 0 0];
    node = neum(i,1);
    if node == 0
        break
    else
    x_0(1:ndim) = coord(node,2:end);
    force_vec(1:ndim) = neum(i,2:end);
    x_1 = x_0 + 1/(norm(force_vec,'fro')) *force_vec;
    mArrow3(x_0,x_1,'color','r');
    end
end
for j = 1  : size(drlt,1)
    x_p = [0 0 0];
    node =drlt(j,1);
    if drlt(j,2) == 1 & drlt(j,3) == 0 & drlt(j,4) == 0
        x_p(1:ndim) = coord(node,2:end);
        plot(x_p(1)+0.01*x_range,x_p(2),'<','color','k','LineWidth',2);
    elseif drlt(j,2) == 0 & drlt(j,3) == 1 & drlt(j,5) == 0
        x_p(1:ndim) = coord(node,2:end);
        plot(x_p(1),x_p(2)-0.01*y_range,'^','color','k','LineWidth',2);        
    elseif drlt(j,2) == 1 & drlt(j,3) == 1 & drlt(j,4) == 0 & drlt(j,5) == 0
        plot(x_p(1),x_p(2),'x','color','k','LineWidth',2);
    end
    
end
hold off

%fname = sprintf('pictures/plate_with_hole_%03d.png', 0);
%print(gcf, '-dpng', fname); 
