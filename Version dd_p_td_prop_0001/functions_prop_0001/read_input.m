function [nnp,ndim,nen,nel,coord,conn,drlt,neum] = read_input(inputfile)
%_________________Routine to read input file from GiD project_______________
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%**************************************************************************
%|-------------------Master thesis Marius Harnisch B.Sc.------------------|
%|-----------------supervised by Dr.-Ing. Thorsten Bartel-----------------|
%|----------------Date of creation: 09.06.2020----------------------------|
%|----------------List of Modifications:----------------------------------|
%**************************************************************************
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input: Inputfile as string. Example: 'Lochscheibe.dat'
%--------------------------------------------------------------------------
%Output:
%       nnp  : number of node points
%       ndim : number of dimensions
%       nen  : number of element nodes
%       nel  : number of elements
%      coord : list of coordinates of each node point
%       conn : connectivity list
%       drlt : Dirichlet boundary conditions in matrix format
%       neum : Neumann boundary conditions in matrix format
fid = fopen(inputfile,'r');
drlt =zeros(1,5);
neum =zeros(1,3);
switch_coord =0;
switch_conn = 0;
switch_drlt = 0;
switch_neum = 0;
conn_count = 0;
drlt_count = 0;
neum_count = 0;
coord_count = 0;
while 1
tline = fgetl(fid);
na = strncmp(tline,'nnp',3);
nb = strncmp(tline,'ndim',4);
nc = strncmp(tline,'nen',3);
nd = strncmp(tline,'nel',3);
if na == 1
    nnp = sscanf(tline, 'nnp %d');
elseif nb == 1
    ndim = sscanf(tline, 'ndim %d');
elseif nc == 1
    nen = sscanf(tline, 'nen %d');
elseif nd == 1
    nel = sscanf(tline, 'nel %d');
end
ne = strncmp(tline,'coordinates start',17);
ne2 = strncmp(tline,'coordinates end',15);
nf = strncmp(tline,'connectivities start',20);
nf2 = strncmp(tline,'connectivities end',18);
ng = strncmp(tline,'Dirichlet start',15);
ng2 = strncmp(tline,'Dirichlet end',13);
nh = strncmp(tline,'Neumann start',13);
nh2 = strncmp(tline,'Neumann end',11);
if ne2 == 1
    switch_coord = 0;
elseif nf2 == 1
    switch_conn =0;
elseif ng2 == 1
    switch_drlt = 0;
elseif nh2 == 1 
    switch_neum = 0;
end
if switch_coord == 1
    coord_count = coord_count+1;
    coord(coord_count,:)=str2num(tline);
elseif switch_conn == 1
    conn_count = conn_count +1;
    conn(conn_count,:) = str2num(tline);
elseif switch_drlt == 1
    drlt_count = drlt_count +1;
    drlt(drlt_count,:) = str2num(tline);   
elseif switch_neum == 1
    neum_count = neum_count +1;
    neum(neum_count,:) = str2num(tline);
end
if ne ==1
    switch_coord = 1;
elseif nf == 1
    switch_conn = 1;
elseif ng == 1
    switch_drlt = 1;
elseif nh == 1
    switch_neum =1;
end
if tline ==-1
    break;
end
end
fclose(fid);
end