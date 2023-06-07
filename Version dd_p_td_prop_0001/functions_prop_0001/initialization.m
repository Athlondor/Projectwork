[nnp,ndim,nen,nel,coord,conn,drlt,neum] = read_input(file_name);
 
drlt_re = drlt;
neum_re = neum;

[ drltDofs, freeDofs, neumDofs ] = dofSeparation( nnp, ndim, drlt, neum );
%Initialize displacements and lagrange parameters
        %u_lr                   = zeros(ndim*nnp, 1);
u_end                = zeros(ndim*nnp,1);
        %eta_lr                 = zeros(ndim*nnp, 1);
eta_end              = zeros(ndim*nnp,1);
A_e = 0.01; % cross sectional area of each truss


writeGiDMesh(file_name, ndim,ndim,nnp,nen,nel,1,coord,conn);


for i = 1 : (stopTime/dt)
    testelem(i).sig  = zeros(1);
    testelem(i).eps  = zeros(1);
    testelem(i).time = 0;
end

% for nc = 1 : nlr
%     hist_surr{nc}.u_lr    = zeros(ndim*nnp,1);
%     hist_surr{nc}.eta_lr  = zeros(ndim*nnp,1);
%   %  hist_surr{nc}.drlt_lr = drlt;
%   %  hist_surr{nc}.neum_lr = neum;
%     hist_surr{nc}.fsur_lr = zeros(ndim*nnp,1);
%     hist_surr{nc}.tau_k = zeros(nel,1);
%     hist_surr{nc}.phi_k = zeros(nel,1);
%     hist_surr{nc}.rho_k = zeros(nel,1);
%     hist_surr{nc}.init_step = 1;
% end
past_time.sig_k    = zeros(nel,1);
past_time.eps_k  = zeros(nel,1);
past_time.time = 0;
for e = 1 : nel
[hist_surr_new,~] = propagator(0,0,0,hist_flag,1,past_time);
history{e}.hist_surr = hist_surr_new;
end


current_time.sig_k = zeros(nel,1);
current_time.eps_k = zeros(nel,1);
lr_flag = 0;
recalc_flag = 0;


time = 0;
step = 0;
 plot_initial_config(coord,conn,nel,neum,drlt,ndim); %some more plots
%initial values
fsur_end             = zeros(ndim*nnp,1);
[fsur_end, u_end,eta_end] = loadDefinition_td(0,stopTime, drlt, neum, neumDofs,drltDofs, fsur_end,u_end,eta_end, ndim,time_vec,loadcurve);
first_lr_switch = 0;