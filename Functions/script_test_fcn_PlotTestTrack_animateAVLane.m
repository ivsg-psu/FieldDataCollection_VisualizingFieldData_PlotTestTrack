%% script_test_fcn_PlotTestTrack_animateAVLane.m 

% This is a script to exercise the function:
% fcn_PlotTestTrack_animateAVLane.m 
% This function was written on 2024_07_10 by Vaishnavi Wagh vbw5054@psu.edu


%% test 1 save the animation plot as a mov file
csvFile = 'Test Track1.csv'; % Path to your CSV file

baseLat = [];
baseLon = [];
baseAlt = []; 
fig_num = [];
car_width = 6; 
car_length = 14;
left_color = [];
right_color = [];
AV_color = [];
name_of_movfile = 'TestTrack1';
path_to_save_video = 'C:\Users\vaish\Desktop\PSU\Research\VisualizingFieldData\FieldDataCollection_VisualizingFieldData_PlotTestTrack\Data';
[ENU_LeftLaneX, ENU_LeftLaneY, ENU_RightLaneX, ENU_RightLaneY] ...'
    = fcn_PlotTestTrack_animateAVLane(csvFile,car_length,car_width, ...
      baseLat,baseLon,baseAlt,left_color,right_color,AV_color,name_of_movfile,path_to_save_video,fig_num);

assert(length(ENU_LeftLaneX)== 743)
assert(length(ENU_LeftLaneY)== 743)
assert(length(ENU_RightLaneX)== 743)
assert(length(ENU_RightLaneY)== 743)

%% test 2 % 
csvFile = 'Test Track2.csv'; % Path to your CSV file

baseLat = [];
baseLon = [];
baseAlt = []; 
fig_num = [];
car_width = 6; 
car_length = 14;
left_color = [];
right_color = [];
AV_color = [];
name_of_movfile = [];
path_to_save_video = [];
[ENU_LeftLaneX, ENU_LeftLaneY, ENU_RightLaneX, ENU_RightLaneY] ...
    = fcn_PlotTestTrack_animateAVLane(csvFile,car_length,car_width, ...
      baseLat,baseLon,baseAlt,left_color,right_color,AV_color,name_of_movfile,...
      path_to_save_video,fig_num);

assert(length(ENU_LeftLaneX)== 679)
assert(length(ENU_LeftLaneY)== 679)
assert(length(ENU_RightLaneX)== 679)
assert(length(ENU_RightLaneY)== 679)

%% Pittsburg test 10/07/2024
csvFile = 'Pittsburgh_1_(Ended_Early).csv'; % Path to your CSV file

% base station in pittsburg
reference_latitude_pitts = 40.44181017;
reference_longitude_pitts = -79.76090840;
reference_altitude_pitts = 327.428;
% base_station_coordinates = [reference_latitude_pitts, reference_longitude_pitts, reference_altitude_pitts];

baseLat = reference_latitude_pitts;
baseLon = reference_longitude_pitts;
baseAlt =  reference_altitude_pitts;

fig_num = 123;
left_color = [1 0 0];
right_color = [1 1 0];
AV_color = [0 1 1];
name_of_movfile = [];
path_to_save_video = [];
car_width = 6; 
car_length = 14;
[ENU_LeftLaneX, ENU_LeftLaneY, ENU_RightLaneX, ENU_RightLaneY] ...
    = fcn_PlotTestTrack_animateAVLane(csvFile,car_length,car_width, ...
      baseLat,baseLon,baseAlt,left_color,right_color,AV_color,name_of_movfile,...
      path_to_save_video,fig_num);

assert(length(ENU_LeftLaneX)== 270)
assert(length(ENU_LeftLaneY)== 270)
assert(length(ENU_RightLaneX)== 270)
assert(length(ENU_RightLaneY)== 270)

% add assertion here to check the length of the variable oputputs of the
% function and make sur ethat the length is equal to the length of the LLA
% coordinates in the csv file, you can hard code this
%% Pittsburg test 11/07/2024
csvFile = 'Pittsburgh_1_11_07_2024.csv'; % Path to your CSV file

