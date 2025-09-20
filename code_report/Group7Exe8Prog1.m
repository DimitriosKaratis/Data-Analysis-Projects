%% Group 7
% Dimitrios Karatis (10775)

%% Problem 8
clear; close all; clc;

% Load data
filename = 'TMS.xlsx';
data = readtable(filename);

% Keep rows where TMS == 1 and remove missing values
data_full = data(data.TMS == 1, :);

% Independent variables
independent_vars = {'Setup', 'Stimuli', 'Intensity', 'Spike', 'Frequency', 'CoilCode', 'preTMS', 'postTMS'};

% Without 'Spike' and 'postTMS'
include_spike = false;
include_postTMS = false;
Group7Exe8Fun1(data_full, include_spike, include_postTMS);

% Without 'Spike' and with 'postTMS'
include_spike = false;
include_postTMS = true;
Group7Exe8Fun1(data_full, include_spike, include_postTMS);

%% Conclusions

% For this question, we chose NOT to include the 'Spike' variable, as it gave worse results 
% in the analysis of question 6.

% Initially, when both 'Spike' and 'postTMS' were excluded, the stepwise regression 
% stood out as the best model with an Adjusted R-squared of 0.505 and the lowest MSE (72.523), 
% selecting the variables EDduration, Intensity, and CoilCode. This indicates that these variables 
% contribute most to explaining the dependent variable. 
% LASSO regression, on the other hand, showed lower performance (Adjusted R-squared 0.390, MSE 84.036) 
% and selected more variables, producing results similar to the full model. 
% PCR, using 4 principal components, had the worst performance (Adjusted R-squared 0.361, MSE 89.669), 
% showing it did not sufficiently explain EDduration. 
% However, all models showed broadly similar trends.

% When the 'postTMS' variable was included, all models showed dramatic improvement. 
% The full model and stepwise regression achieved perfect fit with Adjusted R-squared 1.000 and MSE 0.000, 
% because the new variable contains information that fully explains EDduration.
% To check this, we printed correlations between predictors and EDduration, 
% showing that 'postTMS' has an almost perfect correlation (0.955) with EDduration, 
% which explains our results. 
% LASSO regression also performed very well (Adjusted R-squared 0.999, MSE 0.131), 
% selecting only preTMS and postTMS, showing that these two are sufficient for accurate prediction. 
% PCR improved significantly, using only 2 principal components and achieving nearly perfect fit 
% (Adjusted R-squared 1.000, MSE 0.024).

% Compared to the previous question, adding 'postTMS' dramatically improved all models, 
% leading to higher Adjusted R-squared and much lower MSE. Models for dimension reduction, 
% such as stepwise regression, LASSO, and PCR, also showed changes in selected variables 
% or the number of principal components used. 

% Overall, adding 'postTMS' makes the models more effective, 
% (achieving almost perfect fit in all cases). 
% Note: The fact that nearly all models show perfect fit when 'postTMS' is added is not necessarily 
% a good sign, as it may indicate overfitting. This means the models may be too closely fitted 
% to the existing data and might not perform well on new or unknown data.

% These observations are also evident in the plots we generated.

