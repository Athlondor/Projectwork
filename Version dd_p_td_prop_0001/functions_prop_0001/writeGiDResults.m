%==========================================================================
% TO BE WRITTEN IN EACH TIME STEP
%==========================================================================
function [] = writeGiDResults(file_name, ndim,ndf,nnp,nen,nel,conn, EVoigt2D,u,time,coord,eta,D_sample,D) 
% reopen .res file to APPEND data to the end of the file
[res,er] = fopen(['output/',file_name,'.post.res'],'a');

%--------------------------------------------------------------------------
% write displacements
fprintf(res,'Result "Displacements" "Time Analysis" %1.5f Vector OnNodes\n',time);
fprintf(res,'Values\n');
% loop on nodes
for i = 1:nnp
    glob_dof_numbers = (i*ndf-ndf+1) : (i*ndf);
    fprintf(res,'%d %1.5f %1.5f\n',i,u(glob_dof_numbers));
end
fprintf(res,'End Values\n\n');
%--------------------------------------------------------------------------
% write stresses
fprintf(res,'Result "Stress" "Time Analysis" %1.5f Scalar OnGaussPoints "Normal"\n',time);
fprintf(res,'Values\n');
for e=1:nel
    edof = zeros(ndim, nen);
    edof(1,:) = conn(e,2:end).*ndim -ndim +1;
    for d = 2 : ndim
        edof(d,:) = edof(d-1,:) + 1;
    end
    gdof = reshape( edof, ndim*nen, 1);
    ue = u(gdof);
    Xe = coord(conn(e,2:end),2:end)';
    eta_e = eta(gdof);
    %displacements of current element 
          
    %element volume
    %ve = 0;
    D_sample_e = D_sample(e);
    fprintf(res,'%2.0f ',e); 
l_e = sqrt(  (Xe(1,1)-Xe(1,2))^2 + (Xe(2,1)-Xe(2,2))^2  );
T_e = 1/l_e *[Xe(1,2) - Xe(1,1), Xe(2,2)-Xe(2,1),          0    ,            0;
                  0            ,      0         ,Xe(1,2) - Xe(1,1), Xe(2,2)-Xe(2,1)];
B_e = 1/l_e* [ -1 1]';
    %recalculate stress and strain based on the solution of the current
    %iteration
    sig_star = D(D_sample_e).sig;
    eps_k = B_e'*(T_e*ue);
    sig_k = sig_star + EVoigt2D'*(B_e'*(T_e*eta_e));
       fprintf(res,'%11.4f',sig_k);
    %   fprintf(res,'%11.4f %11.4f %11.4f\n',sig_star(1),sig_star(2),sig_star(3));
       %fprintf(res,'%11.4f %11.4f %11.4f\n',11,22,12);
    fprintf(res,'\n');
end % Loop over elements
fprintf(res,'End Values\n\n');
%--------------------------------------------------------------------------
% write stresses
fprintf(res,'Result "Strains" "Time Analysis" %1.5f Scalar OnGaussPoints "Normal"\n',time);
fprintf(res,'Values\n');
for e=1:nel
    edof = zeros(ndim, nen);
    edof(1,:) = conn(e,2:end).*ndim -ndim +1;
    for d = 2 : ndim
        edof(d,:) = edof(d-1,:) + 1;
    end
    gdof = reshape( edof, ndim*nen, 1);
    ue = u(gdof);
    Xe = coord(conn(e,2:end),2:end)';
    eta_e = eta(gdof);
    %displacements of current element 
       l_e = sqrt(  (Xe(1,1)-Xe(1,2))^2 + (Xe(2,1)-Xe(2,2))^2  );
T_e = 1/l_e *[Xe(1,2) - Xe(1,1), Xe(2,2)-Xe(2,1),          0    ,            0;
                  0            ,      0         ,Xe(1,2) - Xe(1,1), Xe(2,2)-Xe(2,1)];
B_e = 1/l_e* [ -1 1]';
    %recalculate stress and strain based on the solution of the current
    %iteration
    sig_star = D(D_sample_e).sig;
    eps_k = B_e'*(T_e*ue);
    sig_k = sig_star + EVoigt2D'*(B_e'*(T_e*eta_e));   
    %element volume
    %ve = 0;
    fprintf(res,'%2.0f ',e);
        
       %Stress in current quadrature point: 3d Hooke's law
       fprintf(res,'%11.10f',eps_k);
    %   fprintf(res,'%11.4f %11.4f %11.4f\n',sig_star(1),sig_star(2),sig_star(3));
       %fprintf(res,'%11.4f %11.4f %11.4f\n',11,22,12);
    fprintf(res,'\n');
end % Loop over elements
fprintf(res,'End Values\n\n');
fclose(res);

end