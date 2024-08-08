%% script_test_fcn_PlotTestTrack_plotSpeedofAV.m
% This is a script to exercise the function: fcn_PlotTestTrack_plotPointsColorMap.m
% This function was written on 2024_07_14 by V. Wagh, vbw5054@psu.edu

% Revision history:
% 2024_07_14
% -- first write of the code


%% Basic Example
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   ____            _        ______                           _
%  |  _ \          (_)      |  ____|                         | |
%  | |_) | __ _ ___ _  ___  | |__  __  ____ _ _ __ ___  _ __ | | ___
%  |  _ < / _` / __| |/ __| |  __| \ \/ / _` | '_ ` _ \| '_ \| |/ _ \
%  | |_) | (_| \__ \ | (__  | |____ >  < (_| | | | | | | |_) | |  __/
%  |____/ \__,_|___/_|\___| |______/_/\_\__,_|_| |_| |_| .__/|_|\___|
%                                                      | |
%                                                      |_|
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=Basic%20Example
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%§

% since the function does not have any output excaept plots, we do not have asserts in
% the examples
%% Basic example 1 - square around the base station
reference_latitude = 40.8637;
reference_longitude = -77.8359;
reference_altitude= 344.189;
base_station_coordinates = [reference_latitude, reference_longitude, reference_altitude];
ENU_coordinates = [[-5 -5 0];[0 0 0]; [2 0 1]; [2 2 2]; [0 2 1]; [5 5 0]];
values = [0 0 .5 1 .5 0];
maxValue = 1;
minValue = 0;
plot_color = 'jet';
LLA_fig_num = 101;
ENU_fig_num = 102;

fcn_PlotTestTrack_plotPointsColorMap(...
        ENU_coordinates, values , base_station_coordinates, maxValue, minValue, plot_color, LLA_fig_num, ENU_fig_num);



%% Basic example 2 - line across the test track.
reference_latitude = 40.8637;
reference_longitude = -77.8359;
reference_altitude= 344.189;
base_station_coordinates = [reference_latitude, reference_longitude, reference_altitude];

ENU_coordinates = [-100:1:100; -100:1:100; -100:1:100]';
values = -100:1:100;
maxValue = 100;
minValue = -100;
plot_color = 'jet';
LLA_fig_num = 201;
ENU_fig_num = 202;

fcn_PlotTestTrack_plotPointsColorMap(...
        ENU_coordinates, values , base_station_coordinates, maxValue, minValue, plot_color, LLA_fig_num, ENU_fig_num);


%% Basic example 3 - Plots a circle around the test track facility in different colors

reference_latitude = 40.8637;
reference_longitude = -77.8359;
reference_altitude= 344.189;
base_station_coordinates = [reference_latitude, reference_longitude, reference_altitude];

 t = 2*pi*(0:.01:1);
 x = 50.*cos(t);
 y = 50.*sin(t);


ENU_coordinates = [x; y; ones(1,length(x))]';
values = 0:.5:50;
maxValue = 40;
minValue = 10;
plot_color = 'jet';
LLA_fig_num = 301;
ENU_fig_num = 302;

fcn_PlotTestTrack_plotPointsColorMap(...
        ENU_coordinates, values , base_station_coordinates, maxValue, minValue, plot_color, LLA_fig_num, ENU_fig_num);


%% Basic example 4 - If the values exceed the max and min value, it will plot them as the max and min value
reference_latitude = 40.8637;
reference_longitude = -77.8359;
reference_altitude= 344.189;
base_station_coordinates = [reference_latitude, reference_longitude, reference_altitude];

ENU_coordinates = [-100:1:100; -100:1:100; -100:1:100]';
values = -100:1:100;
maxValue = 20;
minValue = -20;
plot_color = 'jet';
LLA_fig_num = 401;
ENU_fig_num = 402;

fcn_PlotTestTrack_plotPointsColorMap(...
        ENU_coordinates, values , base_station_coordinates, maxValue, minValue, plot_color, LLA_fig_num, ENU_fig_num);

%% Basic example 5 - Random scatter of points over pittsburgh site


reference_latitute = 40.44181017;
reference_longitude = -79.76090840;
reference_altitude = 327.428;

base_station_coordinates = [reference_latitute, reference_longitude, reference_altitude];
ENU_coordinates = randi(100,100,3)-50;
values = randi(100,100,1);
maxValue = 100;
minValue = 0;
plot_color = 'jet';
LLA_fig_num = 501;
ENU_fig_num = 502;

fcn_PlotTestTrack_plotPointsColorMap(...
        ENU_coordinates, values , base_station_coordinates, maxValue, minValue, plot_color, LLA_fig_num, ENU_fig_num);