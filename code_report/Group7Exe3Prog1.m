%% Group 7
% Dimitrios Karatis (10775)

%% Problem 3
clear; close all; clc;

% Load data
filename = 'TMS.xlsx';
data = readtable(filename);
TMS = data.TMS;         % TMS status (1 = with TMS, 0 = without TMS)
Setup = data.Setup;     % Setup number (1 to 6)
EDduration = data.EDduration; % ED duration

% Compute mean ED without TMS
ED_no_TMS = EDduration(TMS == 0);
mu0 = mean(ED_no_TMS);

% Run function to test whether mean ED can be mu0
results = Group7Exe3Fun1(TMS, Setup, EDduration, mu0);

% Display results
Group7Exe3Fun2(results, mu0);

%% Conclusions

% The results for both conditions (with and without TMS) show some differences 
% regarding the null hypothesis across the six measurement setups. 
% In some setups, such as SETUP 1, SETUP 4, and SETUP 5, the null hypothesis 
% produces the same result for both with and without TMS (i.e., either rejected 
% or not rejected in both cases).

% However, in other setups, such as SETUP 2, SETUP 3, and SETUP 6, the null 
% hypothesis produces different results with and without TMS (rejected in one 
% case but not in the other).

% In general, these differences may arise from the different behavior of the 
% data with and without TMS, as well as from the different analysis methods 
% used for each case (parametric or bootstrap).

