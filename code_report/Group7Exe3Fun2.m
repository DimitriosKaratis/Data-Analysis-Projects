function Group7Exe3Fun2(results, mu0)
    % Group 7
    % Dimitrios Karatis (10775)
    % Problem 3
    
    % Function - Prints the results of the mean ED analysis

    % Convert confidence intervals to string format for display
    results_display = results;
    for i = 1:height(results)
        results_display.CI_no_TMS{i} = sprintf('[%.2f, %.2f]', ...
            results.CI_no_TMS{i}(1), results.CI_no_TMS{i}(2));
        results_display.CI_with_TMS{i} = sprintf('[%.2f, %.2f]', ...
            results.CI_with_TMS{i}(1), results.CI_with_TMS{i}(2));
    end

    % Variables indicating whether normality was accepted
    normal_no_TMS = results.H0_rejected_no_TMS == 0;
    normal_with_TMS = results.H0_rejected_with_TMS == 0;

    % Display table of results
    disp('Analysis Results:');
    disp(results_display);
    
    fprintf('\nSetups with normal distribution (no TMS):\n');
    disp(find(normal_no_TMS));

    fprintf('\nSetups with normal distribution (with TMS):\n');
    disp(find(normal_with_TMS));

    fprintf('\nDetailed Analysis Summary:\n');
    fprintf('Overall mean duration without TMS (μ0): %.2f\n', mu0);
    fprintf('-------------------------------------------\n');

    % Loop over each setup
    for setup = 1:6
        fprintf('\nSETUP %d:\n', setup);

        % Without TMS
        fprintf('WITHOUT TMS:\n');
        if normal_no_TMS(setup)
            method_no_TMS = 'Parametric C.I. (Normal distribution accepted)';
        else
            method_no_TMS = 'Bootstrap C.I. (Normal distribution rejected)';
        end
        fprintf('- Analysis Method: %s\n', method_no_TMS);
        fprintf('- Mean: %.2f\n', results.Mean_no_TMS(setup));
        fprintf('- Confidence Interval: [%.2f, %.2f]\n', ...
            results.CI_no_TMS{setup}(1), results.CI_no_TMS{setup}(2));
        fprintf('- H0 (μ = %.2f): %s\n', mu0, ...
            iif(results.H0_rejected_no_TMS(setup), 'Rejected', 'Not Rejected'));

        % With TMS
        fprintf('\nWITH TMS:\n');
        if normal_with_TMS(setup)
            method_with_TMS = 'Parametric C.I. (Normal distribution accepted)';
        else
            method_with_TMS = 'Bootstrap C.I. (Normal distribution rejected)';
        end
        fprintf('- Analysis Method: %s\n', method_with_TMS);
        fprintf('- Mean: %.2f\n', results.Mean_with_TMS(setup));
        fprintf('- Confidence Interval: [%.2f, %.2f]\n', ...
            results.CI_with_TMS{setup}(1), results.CI_with_TMS{setup}(2));
        fprintf('- H0 (μ = %.2f): %s\n', mu0, ...
            iif(results.H0_rejected_with_TMS(setup), 'Rejected', 'Not Rejected'));

        fprintf('-------------------------------------------\n');
    end
end

% Helper function for conditional expressions
function result = iif(condition, true_value, false_value)
    % Returns true_value if condition is true, otherwise returns false_value
    if condition
        result = true_value;
    else
        result = false_value;
    end
end

