function Group7Exe8Fun2(y, y_pred, plot_title)
    % Group 7
    % Dimitrios Karatis (10775)
    % Problem 8
    
    % Function - Plots the predicted values against the original data

    % Create a new figure
    figure;
    
    % Scatter plot for the original data
    scatter(1:length(y), y, 75, 'b', 'filled', 'DisplayName', 'Original Data'); 
    hold on;
    
    % Line plot for the predicted values from the regression model
    plot(1:length(y_pred), y_pred, 'r-', 'LineWidth', 3, 'DisplayName', 'Regression Model'); 
    hold on;
    
    % Axis labels and title
    xlabel('Data Index', 'FontSize', 14);  
    ylabel('EDdurationTMS', 'FontSize', 14); 
    title(plot_title, 'FontSize', 16, 'FontWeight', 'bold'); 
    
    % Add legend
    legend('show', 'Location', 'best', 'FontSize', 12, 'Box', 'off');  
    
    % Add grid
    grid on;
    
    % Set axis limits
    xlim([0 length(y)]); 
    ylim([min(y)-5, max(y)+5]);

end

