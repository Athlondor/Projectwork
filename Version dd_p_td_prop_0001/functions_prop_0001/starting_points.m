nsp = length(D);
sum_vec = zeros(1,size(D,2));
     for i = 1 : size(D,2)
         sig_sum = sum(abs(D(i).sig));
         eps_sum = sum(abs(D(i).xi));
         hist_sum = sum(sum(abs(D(i).hist)));
%          tau_sum = sum(abs(D(i).tau));
         t_sum = sig_sum+eps_sum+hist_sum;
         sum_vec(i) = t_sum;
     end
     [~, ssp] = min(sum_vec);
     D_sample = ssp*ones(1,nel);
%D_sample = ones(1,nel);
maxs = max([D(:).sig]);
mins = min([D(:).sig]);
for i = 1 : nel
scatter(D(D_sample(i)).xi,D(D_sample(i)).sig,'r');
% plot([D(D_sample(i)).tau D(D_sample(i)).tau],[maxs mins],'r--');
end