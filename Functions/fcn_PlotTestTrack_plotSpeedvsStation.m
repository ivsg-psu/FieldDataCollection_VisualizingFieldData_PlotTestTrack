function [AVSpeed, StationCoordinates] = fcn_PlotTestTrack_plotSpeedvsStation(csvFile, varargin)
%% fcn_PlotTestTrack_animateAVLane
% create a plot of speed vs Station coordinates by taking the LLA and time
% from the csv file as an input
%
% FORMAT:
%
%       [AVSpeed, StationCoordinates] = fcn_PlotTestTrack_plotSpeedvsStation(csvFile, (baseLat,baseLon, baseAlt, plot_color, fig_num))
%
% INPUTS:
%
%      (MANDATORY INPUTS)
%       csvFile: The name of the .csv file that contains the latitude,
%                    longitude, altitude, and time of the location
%                    at which the OBU sent out the BSM message to the RSU
%                    that was in range. The code assumes latitude in first
%                    column, longitude in second, altitude in third, and 
%                    time in fourth. 
%
%       (OPTIONAL INPUTS)
%      baseLat: Latitude of the base location. Default is 40.8637 for the
%      base station at the Penn State LTI test track
%
%      baseLon: Longitude of the base location. Default is -77.8359 for the
%      base station at the Penn State LTI test track
%
%      baseAlt: Altitude of the base station. Deafault is 344.189 for the
%      base station at the Penn State LTI test track
%
%      plot_color: color of the plot 
%
%      fig_num: figure number
%
% OUTPUTS:
%
%       AVSpeed: An NX1 matrix of the speed of the AV at every location
%
%       StationCoordinates: An NX1 matrix of the Station Coordinates that
%       correspond to the AV speed

% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
%       script_test_fcn_PlotTestTrack_plotSpeedvsStation.m
%
% This function was written on 2024_07_15 by Vaishnavi Wagh
% --Start to write the function 
% Questions or comments? vbw5054@psu.edu

% Revision History
% 2024_07_15 V. Wagh 
% -- started writing function from fcn_PlotTestTrack_animateAVLane
% by V. Wagh

flag_do_debug = 0; % Flag to show the results for debugging
flag_do_plots = 0; % % Flag to plot the final results
flag_check_inputs = 1; % Flag to perform input checking

if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
    debug_fig_num = 34838;
else
    debug_fig_num = [];
end
%% check input arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____                   _
%  |_   _|                 | |
%    | |  _ __  _ __  _   _| |_ ___
%    | | | '_ \| '_ \| | | | __/ __|
%   _| |_| | | | |_) | |_| | |_\__ \
%  |_____|_| |_| .__/ \__,_|\__|___/
%              | |
%              |_|
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if flag_check_inputs == 1
    % Are there the right number of inputs?
    narginchk(1,6);

end


% Default base location coordinates (PSU test track)
baseLat = 40.8637; % default
if 2 <= nargin
    temp = varargin{1};
    if ~isempty(temp)
        baseLat = temp;
    end
end

baseLon = -77.8359;% default
% Default base location coordinates (PSU test track)
if 3 <= nargin
    temp = varargin{2};
    if ~isempty(temp)
        baseLon = temp;
    end
end

baseAlt = 344.189; %default
% Default base location coordinates (PSU test track)
if 4 <= nargin
    temp = varargin{3};
    if ~isempty(temp)
        baseLon = temp;
    end
end

% Does user want to specify plot_color?
plot_color = [1 0 1]; % Default
if 5 <= nargin 
    temp = varargin{4};
    if ~isempty(temp) 
        plot_color = temp; 
    end
end

% fig_num
fig_num = 100; % Default
if 6 <= nargin
    temp = varargin{end};
    if ~isempty(temp)
        fig_num = temp;
    end
end

% Setup figures if there is debugging
if flag_do_debug
    fig_debug = 9999;
else
    fig_debug = []; %#ok<*NASGU>
