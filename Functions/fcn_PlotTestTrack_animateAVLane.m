function [ENU_LeftLaneX, ENU_LeftLaneY, ENU_RightLaneX, ENU_RightLaneY] = fcn_PlotTestTrack_animateAVLane(csvFile, varargin)
%% fcn_PlotTestTrack_animateAVLane
% create animated plot of latitude, longitude coordinates with respect
% to time and a boundary line after displacement, also get the XY
% coordinates of the boundaries
%
% FORMAT:
%
%       [LeftLaneX, LeftLaneY, RightLaneX, RightLaneY] = fcn_PlotTestTrack_animateAVLane(csvFile, (baseLat,baseLon, fig_num))
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
%      baseLat: Latitude of the base location. Default is 40.8637.
%
%      baseLon: Longitude of the base location. Default is -77.8359.
%
%      left_color: color of the left lane boundary
%
%      right_color: color of the right lane boundary
%
%      AV_color: color of the AV
%
%      fig_num: figure number
%
% OUTPUTS:
%
%      [LeftLaneX, LeftLaneY, RightLaneX, RightLaneY]: XY coordinates of
%      the left and right lane boundaries
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
%       script_test_fcn_PlotTestTrack_animateAVLane.m
%
% This function was written on 2024_07_10 by Vaishnavi Wagh
% --Start to write the function 
% Questions or comments? vbw5054@psu.edu

% Revision History
% 2024_07_10 V. Wagh 
% -- started writing function from fcn_PlotTestTrack_LineWithBoundaryWithTime
% by Jiabao Zhao, jpz5469@psu.edu

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

% fig_num
fig_num = 100; % Default
if 4 <= nargin
    temp = varargin{3};
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
% default altitude
baseAlt = 344.189; % TO DO: make this also an optional input
gps_object = GPS(baseLat,baseLon,baseAlt); % Load the GPS class

% Read csv file
LLAandTime = readmatrix(csvFile); % Read the CSV file 

% Check CSV file
   if size(LLAandTime, 2) ~= 4
    error('The CSV file must contain exactly four columns: latitude, longitude, elevation, and time.'); % Check if the input matrix has four columns
   end

% Extract latitude, longitude, elevation, and time values, here we get time
% as NaNs
lat = LLAandTime(:, 1)/10000000;
lon = LLAandTime(:, 2)/10000000;
elv = LLAandTime(:, 3);
time = LLAandTime(:, 4);

% convert LLA to ENU
ENU_coordinates = gps_object.WGSLLA2ENU(lat,lon,elv,baseLat,baseLon,baseAlt);


% last point
Num_length = length(ENU_coordinates)-1;

% get the new lane boundary points for left lane
for ith_coordinate = 1:Num_length

    X1 = ENU_coordinates(ith_coordinate,1);
    Y1 = ENU_coordinates(ith_coordinate,2);
    X2 = ENU_coordinates(ith_coordinate+1,1);
    Y2 = ENU_coordinates(ith_coordinate+1,2);
    distance = -1.8288; % TO DO: have this as an optional input
    [LeftLaneX(ith_coordinate), LeftLaneY(ith_coordinate)] = fcn_INTERNAL_calcPerpendicularPoint(X1, Y1, X2, Y2, distance);
end

% get the new lane boundary points for right lane
for ith_coordinate = 1:Num_length

    X1 = ENU_coordinates(ith_coordinate,1);
    Y1 = ENU_coordinates(ith_coordinate,2);
    X2 = ENU_coordinates(ith_coordinate+1,1);
    Y2 = ENU_coordinates(ith_coordinate+1,2);
    distance = 1.8288; % TO DO: have this as an optional input
    [RightLaneX(ith_coordinate), RightLaneY(ith_coordinate)] = fcn_INTERNAL_calcPerpendicularPoint(X1, Y1, X2, Y2, distance);
end

% correct orientation
RightLane = [RightLaneX' RightLaneY' (RightLaneX*0)'];
LeftLane = [LeftLaneX' LeftLaneY' (LeftLaneX*0)'];

% convert LLA to ENU
LLA_LeftLane = gps_object.ENU2WGSLLA(LeftLane');
LLA_RightLane = gps_object.ENU2WGSLLA(RightLane');

ENU_LeftLaneX = LeftLaneX';
ENU_LeftLaneY = LeftLaneY';
ENU_RightLaneX = RightLaneX';
ENU_RightLaneY = RightLaneY';
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

figure (1); % Create a figure, % TO DO: optional input fig_num
clf;
% Plot the base station with a green star. This sets up the figure for
% the first time, including the zoom into the test track area.
h_geoplot = geoplot(baseLat, baseLon, '*','Color',[0 1 0],'Linewidth',3,'Markersize',10);
h_parent = get(h_geoplot,'Parent');
set(h_parent,'ZoomLevel',16.375);

try
    geobasemap satellite
catch
    geobasemap openstreetmap
end
geotickformat -dd;
hold on;

% plot original data i.e centerline
geoplot(lat, lon,'m-',"LineWidth",3);
geoplot(LLA_LeftLane(:,1), LLA_LeftLane(:,2), 'b-',"LineWidth",3);
geoplot(LLA_RightLane(:,1), LLA_RightLane(:,2), 'c-',"LineWidth",3);
hold off;

% TO DO: add legends for all markers on the plots 

% TO DO: animate the plotting code such that the plot updates as we watch
% it, so a moving plot       priority two

% TO DO: add a vehicle (rectangle) that moves in front of the lane being
% painted (such that it looks like a lane is being painted after the
% vehicle, the vehicle should be able to turn along with the trace, so that
% the orientation of the vehicle is maintained)   priority one

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
