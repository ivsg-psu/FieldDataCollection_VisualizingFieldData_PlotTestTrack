%% script_test_fcn_PlotTestTrack_plotRectangle.m

% This is a script to exercise the function:
% fcn_PlotTestTrack_plotRectangle.m
% This function was written on 2024_08_06 by Vaishnavi Wagh vbw5054@psu.edu


%% Basic Example 1: Test Track LLA coordinates

reference_latitude = 40.86368573;
reference_longitude = -77.83592832;
reference_altitude = 344.189;

LLA_centerPoint = [40.8631116, -77.8350440,	335.9];
LLA_second_point = [40.8633962	-77.8351958	335.5
];

car_length = [];
car_width = [];
AV_color = [];
flag_LLA = [];
flag_ENU = [];
fig_num = [];

[enuCorners, LLACorners] = fcn_PlotTestTrack_plotRectangle(...
    reference_latitude, reference_longitude, reference_altitude, LLA_centerPoint,...
    LLA_second_point,car_length,car_width,AV_color,flag_LLA,flag_ENU,fig_num);


assert(length(LLACorners)==4);
assert(length(enuCorners)==4);
%% Basic Example 2: Pittsburg Track LLA coordinates

reference_latitude_pitts = 40.44181017;
reference_longitude_pitts = -79.76090840;
reference_altitude_pitts = 327.428;
LLA_centerPoint = [40.4420347	-79.7608974	328.5];
LLA_second_point = [40.4420336	-79.7608970	328.4

];

car_length = 20;
car_width = 10;
AV_color = [1 0 1];
flag_LLA = [];
flag_ENU = [];
fig_num = 134;

[enuCorners, LLACorners] = fcn_PlotTestTrack_plotRectangle(...
    reference_latitude_pitts, reference_longitude_pitts, reference_altitude_pitts, LLA_centerPoint,...
    LLA_second_point,car_length,car_width,AV_color,flag_LLA,flag_ENU,fig_num);

assert(length(LLACorners)==4);
assert(length(enuCorners)==4);

%% Basic Example 3: PA_288 Track LLA coordinates

reference_latitude_pitts = 40.8471670113384;
reference_longitude_pitts = -80.26182223666619;
reference_altitude_pitts = 327.428;
LLA_centerPoint = [40.8470251	-80.2630792	268.5];
LLA_second_point = [40.8470697	-80.2627195	268.7];

car_length = 30;
car_width = 10;
AV_color = [1 0 1];
flag_LLA = 0;
flag_ENU = 1;
fig_num = 768;

[enuCorners, LLACorners] = fcn_PlotTestTrack_plotRectangle(...
    reference_latitude_pitts, reference_longitude_pitts, reference_altitude_pitts, LLA_centerPoint,...
    LLA_second_point,car_length,car_width,AV_color,flag_LLA,flag_ENU,fig_num);

assert(length(LLACorners)==4);
assert(length(enuCorners)==4);