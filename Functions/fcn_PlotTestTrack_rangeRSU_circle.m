function [LLA_coordinates, ENU_coordinates] = fcn_PlotTestTrack_rangeRSU_circle(...
    reference_latitude, reference_longitude, reference_altitude, rsu_coordinates_enu, radius, varargin)
%% fcn_PlotTestTrack_rangeRSU_circle
% Takes the input points from the RSU, LLA/ENU and plots a circle
% in all LLA and ENU coordinates if specified

% INPUTS:
%   reference_latitude: 40.86368573
%
%   reference_longitude: -77.83592832
%
%   reference_altitude: 344.189
%
%   rsu_coordinates_enu = A string stating the type of
%   initial_points that have been the input. String can be "LLA" or
%   "ENU"
%
%   radius = Radius measured from the RSU
%
%
%   (OPTIONAL INPUTS)
%
%   plot_color: a color specifier such as [1 0 0] or 'r' indicating
%   what color the traces should be plotted
%
%   MarkerSize: the line width to plot the traces
% OUTPUTS:
%
%       (none)
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
%       script_test_fcn_PlotTestTrack_plotPointsAnywhere.m for a full
%       test suite.
%
% This function was written on 2024_07_10 by A. Kim
% Questions or comments? sbrennan@psu.edu

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
    narginchk(5,7);
end

% base station coordinates
% Prep for GPS conversions
% The true location of the track base station is [40.86368573°, -77.83592832°, 344.189 m].
reference_latitude = 40.86368573;
reference_longitude = -77.83592832;
reference_altitude = 344.189;
base_station_coordinates = [reference_latitude, reference_longitude, reference_altitude]; % Default
if 3 <= nargin
    temp = varargin{1};
    if ~isempty(temp)
        base_station_coordinates = temp;
    end
end

% Does user want to specify plot_color?
plot_color = [1 0 1]; % Default
if 4 <= nargin
    temp = varargin{2};
    if ~isempty(temp)
        plot_color = temp;
    end
end

% Does user want to specify MarkerSize?
MarkerSize = 10; % Default
if 5 <= nargin
    temp = varargin{3};
    if ~isempty(temp)
        MarkerSize = temp;
    end
end

% Does user want to specify LLA_fig_num?
LLA_fig_num = []; % Default
if 6<= nargin
    temp = varargin{4};
    if ~isempty(temp)
        LLA_fig_num = temp;
    end
end

% Does user want to specify ENU_fig_num?
ENU_fig_num = []; % Default is do not plot
if 7 <= nargin
    temp = varargin{5};
    if ~isempty(temp)
        ENU_fig_num = temp;
    end
end

% If all are empty, default to LLA
if isempty(LLA_fig_num) && isempty(ENU_fig_num)
    LLA_fig_num = 1;
    ENU_fig_num = 2;
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

reference_latitude = 40.86368573;
reference_longitude = -77.83592832;
reference_altitude = 344.189;

% Create a GPS object with the reference latitude, longitude, and altitude
gps_object = GPS(reference_latitude, reference_longitude, reference_altitude);

% Convert the ENU coordinates to LLA coordinates
lla_coords = gps_object.ENU2WGSLLA(rsu_coordinates_enu);

% Plot the RSU coordinates on the geoplot created
figure;
h_geoplot = geoplot(lla_coords(1), lla_coords(2), '*','Color',[0 1 0],'LineWidth',3,'MarkerSize',10);

% Obtain the parent of the geoplot with a sattelite or openstreetmap view
h_parent = get(h_geoplot, 'Parent');
set(h_parent, 'ZoomLevel', 16.375);
try
    geobasemap satellite;
catch
    geobasemap openstreetmap;
end
hold on;

% Plot the circle generated from RSU data on the geoplot
theta = linspace(0, 2*pi, 100); % Generate theta values
radius_in_degrees = radius / 111000; % Convert radius from meters to degrees
circle_lat = lla_coords(1) + radius_in_degrees * cos(theta); % Calculate latitude values
circle_lon = lla_coords(2) + radius_in_degrees * sin(theta) ./ cosd(lla_coords(1)); % Calculate longitude values
geoplot(circle_lat, circle_lon, 'Color', [0 0 1], 'LineWidth', 1.5);

% Plot the RSU coordinates on the ENU plot
hold off;
figure;
plot(rsu_coordinates_enu(1), rsu_coordinates_enu(2), '*', 'Color', [0 1 0], 'LineWidth', 3, 'MarkerSize', 10);
hold on;
circle_x = rsu_coordinates_enu(1) + radius * cos(theta); % Calculate x coordinates for the circle in ENU plot
circle_y = rsu_coordinates_enu(2) + radius * sin(theta); % Calculate y coordinates for the circle in ENU plot
plot(circle_x, circle_y, 'Color', [0 0 1], 'LineWidth', 1.5);
hold off;
xlabel('East (m)');
ylabel('North (m)');
axis equal;
end
