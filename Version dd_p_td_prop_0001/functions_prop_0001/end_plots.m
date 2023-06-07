for i = 1 : size(testelem,2)
   plot_sig(i) = testelem(i).sig(1);
   plot_eps(i) = testelem(i).eps(1);
   plot_time(i) = testelem(i).time;
end
figure;
hold on;
subplot(2,1,1);
plot(plot_eps,plot_sig,'k','LineWidth',2);
xlabel('strain');
ylabel('stress');
subplot(2,1,2);
plot(plot_time,plot_sig,'k','LineWidth',2);
xlabel('time');
ylabel('stress');
results.plot_sig = plot_sig;
results.plot_eps = plot_eps;
results.plot_time = plot_time;