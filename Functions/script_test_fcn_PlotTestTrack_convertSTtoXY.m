%% script_test_fcn_PlotTestTrack_convertSTtoXY
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
ST_points2 = fcn_PlotTestTrack_convertXYtoST(Transform_point,v_unit,fig_num);
v_unit2 = [ST_points2(:,1),ST_points2(:,2)];

New_STPoints = fcn_PlotTestTrack_convertXYtoST(ST_points,v_unit2,fig_num);
assert(isequal(New_STPoints(:,1),2))
assert(isequal(New_STPoints(:,2),2))


%% Basic example 4
% very simple points : [2,2]
fig_num = 1004;
figure(fig_num); clf;

v_bar = [1  1]; % 90 degree line segment
v_bar_magnitude = sum((v_bar).^2,2).^0.5;
v_unit = v_bar/v_bar_magnitude;


ENU_points = [2,2; 2 -1];
ST_points = fcn_PlotTestTrack_convertXYtoST(ENU_points,v_unit,fig_num);
assert(length(ST_points)==2);
%% Basic example 5
% very simple points : [2,2]
fig_num = 1005;
figure(fig_num); clf;

v_bar = [2  1]; % 90 degree line segment
v_bar_magnitude = sum((v_bar).^2,2).^0.5;
v_unit = v_bar/v_bar_magnitude;

ENU_points = [2,2; 2 -1];
ST_points = fcn_PlotTestTrack_convertXYtoST(ENU_points,v_unit,fig_num);
assert(length(ST_points)==2);

%% testing speed of function

% load inputs
v_bar = [2  1]; % 90 degree line segment
v_bar_magnitude = sum((v_bar).^2,2).^0.5;
v_unit = v_bar/v_bar_magnitude;

ENU_points = [2,2; 2 -1];
% Speed Test Calculation
fig_num=[];
REPS=5; minTimeSlow=Inf;
tic;
%slow mode calculation - code copied from plotVehicleXYZ
for i=1:REPS
tstart=tic;
ST_points = fcn_PlotTestTrack_convertXYtoST(ENU_points,v_unit,fig_num);
telapsed=toc(tstart);
minTimeSlow=min(telapsed,minTimeSlow);
end
averageTimeSlow=toc/REPS;
%slow mode END
%Fast Mode Calculation
fig_num = -1;
minTimeFast = Inf;
tic;
for i=1:REPS
tstart = tic;
ST_points = fcn_PlotTestTrack_convertXYtoST(ENU_points,v_unit,fig_num);
telapsed = toc(tstart);
minTimeFast = min(telapsed,minTimeFast);
end
averageTimeFast = toc/REPS;
%Display Console Comparison
if 1==1
fprintf(1,'\n\nComparison of fcn_PlotTestTrack_convertXYtoST without speed setting (slow) and with speed setting (fast):\n');
fprintf(1,'N repetitions: %.0d\n',REPS);
fprintf(1,'Slow mode average speed per call (seconds): %.5f\n',averageTimeSlow);
fprintf(1,'Slow mode fastest speed over all calls (seconds): %.5f\n',minTimeSlow);
fprintf(1,'Fast mode average speed per call (seconds): %.5f\n',averageTimeFast);
fprintf(1,'Fast mode fastest speed over all calls (seconds): %.5f\n',minTimeFast);
fprintf(1,'Average ratio of fast mode to slow mode (unitless): %.3f\n',averageTimeSlow/averageTimeFast);
fprintf(1,'Fastest ratio of fast mode to slow mode (unitless): %.3f\n',minTimeSlow/minTimeFast);
end
%Assertion on averageTime NOTE: Due to the variance, there is a chance that
%the assertion will fail.
assert(averageTimeFast<averageTimeSlow);
diff = averageTimeFast*10000 - averageTimeSlow*10000;
