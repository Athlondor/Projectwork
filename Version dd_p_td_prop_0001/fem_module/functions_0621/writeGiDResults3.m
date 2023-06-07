%==========================================================================
% TO BE WRITTEN IN EACH TIME STEP
%==========================================================================
function [] = writeGiDResults3(file_name, ndim,ndf,nnp,nen,nel,conn, EVoigt2D,u,time,coord,elem) 
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
    fprintf(res,'%2.0f ',e);
    sig_k = elem(e).sig;
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
    eps_pl = elem(e).ivar_np1(1);
    fprintf(res,'%2.0f ',e);
        
       %Stress in current quadrature point: 3d Hooke's law
       fprintf(res,'%11.4f',eps_pl);
    %   fprintf(res,'%11.4f %11.4f %11.4f\n',sig_star(1),sig_star(2),sig_star(3));
       %fprintf(res,'%11.4f %11.4f %11.4f\n',11,22,12);
    fprintf(res,'\n');
end % Loop over elements
fprintf(res,'End Values\n\n');
fclose(res);

end