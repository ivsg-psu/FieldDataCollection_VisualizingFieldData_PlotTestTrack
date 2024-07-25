%script_test_fcn_PlotTestTrack_convertSTtoXY
% tests fcn_PlotTestTrack_convertSTtoXY.m

% Revision history
% 2023_07_11 - vbw5054@psu.edu



%% Basic example 1
% very simple points : [2,2]

v_bar = [1 1]; % 45 degree line segment
v_bar_magnitude = sum((v_bar).^2,2).^0.5;
v_unit = v_bar/v_bar_magnitude;

ENU_points = [2,2];
fig_num = 1001;
ST_points = fcn_PlotTestTrack_convertXYtoST(ENU_points,v_unit,fig_num);
assert(length(ST_points)==2)
% assert(abs(station- 2*2^0.5)<1E-10);
% assert(isequal(transverse,0));
% 
% ST_points = [station, transverse];
% ENU_points = fcn_PlotTestTrack_convertSTtoXY(ST_points,v_unit,fig_num);


%% All other examples need to be updated because they use the old version of
% the function that does not exist anymore !!!!!!!!!!

%% Basic example 2
% very simple points : [2,2]

v_bar = [0  1]; % 90 degree line segment
v_bar_magnitude = sum((v_bar).^2,2).^0.5;
v_unit = v_bar/v_bar_magnitude;


ENU_points = [2,2];
fig_num = 1002;
[station, transverse] = fcn_PlotTestTrack_getXYtoStationTransverse(ENU_points,v_unit,fig_num);
assert(abs(station - 2)<1E-10);
assert(abs(transverse + 2)<1E-10);w

%% Basic example 3
% very simple points : [2,2]
fig_num = 1003;
figure(fig_num); clf;

v_bar = [1  2]; % 90 degree line segment
v_bar_magnitude = sum((v_bar).^2,2).^0.5;
v_unit = v_bar/v_bar_magnitude;


ENU_points = [2,2];
[station, transverse] = fcn_PlotTestTrack_getXYtoStationTransverse(ENU_points,v_unit,fig_num);

Transform_point = [1  0]; % 90 degree line segment
[station2, transverse2] = fcn_PlotTestTrack_getXYtoStationTransverse(Transform_point,v_unit,fig_num);
v_unit2 = [station2,transverse2];

ST_points = [station, transverse];
[X_recalc, Y_recalc] = fcn_PlotTestTrack_getXYtoStationTransverse(ST_points,v_unit2,fig_num);
assert(isequal(X_recalc,2))
assert(isequal(Y_recalc,2))


%% Basic example 4
% very simple points : [2,2]
fig_num = 1004;
figure(fig_num); clf;

v_bar = [1  1]; % 90 degree line segment
v_bar_magnitude = sum((v_bar).^2,2).^0.5;
v_unit = v_bar/v_bar_magnitude;


ENU_points = [2,2; 2 -1];
[station, transverse] = fcn_PlotTestTrack_getXYtoStationTransverse(ENU_points,v_unit,fig_num);

%% Basic example 5
% very simple points : [2,2]
fig_num = 1005;
figure(fig_num); clf;

v_bar = [2  1]; % 90 degree line segment
v_bar_magnitude = sum((v_bar).^2,2).^0.5;
v_unit = v_bar/v_bar_magnitude;

ENU_points = [2,2; 2 -1];
[station, transverse] = fcn_PlotTestTrack_getXYtoStationTransverse(ENU_points,v_unit,fig_num);

%% Basic example 6 
% very simple points : [2,2]
ENU_points = [2 2;4 4];
fig_num = 1002;
theta = 5;
R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
v_unit = ENU_points*R;
[station, transverse] = fcn_PlotTestTrack_getXYtoStationTransverse(ENU_points,v_unit,fig_num);


