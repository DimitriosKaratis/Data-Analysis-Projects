%% Group 7
% Dimitrios Karatis (10775)

%% Problem 2
clear; close all; clc;

% Load data
filename = 'TMS.xlsx';
data = readtable(filename);
TMS = data.TMS;           % TMS status (1 = with TMS, 0 = without TMS)
CoilCode = data.CoilCode; % Coil shape (1 = eight-shaped, 0 = round)
EDduration = data.EDduration; % ED duration

% Convert CoilCode from cell array to double if necessary
if iscell(CoilCode)
    CoilCode = cellfun(@str2double, CoilCode);
end

% Separate data based on CoilCode and TMS status
ED_eight_shape = EDduration(CoilCode == 1 & TMS == 1); % Eight-shaped coil, TMS
ED_round_shape = EDduration(CoilCode == 0 & TMS == 1);  % Round coil, TMS

num_resamples = 1000; % Number of resamples for the resampling-based GoF test

% Perform resampling-based goodness-of-fit test
p_value_eight = Group7Exe2Fun1(ED_eight_shape, num_resamples);
p_value_round = Group7Exe2Fun1(ED_round_shape, num_resamples);

% Display resampling-based GoF results
fprintf('Resampling-based Goodness-of-Fit Test Results:\n');
fprintf('Eight-shaped coil: p-value = %.3f\n', p_value_eight);
fprintf('Round coil: p-value = %.3f\n', p_value_round);

% Compare with parametric Chi-squared GoF test
lambda_hat_eight = 1 / mean(ED_eight_shape); % MLE for Exponential (eight-shaped)
lambda_hat_round = 1 / mean(ED_round_shape); % MLE for Exponential (round)
cdf_exp_eight = @(x) 1 - exp(-lambda_hat_eight * x); % CDF for fitted Exponential
cdf_exp_round = @(x) 1 - exp(-lambda_hat_round * x);  % CDF for fitted Exponential
[h_eight, p_eight] = chi2gof(ED_eight_shape, 'CDF', cdf_exp_eight);
[h_round, p_round] = chi2gof(ED_round_shape, 'CDF', cdf_exp_round);

% Display parametric GoF results
fprintf('Parametric Goodness-of-Fit Test Results:\n');
fprintf('Eight-shaped coil: h = %d, p-value = %.3f\n', h_eight, p_eight);
fprintf('Round coil: h = %d, p-value = %.3f\n', h_round, p_round);

%% Conclusions

% The parametric test relies on distributional assumptions (Exponential in our case) 
% and is faster, but it can be inaccurate for small sample sizes. 
% The resampling-based test is more flexible and reduces assumptions about the data distribution, 
% but requires more computational resources and time.

% Both tests agree for the two samples (eight-shaped and round coil). 

% For both tests, the p-values for both coil shapes are greater than 0.05, 
% indicating that we do not reject the null hypothesis. 
% Both methods therefore suggest that there is no significant deviation from 
% the Exponential distribution in the data.

