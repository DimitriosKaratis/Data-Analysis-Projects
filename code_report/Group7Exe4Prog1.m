%% Group 7
% Dimitrios Karatis (10775)

%% Problem 4
clear; close all; clc;

% Load data
filename = 'TMS.xlsx';
data = readtable(filename);
Setup = data.Setup;      % Setup number (1 to 6)
preTMS = data.preTMS;    % Time from start of ED until TMS is applied
postTMS = data.postTMS;  % Time from TMS onset until end of ED

% Initialize results table
results = table('Size', [6, 4], 'VariableTypes', {'double', 'double', 'double', 'double'}, ...
    'VariableNames', {'Setup', 'Correlation', 'Parametric_pValue', 'Permutation_pValue'});

% Number of permutations for permutation test
num_permutations = 1000;

% Loop over each setup
for i = 1:6
    % Data for current setup
    idx = (Setup == i);
    preTMS_i = preTMS(idx);
    postTMS_i = postTMS(idx);
    
    % Remove NaN values
    valid_idx = ~isnan(preTMS_i) & ~isnan(postTMS_i);
    preTMS_i = preTMS_i(valid_idx);
    postTMS_i = postTMS_i(valid_idx);
    
    % Sample Pearson correlation coefficient
    r = corr(preTMS_i, postTMS_i, 'Type', 'Pearson');
    
    % Parametric t-test for correlation significance
    n = length(preTMS_i);
    t_stat = r * sqrt((n-2)/(1-r^2));
    p_parametric = 2 * (1 - tcdf(abs(t_stat), n-2)); % Null hypothesis: true correlation r = 0
    
    % Permutation test
    perm_r = zeros(num_permutations, 1);
    for j = 1:num_permutations
        perm_postTMS = postTMS_i(randperm(length(postTMS_i))); % Shuffle postTMS
        perm_r(j) = corr(preTMS_i, perm_postTMS, 'Type', 'Pearson');
    end
    p_permutation = mean(abs(perm_r) >= abs(r));
    
    % Store results
    results.Setup(i) = i;
    results.Correlation(i) = r;
    results.Parametric_pValue(i) = p_parametric;
    results.Permutation_pValue(i) = p_permutation;
end

% Display results for each setup
for i = 1:6
    fprintf('\nSetup %d:\n', i);
    fprintf('Correlation coefficient: %.3f\n', results.Correlation(i));
    fprintf('Parametric test p-value: %.3f\n', results.Parametric_pValue(i));
    fprintf('Permutation test p-value: %.3f\n', results.Permutation_pValue(i));
    
    if isnan(results.Parametric_pValue(i))
        fprintf('Insufficient data or contains NaN values\n');
    else
        % Interpretation at 5% significance level
        if results.Parametric_pValue(i) < 0.05
            fprintf('Parametric test: Significant correlation detected\n');
        else
            fprintf('Parametric test: No significant correlation detected\n');
        end
        
        if results.Permutation_pValue(i) < 0.05
            fprintf('Permutation test: Significant correlation detected\n');
        else
            fprintf('Permutation test: No significant correlation detected\n');
        end
    end
end

% Display full results table
fprintf('\n\n');
disp('Results of correlation analysis between preTMS and postTMS:');
disp(results);

%% Conclusions

% No setup showed a significant correlation between preTMS and postTMS 
% (all final p-values above 0.05), so we cannot reject the null hypothesis r = 0.
% Only for Setup 4 the p-value was close to 0.05.

% Both parametric and permutation tests produced similar results. No correlation 
% was detected by either method.

% Permutation test results are considered more reliable because of the small 
% sample sizes. The parametric test assumes normality of the data, which may 
% not hold, especially for small datasets.

