if reduced_flag == 0
 [D] = create_data_set(Data,hist_flag);
 X =[D(:).xi];
 Y = [D(:).sig];
 % Data reduction
 Matrix = zeros(size(D,2),2+length(D(1).hist));
Matrix(:,1) = [D(:).xi];
Matrix(:,2) = [D(:).sig];
Matrix(:,3:end) = [D(:).hist]';
[test_a,test_b] = unique(Matrix,'rows');
D_reduced  = D(test_b);
else
    X =[D2(:).xi];
    Y = [D2(:).sig];  
end
 figure;
 scatter(X,Y,'k.');
 hold on;
[~,koeff_matrix] = propagator(0,0,0,hist_flag,1,0);
name = "D_" + date +"_hist" +num2str(hist_flag) +"_"+num2str(length(D2)+"_cycles"+n_cycle)+"_matflag"+num2str(mat_flag);
if k_mn1_timestep_flag == 0
    name = name + "_kmn1";
end