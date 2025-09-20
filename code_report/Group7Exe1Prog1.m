%% Group 7
% Dimitrios Karatis (10775)

%% Problem 1
clear; close all; clc;

% Load data
filename = 'TMS.xlsx'; 
data = readtable(filename);
TMS = data.TMS; 
EDduration = data.EDduration; 

% Filter data based on TMS condition
ED_with_TMS = EDduration(TMS == 1);   % Data with TMS
ED_without_TMS = EDduration(TMS == 0); % Data without TMS

% Distributions to test
distributions = {'Normal', 'Exponential', 'Gamma', 'Lognormal'};
num_bins = 20;
x_range = linspace(min(EDduration), max(EDduration), 100);

% Initialize variables to store best distributions and p-values
bestDist_with_TMS = '';
bestPValue_with_TMS = 0;
bestDist_without_TMS = '';
bestPValue_without_TMS = 0;

% Figure for plotting all fitted distributions
figure;
tiledlayout(4, 2, 'TileSpacing', 'Compact');

% Loop over each distribution
for i = 1:length(distributions)
    dist_name = distributions{i};
    
    % Fit distribution to the data
    dist_with_TMS = fitdist(ED_with_TMS, dist_name);      % with TMS
    dist_without_TMS = fitdist(ED_without_TMS, dist_name); % without TMS
    
    % Calculate PDFs of the fitted distributions
    pdf_with_TMS = pdf(dist_with_TMS, x_range);
    pdf_without_TMS = pdf(dist_without_TMS, x_range);
    
    % Plot histogram and fitted PDF for data with TMS
    nexttile;
    histogram(ED_with_TMS, num_bins, 'Normalization', 'pdf');
    hold on;
    plot(x_range, pdf_with_TMS, 'LineWidth', 2);
    xlabel('EDduration (seconds)');
    ylabel('Density');
    title(['EDduration with TMS - ' dist_name]);
    legend('Empirical PDF', ['Fitted ' dist_name ' PDF']);
    grid on;
    
    % Plot histogram and fitted PDF for data without TMS
    nexttile;
    histogram(ED_without_TMS, num_bins, 'Normalization', 'pdf');
    hold on;
    plot(x_range, pdf_without_TMS, 'LineWidth', 2);
    xlabel('EDduration (seconds)');
    ylabel('Density');
    title(['EDduration without TMS - ' dist_name]);
    legend('Empirical PDF', ['Fitted ' dist_name ' PDF']);
    grid on;
    
    % Perform Chi-squared goodness-of-fit test
    % Null hypothesis: The data follows the fitted distribution
    [h_with_TMS, p_with_TMS] = chi2gof(ED_with_TMS, 'CDF', @(x) cdf(dist_with_TMS,x));
    [h_without_TMS, p_without_TMS] = chi2gof(ED_without_TMS, 'CDF', @(x) cdf(dist_without_TMS,x));
    
    % Display test results
    fprintf('Goodness-of-Fit Test Results for %s distribution:\n', dist_name);
    fprintf('With TMS: h = %d, p = %.3f\n', h_with_TMS, p_with_TMS);
    fprintf('Without TMS: h = %d, p = %.3f\n', h_without_TMS, p_without_TMS);
    
    % Update best distribution based on highest p-value
    if p_with_TMS > bestPValue_with_TMS
        bestPValue_with_TMS = p_with_TMS;
        bestDist_with_TMS = dist_name;
    end
    if p_without_TMS > bestPValue_without_TMS
        bestPValue_without_TMS = p_without_TMS;
        bestDist_without_TMS = dist_name;
    end
end

% Display best-fitting distributions
fprintf('Best Distribution with TMS: %s (p-value: %.3f)\n', bestDist_with_TMS, bestPValue_with_TMS);
fprintf('Best Distribution without TMS: %s (p-value: %.3f)\n', bestDist_without_TMS, bestPValue_without_TMS);

% Plot histograms with best-fitting distributions
figure;
sgtitle('Data Histograms and Best Distribution Fits');

% Best distribution fit + histogram with TMS
subplot(1, 2, 1);
histogram(ED_with_TMS, num_bins, 'Normalization', 'pdf');
hold on;
dist_with_TMS = fitdist(ED_with_TMS, bestDist_with_TMS);
pdf_with_TMS = pdf(dist_with_TMS, x_range);
plot(x_range, pdf_with_TMS, 'r', 'LineWidth', 2);
title('ED Duration with TMS');
xlabel('ED Duration');
ylabel('Density');
legend('Empirical PDF', sprintf('Best Distribution Fit (%s)', bestDist_with_TMS));
hold off;

% Best distribution fit + histogram without TMS
subplot(1, 2, 2);
histogram(ED_without_TMS, num_bins, 'Normalization', 'pdf');
hold on;
dist_without_TMS = fitdist(ED_without_TMS, bestDist_without_TMS);
pdf_without_TMS = pdf(dist_without_TMS, x_range);
plot(x_range, pdf_without_TMS, 'r', 'LineWidth', 2);
title('ED Duration without TMS');
xlabel('ED Duration');
ylabel('Density');
legend('Empirical PDF', sprintf('Best Distribution Fit (%s)', bestDist_without_TMS));
hold off;

%% Conclusions

% From the results, the Exponential distribution fits best for data without TMS,
% while the Lognormal distribution fits best for data with TMS,
% as indicated by the higher Chi-squared GoF p-values for these distributions.

