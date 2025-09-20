# Data Analysis Project – Epilepsy Study with TMS

This repository contains the implementation of the **Data Analysis project** for the course *Data Analysis* at the **Department of Electrical and Computer Engineering, Aristotle University of Thessaloniki.**  

The project focuses on the statistical analysis of experimental data from epilepsy research using **Transcranial Magnetic Stimulation (TMS)**, a non-invasive brain stimulation technique. The goal is to investigate how TMS affects the duration of epileptic discharges (ED) and to explore statistical modeling approaches for the collected data.

---

## 📊 Project Overview

The dataset (provided in `TMS.xlsx`) includes measurements of epileptic discharges with and without TMS, along with experimental parameters such as stimulation intensity, frequency, coil type, and timing variables.  

The project is structured into **eight main exercises**, each addressing different statistical methods and modeling approaches:

1. **Probability Distribution Fitting**  
   - Identify suitable parametric distributions for ED duration with and without TMS.  
   - Compare empirical PDFs with fitted models.  

2. **Goodness-of-Fit Testing with Resampling**  
   - Perform Chi-square tests for exponential distribution under different coil shapes (round vs. figure-eight).  
   - Compare parametric and resampling-based hypothesis tests.  

3. **Confidence Intervals & Hypothesis Testing**  
   - Analyze mean ED duration across six experimental setups, with and without TMS.  
   - Apply parametric or bootstrap-based confidence intervals depending on distribution normality.  

4. **Correlation Analysis**  
   - Test correlation between preTMS (time to stimulation) and postTMS (time after stimulation).  
   - Compare parametric (Student’s t) and randomization tests across setups.  

5. **Simple Linear Regression**  
   - Model ED duration as a function of setup, separately for with/without TMS.  
   - Assess regression fit and potential improvements with polynomial models.  

6. **Multiple Linear Regression & Variable Selection**  
   - Fit full regression models with predictors: Setup, Stimuli, Intensity, Spike, Frequency, CoilCode.  
   - Compare full, stepwise, and LASSO-selected models.  
   - Evaluate mean squared error and adjusted R².  

7. **Model Validation with Train/Test Splits**  
   - Assess predictive performance of regression models using random train/test partitions.  
   - Compare variable selection performed on full vs. training subsets.  

8. **Extended Modeling with PreTMS/PostTMS**  
   - Include preTMS as an additional predictor.  
   - Compare Stepwise, LASSO, and Principal Component Regression (PCR).  
   - Evaluate improvements when adding postTMS as well.  

---

## 🛠️ Implementation

- All solutions are implemented in **MATLAB**.  
- Each exercise includes scripts (`GroupXXExeYProgZ.m`) and functions (`GroupXXExeYFunZ.m`) following the naming conventions specified in the assignment.  
- Code files include explanatory comments and conclusions in English.  
