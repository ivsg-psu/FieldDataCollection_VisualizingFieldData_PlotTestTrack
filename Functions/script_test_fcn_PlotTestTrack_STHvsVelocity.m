% script_test_fcn_PlotTestTrack_STHvsVelocity.m - this is is a script written
% to test the function: fcn_PlotTestTrack_STHvsVelocity.m
%
% Revision history:
% 2024_07_15 - started writing the function and script

%% Test 1 
csvFile = readtable('Pittsburgh_3.csv'); % Path to your CSV file
[speed,position] = fcn_PlotTestTrack_STHvsVelocity(csvFile);

%% Test 2
csvFile = readtable('site2_3.csv'); % Path to your CSV file
[speed,position] = fcn_PlotTestTrack_STHvsVelocity(csvFile);

%% Test 3
csvFile = readtable('site2_1.csv'); % Path to your CSV file
[speed,position] = fcn_PlotTestTrack_STHvsVelocity(csvFile);
