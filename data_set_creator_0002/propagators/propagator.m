function [hist_surr_new,koeff_matrix] = propagator(eps_k,sig_k,hist_surr,hist_flag,init_flag,past_time)

% init_flag == 1:
%    BEDEUTUNG UND WAS DER CODE IM FOLGENDEN AUSFÜHRT

if init_flag == 1
    switch hist_flag
        case 1 % stress, strain and rho are saved (from EVERY load-reversal) (max 10 load-reversal)
            % structure : [phi_1, tau_1, rho_1, ... , phi_n, tau_n, rho_n]
            % where the subscript is the i-th load-reversal
            hist_surr_new = zeros(30,1);
            weight_vec = zeros(30,1);
            % %             weight_vec(1:3:end) = 1/210000; % k_phi
            % %             weight_vec(1:3:end) =1; % k_phi
            % %             weight_vec(2:3:end) = 210000; %k_tau
            %             weight_vec(3:3:end) = 1;        % k_rho
            weight_vec(1:3:end) = 1/1; % k_phi
            weight_vec(2:3:end) = 210000; %k_tau
            weight_vec(3:3:end) = 1;        % k_rho
            
            % %             weight_vec(1:3:end) = 1/1; % k_phi
            % %             weight_vec(1:3:end) = 30; % k_phi
            % %             weight_vec(2:3:end) = 1; %k_tau
            %             weight_vec(2:3:end) = 0; %k_tau
            %             weight_vec(3:3:end) = 1;        % k_rho
            koeff_matrix = diag(weight_vec);
            %             if sig_k > 0 % erster Schritt in positive Richtung
            %                 hist_surr_new(3:3:end) = -1;
            %                 hist_surr_new(3:6:end) = 1;
            %             else % erster Schritt in negative Richtung
            %                 hist_surr_new(3:3:end) = 1;
            %                 hist_surr_new(3:6:end) = -1;
            %             end
        case 2 % only stress with maximum absolute value is saved
            hist_surr_new = zeros(1,1);
            hist_surr_new(1) = max(hist_surr);
            koeff_matrix = 30;
        case 3 % only strain with maximum absolute value is saved
            hist_surr_new = zeros(1,1);
            hist_surr_new(1) = max(hist_surr);
            koeff_matrix = 30;
        case 4
            hist_surr_new = zeros(3,1);
            %             weight_vec = [1/210000 1/210000 1];
            %             weight_vec = [30 0 1];
            weight_vec = [1/21,0,1];
            koeff_matrix = diag(weight_vec);
            
            
        case 5
            % stress, strain and rho are saved (from EVERY load-reversal) (max 10 load-reversal)
            % structure : [phi_1, tau_1, rho_1, ... , phi_n, tau_n, rho_n]
            % where the subscript is the i-th load-reversal
            hist_surr_new = zeros(32,1);
            weight_vec = zeros(32,1);
            %             weight_vec(1:3:end) = 1/2100000; % k_phi
            %             weight_vec(1:3:end) = 1; % k_phi
            %             weight_vec(2:3:end) = 210000; %k_tau
            %             weight_vec(3:3:end) = 1;        % k_rho
            weight_vec(1:3:end) = 1/210000; % k_phi
            weight_vec(2:3:end) = 210000; %k_tau
            weight_vec(3:3:end) = 1;        % k_rho
            
            weight_vec(1:3:end) = 1/1; % k_phi
            weight_vec(2:3:end) = 1; %k_tau
            weight_vec(3:3:end) = 1;        % k_rho
            %             weight_vec(1:3:end) = 1/1; % k_phi
            %             weight_vec(2:3:end) = 210000; %k_tau
            %             weight_vec(3:3:end) = 1;        % k_rho
            weight_vec(end) = 0;
            weight_vec(end-1) = 0/1;
            
            %% STRAIN CONTROLLED
             weight_vec(1:3:end) = 1/210000; % k_phi
            weight_vec(2:3:end) = 210000; %k_tau
            weight_vec(3:3:end) = 1;        % k_rho
            
            
            
            %%
            koeff_matrix = diag(weight_vec);
            %             if sig_k > 0 % erster Schritt in positive Richtung
            %                 hist_surr_new(3:3:end) = -1;
            %                 hist_surr_new(3:6:end) = 1;
            %             else % erster Schritt in negative Richtung
            %                 hist_surr_new(3:3:end) = 1;
            %                 hist_surr_new(3:6:end) = -1;
            %             end
        otherwise
            error('Error: Unknown History Surrogate (hist_flag) \\ Error in Function "propagator" in line 38');
    end
else
    switch hist_flag
        case 1
            if hist_surr(3) == 0 % no previous loadreversal and initial step
                hist_surr_new = hist_surr;
                hist_surr_new(3) = sign(sig_k);
                hist_surr_new(1) = 0;
                hist_surr_new(2) = 0;
            else
                if sign(sig_k-past_time.sig_k) == hist_surr(3) % no load reversal
                    hist_surr_new = hist_surr;
                else % load-reversal
                    hist_surr_new = zeros(length(hist_surr),1);
                    hist_surr_new(4:end) = hist_surr(1:end-3);
                    hist_surr_new(1) = past_time.sig_k;
                    hist_surr_new(2) = past_time.eps_k;
                    hist_surr_new(3) = sign(sig_k-past_time.sig_k);
                end
            end
        case 2 % only stress with maximum absolute value is saved
            if abs(sig_k)-abs(hist_surr) > 1e-10
                hist_surr_new = sig_k;
            else
                hist_surr_new = hist_surr;
            end
            
        case 3 % only strain with maximum absolute value is saved
            if abs(eps_k) > abs(hist_surr)
                hist_surr_new = eps_k;
            else
                hist_surr_new = hist_surr;
            end
        case 4
            if hist_surr(3) == 0
                hist_surr_new = zeros(3,1);
                hist_surr_new(3) = sign(sig_k);
                hist_surr_new(2) = sig_k;
                hist_surr_new(1) = 0;
            else
                if sign(sig_k - hist_surr(2)) == hist_surr(3) % no loadreversal
                    hist_surr_new = hist_surr;
                    hist_surr_new(2) = sig_k;
                else
                    hist_surr_new(3) = sign(sig_k - hist_surr(2));
                    hist_surr_new(2) = sig_k;
                    hist_surr_new(1) = hist_surr(2);
                    hist_surr_new = hist_surr_new';
                end
            end
            
        case 5
            if hist_surr(3) == 0 % no previous loadreversal and initial step
                hist_surr_new = hist_surr;
                hist_surr_new(3) = sign(sig_k);
                hist_surr_new(1) = 0;
                hist_surr_new(2) = 0;
                hist_surr_new(end) = eps_k;
                hist_surr_new(end-1) = sig_k;
            else
                if sign(sig_k-hist_surr(end-1)) == hist_surr(3) % no load reversal
                    hist_surr_new = hist_surr;
                    hist_surr_new(end) = eps_k;
                    hist_surr_new(end-1) = sig_k;
                else % load-reversal
                    hist_surr_new = zeros(length(hist_surr),1);
                    hist_surr_new(4:end-2) = hist_surr(1:end-5);
                    hist_surr_new(1) = past_time.sig_k;
                    hist_surr_new(2) = past_time.eps_k;
                    hist_surr_new(3) = sign(sig_k-past_time.sig_k);
                    hist_surr_new(end) = eps_k;
                    hist_surr_new(end-1) = sig_k;
                end
            end
            
        case 7
        otherwise
            error('Error: Unknown History Surrogate (hist_flag) \\ Error in Function "propagator" in line 85');
    end
    
    
    
    
    
    
    
    
end
end