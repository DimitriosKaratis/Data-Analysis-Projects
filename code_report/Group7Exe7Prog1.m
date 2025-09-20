%% Group 7
% Dimitrios Karatis (10775)

%% Problem 7
clear; close all; clc;

% Load data
filename = 'TMS.xlsx';
data = readtable(filename);

% Set random seed for reproducibility
rng(10)

% Keep rows where TMS == 1 and remove missing values
data_full = data(data.TMS == 1, :);

% Independent variables
independent_vars = {'Setup', 'Stimuli', 'Intensity', 'Spike', 'Frequency', 'CoilCode'};

% Data without 'Spike'
include_spike = false; 
Group7Exe7Fun1(data_full, include_spike);


%% Conclusions

% For this question, we chose NOT to include the 'Spike' variable, as it gave worse results 
% in the analysis of question 6.

% From the first part of the results, we observe that the LASSO model, which seems to have 
% selected more variables, shows worse performance on the test set, with negative R-squared (-0.283) 
% and Adjusted R-squared (-0.504), indicating overfitting and high MSE (130.274). 
% In contrast, the Stepwise model with the variables "EDduration" and "Intensity" performs better, 
% with negative R-squared (-0.101) but lower MSE (111.759), showing better adaptation to this dataset.

% In the second part of the analysis, the LASSO results remain almost identical to the first part, 
% with negative R-squared and high MSE (127.143). However, the Stepwise model shows improved performance, 
% with positive R-squared (0.337), Adjusted R-squared (0.295), and lower MSE (67.378), indicating better fit.

% In summary, the LASSO model shows similar results in both cases, but the Stepwise model performs 
% significantly better when the variables are selected in the training set, 
% both compared to LASSO and its initial application to the full dataset. 

% All these conclusions are also visible in the plots we generated.

% General observation:
% Negative R-squared and Adjusted R-squared indicate that the model is not able to explain 
% the variance in the data and may perform worse than a simple model that predicts the mean 
% of the dependent variable for all observations. A negative R-squared means the model performs 
% worse than the mean model, while Adjusted R-squared also accounts for the number of predictors 
% and the degrees of freedom. Therefore, negative R-squared and Adjusted R-squared suggest that 
% the model may be overcomplicated or that the predictors used do not relate to the dependent variable.

