%==========================================================================
% TO BE WRITTEN IN EACH TIME STEP
%==========================================================================
function [] = writeGiDResults(file_name, ndm,ndf,nnp,nen,nel,nqp,x,conn, xE,u,time,elem) 
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
% %--------------------------------------------------------------------------
% write stresses
%%%%TO BE FINALIZED
 fprintf(res,'Result "Stress" "Time Analysis" %1.5f Scalar OnGaussPoints "Normal"\n',time);
 fprintf(res,'Values\n');
 q = 1;
 for e=1:nel
    sig = elem(e).sig(q);
    fprintf(res,'%d  %1.5f\n',e,sig);
end % Loop over elements
fprintf(res,'End Values\n\n');

fclose(res);

end
