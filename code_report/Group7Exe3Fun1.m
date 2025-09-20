function results = Group7Exe3Fun1(TMS, Setup, EDduration, mu0)
    % Group 7
    % Dimitrios Karatis (10775)
    % Problem 3
    
    % Function - Checks whether the mean ED can be equal to mu0,
    % using confidence intervals and parametric or bootstrap tests

    % Initialize results table
    results = table('Size', [6, 7], 'VariableTypes', {...
        'double', 'double', 'cell', 'logical', 'double', ...
        'cell', 'logical'}, ...
        'VariableNames', {...
        'Setup', 'Mean_no_TMS', 'CI_no_TMS', 'H0_rejected_no_TMS', ...
        'Mean_with_TMS', 'CI_with_TMS', 'H0_rejected_with_TMS'});

    % Loop over each setup
    for setup = 1:6
        % Get samples for current setup
        ED_no_TMS_setup = EDduration(TMS == 0 & Setup == setup);
        ED_with_TMS_setup = EDduration(TMS == 1 & Setup == setup);

        % Estimate mean and standard deviation
        mu_no_TMS = mean(ED_no_TMS_setup);
        sigma_no_TMS = std(ED_no_TMS_setup);
        mu_with_TMS = mean(ED_with_TMS_setup);
        sigma_with_TMS = std(ED_with_TMS_setup);

        % Determine number of bins for Chi-squared GoF test
        bins_no_TMS = round(sqrt(length(ED_no_TMS_setup)));
        bins_with_TMS = round(sqrt(length(ED_with_TMS_setup)));

        % Chi-squared GoF test for normality
        cdf_normal_no_TMS = @(x) normcdf(x, mu_no_TMS, sigma_no_TMS);
        [~, p_no_TMS, ~] = chi2gof(ED_no_TMS_setup, 'CDF', cdf_normal_no_TMS, ...
            'NBins', bins_no_TMS);

        cdf_normal_with_TMS = @(x) normcdf(x, mu_with_TMS, sigma_with_TMS);
        [~, p_with_TMS, ~] = chi2gof(ED_with_TMS_setup, 'CDF', cdf_normal_with_TMS, ...
            'NBins', bins_with_TMS);

        % For data without TMS
        if p_no_TMS > 0.05  % Normality accepted - use parametric test
            ci_no_TMS = mean(ED_no_TMS_setup) + tinv([0.025 0.975], length(ED_no_TMS_setup)-1) * ...
                std(ED_no_TMS_setup) / sqrt(length(ED_no_TMS_setup)); % Confidence interval
            [~, p_value_no_TMS] = ttest(ED_no_TMS_setup, mu0); % t-test for null hypothesis
            h0_rejected_no_TMS = (p_value_no_TMS < 0.05);
        else % Normality rejected - use bootstrap test
            ci_no_TMS = bootci(1000, @mean, ED_no_TMS_setup);
            boot_means = bootstrp(1000, @mean, ED_no_TMS_setup);
            p_value_no_TMS = 2 * min(mean(boot_means >= mu0), mean(boot_means <= mu0));
            h0_rejected_no_TMS = (p_value_no_TMS < 0.05);
        end

        % For data with TMS
        if p_with_TMS > 0.05 % Normality accepted - use parametric test
            ci_with_TMS = mean(ED_with_TMS_setup) + tinv([0.025 0.975], length(ED_with_TMS_setup)-1) * ...
                std(ED_with_TMS_setup) / sqrt(length(ED_with_TMS_setup)); % Confidence interval
            [~, p_value_with_TMS] = ttest(ED_with_TMS_setup, mu0); % t-test for null hypothesis
            h0_rejected_with_TMS = (p_value_with_TMS < 0.05);
        else % Normality rejected - use bootstrap test
            ci_with_TMS = bootci(1000, @mean, ED_with_TMS_setup);
            boot_means = bootstrp(1000, @mean, ED_with_TMS_setup);
            p_value_with_TMS = 2 * min(mean(boot_means >= mu0), mean(boot_means <= mu0));
            h0_rejected_with_TMS = (p_value_with_TMS < 0.05);
        end

        % Store results
        results.Setup(setup) = setup;
        results.Mean_no_TMS(setup) = mean(ED_no_TMS_setup);
        results.CI_no_TMS{setup} = ci_no_TMS;
        results.H0_rejected_no_TMS(setup) = h0_rejected_no_TMS;
        results.Mean_with_TMS(setup) = mean(ED_with_TMS_setup);
        results.CI_with_TMS{setup} = ci_with_TMS;
        results.H0_rejected_with_TMS(setup) = h0_rejected_with_TMS;
    end
end

