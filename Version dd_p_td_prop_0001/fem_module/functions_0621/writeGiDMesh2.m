%==========================================================================
% TO BE WRITTEN ONLY ONCE
%==========================================================================
function [] = writeGiDMesh(file_name, ndm,ndf,nnp,nen,nel,nqp,x,conn)
%if time == dt
%---------------------------------------------------------------------
%WRITE THE MESH TO .msh
%---------------------------------------------------------------------
%open or create file with writing permission and discard any content
[mes,er3]= fopen(['output/',file_name,'.post.msh'],'w');

%write the header
fprintf(mes,'mesh ''FEM_MESH'' dimension 2 Elemtype Linear Nnode 2\n\n');

%write nodal coordinates
fprintf(mes,'#Node x y\n');
fprintf(mes,'coordinates\n');
for n=1:nnp
    fprintf(mes,'%d %9.5f %9.5f\n',n,x(n,:));
end
fprintf(mes,'end coordinates\n\n');

%write elements
fprintf(mes,'#ElementX node1 node2 igp\n');
fprintf(mes,'elements\n');
for e=1:nel
    fprintf(mes,'%d %d %d %d\n',e,conn(e,:),1);
end
fprintf(mes,'end elements\n\n');

fclose(mes);

%---------------------------------------------------------------------
%WRITE THE HEADER TO .res
%---------------------------------------------------------------------
%open or create file with writing permission and discard any content
[res,er] = fopen(['output/',file_name,'.post.res'],'w');

%write the header
fprintf(res,'GiD Post results File 1.0\n\n');

%define the GaussPoints
fprintf(res,'GaussPoints "Normal" Elemtype Linear\n');
fprintf(res,'Number of Gauss Points: 1\n');
fprintf(res,'Natural Coordinates: Internal\n');
fprintf(res,'endguasspoints\n\n');

fclose(res);
end
