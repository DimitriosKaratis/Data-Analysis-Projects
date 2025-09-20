function Group7Exe6Fun2(y, y_pred, plot_title)
    % Group 7
    % Dimitrios Karatis (10775)
    % Problem 6
    %
    % This function plots the original EDduration data versus predicted values 
    % from a regression model.
    
    % Create a new figure
    figure;
    
    % Scatter plot of original data
    scatter(1:length(y), y, 75, 'b', 'filled', 'DisplayName', 'Original Data'); 
    hold on;
    
    % Plot predicted values from the model
    plot(1:length(y_pred), y_pred, 'r-', 'LineWidth', 3, 'DisplayName', 'Regression Model'); 
    hold on;
    
    % Label axes and add title
    xlabel('Data Index', 'FontSize', 14);  
    ylabel('ED Duration', 'FontSize', 14); 
    title(plot_title, 'FontSize', 16, 'FontWeight', 'bold'); 
    
    % Add legend
    legend('show', 'Location', 'best', 'FontSize', 12, 'Box', 'off');  
    
    % Add grid
    grid on;
    
    % Set axes limits
    xlim([0 length(y)]); 
    ylim([min(y)-5, max(y)+5]);
end

