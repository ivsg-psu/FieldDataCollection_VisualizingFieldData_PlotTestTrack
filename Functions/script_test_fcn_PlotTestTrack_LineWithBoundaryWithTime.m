% script_test_fcn_PlotTestTrack_LineWithBoundaryWithTime
% This is a script to exercise the function:
% fcn_PlotTestTrack_LineWithBoundaryWithTime.m 
% This function was written on 2024_07_07 by Jiabao Zhao, jpz5469@psu.edu


%% test 1
csvFile = 'Test Track1.csv'; % Path to your CSV file
fcn_PlotTestTrack_LineWithBoundaryWithTime(csvFile, [], [], true); 

%% test 2
csvFile = 'Test Track2.csv'; % Path to your CSV file
fcn_PlotTestTrack_LineWithBoundaryWithTime(csvFile, [], [], true); 

%% 