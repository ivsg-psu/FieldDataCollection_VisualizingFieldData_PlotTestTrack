function [ENUCorners_Final, LLACorners_Final] = fcn_PlotTestTrack_plotRectangle(...
    reference_latitude, reference_longitude, reference_altitude, LLA_centerPoint, LLA_second_point, varargin)
%% fcn_PlotTestTrack_plotRectangle
% Takes the LLA coordinates of the center of rectangle as inpt along with
% the reference_latitude, reference_longitude, reference_altitude and plots
% a rectangle of the input length and width in LLA and ENU

% FORMAT:
%
%       [ENU_X, ENU_Y] = fcn_PlotTestTrack_plotRectangle(...
%       reference_latitude, reference_longitude, reference_altitude, LLA_centerPoint,...
%       LLA_second_point, (car_length,car_width,AV_color,flag_LLA,flag_ENU,fig_num)
%
% INPUTS:
%
%      (MANDATORY INPUTS)
%
%      reference_latitude: Latitude of the base location.
%
%      reference_longitude: Longitude of the base location.
%
%      reference_altitude: Altitude of the base location.
%
%      LL_centerPoint: The Latitude and longitude coordinates of the
%       centerpoint of the rectangle
%
%      LLA_second_point: LLA coordinates of another point so that we can
%      get the direction of the AV (or rectangle)
%
%      (OPTIONAL INPUTS)
%
%      car_length: The length of car (The unit have to be in Feet)
%
%      car_width: The width of car (The unit have to be in Feet)
%
%      AV_color: color of the AV
%
%      flag_LLA: a 0 or 1 value depending on if the user wants to plot in
%      LLA (1) or not (0).
%
%      flag_ENU: a 0 or 1 value depending on if the user wants to plot in
%      ENU (1) or not (0).
%
%     fig_num: figure number specified by user
%
% OUTPUTS:
%
%       enuCorners: ENU coordinates of the corner points of the rectangle
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
%       script_test_fcn_PlotTestTrack_plotRectangle.m for a full
%       test suite.
%
% This function was written on 2024_08_05 by V. Wagh
% Questions or comments? vbw5054@psu.edu


flag_do_debug = 0; % Flag to plot the results for debugging
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
    narginchk(5,11);
end

% car length or length of the rectangle
car_length = 14; % default
if 6 <= nargin
    temp = varargin{1};
    if ~isempty(temp)
        car_length = temp;
    end
end

% car width or width of the rectangle
car_width = 6; % default
if 7 <= nargin
    temp = varargin{2};
    if ~isempty(temp)
        car_width = temp;
    end
end

AV_color = [0 0 1]; % deafult
if 8 <= nargin
    temp = varargin{3};
    if ~isempty(temp)
        AV_color = temp;
    end
end

flag_LLA = 1; % default is to plot the rectangle in LLA
if 9 <= nargin
    temp = varargin{4};
    if ~isempty(temp)
        flag_LLA = temp;
    end
end

flag_ENU = 1; % default is to plot the rectangle in ENU
if 10 <= nargin
    temp = varargin{5};
    if ~isempty(temp)
        flag_ENU = temp;
    end
end

% fig_num
fig_num = 100; % Default
if 11 <= nargin
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


% Create a GPS object with the reference latitude, longitude, and altitude
gps_object = GPS(reference_latitude, reference_longitude, reference_altitude);

% converting LLA to ENU for center point of rectangle
centerLat = LLA_centerPoint(:,1);
centerLon = LLA_centerPoint(:,2);
centerAlt = reference_altitude;
centerENU = gps_object.WGSLLA2ENU(centerLat,centerLon,centerAlt,reference_latitude,reference_longitude,reference_altitude);

% convert the LLA of second point to ENU
secondPoint_ENU = gps_object.WGSLLA2ENU(LLA_second_point(:,1),LLA_second_point(:,2),LLA_second_point(:,3),reference_latitude,reference_longitude,reference_altitude);

% Seprate X and Y values for ease of calculation
E_center = centerENU(:,1);
N_center = centerENU(:,2);
E_ref = secondPoint_ENU(:,1);
N_ref = secondPoint_ENU(:,2);

% first go straight in the direction of the car
[X_straightFront, Y_straightFront] = fcn_INTERNAL_calculateNewENUPoint(centerENU, secondPoint_ENU, car_length/2);
% this is the front point in the middle of the edge. We need to get the corner

% for left front of rectangle
[X_leftFront, Y_leftFront] = fcn_INTERNAL_calcPerpendicularPoint(X_straightFront, Y_straightFront, E_ref, N_ref, -car_width/2);

% for right front of rectangle
[X_rightFront, Y_rightFront] = fcn_INTERNAL_calcPerpendicularPoint(X_straightFront, Y_straightFront, E_ref, N_ref, car_width/2);

% go backwards
% go straight in the opposite direction of the car
[X_straightBack, Y_straightBack] = fcn_INTERNAL_calculateNewENUPoint(centerENU, secondPoint_ENU, -car_length/2);
% this is the front point in the middle of the edge. We need to get the corner

% for left back of rectangle
[X_leftBack, Y_leftBack] = fcn_INTERNAL_calcPerpendicularPoint(X_straightBack, Y_straightBack, E_ref, N_ref, -car_width/2);

% for right back of rectangle
[X_rightBack, Y_rightBack] = fcn_INTERNAL_calcPerpendicularPoint(X_straightBack, Y_straightBack, E_ref, N_ref, car_width/2);

% Left and Right together
enuCorners_Left = [X_leftFront Y_leftFront 0
    X_leftBack Y_leftBack 0];

enuCorners_Right = [X_rightFront Y_rightFront 0
    X_rightBack Y_rightBack 0];

enuCorners = [X_leftFront Y_leftFront 
    X_rightFront Y_rightFront 
    X_rightBack Y_rightBack 
    X_leftBack Y_leftBack 
    ];

orderedENUPoints = fcn_INTERNAL_reorderRectanglePoints(enuCorners);

% add 3rd column for conversion
orderedENUPoints_WithAlt = [orderedENUPoints(:,1) orderedENUPoints(:,2) orderedENUPoints(:,1)*0];
ENUCorners_Final = orderedENUPoints_WithAlt(1:end-1,:);
% convert ENU to LLA
LLACorners = gps_object.ENU2WGSLLA(orderedENUPoints_WithAlt);
LLACorners_Final = LLACorners(1:end-1,:);
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

% Plot rectangle in LLA
if flag_LLA == 1

    % Plot the rectangle on a geographic plot
    figure(fig_num);

    % Plot the center of the rectangle
    h_geoplot = geoplot(centerLat, centerLon, '*','Color',AV_color,'MarkerSize',3);


    % Obtain the parent of the geoplot with a sattelite or openstreetmap view
    h_parent = get(h_geoplot, 'Parent');
    %set(h_parent, 'ZoomLevel', 16.375);
    try
        geobasemap satellite;
    catch
        geobasemap openstreetmap;
    end
    hold on;
    geotickformat -dd;

    geoplot(LLACorners(:, 1), LLACorners(:, 2), 'Color',AV_color,'LineStyle','-','LineWidth',3);
    geoplot(LLA_second_point(:,1), LLA_second_point(:,2), 'g*','MarkerSize',3); % Plot direction point
    title('Rectangle of AV in LLA Coordinates');
end


if flag_ENU == 1

    % Plot the rectangle in ENU coordinates
    figure(fig_num+1);

    % Plot the center of the rectangle
    plot(centerENU(:,1),centerENU(:,2),'Color',AV_color,'Marker','*','MarkerSize',5);
    hold on;
    plot(secondPoint_ENU(:,1), secondPoint_ENU(:,2), 'g*','MarkerSize',3); % Plot direction point
    hold on;
    plot(orderedENUPoints(:, 1), orderedENUPoints(:, 2), 'Color',AV_color,'LineWidth',3);
    title('Rectangle in ENU Coordinates');
    xlabel('East (meters)');
    ylabel('North (meters)');
    axis equal;
    grid on;

    hold off;
    legend('Center of rectangle','Second Point', 'Rectangle');
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

%% fcn_INTERNAL_calculateNewENUPoint
function [new_X, new_Y] = fcn_INTERNAL_calculateNewENUPoint(enu1, enu2, x)
% Calculate the unit vector from enu1 to enu2
vec = enu2 - enu1;
unitVec = vec / norm(vec);

% Calculate the new point x distance away in the direction of enu2
newPoint = enu1 + x * unitVec;
new_X = newPoint(:,1);
new_Y = newPoint(:,2);
end

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
%% fcn_INTERNAL_reorderRectanglePoints

function rectPoints = fcn_INTERNAL_reorderRectanglePoints(points)
    % plotRectangleFromUnorderedPoints Plots a rectangle from four unordered XY points.
    %
    % Inputs:
    %   points - A 4x2 matrix where each row is an (X, Y) coordinate

    % Ensure the input is a 4x2 matrix
    assert(size(points, 1) == 4 && size(points, 2) == 2, 'Input must be a 4x2 matrix of points.');

    % Calculate the centroid of the points
    centroid = mean(points);

    % Calculate angles of each point relative to the centroid
    angles = atan2(points(:, 2) - centroid(2), points(:, 1) - centroid(1));

    % Sort points based on angles
    [~, order] = sort(angles);
    orderedPoints = points(order, :);

    % Reorder the points to form a rectangle (ensure correct order)
    % Find the pair of opposite corners with the maximum distance
    dists = pdist2(orderedPoints, orderedPoints);
    [~, idx] = max(dists(:));
    [row, col] = ind2sub(size(dists), idx);

    % Determine the two pairs of corners
    corners1 = [orderedPoints(row, :); orderedPoints(col, :)];
    remainingPoints = setdiff(1:4, [row, col]);
    corners2 = [orderedPoints(remainingPoints(1), :); orderedPoints(remainingPoints(2), :)];

    % Combine the points to form the rectangle
    rectPoints = [corners1(1, :); corners2(1, :); corners1(2, :); corners2(2, :); corners1(1, :)];
end



