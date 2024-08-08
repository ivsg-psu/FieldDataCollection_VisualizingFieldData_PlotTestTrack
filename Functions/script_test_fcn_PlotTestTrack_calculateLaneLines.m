%% script_test_fcn_PlotTestTrack_calculateLaneLines.m 

% This is a script to exercise the function:
% fcn_PlotTestTrack_calculateLaneLines.m 
% This function was written on 2024_08_05 by Vaishnavi Wagh vbw5054@psu.edu


%% Pittsburg test 11/07/2024
csvFile = 'Pittsburgh_2_11_07_2024.csv'; % Path to your CSV file

% base station in pittsburg
reference_latitude_pitts = 40.44181017;
reference_longitude_pitts = -79.76090840;
reference_altitude_pitts = 327.428;

baseLat = reference_latitude_pitts;
baseLon = reference_longitude_pitts;
baseAlt = reference_altitude_pitts;
laneWidth = [];
      [ENU_LeftLaneX, ENU_LeftLaneY, ENU_RightLaneX, ENU_RightLaneY, ENU_LaneCenterX, ENU_LaneCenterY]...
      = fcn_PlotTestTrack_calculateLaneLines(csvFile,baseLat,baseLon,baseAlt, laneWidth);

assert(length(ENU_LeftLaneX) == 5988)
assert(length(ENU_LeftLaneY) == 5988)
assert(length(ENU_RightLaneX) == 5988)
assert(length(ENU_RightLaneY) == 5988)
assert(length(ENU_LaneCenterX) == 5988)
assert(length(ENU_LaneCenterY) == 5988)

%% Test Track
csvFile = 'Test Track1.csv'; % Path to your CSV file

reference_latitude = [];
reference_longitude = [];
reference_altitude= [];
base_station_coordinates = [reference_latitude, reference_longitude, reference_altitude];

baseLat = reference_latitude;
baseLon = reference_longitude;
baseAlt = reference_altitude;
laneWidth = [];
      [ENU_LeftLaneX, ENU_LeftLaneY, ENU_RightLaneX, ENU_RightLaneY, ENU_LaneCenterX, ENU_LaneCenterY]...
      = fcn_PlotTestTrack_calculateLaneLines(csvFile,baseLat,baseLon,baseAlt, laneWidth);

assert(length(ENU_LeftLaneX) == 754)
assert(length(ENU_LeftLaneY) == 754)
assert(length(ENU_RightLaneX) == 754)
assert(length(ENU_RightLaneY) == 754)
assert(length(ENU_LaneCenterX) == 754)
assert(length(ENU_LaneCenterY) == 754)

%% Basic example 3 - TestTrack 2
csvFile = 'Test Track2.csv'; % Path to your CSV file

reference_latitude = 40.8637;
reference_longitude = -77.8359;
reference_altitude= 344.189;


baseLat = reference_latitude;
baseLon = reference_longitude;
baseAlt = reference_altitude;
laneWidth = 4;
      [ENU_LeftLaneX, ENU_LeftLaneY, ENU_RightLaneX, ENU_RightLaneY, ENU_LaneCenterX, ENU_LaneCenterY]...
      = fcn_PlotTestTrack_calculateLaneLines(csvFile,baseLat,baseLon,baseAlt, laneWidth);
assert(length(ENU_LeftLaneX) == 713)
assert(length(ENU_LeftLaneY) == 713)
assert(length(ENU_RightLaneX) == 713)
assert(length(ENU_RightLaneY) == 713)
assert(length(ENU_LaneCenterX) == 713)
assert(length(ENU_LaneCenterY) == 713)

%% Basic example 4 - TestTrack 1 with different lane width
csvFile = 'Test Track1.csv'; % Path to your CSV file

reference_latitude = 40.8637;
reference_longitude = -77.8359;
reference_altitude= 344.189;



baseLat = reference_latitude;
baseLon = reference_longitude;
baseAlt = reference_altitude;
laneWidth = 6;
      [ENU_LeftLaneX, ENU_LeftLaneY, ENU_RightLaneX, ENU_RightLaneY, ENU_LaneCenterX, ENU_LaneCenterY]...
      = fcn_PlotTestTrack_calculateLaneLines(csvFile,baseLat,baseLon,baseAlt, laneWidth);

assert(length(ENU_LeftLaneX) == 754)
assert(length(ENU_LeftLaneY) == 754)
assert(length(ENU_RightLaneX) == 754)
assert(length(ENU_RightLaneY) == 754)
assert(length(ENU_LaneCenterX) == 754)
assert(length(ENU_LaneCenterY) == 754)

%% Basic example 5 - Speed Plot of TestTrack 2 with different lane width and plot color
csvFilename = 'Test Track2.csv'; % Path to your CSV file

reference_latitude = 40.8637;
reference_longitude = -77.8359;
reference_altitude= 344.189;

baseLat = reference_latitude;
baseLon = reference_longitude;
baseAlt = reference_altitude;
laneWidth = 10;
      [ENU_LeftLaneX, ENU_LeftLaneY, ENU_RightLaneX, ENU_RightLaneY, ENU_LaneCenterX, ENU_LaneCenterY]...
      = fcn_PlotTestTrack_calculateLaneLines(csvFilename,baseLat,baseLon,baseAlt, laneWidth);

assert(length(ENU_LeftLaneX) == 713)
assert(length(ENU_LeftLaneY) == 713)
assert(length(ENU_RightLaneX) == 713)
assert(length(ENU_RightLaneY) == 713)
assert(length(ENU_LaneCenterX) == 713)
assert(length(ENU_LaneCenterY) == 713)
