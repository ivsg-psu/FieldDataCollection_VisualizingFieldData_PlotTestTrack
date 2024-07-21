function [ENU_LeftLaneX, ENU_LeftLaneY, ENU_RightLaneX, ENU_RightLaneY]...
    = fcn_PlotTestTrack_animateAVLane(csvFile,car_length,car_width,varargin)
%% fcn_PlotTestTrack_animateAVLane
% create animated plot of latitude, longitude coordinates with respect
% to time and a boundary line after displacement, also get the XY
% coordinates of the boundaries
%
% FORMAT:
%
%       [ENU_LeftLaneX, ENU_LeftLaneY, ENU_RightLaneX, ENU_RightLaneY]
%       = fcn_PlotTestTrack_animateAVLane(csvFile,car_length,car_width,
%       (fig_num,baseLat,baseLon,left_color,right_color,AV_color))
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
%       car_length: The length of car (The unit have to be in Feet)
%
%       car_width: The width of car (The unit have to be in Feet)
%
%      (OPTIONAL INPUTS)
%      baseLat: Latitude of the base location. Default is 40.8637.
%
%      baseLon: Longitude of the base location. Default is -77.8359.
%
%      baseAlt: Altitude of the base location. Default is []. 
%
%      left_color: color of the left lane boundary
%
%      right_color: color of the right lane boundary
%
%      AV_color: color of the AV
%
%      fig_num: figure number
%
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
% -- fixed animation issue of car and the rectangle direction on 2024_0_18
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
    narginchk(3,10);

end

% Default base location coordinates (PSU test track)
baseLat = 40.8637; % default
if 4 <= nargin
    temp = varargin{1};
    if ~isempty(temp)
        baseLat = temp;
    end
end

baseLon = -77.8359;% default
% Default base location coordinates (PSU test track)
if 5 <= nargin
    temp = varargin{2};
    if ~isempty(temp)
        baseLon = temp;
    end
end

baseAlt = 344.189;% default
% Default base location coordinates (PSU test track)
if 6 <= nargin
    temp = varargin{3};
    if ~isempty(temp)
        baseAlt = temp;
    end
end

left_color = [0 0 1]; % deafult 
if 7 <= nargin
    temp = varargin{4};
    if ~isempty(temp)
        left_color = temp;
    end
end

right_color = [0 1 1]; % deafult 
if 8 <= nargin
    temp = varargin{5};
    if ~isempty(temp)
        right_color = temp;
    end
end

AV_color = [1 0 1]; % deafult 
if 9 <= nargin
    temp = varargin{6};
    if ~isempty(temp)
        AV_color = temp;
    end
end

% fig_num
fig_num = 100; % Default
if 10 <= nargin
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

figure (fig_num); % Create a figure
clf;


% Plot the base station i.e the RSU in this case with the same colour as the AV.
% This sets up the figure for
% the first time, including the zoom into the test track area.
h_geoplot = geoplot(baseLat, baseLon, '*','Color',AV_color,'Linewidth',3,'Markersize',10);
h_parent = get(h_geoplot,'Parent');
set(h_parent,'ZoomLevel',16.375);

try
    geobasemap satellite
catch
    geobasemap openstreetmap
end
geotickformat -dd;


% plot original data i.e centerline and rectangle of car
hold on
h_center = geoplot(lat, lon, "Color",AV_color, "LineWidth", 3);
h_left = geoplot(LLA_LeftLane(:, 1), LLA_LeftLane(:, 2), "Color",left_color, "LineWidth", 3);
h_right = geoplot(LLA_RightLane(:, 1), LLA_RightLane(:, 2), "Color",right_color, "LineWidth", 3);
h_rect = geoplot(nan, nan, "Color",AV_color, 'LineWidth', 2);

% Conversion factors
feet_per_degree_lat = 364567; % Approximate conversion factor for latitude
feet_per_degree_lon = feet_per_degree_lat * cosd(mean(lat)); % Adjust for mid-latitude

% Convert car dimensions to degrees
car_length_deg = car_length / feet_per_degree_lat;
car_width_deg = car_width / feet_per_degree_lon;

% Animation loop
for ith_coordinate = 1:Num_length
    % Update the data for center, left and right lane
    set(h_center, 'XData', lat(1:ith_coordinate), 'YData', lon(1:ith_coordinate), 'LineWidth', 3);
    set(h_left, 'XData', LLA_LeftLane(1:ith_coordinate, 1), 'YData', LLA_LeftLane(1:ith_coordinate, 2), 'LineWidth', 3);
    set(h_right, 'XData', LLA_RightLane(1:ith_coordinate, 1), 'YData', LLA_RightLane(1:ith_coordinate, 2), 'LineWidth', 3);

    % Update the data for the rectangle to represent the car
    % Calculate the unit vector where the car is heading to
    Vector = [lat(ith_coordinate+1)-lat(ith_coordinate), lon(ith_coordinate+1)-lon(ith_coordinate)];
    magnitude = sum(Vector.^2,2).^0.5;
    unitVtor = Vector./magnitude;
    %Calculate the unit vector that is perpendicular to the direction of 
    % the car
    perpVector = [unitVtor(2), -unitVtor(1)];
    scaled_perpVector = perpVector * (car_width_deg/2);
    center = [lat(ith_coordinate) lon(ith_coordinate)];
    % Find center points of front, back, left and right of the lane
    New_point_left = center - scaled_perpVector;
    New_point_right = center + scaled_perpVector;
    New_point_front = center + unitVtor.*(car_length_deg/2);
    New_point_back = center - unitVtor.*(car_length_deg/2);
    % Find the points of the four corners of the car 
    Left_bottom_corner = New_point_back - scaled_perpVector;
    Left_top_corner = New_point_front - scaled_perpVector;
    Right_bottom_corner = New_point_back + scaled_perpVector;
    Right_top_corner = New_point_front + scaled_perpVector;
    %Coordination of the rectangle 
    x = [Left_bottom_corner(1),Right_bottom_corner(1),Right_top_corner(1),Left_top_corner(1),Left_bottom_corner(1)];
    y = [Left_bottom_corner(2),Right_bottom_corner(2),Right_top_corner(2),Left_top_corner(2),Left_bottom_corner(2)];
    set(h_rect,'XData',x,'YData',y)
    % Pause to control the speed of the animation
    pause(0.1);
end
legend([h_center, h_left, h_right, h_rect], {'Center Lane', 'Left Lane', 'Right Lane', 'Car'}, 'Location', 'best');
hold off;


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


