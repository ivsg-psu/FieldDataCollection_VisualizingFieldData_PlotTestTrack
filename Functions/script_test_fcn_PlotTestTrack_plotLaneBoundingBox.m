%% script_test_fcn_PlotTestTrack_plotLaneBoundingBox.m 

% This is a script to exercise the function:
% fcn_PlotTestTrack_animateAVLane.m 
% This function was written on 2024_07_18 by Joseph Baker jmb9658@psu.edu


%% Pittsburg test 11/07/2024
csvFile = 'Pittsburgh_2_11_07_2024.csv'; % Path to your CSV file

% base station in pittsburg
reference_latitude_pitts = 40.44181017;
reference_longitude_pitts = -79.76090840;
reference_altitude_pitts = 327.428;
base_station_coordinates = [reference_latitude_pitts, reference_longitude_pitts, reference_altitude_pitts];

baseLat = reference_latitude_pitts;
baseLon = reference_longitude_pitts;
baseAlt = reference_altitude_pitts;
laneWidth = [];
left_color = [];
right_color= [];
center_color = [];
lane_color = [];
fig_num = 177;
[LLA_leftLane,LLA_rightLane, LLA_centerOfLane] = fcn_PlotTestTrack_plotLaneBoundingBox(csvFile, ...
                                                baseLat,baseLon, baseAlt,laneWidth, left_color,...
                                                right_color,center_color,lane_color,fig_num);


%% Test Track
csvFile = 'Test Track1.csv'; % Path to your CSV file

% base station in pittsburg
reference_latitude = [];
reference_longitude = [];
reference_altitude= [];
base_station_coordinates = [reference_latitude, reference_longitude, reference_altitude];

baseLat = reference_latitude;
baseLon = reference_longitude;
baseAlt = reference_altitude;
laneWidth = [];
left_color = [];
right_color= [];
center_color = [];
lane_color = [];
fig_num = 200;
[LLA_leftLane,LLA_rightLane, LLA_centerOfLane] = fcn_PlotTestTrack_plotLaneBoundingBox(csvFile, ...
                                                baseLat,baseLon, baseAlt,laneWidth, left_color,...
                                                right_color,center_color,lane_color,fig_num);