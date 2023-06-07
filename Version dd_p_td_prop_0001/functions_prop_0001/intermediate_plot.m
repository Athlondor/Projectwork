figure(69);
            hold on;
           s = scatter(eps_k,sig_k,'r');
            plot([eps_k D(D_sample_n(e)).xi],[sig_k D(D_sample_n(e)).sig],'k','LineWidth',1);
            plot([eps_k D(D_sample(e)).xi],[sig_k D(D_sample(e)).sig],'k','LineWidth',1);
           s.LineWidth = 2;
           % text(eps_k,sig_k,num2str(iter));