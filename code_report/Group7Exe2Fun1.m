function p_value = Group7Exe2Fun1(data, num_resamples)
    % Group 7
    % Dimitrios Karatis (10775)
    % Problem 2

    % Function - Performs a resampling-based goodness-of-fit test for Exponential distribution

    % Estimate Exponential distribution parameter (MLE)
    lambda_hat = 1 / mean(data); 
    
    % Compute Chi-squared statistic for the original sample
    cdf_exp = @(x) 1 - exp(-lambda_hat * x);  % CDF of fitted Exponential
    [~, ~, stats] = chi2gof(data, 'CDF', cdf_exp);
    chi2_stat_0 = stats.chi2stat; % Chi-squared statistic for original data
    
    % Generate resamples and compute Chi-squared statistic for each
    chi2_resamples = zeros(num_resamples, 1);
    for i = 1:num_resamples
        resample = exprnd(1/lambda_hat, size(data));  % Generate random sample
        [~, ~, stats_resample] = chi2gof(resample, 'CDF', cdf_exp);
        chi2_resamples(i) = stats_resample.chi2stat; % Store resample statistic
    end
    
    % Compute p-value as proportion of resamples with chi2 >= original
    p_value = mean(chi2_resamples >= chi2_stat_0);
end

