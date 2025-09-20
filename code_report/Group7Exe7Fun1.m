function Group7Exe7Fun1(data_full, include_spike)
    % Group 7
    % Dimitrios Karatis (10775)
    % Problem 7
    %
    % Function: Fits full, stepwise, and LASSO regression models after splitting
    % the dataset into training and test sets. Includes or excludes 'Spike' variable 
    % based on input.

    fprintf('\n\n');
    if include_spike
        independent_vars = {'Setup', 'Stimuli', 'Intensity', 'Spike', 'Frequency', 'CoilCode'};
        disp('------ INCLUDING SPIKE ------');

        % Keep only rows with TMS==1 and remove missing values
        data_full = rmmissing(data_full);

        % Convert categorical/cell variables to double
        for var = independent_vars
            if iscell(data_full.(var{:})) || iscategorical(data_full.(var{:}))
                data_full.(var{:}) = double(categorical(data_full.(var{:})));
            end
        end
    else
        independent_vars = {'Setup', 'Stimuli', 'Intensity', 'Frequency', 'CoilCode'};
        disp('------ EXCLUDING SPIKE ------');

        % Convert categorical/cell variables to double
        for var = independent_vars
            if iscell(data_full.(var{:})) || iscategorical(data_full.(var{:}))
                data_full.(var{:}) = double(categorical(data_full.(var{:})));
            end
        end
    end

    % Prepare predictors (X) and response (y)
    X_full = data_full{:, independent_vars};
    y = data_full.EDduration;

    % Split dataset into training (70%) and test (30%) sets
    cv = cvpartition(size(X_full, 1), 'HoldOut', 0.3);
    train_idx = training(cv);
    test_idx = test(cv);

    X_train = X_full(train_idx, :);
    y_train = y(train_idx);
    X_test = X_full(test_idx, :);
    y_test = y(test_idx);

    %% Stepwise Regression Using Full Dataset for Variable Selection

    stepwise_model = stepwiselm(X_full, y, 'VarNames', ['EDduration', independent_vars]);
    selected_vars_stepwise = stepwise_model.PredictorNames;

    % Get indices of selected predictors
    [selected_vars_stepwise_idx, ~] = ismember(selected_vars_stepwise, independent_vars);

    % Subset training and test sets to selected predictors
    X_train_stepwise = X_train(:, selected_vars_stepwise_idx);
    X_test_stepwise = X_test(:, selected_vars_stepwise_idx);

    % Add intercept term
    X_train_stepwise_ones = [ones(size(X_train_stepwise, 1), 1), X_train_stepwise];
    X_test_stepwise_ones = [ones(size(X_test_stepwise, 1), 1), X_test_stepwise];

    % Fit linear model on training set
    [b, ~, ~, ~, ~] = regress(y_train, X_train_stepwise_ones);    

    % Predict on test set
    y_pred_test = X_test_stepwise_ones * b;

    % Compute test set metrics
    mse_stepwise = mean((y_test - y_pred_test).^2);
    R2_ordinary_stepwise = 1 - sum((y_test - y_pred_test).^2) / sum((y_test - mean(y_test)).^2);
    n_test = length(y_test);
    p = length(selected_vars_stepwise);
    R2_adj_stepwise = 1 - ((1 - R2_ordinary_stepwise) * (n_test - 1)) / (n_test - p - 1);

    % Plot predictions
    plot_title = ifelse(include_spike, ...
        'Regress model with Spike on train set (Stepwise selection)', ...
        'Regress model without Spike on train set (Stepwise selection)');
    Group7Exe7Fun2(y_test, y_pred_test, plot_title);

    %% LASSO Regression Using Full Dataset for Variable Selection

    [B, FitInfo] = lasso(X_full, y, "CV", 10); 
    [~, lambda_min_idx] = min(FitInfo.MSE);
    lasso_vars_min = find(B(:, lambda_min_idx) ~= 0);

    % Subset training and test sets to selected predictors
    X_train_lasso = X_train(:, lasso_vars_min);
    X_test_lasso = X_test(:, lasso_vars_min);

    % Add intercept
    X_train_lasso_ones = [ones(size(X_train_lasso, 1), 1), X_train_lasso];
    X_test_lasso_ones = [ones(size(X_test_lasso, 1), 1), X_test_lasso];

    % Fit linear model on training set
    [b, ~, ~, ~, ~] = regress(y_train, X_train_lasso_ones);    
    y_pred_test = X_test_lasso_ones * b;

    % Test set metrics
    mse_lasso = mean((y_test - y_pred_test).^2);
    R2_ordinary_lasso = 1 - sum((y_test - y_pred_test).^2) / sum((y_test - mean(y_test)).^2);
    n_test = length(y_test);
    p = length(lasso_vars_min);
    R2_adj_lasso = 1 - ((1 - R2_ordinary_lasso) * (n_test - 1)) / (n_test - p - 1);

    plot_title = ifelse(include_spike, ...
        'Regress model with Spike on train set (Lasso selection)', ...
        'Regress model without Spike on train set (Lasso selection)');
    Group7Exe7Fun2(y_test, y_pred_test, plot_title);

    %% Display Model Comparisons

    fprintf('\nModel Comparisons:\n');

    fprintf('1. Stepwise model on test set:\n');
    fprintf('  R-squared: %.3f\n', R2_ordinary_stepwise);
    fprintf('  Adjusted R-squared: %.3f\n', R2_adj_stepwise);
    fprintf('  Mean Squared Error: %.3f\n', mse_stepwise);
    if ~isempty(selected_vars_stepwise)
        disp(['  Selected variables: ', strjoin(selected_vars_stepwise, ', ')]);
    else
        warning('No variables selected by stepwise regression.');
    end

    fprintf('\n2. Lasso model on test set:\n');
    fprintf('  R-squared: %.3f\n', R2_ordinary_lasso);
    fprintf('  Adjusted R-squared: %.3f\n', R2_adj_lasso);
    fprintf('  Mean Squared Error: %.3f\n', mse_lasso);
    fprintf('  Selected variables: ');
    if ~isempty(lasso_vars_min)
        fprintf('%s, ', independent_vars{lasso_vars_min(1:end-1)});
        fprintf('%s\n', independent_vars{lasso_vars_min(end)});
    else
        fprintf('No predictors selected by LASSO.\n');
    end
end