% base station in pittsburg
reference_latitude_pitts = 40.44181017;
reference_longitude_pitts = -79.76090840;
reference_altitude_pitts = 327.428;
% base_station_coordinates = [reference_latitude_pitts, reference_longitude_pitts, reference_altitude_pitts];

baseLat = reference_latitude_pitts;
baseLon = reference_longitude_pitts;
baseAlt =  reference_altitude_pitts;
fig_num = 222;
left_color = [1 0 0];
right_color = [1 1 0];
AV_color = [0 1 1];
car_width = 6; 
car_length = 14;
name_of_movfile = [];
path_to_save_video = [];
[ENU_LeftLaneX, ENU_LeftLaneY, ENU_RightLaneX, ENU_RightLaneY] ...
    = fcn_PlotTestTrack_animateAVLane(csvFile,car_length,car_width, ...
      baseLat,baseLon,baseAlt,left_color,right_color,AV_color,name_of_movfile,...
      path_to_save_video,fig_num);

assert(length(ENU_LeftLaneX)== 440)
assert(length(ENU_LeftLaneY)== 440)
assert(length(ENU_RightLaneX)== 440)
assert(length(ENU_RightLaneY)== 440)

%% Pittsburg test 11/07/2024
csvFile = 'Pittsburgh_2_11_07_2024_after5293.csv'; % Path to your CSV file

% base station in pittsburg
reference_latitude_pitts = 40.44181017;
reference_longitude_pitts = -79.76090840;
reference_altitude_pitts = 327.428;
%base_station_coordinates = [reference_latitude_pitts, reference_longitude_pitts, reference_altitude_pitts];

% car_length = 4.27; % 4.27m is the standard length of a sedan
% car_width = 1.77; % 1.77 m is the standard width of a sedan
baseLat = reference_latitude_pitts;
baseLon = reference_longitude_pitts;
baseAlt = reference_altitude_pitts;
fig_num = 567;
left_color = [1 0 0];
right_color = [1 1 0];
AV_color = [0 1 1];
car_width = 6; 
car_length = 14;
name_of_movfile = [];
path_to_save_video = [];
[ENU_LeftLaneX, ENU_LeftLaneY, ENU_RightLaneX, ENU_RightLaneY] ...
    = fcn_PlotTestTrack_animateAVLane(csvFile,car_length,car_width, ...
      baseLat,baseLon,baseAlt,left_color,right_color,AV_color,name_of_movfile,...
      path_to_save_video,fig_num);

assert(length(ENU_LeftLaneX)== 511)
assert(length(ENU_LeftLaneY)== 511)
assert(length(ENU_RightLaneX)== 511)
assert(length(ENU_RightLaneY)== 511)


rsu_coordinates_lla = [40.43073, -79.87261 0];

reference_latitude = reference_latitude_pitts;
reference_longitude = reference_longitude_pitts;
reference_altitude = reference_altitude_pitts;
gps_object = GPS(reference_latitude, reference_longitude, reference_altitude);
rsu_coordinates_enu = gps_object.WGSLLA2ENU(rsu_coordinates_lla(:,1),rsu_coordinates_lla(:,2), rsu_coordinates_lla(:,3),reference_latitude_pitts, reference_longitude_pitts, reference_altitude_pitts);

radius = 1000;
fcn_PlotTestTrack_rangeRSU_circle(reference_latitude, reference_longitude, reference_altitude, rsu_coordinates_enu, radius)

