figure(69);
hold on;
xlabel('Strain');
ylabel('Stress [MPa]');
x0=10;
y0=300;
width=1.5*550;
height=1.5*400;
set(gcf,'position',[x0,y0,width,height]);
for i = 1 : length(D)
x(i)=D(i).xi;
y(i)=D(i).sig;
end
scatter(x,y,'k.');