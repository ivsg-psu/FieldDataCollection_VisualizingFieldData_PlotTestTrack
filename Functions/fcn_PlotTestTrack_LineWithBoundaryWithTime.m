function fcn_PlotTestTrack_LineWithBoundaryWithTime(csvFile, varargin)
%% fcn_PlotTestTrack_LineWithBoundaryWithTime
% plot create animated plot of latitude, longitude coordinates with respect
% to time and a boundary line after displacement.
%
% FORMAT:
%
%       fcn_PlotTestTrack_LineWithBoundaryWithTime(csvFile, varargin)
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
%      baseLat (optional): Latitude of the base location. Default is 40.8637.
%      baseLon (optional): Longitude of the base location. Default is -77.8359.
%      showTrajectory (optional): Boolean to toggle trajectory line. Default is true.
%
%    
%
% OUTPUTS:
%
%      Plot of LLA coordinates with respect to time 
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
%       script_test_fcn_PlotTestTrack_LineWithBoundaryWithTime.m
%
% This function was written on 2024_07_07 by Jiabao Zhao
% --Start to write the function 
% Questions or comments? jpz5469@psu.edu

% Revision history:
% 2024_07_17 - A.Kim
% -- Added improved debugging and input checking section

%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==4 && isequal(varargin{end},-1))
    flag_do_debug = 0; % Flag to plot the results for debugging
    flag_check_inputs = 0; % Flag to perform input checking
    flag_max_speed = 1;
else
    % Check to see if we are externally setting debug mode to be "on"
    flag_do_debug = 0; % Flag to plot the results for debugging
    flag_check_inputs = 1; % Flag to perform input checking
    MATLABFLAG_PLOTTESTTRACK_FLAG_CHECK_INPUTS = getenv("MATLABFLAG_PLOTTESTTRACK_FLAG_CHECK_INPUTS");
    MATLABFLAG_PLOTTESTTRACK_FLAG_DO_DEBUG = getenv("MATLABFLAG_PLOTTESTTRACK_FLAG_DO_DEBUG");
    if ~isempty(MATLABFLAG_PLOTTESTTRACK_FLAG_CHECK_INPUTS) && ~isempty(MATLABFLAG_PLOTTESTTRACK_FLAG_DO_DEBUG)
        flag_do_debug = str2double(MATLABFLAG_PLOTTESTTRACK_FLAG_DO_DEBUG);
        flag_check_inputs  = str2double(MATLABFLAG_PLOTTESTTRACK_FLAG_CHECK_INPUTS);
    end
end

if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
    debug_fig_num = 23434; %#ok<NASGU>
else
    debug_fig_num = []; %#ok<NASGU>
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
    narginchk(1,4);

end


% Does user want to specify plot_color?
plot_color = [1 0 1]; % Default is cyan
if 2 <= nargin
    temp = varargin{1};
    if ~isempty(temp)
        plot_color = temp;
    end
end


% Does user want to specify line_width?
line_width = 2; % Default
if 3 <= nargin
    temp = varargin{2};
    if ~isempty(temp)
        line_width = temp;
    end
end

% Does user want to specify flag_plot_headers_and_tailers?
flag_plot_headers_and_tailers = 1;
if 4 <= nargin
    temp = varargin{3};
    if ~isempty(temp)
        flag_plot_headers_and_tailers = temp;
    end
end


% Does user want to specify flag_plot_points?
flag_plot_points = 1;
if 5 <= nargin
    temp = varargin{4};
    if ~isempty(temp)
        flag_plot_points = temp;
    end
end

% Does user want to specify fig_num?
flag_make_new_plot = 1; % Default to make a new plot, which will clear the plot and start a new plot
fig_num = []; % Initialize the figure number to be empty
if 6 == nargin
    temp = varargin{end};
    if ~isempty(temp)
        fig_num = temp;

    else % An empty figure number is given by user, so we have to make one
        fig = figure; % create new figure with next default index
        fig_num = get(fig,'Number');
        flag_make_new_plot = 1;
    end
