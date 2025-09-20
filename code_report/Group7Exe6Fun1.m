function Group7Exe6Fun1(data_full, include_spike)
    % Group 7
    % Dimitrios Karatis (10775)
    % Problem 6
    %
    % This function fits three types of regression models to ED duration:
    %   1. Full multiple linear regression
    %   2. Stepwise regression
    %   3. LASSO regression
    % Optionally includes the 'Spike' variable depending on include_spike input.

    fprintf('\n\n');

    % Determine independent variables based on inclusion of 'Spike'
    if include_spike
        independent_vars = {'Setup', 'Stimuli', 'Intensity', 'Spike', 'Frequency', 'CoilCode'};
        disp('------ INCLUDING SPIKE ------');
        data_full = rmmissing(data_full); % Remove missing rows
    else
        independent_vars = {'Setup', 'Stimuli', 'Intensity', 'Frequency', 'CoilCode'};
        disp('------ EXCLUDING SPIKE ------');
    end

    % Convert categorical/cell variables to numeric
    for var = independent_vars
        if iscell(data_full.(var{:})) || iscategorical(data_full.(var{:}))
            data_full.(var{:}) = double(categorical(data_full.(var{:})));
        end
    end

    % Extract predictors (X) and response (y)
    X_full = data_full{:, independent_vars};
    y = data_full.EDduration;

    %% Full Multiple Linear Regression
    X_full_ones = [ones(size(X_full, 1), 1), X_full]; % Add column for intercept
    [b1, ~, r1, ~, stats1] = regress(y, X_full_ones);
    mse_linear = mean(r1.^2);
    R2_linear = stats1(1);

    n = length(y);        % Number of observations
    p = size(X_full, 2);  % Number of predictors
    R2_adj_linear = 1 - ((1 - R2_linear) * (n - 1)) / (n - p - 1); % Adjusted R-squared
    y_pred_linear = X_full_ones * b1; % Predicted values

    % Plot linear model results
    plot_title = ternary(include_spike, 'Full Model with Spike', 'Full Model without Spike');
    Group7Exe6Fun2(y, y_pred_linear, plot_title);

    %% Stepwise Regression
    stepwise_model = stepwiselm(X_full, y, 'VarNames', ['EDduration', independent_vars]);
    y_pred_stepwise = predict(stepwise_model, X_full);
    selected_vars_stepwise = stepwise_model.PredictorNames;

    plot_title = ternary(include_spike, 'Stepwise model with Spike', 'Stepwise model without Spike');
    Group7Exe6Fun2(y, y_pred_stepwise, plot_title);

    %% LASSO Regression
    [B, FitInfo] = lasso(X_full, y, 'CV', 10); 
    [~, lambda_min_idx] = min(FitInfo.MSE);
    lasso_vars_min = find(B(:, lambda_min_idx) ~= 0);

    % Predicted values and statistics
    B_optimal = B(:, lambda_min_idx);
    intercept = FitInfo.Intercept(lambda_min_idx);
    y_pred_lasso = X_full * B_optimal + intercept;
    mse_lasso = mean((y - y_pred_lasso).^2);
    R2_lasso = 1 - sum((y - y_pred_lasso).^2) / sum((y - mean(y)).^2);
    R2_adj_lasso = 1 - (1 - R2_lasso) * (n - 1) / (n - p - 1);
    best_lambda = FitInfo.Lambda(lambda_min_idx);
    disp(['Optimal Lambda: ', num2str(best_lambda)]);

    plot_title = ternary(include_spike, 'Lasso model with Spike', 'Lasso model without Spike');
    Group7Exe6Fun2(y, y_pred_lasso, plot_title);

    %% Model Comparison
    fprintf('\nModel Comparisons:\n');
    fprintf('1. Full Model:\n');
    fprintf('  R-squared: %.3f\n', R2_linear);
    fprintf('  Adjusted R-squared: %.3f\n', R2_adj_linear);
    fprintf('  Mean Squared Error: %.3f\n', mse_linear);

    fprintf('\n2. Stepwise Regression Model:\n');
    fprintf('  R-squared: %.3f\n', stepwise_model.Rsquared.Ordinary);
    fprintf('  Adjusted R-squared: %.3f\n', stepwise_model.Rsquared.Adjusted);
    fprintf('  Mean Squared Error: %.3f\n', stepwise_model.MSE);
    if ~isempty(selected_vars_stepwise)
        disp(['  Selected variables: ', strjoin(selected_vars_stepwise, ', ')]);
    else
        warning('No variables were selected by stepwise regression.');
    end

    fprintf('\n3. LASSO Regression Model (Min MSE Lambda):\n');
    fprintf('  R-squared: %.3f\n', R2_lasso);
    fprintf('  Adjusted R-squared: %.3f\n', R2_adj_lasso);
    fprintf('  Mean Squared Error: %.3f\n', mse_lasso);
    if ~isempty(lasso_vars_min)
        fprintf('  Selected variables: ');
        fprintf('%s, ', independent_vars{lasso_vars_min(1:end-1)});
        fprintf('%s\n', independent_vars{lasso_vars_min(end)});
    else
        fprintf('  No predictors selected by LASSO.\n');
    end
end

% Helper function for ternary operations
function result = ternary(condition, true_val, false_val)
    if condition
        result = true_val;
    else
        result = false_val;
    end
end