%% Not examples , to be moved to another repo
% %% PPT Pittsburg
% 
% csvFile = 'Pittsburgh_3_after786.csv'; % Path to your CSV file
% 
% % base station in pittsburg
% reference_latitude_pitts = 40.44181017;
% reference_longitude_pitts = -79.76090840;
% reference_altitude_pitts = 327.428;
% %base_station_coordinates = [reference_latitude_pitts, reference_longitude_pitts, reference_altitude_pitts];
% 
% % car_length = 4.27; % 4.27m is the standard length of a sedan
% % car_width = 1.77; % 1.77 m is the standard width of a sedan
% baseLat = reference_latitude_pitts;
% baseLon = reference_longitude_pitts;
% baseAlt = reference_altitude_pitts;
% fig_num = 567;
% left_color = [1 0 0];
% right_color = [1 1 0];
% AV_color = [0 1 1];
% car_width = 6; 
% car_length = 14;
% name_of_movfile = [];
% path_to_save_video = [];
% [~, ~, ~, ~] ...
%     = fcn_PlotTestTrack_animateAVLane(csvFile,car_length,car_width, ...
%       baseLat,baseLon,baseAlt,left_color,right_color,AV_color,name_of_movfile,...
%       path_to_save_video,fig_num);
% 
% 
% rsu_coordinates_lla = [40.43073, -79.87261 0];
% 
% reference_latitude = reference_latitude_pitts;
% reference_longitude = reference_longitude_pitts;
% reference_altitude = reference_altitude_pitts;
% gps_object = GPS(reference_latitude, reference_longitude, reference_altitude);
% rsu_coordinates_enu = gps_object.WGSLLA2ENU(rsu_coordinates_lla(:,1),rsu_coordinates_lla(:,2), rsu_coordinates_lla(:,3),reference_latitude_pitts, reference_longitude_pitts, reference_altitude_pitts);
% 
% radius = 1000;
% fcn_PlotTestTrack_rangeRSU_circle(reference_latitude, reference_longitude, reference_altitude, rsu_coordinates_enu, radius)
% 
% legend('RSU Location', 'Expected Range of RSU','Centerline of Lane that AV drives through ', 'Left bundary of Lane', 'Right Boundary of Lane', 'AV' );
% 
% 
% 
% %% PPT PA-288
% 
% csvFile = 'Pittsburgh_3_after786.csv'; % Path to your CSV file
% 
% % base station in pittsburg
% reference_latitude_pitts = 40.44181017;
% reference_longitude_pitts = -79.76090840;
% reference_altitude_pitts = 327.428;
% base_station_coordinates = [reference_latitude_pitts, reference_longitude_pitts, reference_altitude_pitts];
% 
% % car_length = 4.27; % 4.27m is the standard length of a sedan
% % car_width = 1.77; % 1.77 m is the standard width of a sedan
% baseLat = reference_latitude_pitts;
% baseLon = reference_longitude_pitts;
% baseAlt = reference_altitude_pitts;
% fig_num = 567;
% left_color = [1 0 0];
% right_color = [1 1 0];
% AV_color = [0 1 1];
% car_width = 6; 
% car_length = 14;
% name_of_movfile = [];
% path_to_save_video = [];
% [ENU_LeftLaneX, ENU_LeftLaneY, ENU_RightLaneX, ENU_RightLaneY] ...
%     = fcn_PlotTestTrack_animateAVLane(csvFile,car_length,car_width, ...
%       baseLat,baseLon,baseAlt,left_color,right_color,AV_color,name_of_movfile,...
%       path_to_save_video,fig_num);
% 
% 
% 
% rsu_coordinates_lla = [40.43073, -79.87261 0];
% 
% reference_latitude = reference_latitude_pitts;
% reference_longitude = reference_longitude_pitts;
% reference_altitude = reference_altitude_pitts;
% gps_object = GPS(reference_latitude, reference_longitude, reference_altitude);
% rsu_coordinates_enu = gps_object.WGSLLA2ENU(rsu_coordinates_lla(:,1),rsu_coordinates_lla(:,2), rsu_coordinates_lla(:,3),reference_latitude_pitts, reference_longitude_pitts, reference_altitude_pitts);
% 
% radius = 1000;
% fcn_PlotTestTrack_rangeRSU_circle(reference_latitude, reference_longitude, reference_altitude, rsu_coordinates_enu, radius)
% 
% legend('RSU Location', 'Expected Range of RSU','Centerline of Lane that AV drives through ', 'Left bundary of Lane', 'Right Boundary of Lane', 'AV' );