% script_test_fcn_PlotTestTrack_plotPointsAnywhere.m
% This is a script to exercise the function: fcn_PlotTestTrack_plotPointsAnywhere.m
% This function was written on 2023_07_08 by V. Wagh, vbw5054@psu.edu

% Revision history:
% 2023_07_08
% -- first write of the code

close all;

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

%% Basic example 1 - input  ENU coordinates and plot points in both LLA and ENU (do not specify any opyional inputs)

% FieldMeasurements_OriginalTrackLane_OuterMarkerClusterSolidWhite_1
initial_points = 1.0e+02 * [

-0.681049494040000  -1.444101004200000   0.225959982543000
-0.635840916402000  -1.480360972130000   0.225959615156000
-0.591458020164000  -1.513620272760000   0.225949259327000
-0.526826099435000  -1.557355626820000   0.226468769561000
-0.455230413850000  -1.601954836740000   0.226828212563000
-0.378844266810000  -1.644026018910000   0.227087638509000
-0.302039949257000  -1.680678797970000   0.227207090339000
-0.217481846757000  -1.715315663660000   0.227336509752000
-0.141767378277000  -1.742610853740000   0.227585981357000
-0.096035753167200  -1.756950994360000   0.227825672033000
];

input_coordinates_type = "ENU";
base_station_coordinates = [];
plot_color = [];
MarkerSize = [];
LLA_fig_num = [];
ENU_fig_num = [];

[LLA_coordinates, ENU_coordinates]  = fcn_PlotTestTrack_plotPointsAnywhere(...
    initial_points, input_coordinates_type, base_station_coordinates,...
    plot_color, MarkerSize, LLA_fig_num, ENU_fig_num);

%% Basic example 2 - input LLA coordinates and plot points in both LLA and ENU coordinates (do not specify any opyional inputs)


% FieldMeasurements_OriginalTrackLane_OuterMarkerClusterSolidWhite_1
initial_points = 1.0e+02 *[

0.408623854107731  -0.778367360663248   3.667869999985497
0.408623527614556  -0.778366824471459   3.667869999850096
0.408623228140075  -0.778366298073317   3.667860000095597
0.408622834336925  -0.778365531515185   3.668379999958485
0.408622432755178  -0.778364682365638   3.668739999760671
0.408622053936209  -0.778363776401051   3.669000000069386
0.408621723905615  -0.778362865478155   3.669120000111036
0.408621412026466  -0.778361862594228   3.669249999930642
0.408621166253217  -0.778360964599280   3.669500000276769
0.408621037130544  -0.778360422209667   3.669740000166511
];

input_coordinates_type = "LLA";
base_station_coordinates = [];
plot_color = [];
MarkerSize = [];
LLA_fig_num = [];
ENU_fig_num = [];

[LLA_coordinates, ENU_coordinates]  = fcn_PlotTestTrack_plotPointsAnywhere(...
    initial_points, input_coordinates_type, base_station_coordinates,...
    plot_color, MarkerSize, LLA_fig_num, ENU_fig_num);

%% Basic example 3 - input  LLA coordinates and plot points in both LLA and ENU (specify optional inputs)

% FieldMeasurements_OriginalTrackLane_OuterMarkerClusterSolidWhite_1
initial_points =  [
40.43073, -79.87261 0
]; % RSU location in pittsburg

input_coordinates_type = "LLA";

% base station in pittsburg
reference_latitude_pitts = 40.44181017;
reference_longitude_pitts = -79.76090840;
reference_altitude_pitts = 327.428;
base_station_coordinates = [reference_latitude_pitts, reference_longitude_pitts, reference_altitude_pitts];
plot_color = [1 1 0];
MarkerSize = 20;
LLA_fig_num = 123;
ENU_fig_num = 456;

[LLA_coordinates, ENU_coordinates]  = fcn_PlotTestTrack_plotPointsAnywhere(...
    initial_points, input_coordinates_type, base_station_coordinates,...
    plot_color, MarkerSize, LLA_fig_num, ENU_fig_num);