end
%% Write main code for plotting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _
%  |  \/  |     (_)
%  | \  / | __ _ _ _ __
%  | |\/| |/ _` | | '_ \
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load GPS Class library for conversions
gps_object = GPS(baseLat,baseLon,baseAlt); % Load the GPS class

% read the csv file
% Read csv file containing LLA coordinates and time of the OBU when the BSM
% message was sent out to the RSU
% csvfile_FID = fopen(csvFile);
% formatSpec = '%d %d %d %s'; 
% [LLA,count] = fscanf(csvfile_FID,['%d' 'lat long elev timediff']);
% fclose(csvfile_FID);

LLAandTime = readtable(csvFile,"ReadRowNames",false); %#ok<*CSVRD>

% assigning columns
LatitudeofAV = LLAandTime(:,1);
LatitudeofAV = LatitudeofAV{:,:};

LongitudeofAV = LLAandTime(:,2);
LongitudeofAV = LongitudeofAV{:,:};

AltitudeofAV = LLAandTime(:,3);
AltitudeofAV = AltitudeofAV{:,:};

TimeDiff= LLAandTime(:,4);
TimeDiff = TimeDiff{:,:};

LocationandTimeOBU = [LatitudeofAV/10000000 LongitudeofAV/10000000 AltitudeofAV/10000000];

ENU_coordinates_noUnique = gps_object.WGSLLA2ENU(LocationandTimeOBU(:,1),LocationandTimeOBU(:,2),LocationandTimeOBU(:,3),baseLat,baseLon,baseAlt);

time_in_sec = seconds(TimeDiff);
time_in_sec = time_in_sec - time_in_sec(1,:);
apparent_delta_t = 0.1;
time_index = round(time_in_sec/apparent_delta_t);
inferred_time_index = (1:length(time_index))' - 1;
apparent_delay = inferred_time_index - 10*time_in_sec;
TimeandENU = [inferred_time_index time_index time_in_sec apparent_delay (ENU_coordinates_noUnique - ENU_coordinates_noUnique(1,:))];
delta_station = [0; sum(diff(ENU_coordinates_noUnique).^2,2).^0.5];
speed = [0; delta_station]/apparent_delta_t;

figure(557);
plot(speed(3000:end));


figure(2727)
plot(inferred_time_index(1:3000), apparent_delay(1:3000),'k.');

% Find unique rows based on the first two columns
[~, uniqueIdx] = unique(LocationandTimeOBU(:, 1:2), 'rows', 'stable');


% Extract the unique rows from the original matrix
uniqueRows = LocationandTimeOBU(uniqueIdx, :);

% Extract latitude, longitude, elevation, and time values, here we get time
% as NaNs
lat = uniqueRows(:,1)/10000000;
lon = uniqueRows(:,2)/10000000;
elv = uniqueRows(:,3)/10000000;
time = TimeDiff(uniqueIdx, :);

% convert LLA to ENU
ENU_coordinates = gps_object.WGSLLA2ENU(lat,lon,elv,baseLat,baseLon,baseAlt);

% get the speed based on the X,Y and timeinterval
% get speed
NumLength = length(ENU_coordinates)-1;
for ith_coordinate = 1:NumLength
    point1 = ENU_coordinates(ith_coordinate,1:2);
    point2 = ENU_coordinates(ith_coordinate+1,1:2);
    timeatpt1 = time(ith_coordinate,:);
    timeatpt2 = time(ith_coordinate+1,:);
    SpeedofAV_mps(ith_coordinate) = fcn_INTERNAL_calcSpeed(point1, point2, timeatpt1, timeatpt2);
end

% correct orientation of matrix
SpeedofAV_mps = SpeedofAV_mps';

% Find the indices of rows with any element above 50
rowsToDelete = any(SpeedofAV_mps > 25, 2); % the mph should not go beyond 50

% Delete those rows from the matrix
SpeedofAV_mps(rowsToDelete, :) = [];

SpeedofAV_mps_cutshort = SpeedofAV_mps(10:end-10,:);
% Find the indices of rows with any element equal to zero
rowsToDeleteforzeros = any(SpeedofAV_mps_cutshort < 0.45, 2); % the mph should not go to zero once the vehicle has started

% Delete those rows from the matrix
SpeedofAV_mps_cutshort(rowsToDeleteforzeros, :) = [];

final_SpeedofAV_mps = [SpeedofAV_mps(1:10); SpeedofAV_mps_cutshort; SpeedofAV_mps(end-10:end)];

% add a last point to make the arrays of equal sizes
final_SpeedofAV_mps(end+1) = final_SpeedofAV_mps(end);

% convert speed from m/s tp mph 
AVSpeed = final_SpeedofAV_mps*2.23694;

% calculate station coordiantes
NumLength = length(ENU_coordinates)-1;
StationCoordinates  = zeros(NumLength+1,1);
for ith_coordinate = 1:NumLength
    point1 = ENU_coordinates(ith_coordinate,1:2);
    point2 = ENU_coordinates(ith_coordinate+1,1:2);
    distance = norm(point2 - point1);
    StationCoordinates(ith_coordinate+1,1) = StationCoordinates(ith_coordinate,1) +  distance;
end

StationCoordinates(rowsToDelete, :) = [];

StationCoordinates_cutshort = StationCoordinates(10:end-10);
StationCoordinates_cutshort(rowsToDeleteforzeros, :) = [];
final_StationCoordinates = [StationCoordinates(1:10); StationCoordinates_cutshort; StationCoordinates(end-10:end)];
%% Any debugging?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____       _
%  |  __ \     | |
%  | |  | | ___| |__  _   _  __ _
%  | |  | |/ _ \ '_ \| | | |/ _` |
%  | |__| |  __/ |_) | |_| | (_| |
%  |_____/ \___|_.__/ \__,_|\__, |
%                            __/ |
%                           |___/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TO DO: chnage this to an internal function, call the internal fumction in
% the debug area

figure (fig_num); % Create a figure, % TO DO: optional input fig_num
clf;
plot(final_StationCoordinates(:,1),AVSpeed, "Color",plot_color,"Marker",".");
title('Station vs Speed plot');
xlabel('Station Coordinates in m');
ylabel('Speed in mph');

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end

end

%% Functions follow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   ______                _   _
%  |  ____|              | | (_)
%  | |__ _   _ _ __   ___| |_ _  ___  _ __  ___
%  |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
%  | |  | |_| | | | | (__| |_| | (_) | | | \__ \
%  |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
%
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%§
%% fcn_INTERNAL_calcPerpendicularPoint
function [X_new, Y_new] = fcn_INTERNAL_calcPerpendicularPoint(X1, Y1, X2, Y2, distance)

% Input points
point_start = [X1, Y1];
point_end = [X2, Y2];

% Compute the vector from point_start to point_end
vector_to_calculate = point_end - point_start;
magnitude_vector_to_calculate = sum(vector_to_calculate.^2,2).^0.5;

% Compute the unit vector
unit_vector = vector_to_calculate./magnitude_vector_to_calculate;

 if ~isnan(unit_vector)

    % Find a vector perpendicular to the unit vector
    % Rotating 90 degrees clockwise: [x; y] -> [y; -x]
    perpendicular_vector = [unit_vector(2), -unit_vector(1)];

    % Scale the perpendicular vector by the desired distance
    scaled_perpendicular_vector = perpendicular_vector * distance;

    % Compute the new point by adding the scaled perpendicular vector to point_start
    new_point = point_start + scaled_perpendicular_vector;

    % Output the coordinates of the new point
    X_new = new_point(1);
    Y_new = new_point(2);
 else
    X_new = NaN;
    Y_new = NaN;
 end

end

%% fcn_INTERNAL_parseTimeStrings
function [matrixBeforeColon, matrixBetweenColons, remainingStrings] = fcn_INTERNAL_parseTimeStrings(timeStrings)
    % Initialize matrices and cell array
    matrixBeforeColon = [];
    matrixBetweenColons = [];
    remainingStrings = {};

    for i = 1:length(timeStrings)
        str = timeStrings{i};
        colons = strfind(str, ':');
        
        % Ensure there are at least two colons in the string
        if length(colons) >= 2
            % Extract numbers before the first colon
            numBefore = str2double(str(1:colons(1)-1));
            matrixBeforeColon = [matrixBeforeColon; numBefore];
            
            % Extract numbers between the first and second colons
            numBetween = str2double(str(colons(1)+1:colons(2)-1));
            matrixBetweenColons = [matrixBetweenColons; numBetween];
            
            % Extract the remaining string after the second colon
            remainingStr = str(colons(2)+1:end);
            remainingStrings{end+1} = remainingStr;
        else
            % Handle case where there are less than two colons
            disp(['Invalid format: ', str]);
        end
    end
end

%% fcn_INTERNAL_calcSpeed
function speed = fcn_INTERNAL_calcSpeed(point1, point2, timeatpt1, timeatpt2)

    % Calculate the distance between the two points
    distance = norm(point2 - point1);
    
    timeInterval = timeatpt2-timeatpt1;

    % Calculate the speed
    time_interval_sec = seconds(timeInterval);
    speed = distance / time_interval_sec;
end