%% script_test_fcn_PlotTestTrack_circleCenterFromThreePoints - this is is a script written
% to test the function: fcn_circleCenterFromThreePoints.m.
%
% Revision history:
% 2020_03_20 - started writing the function and script
% 2020_05_22 - added more comments

%% Example 1
x = [0; 0.5; 1; 4; 6; 7; 9; 11; 15];
y = [0; 4;  -1;-3; 2; -1;3;  3; -0.5];
fcn_circleCenterFromThreePoints(x,y,1);
plot(x,y,'r-');
hold on
figure(1); clf;
for i=1:length(x)-2
    fcn_circleCenterFromThreePoints(x(i:i+2),y(i:i+2),1);
    plot(x,y,'g-');
    %pause;
end

%% Example 2
x = [0; 1; 0.5; 5];
y = [0; 4; -1; 6];
fcn_circleCenterFromThreePoints(x,y,1);


%% Example 3, create more circles by left clicking
x = [1; -1;];
y = [1; -1;];
button = 1;
while sum(button) <=1   % read ginputs until a mouse right-button occurs   
    % Get a new point and redo plot
    [x(end+1),y(end+1),button] = ginput(1); %#ok<SAGROW>
    fcn_circleCenterFromThreePoints(x,y,1);     
end

%% testing speed of function

% load inputs
x = [0; 1; 0.5; 5];
y = [0; 4; -1; 6];


% Speed Test Calculation
fig_num=[];
REPS=5; minTimeSlow=Inf;
tic;
%slow mode calculation - code copied from plotVehicleXYZ
for i=1:REPS
tstart=tic;
fcn_circleCenterFromThreePoints(x,y,fig_num);
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
fcn_circleCenterFromThreePoints(x,y,fig_num);
telapsed = toc(tstart);
minTimeFast = min(telapsed,minTimeFast);
end
averageTimeFast = toc/REPS;
%Display Console Comparison
if 1==1
fprintf(1,'\n\nComparison of fcn_circleCenterFromThreePoints without speed setting (slow) and with speed setting (fast):\n');
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
