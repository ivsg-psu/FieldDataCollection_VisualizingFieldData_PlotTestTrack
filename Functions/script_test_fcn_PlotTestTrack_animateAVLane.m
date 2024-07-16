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

%% Pittsburg test 10/07/2024
csvFile = 'Pittsburgh_1_(Ended_Early).csv'; % Path to your CSV file

% base station in pittsburg
reference_latitude_pitts = 40.44181017;
reference_longitude_pitts = -79.76090840;
reference_altitude_pitts = 327.428;
base_station_coordinates = [reference_latitude_pitts, reference_longitude_pitts, reference_altitude_pitts];

baseLat = reference_latitude_pitts;
baseLon = reference_longitude_pitts;
fig_num = 123;
[ENU_LeftLaneX, ENU_LeftLaneY, ENU_RightLaneX, ENU_RightLaneY] = fcn_PlotTestTrack_animateAVLane(csvFile, baseLat,baseLon, fig_num);

%% Pittsburg test 11/07/2024
csvFile = 'Pittsburgh_1_11_07_2024.csv'; % Path to your CSV file

% base station in pittsburg
reference_latitude_pitts = 40.44181017;
reference_longitude_pitts = -79.76090840;
reference_altitude_pitts = 327.428;
base_station_coordinates = [reference_latitude_pitts, reference_longitude_pitts, reference_altitude_pitts];

baseLat = reference_latitude_pitts;
baseLon = reference_longitude_pitts;
fig_num = 123;
[ENU_LeftLaneX, ENU_LeftLaneY, ENU_RightLaneX, ENU_RightLaneY] = fcn_PlotTestTrack_animateAVLane(csvFile, baseLat,baseLon, fig_num);

%% Pittsburg test 11/07/2024
csvFile = 'Pittsburgh_2_11_07_2024.csv'; % Path to your CSV file

% base station in pittsburg
reference_latitude_pitts = 40.44181017;
reference_longitude_pitts = -79.76090840;
reference_altitude_pitts = 327.428;
base_station_coordinates = [reference_latitude_pitts, reference_longitude_pitts, reference_altitude_pitts];

baseLat = reference_latitude_pitts;
baseLon = reference_longitude_pitts;
fig_num = 123;
[ENU_LeftLaneX, ENU_LeftLaneY, ENU_RightLaneX, ENU_RightLaneY] = fcn_PlotTestTrack_animateAVLane(csvFile, baseLat,baseLon, fig_num);


rsu_coordinates_lla = [40.43073, -79.87261 0];

gps_object = GPS(reference_latitude, reference_longitude, reference_altitude);
rsu_coordinates_enu = gps_object.WGSLLA2ENU(rsu_coordinates_lla(:,1),rsu_coordinates_lla(:,2), rsu_coordinates_lla(:,3),reference_latitude, reference_longitude, reference_altitude);

radius = 1000;
fcn_PlotTestTrack_rangeRSU_circle(reference_latitude, reference_longitude, reference_altitude, rsu_coordinates_enu, radius)