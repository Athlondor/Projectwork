function [hist_surr_new,current_time,past_time] =  propagator_dd(hist_surr,current_time,nel,past_time,time,hist_flag)
    %_________________Routine to find load-reversals______________
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%**************************************************************************
%|-------------------Ph.D. thesis Marius Harnisch M.Sc.------------------|
%|-----------------supervised by Dr.-Ing. Thorsten Bartel-----------------|
%|----------------Date of creation: 30.08.2022----------------------------|
%|----------------List of Modifications:----------------------------------|
%**************************************************************************
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for e = 1 : nel
    hist_surr_e = hist_surr{e}.hist_surr;
    xi = current_time.eps_k(e);
    sig = current_time.sig_k(e);
    past_time_e.sig_k = past_time.sig_k(e); 
    past_time_e.eps_k = past_time.eps_k(e);
    [hist_surr_updated] = propagator(xi,sig,hist_surr_e,hist_flag,0,past_time_e);
    hist_surr_new{e}.hist_surr = hist_surr_updated;
end
past_time.time = time;
past_time.sig_k = current_time.sig_k;
past_time.eps_k = current_time.eps_k;
past_time.u     = current_time.u;
past_time.eta   = current_time.eta;
end