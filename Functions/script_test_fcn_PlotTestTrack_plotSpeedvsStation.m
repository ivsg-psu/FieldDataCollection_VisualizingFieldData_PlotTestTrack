% script_test_fcn_PlotTestTrack_plotSpeedvsStation.m
% This is a script to exercise the function: fcn_PlotTestTrack_plotSpeedvsStation.m
% This function was written on 2024_07_15 by V. Wagh, vbw5054@psu.edu

% Revision history:
% 2024_07_15
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

%% Basic example 1 - RSU range test at Pittsburg with time

csvFile = 'site2_1.csv';

baseLat = 40.44181017;
baseLon = -79.76090840;
baseAlt = 327.428;
plot_color = [];
fig_num = [];

[AVSpeed, StationCoordinates] = fcn_PlotTestTrack_plotSpeedvsStation(csvFile, baseLat,baseLon, baseAlt, plot_color, fig_num);

assert(length(AVSpeed) == 22)
assert(length(StationCoordinates) == 763)

% add median filter to get rid of spikes
% plot NaNs for station coordinates > 5m apart
%% Basic example 2 - RSU range test at Pittsburg with time

csvFile = 'Pittsburgh_3.csv';

baseLat = 40.44181017;
baseLon = -79.76090840;
baseAlt = 327.428;
plot_color = [];
fig_num = [];

[AVSpeed, StationCoordinates] = fcn_PlotTestTrack_plotSpeedvsStation(csvFile, baseLat,baseLon, baseAlt, plot_color, fig_num);



%% Basic example 3 - RSU range test at PA_288 with time

csvFile = 'PA_288_2.csv';

baseLat = 40.44181017;
baseLon = -79.76090840;
baseAlt = 327.428;
plot_color = [];
fig_num = [];

[AVSpeed, StationCoordinates] = fcn_PlotTestTrack_plotSpeedvsStation(csvFile, baseLat,baseLon, baseAlt, plot_color, fig_num);

