function Group7Exe7Fun2(y, y_pred, plot_title)
    % Group 7
    % Dimitrios Karatis (10775)
    % Problem 7
    %
    % Function: Plots original data vs. predicted values from a regression model

    % Create new figure
    figure;
    
    % Scatter plot for original data
    scatter(1:length(y), y, 75, 'b', 'filled', 'DisplayName', 'Original Data'); 
    hold on;
    
    % Line plot for predicted values
    plot(1:length(y_pred), y_pred, 'r-', 'LineWidth', 3, 'DisplayName', 'Regression Model'); 
    
    % Axis labels and plot title
    xlabel('Data Index', 'FontSize', 14);  
    ylabel('ED Duration (TMS)', 'FontSize', 14); 
    title(plot_title, 'FontSize', 16, 'FontWeight', 'bold'); 
    
    % Add legend
    legend('show', 'Location', 'best', 'FontSize', 12, 'Box', 'off');  
    
    % Enable grid
    grid on;
    
    % Set axis limits
    xlim([0 length(y)]); 
    ylim([min(y)-5, max(y)+5]);
end

