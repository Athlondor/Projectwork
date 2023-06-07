function [coord,conn,drlt,neum] =  load_GiDcf_input( x, elem,drlt_in, neum_in)
%_________________Routine to load problem from a GiD calculation file______
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%**************************************************************************
%|-------------------Master thesis Marius Harnisch B.Sc.------------------|
%|-----------------supervised by Dr.-Ing. Thorsten Bartel-----------------|
%|----------------Date of creation: 14.06.2020----------------------------|
%|----------------List of Modifications:----------------------------------|
%**************************************************************************
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1 : size(x,1)
    coord(i,1) = i;
    coord(i,2:3) = x(i,1:2);
end
for i = 1 : size(elem,2)
    conn(i,1) = i;
    conn(i,2:5) = elem(i).cn;
end
drlt_in(:,2) = [];
for i = 1 : size(drlt_in,1)
    node = drlt_in(i,1);
    dof = drlt_in(i,2);
    value = drlt_in(i,3);
    if dof == 1
        drlt(node,1) = node;
        drlt(node,2) = 1;
        drlt(node,4) = value;
    elseif dof == 2
        drlt(node,1) = node;
        drlt(node,3) = 1;
        drlt(node,5) = value;
    end
end
neum_in(:,2) = [];
for i = 1: size(neum_in,1)
    node = neum_in(i,1);
    dof = neum_in(i,2);
end
end