end


% Is the figure number still empty? If so, then we need to open a new
% figure
if flag_make_new_plot && isempty(fig_num)
    fig = figure; % create new figure with next default index
    fig_num = get(fig,'Number');
    flag_make_new_plot = 1;
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
data = readmatrix(csvFile); % Read the CSV file 
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

% Plotting 
   if size(data, 2) ~= 4
    error('The CSV file must contain exactly four columns: latitude, longitude, elevation, and time.'); % Check if the input matrix has four columns
   end

% Extract latitude, longitude, elevation, and time values
lat = data(:, 1)/10000000;
lon = data(:, 2)/10000000;
elv = data(:, 3);
time = data(:, 4);

% Default base location coordinates (PSU test track)
defaultBaseLat = 40.8637;
defaultBaseLon = -77.8359;
% Default plots trajectory
defaultShowTrajectory = true;

% Check for optional inputs and set defaults if necessary
if nargin < 2 || isempty(varargin{1})
    baseLat = defaultBaseLat;
else
    baseLat = varargin{1};
end
if nargin < 3 || isempty(varargin{2})
    baseLon = defaultBaseLon;
else
    baseLon = varargin{2};
end
if nargin < 4 || isempty(varargin{3})
    showTrajectory = defaultShowTrajectory;
else
    showTrajectory = varargin{3};
end
figure (1); % Create a figure

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

hold on;

% Initialize the plot with the first point from the csv file
h = geoplot(lat(1), lon(1), 'bs', 'MarkerSize', 10, 'MarkerFaceColor', 'b');

% Initialize the line plot for the trajectory
if showTrajectory
    traj = geoplot(NaN, NaN, 'r-', 'LineWidth', 2);
end

% Calculate boundary lines 6 meters away
    distanceOffset = 6; % in meters
    [latOffset1, lonOffset1] = offsetCoordinates(lat, lon, distanceOffset);
    [latOffset2, lonOffset2] = offsetCoordinates(lat, lon, -distanceOffset);

    % Initialize the boundary line plots
    boundary1 = geoplot(NaN, NaN, 'g-', 'LineWidth', 2);
    boundary2 = geoplot(NaN, NaN, 'g-', 'LineWidth', 2);

% Use a timer to create the animation
currentIndex = 2;
t = timer('TimerFcn', @updatePlot, 'Period', 0.1, 'ExecutionMode', 'fixedRate');

% Start the timer
    start(t);

    function updatePlot(~, ~)
        if currentIndex <= length(lat)
            set(h, 'LatitudeData', lat(currentIndex), 'LongitudeData', lon(currentIndex));
            % Update the trajectory line
            if showTrajectory
                set(traj, 'LatitudeData', lat(1:currentIndex), 'LongitudeData', lon(1:currentIndex));
                % Update the boundary lines
                set(boundary1, 'LatitudeData', latOffset1(1:currentIndex), 'LongitudeData', lonOffset1(1:currentIndex));
                set(boundary2, 'LatitudeData', latOffset2(1:currentIndex), 'LongitudeData', lonOffset2(1:currentIndex));
            end
            currentIndex = currentIndex + 1;
        else
            stop(t); % Stop the timer when all points are plotted
            delete(t); % Delete the timer object
            % Final update of the trajectory line after the car has moved
            if showTrajectory
                set(traj, 'LatitudeData', lat, 'LongitudeData', lon);
                set(boundary1, 'LatitudeData', latOffset1, 'LongitudeData', lonOffset1);
                set(boundary2, 'LatitudeData', latOffset2, 'LongitudeData', lonOffset2);
            end
        end
    end

hold off;
if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end
function [latOffset, lonOffset] = offsetCoordinates(lat, lon, offset)
    % Calculate the offset in degrees assuming small offsets
    R = 6378137; % Earth's radius in meters
    dLat = offset / R;
    dLon = offset / (R * cosd(mean(lat)));
    latOffset = lat + rad2deg(dLat);
    lonOffset = lon + rad2deg(dLon);
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

