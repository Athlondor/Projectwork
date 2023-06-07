function plotresults = plot_results(result,add_plots)
figure(69);
hold on;
sig = [0,result.sig];
eps = [0,result.eps];
step = [result.step];
plot(eps,sig,'k-','LineWidth',2)
% xlabel('Strain');
% ylabel('Stress (MPa)');
% grid on;
figure(2);
subplot(2,1,1);
hold on;
plot(eps,sig,'r--','LineWidth',2)
if add_plots == 1
u_all = [result.u];
time = [result.time];
u_x = u_all(1,:);
u_y = u_all(2,:);
figure;
hold on;
plot(time,u_x,'k-');
xlabel('time');
ylabel('displacement');
grid on;
figure;
hold on;
if isempty(result(1).f) == 0
plot(time,[result.f],'k-','LineWidth',2);
%title('First non zero prescribed force over time');
xlabel('time s');
ylabel('F(t) MN');
grid on;
end
end
end