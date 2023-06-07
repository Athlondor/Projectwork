pointer = 1;
level=1;
load_tree=zeros(1,1);
eps_max = x_array(i+1);
load_tree(level,1) = eps_max;
level = 2;
load_tree(level,:) =0;
%     [eps_left]= search_all_left(eps_max,step_l,vz_id,full_cycle,epsilon_max);
epsilon_start = load_tree(level-1,pointer);
[eps_left] = search_all_left_v2(epsilon_start,epsilon_max,step_l,vz_id);
branch = load_tree(1:level-1,pointer);
for p = 1: length(eps_left)
    if length(eps_left) == 1
        load_tree(level,pointer) = eps_left(1);
    else
        branch2 = [branch; eps_left(p)];
        if p == 1
            load_tree(:,pointer) = branch2;
        else
            load_tree = [load_tree(:,1:pointer-1),branch2,load_tree(:,pointer:end)];
        end
    end
    pointer = pointer +1;
end
ready = false;
pointer = 1;
if level == n_cycle
    ready = true;
end
while ~ready
    pointer = 1;
    if level == n_cycle
        ready = true;
        break;
    end
    level = level +1;
    load_tree(level,:) =0;
    for j= 1 : length(load_tree(level-1,:))
        epsilon_start = load_tree(level-1,pointer);
        [eps_right] = search_all_right(epsilon_start,epsilon_max,step_l,vz_id);
        branch = load_tree(1:level-1,pointer);
        for p = 1: length(eps_right)
            if length(eps_right) == 1
                load_tree(level,pointer) = eps_right(1);
            else
                branch2 = [branch; eps_right(p)];
                if p == 1
                    load_tree(:,pointer) = branch2;
                else
                    load_tree = [load_tree(:,1:pointer-1),branch2,load_tree(:,pointer:end)];
                end
            end
            pointer = pointer +1;
        end
    end
    if level == n_cycle
        ready = true;
        break;
    end
    level = level+1;
    load_tree(level,:) =0;
    pointer = 1;
    for k = 1 : length(load_tree(level-1,:))
        
        eps_max =  load_tree(level-1,pointer);
        %                  [eps_left]= search_all_left(eps_max,step_l,vz_id);
        %                  [eps_left] = search_all_left(eps_max,step_l,vz_id,full_cycle,epsilon_max);
        epsilon_start = load_tree(level-1,pointer);
        [eps_left] = search_all_left_v2(epsilon_start,epsilon_max,step_l,vz_id);
        branch = load_tree(1:level-1,pointer);
        for p = 1: length(eps_left)
            if length(eps_left) == 1
                load_tree(level,pointer) = eps_left(1);
            else
                branch2 = [branch; eps_left(p)];
                if p == 1
                    load_tree(:,pointer) = branch2;
                else
                    load_tree = [load_tree(:,1:pointer-1),branch2,load_tree(:,pointer:end)];
                end
            end
            pointer = pointer +1;
        end
    end
    
end