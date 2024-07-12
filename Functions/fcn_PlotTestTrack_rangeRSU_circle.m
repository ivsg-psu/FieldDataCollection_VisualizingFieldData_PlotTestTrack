function fcn_PlotTestTrack_rangeRSU_circle(...
    reference_latitude, reference_longitude, reference_altitude, rsu_coordinates_enu, radius, varargin)
%% fcn_PlotTestTrack_rangeRSU_circle
% Takes the input points from the RSU, LLA/ENU and plots a circle
% in all LLA and ENU coordinates if specified

% INPUTS:
%   reference_latitude: the base station latitude 
%
%   reference_longitude: -77.83592832
%
%   reference_altitude: 344.189
%
%   rsu_coordinates_enu = ENU coords in NX3 format
%
%   radius = Radius measured from the RSU in meters
%
%   (OPTIONAL INPUTS)
%
%   plot_color: a color specifier such as [1 0 0] or 'r' indicating
%   what color the RSU point and circle should be plotted
%
%   MarkerSize: the size of the marker to plot the RSU position
%
%   fig_num: figure number
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
%       script_test_fcn_PlotTestTrack_rangeRSU_circle.m for a full
%       test suite.
%
% This function was written on 2024_07_10 by A. Kim
% Questions or comments? sbrennan@psu.edu % Abel's email


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
    narginchk(5,8);
end


% Does user want to specify plot_color?
plot_color = [1 0 1]; % Default
if 6 <= nargin
    temp = varargin{1};
    if ~isempty(temp)
        plot_color = temp;
    end
end

% Does user want to specify MarkerSize?
MarkerSize = 10; % Default
if 7 <= nargin
    temp = varargin{2};
    if ~isempty(temp)
        MarkerSize = temp;
    end
end

% assign LLA and ENY figure numbers
% Does user want to specify fig_num?
fig_num = 100; % Default
if 8 <= nargin
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

% Convert the ENU coordinates to LLA coordinates
lla_coords = gps_object.ENU2WGSLLA(rsu_coordinates_enu);

% Plot the RSU coordinates on the geoplot created
figure(fig_num);
h_geoplot = geoplot(lla_coords(1), lla_coords(2), '*','Color',plot_color,'LineWidth',3,'MarkerSize',MarkerSize);

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
geoplot(circle_lat, circle_lon, 'Color', plot_color, 'LineWidth', 1.5);

% Plot the RSU coordinates on the ENU plot
hold off;
figure(fig_num+1);
plot(rsu_coordinates_enu(1), rsu_coordinates_enu(2), '*', 'Color', plot_color, 'LineWidth', 3, 'MarkerSize', MarkerSize);
hold on;
circle_x = rsu_coordinates_enu(1) + radius * cos(theta); % Calculate x coordinates for the circle in ENU plot
circle_y = rsu_coordinates_enu(2) + radius * sin(theta); % Calculate y coordinates for the circle in ENU plot
plot(circle_x, circle_y, 'Color', plot_color, 'LineWidth', 1.5);
hold off;
xlabel('East (m)');
ylabel('North (m)');
axis equal;
end