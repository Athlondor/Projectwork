for e = 1 : nel
figure(69);
            hold on;
           s = scatter(current_time.eps_k(e),current_time.sig_k(e),'r');
            plot([past_time.eps_k(e) D(D_sample_n(e)).xi],[past_time.sig_k(e) D(D_sample_n(e)).sig],'k','LineWidth',1);
            plot([current_time.eps_k(e) D(D_sample(e)).xi],[current_time.sig_k(e) D(D_sample(e)).sig],'k','LineWidth',1);
           s.LineWidth = 2;
           % text(eps_k,sig_k,num2str(iter));
end