function [] = plot_data(data)
figure;
hold on;
    for i = 1 : size(data,2)
        plot(data{i}.eps,data{i}.sig,'k');
    end
end