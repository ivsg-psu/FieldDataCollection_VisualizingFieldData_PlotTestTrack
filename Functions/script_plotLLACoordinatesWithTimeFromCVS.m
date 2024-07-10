% script_plotLLACoordinatesWithTimeFromCVS.m
% This is a script to exercise the function: plotLLACoordinatesWithTimeFromCVS.m
% This function was written on 2024_07_02 by R. Ross, rkr5407@psu.edu


% Revision history:
% 
%% Example 1
% Only CVS file input is required to run, other inputs are defaulted 
csvFile = 'Test Track1.csv'; % Path to your CSV file
plotLLACoordinatesWithTimeFromCSV(csvFile);
%% Example 2
plotLLACoordinatesWithTimeFromCSV('Test Track1.csv', [], [], true);  % With trajectory line
%% Example 3
plotLLACoordinatesWithTimeFromCSV('Test Track1.csv', [], [], false); % Without trajectory line
