%% Group 7
% Dimitrios Karatis (10775)

%% Problem 5
clear; close all; clc;

% Load data
filename = 'TMS.xlsx';
data = readtable(filename);
TMS = data.TMS;          % TMS status (1 = with TMS, 0 = without TMS)
EDduration = data.EDduration; % ED duration
Setup = data.Setup;      % Setup number (1 to 6)

% Initialize tables to store R^2 results for different models
results_linear = table('Size', [2, 2], 'VariableTypes', {'string', 'double'}, ...
    'VariableNames', {'Condition', 'R_squared'});
results_poly2 = table('Size', [2, 2], 'VariableTypes', {'string', 'double'}, ...
    'VariableNames', {'Condition', 'R_squared'});
results_poly3 = table('Size', [2, 2], 'VariableTypes', {'string', 'double'}, ...
    'VariableNames', {'Condition', 'R_squared'});
results_poly4 = table('Size', [2, 2], 'VariableTypes', {'string', 'double'}, ...
    'VariableNames', {'Condition', 'R_squared'});
results_poly5 = table('Size', [2, 2], 'VariableTypes', {'string', 'double'}, ...
    'VariableNames', {'Condition', 'R_squared'});
results_poly6 = table('Size', [2, 2], 'VariableTypes', {'string', 'double'}, ...
    'VariableNames', {'Condition', 'R_squared'});

% Conditions: without TMS and with TMS
conditions = {'Without TMS', 'With TMS'}; 

for conditionIdx = 1:2
    if conditionIdx == 1
        idx = (TMS == 0); % Without TMS
    else
        idx = (TMS == 1); % With TMS
    end

    % Data for the current condition
    EDduration_cond = EDduration(idx);
    Setup_cond = Setup(idx);

    % Linear model
    model = fitlm(Setup_cond, EDduration_cond);

    % Polynomial models (degree 2 to 6)
    poly2_model = fitlm(Setup_cond, EDduration_cond, 'poly2'); 
    poly3_model = fitlm(Setup_cond, EDduration_cond, 'poly3');
    poly4_model = fitlm(Setup_cond, EDduration_cond, 'poly4');
    poly5_model = fitlm(Setup_cond, EDduration_cond, 'poly5');
    poly6_model = fitlm(Setup_cond, EDduration_cond, 'poly6');

    % Store R^2 values
    results_linear.Condition(conditionIdx) = conditions{conditionIdx};
    results_linear.R_squared(conditionIdx) = model.Rsquared.Ordinary;

    results_poly2.Condition(conditionIdx) = conditions{conditionIdx};
    results_poly2.R_squared(conditionIdx) = poly2_model.Rsquared.Ordinary;

    results_poly3.Condition(conditionIdx) = conditions{conditionIdx};
    results_poly3.R_squared(conditionIdx) = poly3_model.Rsquared.Ordinary;

    results_poly4.Condition(conditionIdx) = conditions{conditionIdx};
    results_poly4.R_squared(conditionIdx) = poly4_model.Rsquared.Ordinary;

    results_poly5.Condition(conditionIdx) = conditions{conditionIdx};
    results_poly5.R_squared(conditionIdx) = poly5_model.Rsquared.Ordinary;

    results_poly6.Condition(conditionIdx) = conditions{conditionIdx};
    results_poly6.R_squared(conditionIdx) = poly6_model.Rsquared.Ordinary;

    % Plot linear fit
    Setup_fine = linspace(min(Setup_cond), max(Setup_cond), 100);
    figure;
    scatter(Setup_cond, EDduration_cond, 'filled');
    hold on;
    plot(Setup_fine, predict(model, Setup_fine'), '-r', 'LineWidth', 2);
    hold off;
    title(sprintf('ED Duration vs Setup for %s (Linear Fit)', conditions{conditionIdx}));
    xlabel('Setup');
    ylabel('ED Duration');
    legend('Data', 'Linear Fit', 'Location', 'best');
    grid on;

    % Plot polynomial fits (degree 2 to 6)
    figure;
    scatter(Setup_cond, EDduration_cond, 'filled');
    hold on;
    plot(Setup_fine, predict(poly2_model, Setup_fine'), '-g', 'LineWidth', 2);
    plot(Setup_fine, predict(poly3_model, Setup_fine'), '-b', 'LineWidth', 2);
    plot(Setup_fine, predict(poly4_model, Setup_fine'), '-m', 'LineWidth', 2);
    plot(Setup_fine, predict(poly5_model, Setup_fine'), '-c', 'LineWidth', 2);
    plot(Setup_fine, predict(poly6_model, Setup_fine'), '-y', 'LineWidth', 2);
    hold off;
    title(sprintf('ED Duration vs Setup for %s (Polynomial Fits)', conditions{conditionIdx}));
    xlabel('Setup');
    ylabel('ED Duration');
    legend('Data', '2nd Degree Poly', '3rd Degree Poly', '4th Degree Poly', '5th Degree Poly', '6th Degree Poly', 'Location', 'best');
    grid on;
end

% Display R^2 results
disp('Linear Regression Analysis Results:');
disp(results_linear);

disp('2nd Degree Polynomial Regression Analysis Results:');
disp(results_poly2);

disp('3rd Degree Polynomial Regression Analysis Results:');
disp(results_poly3);

disp('4th Degree Polynomial Regression Analysis Results:');
disp(results_poly4);

disp('5th Degree Polynomial Regression Analysis Results:');
disp(results_poly5);

disp('6th Degree Polynomial Regression Analysis Results:');
disp(results_poly6);

%% Conclusions

% R^2 values for the linear model are very low (~0.006 without TMS, ~0.08 with TMS).
% Linear regression performs slightly better with TMS.

% Polynomial models of degree 2–6 were tested and gave much better results.
% Best fits were 5th and 6th degree polynomials, with R^2 ~0.4 (without TMS) and ~0.48 (with TMS).
% Increasing model degree improves fit, but the 6th degree yields nearly identical results 
% to the 5th degree, indicating potential overfitting.

