%% script_test_fcn_PlotTestTrack_convertXYtoST
% tests fcn_PlotTestTrack_convertXYtoST.m

% Revision history
% 2023_07_10 - vbw5054@psu.edu



% % calculation
% MarkerCluster = fcn_PlotTestTrack_MarkerDataTemplate();
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
ST_points = fcn_PlotTestTrack_convertXYtoST(ENU_points,v_unit,fig_num);
assert(abs(ST_points(:,1)- 2*2^0.5)<1E-10);
assert(isequal(ST_points(:,2),0));
%% Basic example 2
% very simple points : [2,2]

v_bar = [0  1]; % 90 degree line segment
v_bar_magnitude = sum((v_bar).^2,2).^0.5;
v_unit = v_bar/v_bar_magnitude;


ENU_points = [2,2];
fig_num = 1002;
ST_points = fcn_PlotTestTrack_convertXYtoST(ENU_points,v_unit,fig_num);
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
ST_points = fcn_PlotTestTrack_convertXYtoST(ENU_points,v_unit,fig_num);

Transform_point = [1  0]; % 90 degree line segment
v_unit2 = fcn_PlotTestTrack_convertXYtoST(Transform_point,v_unit,fig_num);

points_recalc(:,:) = fcn_PlotTestTrack_convertXYtoST(ST_points,v_unit2,fig_num);
assert(isequal(points_recalc(1,1),2))
assert(isequal(points_recalc(1,2),2))


%% Basic example 4
% very simple points : [2,2]
fig_num = 1004;
figure(fig_num); clf;

v_bar = [1  1]; % 90 degree line segment
v_bar_magnitude = sum((v_bar).^2,2).^0.5;
v_unit = v_bar/v_bar_magnitude;


ENU_points = [2,2; 2 -1];
ST_points = fcn_PlotTestTrack_convertXYtoST(ENU_points,v_unit,fig_num);

assert(length(ST_points) == 2)

%% Basic example 5
% very simple points : [2,2]
fig_num = 1005;
figure(fig_num); clf;

v_bar = [2  1]; % 90 degree line segment
v_bar_magnitude = sum((v_bar).^2,2).^0.5;
v_unit = v_bar/v_bar_magnitude;

ENU_points = [2,2; 2 -1];
ST_points = fcn_PlotTestTrack_convertXYtoST(ENU_points,v_unit,fig_num);

assert(length(ST_points) == 2)




