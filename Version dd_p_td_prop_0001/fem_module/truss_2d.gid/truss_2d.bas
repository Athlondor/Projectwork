%--------------------------------------------------------------------------
% Problem definition
%--------------------------------------------------------------------------
ndm = 2;	% Dimension
ndf = 2;	% Dofs per element
nen = 2;	% Nodes per element

%--------------------------------------------------------------------------
% Geometry
%--------------------------------------------------------------------------
% Number of elements
nel = *nelem;

% Connectivity
conn = [
*loop elems
		*elemsconec ;
*end
];
% Nodes
nnp = *npoin;
x   = [
*loop nodes
       *NodesCoord ;
*end
];

nqp = 1;                % Number of quadrature points
%--------------------------------------------------------------------------
% Materials
%--------------------------------------------------------------------------
*loop materials
xE = *MatProp(1);
Area = *MatProp(2);
*end materials

%--------------------------------------------------------------------------
% Boundary conditions
%--------------------------------------------------------------------------

% Dirichlet boundary condition
%      node  ldof  loadid     scale
drlt = [
*Set Cond Displacement_X *nodes
*loop nodes *onlyInCond
*nodesnum, 1, *cond(1,int), *cond(2);
*end
*Set Cond Displacement_Y *nodes
*loop nodes *onlyInCond
*nodesnum, 2, *cond(1,int), *cond(2);
*end
];

% Neumann boundary condition
%      node  ldof  loadid  scale
neum = [
*Set Cond Force_X *nodes
*loop nodes *OnlyInCond
*nodesnum, 1, *cond(1,int), *cond(2);
*end
*Set Cond Force_Y *nodes
*loop nodes *OnlyInCond
*nodesnum, 2, *cond(1,int), *cond(2);
*end
];

% loadcurves
loadcurve(1).time = 	[0	*GenData(total_time)];
loadcurve(1).value = 	[0	0];
loadcurve(2).time = [*GenData(1)
*for(i=2;i<=4;i=i+1)
*if(GenData(*i,int)==0)
*break
*else
			*GenData(*i)
*endif	
*end for
]';
loadcurve(2).value = [*GenData(5)
*for(i=6;i<=8;i=i+1)
*set var v1=i
*set var v2=operation(v1-4)
*if(GenData(*v2,int)==0)
*break
*else
			*GenData(*i)
*endif	
*end for
]';

% time step / load step variables
ttime = *GenData(total_time); % total time of simulation
dt    = *GenData(timestep); % time step

% BC variables 
allDofs = (1:1:nnp**ndf)';       % array with all DOF numbers
numDrltDofs = size(drlt,1);     % number of dirichlet DOF's
drltDofs = zeros(numDrltDofs,1);% initialise drltDofs array
