function Group7Exe8Fun1(data_full, include_spike, include_postTMS)
    % Group 7
    % Dimitrios Karatis (10775)
    % Problem 8

    % Function - Fits a full model, stepwise regression model, LASSO, and PCR
    % Depending on 'include_spike', the 'Spike' variable is included
    % Depending on 'include_postTMS', the 'postTMS' variable is included

    %% Select independent variables
    fprintf('\n\n')
    if include_spike && include_postTMS
        independent_vars = {'Setup', 'Stimuli', 'Intensity', 'Spike', 'Frequency', 'CoilCode', 'preTMS', 'postTMS'};
        disp('------ INCLUDING SPIKE AND postTMS ------');
        data_full = rmmissing(data_full); % Remove missing rows if using Spike
    elseif include_spike && ~include_postTMS
        independent_vars = {'Setup', 'Stimuli', 'Intensity', 'Spike', 'Frequency', 'CoilCode', 'preTMS'};
        disp('------ INCLUDING SPIKE ------');
        data_full = rmmissing(data_full); % Remove missing rows if using Spike
    elseif ~include_spike && include_postTMS
        independent_vars = {'Setup', 'Stimuli', 'Intensity', 'Frequency', 'CoilCode', 'preTMS', 'postTMS'};
        disp('------ INCLUDING postTMS ------');
    else
        independent_vars = {'Setup', 'Stimuli', 'Intensity', 'Frequency', 'CoilCode', 'preTMS'};
        disp('------ EXCLUDING SPIKE AND postTMS ------');
    end

    % Convert categorical or cell variables to double
    for var = independent_vars
        if iscell(data_full.(var{:})) || iscategorical(data_full.(var{:}))
            data_full.(var{:}) = double(categorical(data_full.(var{:})));
        end
    end

    % Create X matrix and dependent variable y
    X_full = data_full{:, independent_vars};
    y = data_full.EDduration;

    %% Print Pearson correlations between predictors and EDduration
    fprintf('Pearson correlations between predictors and EDduration:\n');
    for i = 1:numel(independent_vars)
        corr_with_y = corr(X_full(:, i), y, 'Type', 'Pearson');
        fprintf('  %s: %.3f\n', independent_vars{i}, corr_with_y);
    end
    fprintf('\n');

    %% Full linear regression model
    X_full_ones = [ones(size(X_full, 1), 1), X_full]; % Add intercept
    [b1, ~, r1, ~, stats1] = regress(y, X_full_ones);
    mse_linear = mean(r1.^2);
    R2_linear = stats1(1);
    n = length(y);
    p = size(X_full, 2);
    R2_adj_linear = 1 - ((1 - R2_linear) * (n - 1)) / (n - p - 1);
    y_pred_linear = X_full_ones * b1;

    % Plot results
    if include_spike && include_postTMS
        plot_title = 'Full model with Spike and postTMS';
    elseif include_spike && ~include_postTMS
        plot_title = 'Full model with Spike and no postTMS';
    elseif ~include_spike && include_postTMS
        plot_title = 'Full model without Spike and with postTMS';
    else
        plot_title = 'Full model without Spike and postTMS';
    end
    Group7Exe8Fun2(y, y_pred_linear, plot_title);

    %% Stepwise regression model
    stepwise_model = stepwiselm(X_full, y, 'VarNames', ['EDduration', independent_vars]);
    y_pred_stepwise = predict(stepwise_model, X_full);
    selected_vars_stepwise = stepwise_model.PredictorNames;

    if include_spike && include_postTMS
        plot_title = 'Stepwise model with Spike and postTMS';
    elseif include_spike && ~include_postTMS
        plot_title = 'Stepwise model with Spike and no postTMS';
    elseif ~include_spike && include_postTMS
        plot_title = 'Stepwise model without Spike and with postTMS';
    else
        plot_title = 'Stepwise model without Spike and postTMS';
    end
    Group7Exe8Fun2(y, y_pred_stepwise, plot_title);

    %% LASSO regression
    [B, FitInfo] = lasso(X_full, y, 'CV', 50);
    [~, lambda_min_idx] = min(FitInfo.MSE);
    lasso_vars_min = find(B(:, lambda_min_idx) ~= 0);

    n = length(y);
    p = length(lasso_vars_min);

    B_optimal = B(:, lambda_min_idx);
    intercept = FitInfo.Intercept(lambda_min_idx);
    y_pred_lasso = X_full * B_optimal + intercept;
    mse_lasso = mean((y - y_pred_lasso).^2);
    R2_lasso = 1 - sum((y - y_pred_lasso).^2) / sum((y - mean(y)).^2);
    R2_adj_lasso = 1 - (1 - R2_lasso) * (n - 1) / (n - p - 1);

    if include_spike && include_postTMS
        plot_title = 'LASSO model with Spike and postTMS';
    elseif include_spike && ~include_postTMS
        plot_title = 'LASSO model with Spike and no postTMS';
    elseif ~include_spike && include_postTMS
        plot_title = 'LASSO model without Spike and with postTMS';
    else
        plot_title = 'LASSO model without Spike and postTMS';
    end
    Group7Exe8Fun2(y, y_pred_lasso, plot_title);

    %% Principal Component Regression (PCR)
    [~, score, ~, ~, explained] = pca(X_full);
    cumulative_explained = cumsum(explained);
    num_components = find(cumulative_explained >= 95, 1);
    X_pcr = score(:, 1:num_components);
    X_pcr_ones = [ones(size(X_pcr, 1), 1), X_pcr];

    [B_pcr, ~, r_pcr, ~, stats_pcr] = regress(y, X_pcr_ones);
    mse_pcr = mean(r_pcr.^2);
    R2_pcr = stats_pcr(1);
    R2_adj_pcr = 1 - (1 - R2_pcr) * (length(y) - 1) / (length(y) - num_components - 1);
    y_pred_pcr = X_pcr_ones * B_pcr;

    if include_spike && include_postTMS
        plot_title = 'PCR model with Spike and postTMS';
    elseif include_spike && ~include_postTMS
        plot_title = 'PCR model with Spike and no postTMS';
    elseif ~include_spike && include_postTMS
        plot_title = 'PCR model without Spike and with postTMS';
    else
        plot_title = 'PCR model without Spike and postTMS';
    end
    Group7Exe8Fun2(y, y_pred_pcr, plot_title);

    %% Model comparison
    fprintf('\nModel Comparisons:\n');

    fprintf('1. Full Model:\n');
    fprintf('  R-squared: %.3f\n', R2_linear);
    fprintf('  Adjusted R-squared: %.3f\n', R2_adj_linear);
    fprintf('  Mean Squared Error: %.3f\n', mse_linear);

    fprintf('\n2. Stepwise Regression Model:\n');
    fprintf('  R-squared: %.3f\n', stepwise_model.Rsquared.Ordinary);
    fprintf('  Adjusted R-squared: %.3f\n', stepwise_model.Rsquared.Adjusted);
    fprintf('  Mean Squared Error: %.3f\n', stepwise_model.MSE);
    fprintf('  Selected variables: ');
    fprintf('%s, ', selected_vars_stepwise{1:end-1});
    fprintf('%s\n', selected_vars_stepwise{end});

    fprintf('\n3. LASSO Regression Model (Min MSE Lambda):\n');
    fprintf('  R-squared: %.3f\n', R2_lasso);
    fprintf('  Adjusted R-squared: %.3f\n', R2_adj_lasso);
    fprintf('  Mean Squared Error: %.3f\n', mse_lasso);
    fprintf('  Selected variables: ');
    if ~isempty(lasso_vars_min)
        fprintf('%s, ', independent_vars{lasso_vars_min(1:end-1)});
        fprintf('%s\n', independent_vars{lasso_vars_min(end)});
    else
        fprintf('No predictors selected by LASSO.\n');
    end

    fprintf('\n4. Principal Component Regression (PCR):\n');
    fprintf('  R-squared: %.3f\n', R2_pcr);
    fprintf('  Adjusted R-squared: %.3f\n', R2_adj_pcr);
    fprintf('  Mean Squared Error: %.3f\n', mse_pcr);
    fprintf('  Number of principal components used: %d\n', num_components);

end

