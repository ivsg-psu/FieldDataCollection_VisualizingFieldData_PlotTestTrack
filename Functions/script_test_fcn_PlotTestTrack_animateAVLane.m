%% script_test_fcn_PlotTestTrack_animateAVLane.m 

% This is a script to exercise the function:
% fcn_PlotTestTrack_animateAVLane.m 
% This function was written on 2024_07_10 by Vaishnavi Wagh vbw5054@psu.edu


%% test 1
csvFile = 'Test Track1.csv'; % Path to your CSV file

baseLat = [];
baseLon = [];
fig_num = [];
[ENU_LeftLaneX, ENU_LeftLaneY, ENU_RightLaneX, ENU_RightLaneY] = fcn_PlotTestTrack_animateAVLane(csvFile, baseLat,baseLon, fig_num);

%%
