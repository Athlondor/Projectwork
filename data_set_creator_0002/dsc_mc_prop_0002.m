%% One-dimensional constitutive driver to create 1D data-sets
% 
%
% Created by Marius Harnisch on 23.09.2022. If you ecounter Bugs, would like to ask a question and/or
% have suggestions for improvement, please contact me at marius.harnisch@tu-dortmund.de 
% A change log can be found at the end of this file.

%% Instruction Manual
% If you would like to implement your own material law, please open the
% function "material_box" in the material_laws folder, where you can find
% an instruction on how to do so.

% Otherwise, the Data Set creator uses the already implemented plasticity
% model. In the following you will find an explanation on the possible
% settings. For you as a user, only the "Settings" section is of
% importance.



% reduced_flag: "1" or "0" - If "1", Additional steps are taken in order to
%               not save redundant data. If "0", Every single load-path is
%               saved and the subsequently utilized to construct the data
%               set via the History Surrogate in propagator. This leads to
%               numerous identical values in the data-set. Should be set to
%               "1".

% epsilon_max: (positive) Double - The maximum strain up to which the loadpaths will be
%               generated. Note: The loadpaths are constructed both in
%               positive AND negative direction up to epsilon max.

% n_cycle : (positive) Integer - The number of loadreversals that should be considered
%           in the data set. Note that the Data set size scales heavily
%           with this number. Data set size of within the low millions
%           should be still usable.

% full_cycle: "True" or "False". If true, the loadpaths can have various
%               form within the range defined by [-epsilon_max,
%               epsilon_max]. If false, the strain within a loadpath can not
%               switch signs.

% k_mn1_timestep_flag: "1" or "0" - If "1": Data-set values are saved as
%                        (epsilon_k, sigma_k, H_k) if "0" values are saved as (epsilon_k,sigma_k,
%                        H_{k-1}", where "k" is the time step

% grid_res_x: (positive) Integer - The number of sample points on the strain axis. The
%             strain axis is subdivided into 2*grid_res_x equidistant
%             regions within [-epsilon_max, epsilon_max]. Therefore
%             grid_res_x controls the resoution of the phase space.
%            

% mat_flag: Integer - controls which material law to be used. Preinstalled
%           is only "1", for which the plasticity model with linear isotropc
%           hardening is used. If you implement your own material routine, it will
%           most likely be used by setting mat_flag to "3".
close all;
clear;
addpath('helper_functions','material_laws','propagator','propagators');
dir = pwd;
%% Settings
reduced_flag = 1;           % 0 or 1
epsilon_max = 1.5*10^(-2);  % (positive) Double
n_cycle = 1;                % (Positive) Integer
full_cycle = false;         % False or True
k_mn1_timestep_flag = 0;    % 0 or 1
grid_res_x = 150;             % (Positive) Integer
mat_flag =1;               % Integer

%%
global tmax dt hist_flag
tmax = 10;
dt = 0.005;
hist_flag =5;
td_switch = 1; % 0 = off, 1 = on --> DSC is executed for n = n-1 cycles until n = 1;
initialization;
if k_mn1_timestep_flag ~= 1 && k_mn1_timestep_flag ~= 0
    error('k_mn1_timestep_flag has to be chosen to be either "1" or "0"')
end
if n_cycle ~= 1
for i = 1 : grid_res_x
    load_tree_def_pos % definition all possible loadpath combinations in positive direction
    for lb = 1: size(load_tree,2) % perform time discrete calculations for every tree
        time_vec_def_pos; % definition time vector for the current loadpath in positive direction

        % Starting point of time-discrete material point simulation
        ta=t(1);
        te=t(end);
        time=ta:dt:te;
        steps=size(time,2);
        e11=load_steplin(dt,t,lam);

        s11      =zeros(steps,1);
        [~, sdv,matparam] = material_box(true,[],[],mat_flag,[]);
        for n=1:steps-1


            %% material_box
            [stress, sdvup] = material_box(false,sdv,e11(n+1),mat_flag,matparam);
            s11(n+1) = stress;
            sdv = sdvup;   
        end
        save_data; % Save the data into the data-set using the Propagator and history surrogate
    end % end of time-discrete material point simulation
end % end of current load_tree 



calculte_subcycles; % Do the same for all loadpaths with n-1 loadreversal points and so on;

%%  negative direction
prelim; % preleminary settings;
for i =1 : grid_res_x
    load_tree_def_neg % definition all possible loadpath combinations in negative direction
    for lb = 1: size(load_tree,2)
        time_vec_def_neg; % definition time vector for the current loadpath in negative direction
        % Starting point of time-discrete material point simulation
        ta=t(1);
        te=t(end);
        time=ta:dt:te;
        steps=size(time,2);
        e11=load_steplin(dt,t,lam);
        s11      =zeros(steps,1);

        [~, sdv,matparam] = material_box(true,[],[],mat_flag,[]);
        for n=1:steps-1
            %% Material Box
            [stress, sdvup] = material_box(false,sdv,e11(n+1),mat_flag,matparam);
            s11(n+1) = stress;
            sdv = sdvup;
        end
        save_data; % Save the data into the data-set using the Propagator and history surrogate

    end % end of time-discrete material point simulation
end % end of current load_tree 

calculte_subcycles; % Do the same for all loadpaths with n-1 loadreversal points and so on;


else
   [D2,Data]= single_lr(mat_flag,grid_res_x,epsilon_max,full_cycle,k_mn1_timestep_flag,reduced_flag);
end
data_postprocessing;
if ispc
    save(dir(1:end-21)+"Version dd_p_td_prop_0001/data_sets_prop_0001/"+name,"D2");
elseif isunix
    error('Running on Linux system - can not save Data-Set. Please contact Marius.');
end

%% Change log
% *20.02.2023* (by MH)
% The following bug fixes have been performed:
%     * The "search_all_left.m" has been reworked into "search_all_left_v2.m" such that now
%       it can also be used for a full cycle (all left values of a positive epsilon are now 
%       taken in to the negative range and not end at 0 as they do for search_all_left.m

%     * In some subroutines, the "search_all_left.m" function was redifined as function instead 
%        of using the matlab file saved in the helper functions. These have now been commented out
%        and all subroutines now use the "search_all_left.m" and "search_all_right.m" functions in
%        the "helper_functions" folder

%    *  The "search_all_left.m" function in the helper_functions folder has been retired (but not yet deleted)

%    * The change of the "search_all_left.m" function affects the following subroutines:
%         * load_tree_def_pos
%         * load_tree_def_neg
%         * calculte_subcycles (--> "time_discrete_dataset_extension" --> "positive_extension" and "negative_extension"

%    * The code did not reverse the loadcycle all the way into the negative regime for the "full_cycle" flag on "true" 
%      for an n_cycle of > 1
%      This has been fixed by introducing in "time_vec_def_pos", "negative_extension" and "positive_extension" a case desticntion for the lam(end) case, where, for a full cylce,
%      the value now is "lam(end) = -epsilon_max" and for full_cylce = false it is "lam(end) = 0"
        
