% script_test_fcn_PlotTestTrack_PostionvsVelocity.m - this is is a script written
% to test the function: fcn_PlotTestTrack_PostionvsVelocity.m
%
% Revision history:
% 2024_07_15 - started writing the function and script

%% Test 1 
csvFile = readtable('Pittsburgh_3.csv'); % Path to your CSV file
[speed,position] = fcn_PlotTestTrack_PostionvsVelocity(csvFile);
assert(length(speed) == 824)
assert(length(position) == 824)

%% Test 2
csvFile = readtable('site2_3.csv'); % Path to your CSV file
[speed,position] = fcn_PlotTestTrack_PostionvsVelocity(csvFile);
assert(length(speed) == 512)
assert(length(position) == 512)

%% Test 3
csvFile = readtable('site2_1.csv'); % Path to your CSV file
[speed,position] = fcn_PlotTestTrack_PostionvsVelocity(csvFile);
assert(length(speed) == 779)
assert(length(position) == 779)

%% Test 4
csvFile = readtable('Test Track1.csv'); % Path to your CSV file
[speed,position] = fcn_PlotTestTrack_PostionvsVelocity(csvFile);
assert(length(speed) == 743)
assert(length(position) == 743)


%% Test 5
csvFile = readtable('Test Track2.csv'); % Path to your CSV file
[speed,position] = fcn_PlotTestTrack_PostionvsVelocity(csvFile);
assert(length(speed) == 679)
assert(length(position) == 679)