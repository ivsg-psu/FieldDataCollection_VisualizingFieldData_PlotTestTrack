%script_test_fcn_LoadWZ_convertXYtoST
% tests fcn_LoadWZ_convertXYtoST.m

% Revision history
% 2023_07_10 - vbw5054@psu.edu

%% Set up the workspace
close all
clc

% % calculation
% MarkerCluster = fcn_LoadWZ_MarkerDataTemplate();
% % getting the unit orthogonal vector
% % use the unit orthogonal to get the to get the distance between the
% % current lane marker and the existing lane marker
% rotation_matrix = [0 -1; 1 0];
% % calculating unit vector -
% % it is ALWAYS MarkerCluster 1, lane 2 -only use the first
% % 2 points, and only XY data (columns 1 and 2)
% % using the markercluster1, center lane as the reference
% % (as v_orthogonal for other markercluster was found to be very similar)
% white_reference_line = MarkerCluster{1}.MarkerCluster_ENU{2}(1:2,1:2);
% v_bar = diff(white_reference_line); % Take the differences between points


%% Basic example 1
% very simple points : [2,2]

v_bar = [1 1]; % 45 degree line segment
v_bar_magnitude = sum((v_bar).^2,2).^0.5;
v_unit = v_bar/v_bar_magnitude;


ENU_points = [2,2];
fig_num = 1001;
ST_points = fcn_LoadWZ_convertXYtoST(ENU_points,v_unit,fig_num);
assert(abs(ST_points(:,1)- 2*2^0.5)<1E-10);
assert(isequal(ST_points(:,2),0));
%% Basic example 2
% very simple points : [2,2]

v_bar = [0  1]; % 90 degree line segment
v_bar_magnitude = sum((v_bar).^2,2).^0.5;
v_unit = v_bar/v_bar_magnitude;


ENU_points = [2,2];
fig_num = 1002;
[ST_points(:,1), ST_points(:,2)] = fcn_LoadWZ_convertXYtoST(ENU_points,v_unit,fig_num);
assert(abs(ST_points(:,1) - 2)<1E-10);
assert(abs(ST_points(:,2) + 2)<1E-10);

%% Basic example 3
% very simple points : [2,2]
fig_num = 1003;
figure(fig_num); clf;

v_bar = [1  2]; % 90 degree line segment
v_bar_magnitude = sum((v_bar).^2,2).^0.5;
v_unit = v_bar/v_bar_magnitude;


ENU_points = [2,2];
ST_points = fcn_LoadWZ_convertXYtoST(ENU_points,v_unit,fig_num);

Transform_point = [1  0]; % 90 degree line segment
v_unit2 = fcn_LoadWZ_convertXYtoST(Transform_point,v_unit,fig_num);

[X_recalc, Y_recalc] = fcn_LoadWZ_convertXYtoST(ST_points,v_unit2,fig_num);
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
ST_points = fcn_LoadWZ_convertXYtoST(ENU_points,v_unit,fig_num);

%% Basic example 5
% very simple points : [2,2]
fig_num = 1005;
figure(fig_num); clf;

v_bar = [2  1]; % 90 degree line segment
v_bar_magnitude = sum((v_bar).^2,2).^0.5;
v_unit = v_bar/v_bar_magnitude;

ENU_points = [2,2; 2 -1];
ST_points = fcn_LoadWZ_convertXYtoST(ENU_points,v_unit,fig_num);

%% Basic example 6 
% very simple points : [2,2]
ENU_points = [2 2;4 4];
fig_num = 1002;
theta = 5;
R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
v_unit = ENU_points*R;
ST_points = fcn_LoadWZ_convertXYtoST(ENU_points,v_unit,fig_num);


