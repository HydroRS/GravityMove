% Income data for a sample population
income = [15000, 20000, 30000, 40000, 50000, 60000, 70000, 80000, 90000, 100000];

% Calculate the cumulative percentage of income and population
cumulative_income = cumsum(sort(income));
cumulative_income_percent = cumulative_income / sum(income);
cumulative_population_percent = (1:length(income)) / length(income);

% Calculate the Lorenz curve
lorenz_x = [0, cumulative_population_percent];
lorenz_y = [0, cumulative_income_percent];

% Set plot properties
line_width = 2;
font_name = 'Calibri';

% Plot the Lorenz curve
plot(lorenz_x, lorenz_y, 'b', [0,1], [0,1], 'k', 'LineWidth', line_width);
% title('Lorenz Curve', 'FontName', font_name);
xlabel('Cumulative proportion of population', 'FontName', font_name, 'FontSize',12);
ylabel('Cumulative proportion of water use', 'FontName', font_name, 'FontSize',12);
set(gca, 'FontName', font_name, 'FontSize',12);







