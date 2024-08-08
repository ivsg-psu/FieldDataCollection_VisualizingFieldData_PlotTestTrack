function fcn_PlotTestTrack_plotTraceLLA(LLA_data, varargin)
%% fcn_PlotTestTrack_plotTraceLLA
% Plots trace of LLA data via geoplot.
%
% FORMAT:
%
%       fcn_PlotTestTrack_plotTraceLLA(LLA_data,(plot_color),(fig_num))
%
% INPUTS:
%
%      (MANDATORY INPUTS)
%
%       LLA_data: a NX2 vector of [X Y] data for the lane marker positions
%
%       (OPTIONAL INPUTS)
%
%       plot_color: a 3 x 1 array to indicate the color to use
%
%       line_width: the width of the line to use (default is 2)
%
%       flag_plot_headers_and_tailers: set to 1 to plot a green bar at the
%       "head" of the plot, red bar at the "tail of the plot. For plots
%       with 4 points or less, the head and tail is created via vector
%       projections. For plots with more than 4, the segments at start and
%       end define the head and tail (default is 1)
%
%       flag_plot_points: set to 1 to plot points encircled by the plot
%       color, or 0 to not plot the points (default is 1)
%
%       fig_num: a figure number to plot result
%
%       (ENVIRONMENT VARIABLES)
%       uses setenv("MATLABFLAG_PLOTTESTTRACK_ALIGNMATLABLLAPLOTTINGIMAGES","1");
%       to add offset during plotting, in images, to match to true LLA
%       coordinates.
%      
%
% OUTPUTS:
%
%      (none)
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
%       script_test_fcn_PlotTestTrack_plotTraceLLA.m for a full
%       test suite.
%
% This function was written on 2023_07_18 by S. Brennan
% Questions or comments? sbrennan@psu.edu


% Revision history:
% 2023_07_18 by S. Brennan, sbrennan@psu.edu
% -- start writing function

% 2023_09_08 by V. Wagh
% -- added in line 236,237,
% offset_Lat = 0; % default offset
% offset_Lon = 0; % default offset 
% to get rid of Unrecognized function or variable errors 

%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==6 && isequal(varargin{end},-1))
    flag_do_debug = 0; % % % % Flag to plot the results for debugging
    flag_check_inputs = 0; % Flag to perform input checking
    flag_max_speed = 1;
else
    % Check to see if we are externally setting debug mode to be "on"
    flag_do_debug = 0; % % % % Flag to plot the results for debugging
    flag_check_inputs = 1; % Flag to perform input checking
    MATLABFLAG_PlotTestTrack_FLAG_CHECK_INPUTS = getenv("MATLABFLAG_PlotTestTrack_FLAG_CHECK_INPUTS");
    MATLABFLAG_PlotTestTrack_FLAG_DO_DEBUG = getenv("MATLABFLAG_PlotTestTrack_FLAG_DO_DEBUG");
    if ~isempty(MATLABFLAG_PlotTestTrack_FLAG_CHECK_INPUTS) && ~isempty(MATLABFLAG_PlotTestTrack_FLAG_DO_DEBUG)
        flag_do_debug = str2double(MATLABFLAG_PlotTestTrack_FLAG_DO_DEBUG); 
        flag_check_inputs  = str2double(MATLABFLAG_PlotTestTrack_FLAG_CHECK_INPUTS);
    end
end

flag_do_debug = 1;

if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
    debug_fig_num = 999978;
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

if flag_max_speed == 1
    % Are there the right number of inputs?
    narginchk(1,6);

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
end


% Setup figures if there is debugging
if flag_do_debug
    fig_debug = 9999;
else
    fig_debug = []; %#ok<*NASGU>
end

flag_do_plots = 0;
if (0==flag_max_speed) && (6<= nargin)
    temp = varargin{end};
    if ~isempty(temp)
        fig_num = temp;
        flag_do_plots = 1;
    end
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


% Prep a figure
figure(fig_num);

% Does the figure already have data?
temp_fig_handle = gcf;
if isempty(temp_fig_handle.Children)
    % Initialize the plot
    % which automatically plot the base station with a green star
    fcn_PlotTestTrack_geoPlotData([],[],'',fig_num);
end

% Plot LLA results as cell?
if iscell(LLA_data)
    for ith_data = 1:length(LLA_data)
        LLA_data_to_plot = LLA_data{ith_data};
        fcn_INTERNAL_plotData(LLA_data_to_plot,plot_color,line_width,flag_plot_headers_and_tailers, flag_plot_points)
    end
else
    fcn_INTERNAL_plotData(LLA_data,plot_color,line_width,flag_plot_headers_and_tailers, flag_plot_points);
end

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

if flag_do_plots    
% Prep a figure
figure(fig_num);

% Does the figure already have data?
temp_fig_handle = gcf;
if isempty(temp_fig_handle.Children)
    % Initialize the plot
    % which automatically plot the base station with a green star
    fcn_PlotTestTrack_geoPlotData([],[],'',fig_num);
end

% Plot LLA results as cell?
if iscell(LLA_data)
    for ith_data = 1:length(LLA_data)
        LLA_data_to_plot = LLA_data{ith_data};
        fcn_INTERNAL_plotData(LLA_data_to_plot,plot_color,line_width,flag_plot_headers_and_tailers, flag_plot_points)
    end
else
    fcn_INTERNAL_plotData(LLA_data,plot_color,line_width,flag_plot_headers_and_tailers, flag_plot_points);
end    
end % Ends check if plotting

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end

end % Ends main function


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

%% fcn_INTERNAL_plotData
function fcn_INTERNAL_plotData(LLA_data_to_plot,plot_color,line_width,flag_plot_headers_and_tailers, flag_plot_points)


reference_latitude = 40.86368573;
reference_longitude = -77.83592832;
reference_altitude = 344.189;
gps_object = GPS(reference_latitude,reference_longitude,reference_altitude); % Load the GPS class

% Check to see if we are forcing image alignment via Lat and Lon shifting,
% when doing geoplot. This is added because the geoplot images are very, very
% slightly off at the test track, which is confusing when plotting data
% above them.
offset_Lat = 0; % default offset
offset_Lon = 0; % default offset
MATLABFLAG_PLOTTESTTRACK_ALIGNMATLABLLAPLOTTINGIMAGES_LAT = getenv("MATLABFLAG_PLOTTESTTRACK_ALIGNMATLABLLAPLOTTINGIMAGES_LAT");
MATLABFLAG_PLOTTESTTRACK_ALIGNMATLABLLAPLOTTINGIMAGES_LON = getenv("MATLABFLAG_PLOTTESTTRACK_ALIGNMATLABLLAPLOTTINGIMAGES_LON");
if ~isempty(MATLABFLAG_PLOTTESTTRACK_ALIGNMATLABLLAPLOTTINGIMAGES_LAT) && ~isempty(MATLABFLAG_PLOTTESTTRACK_ALIGNMATLABLLAPLOTTINGIMAGES_LON)
    offset_Lat = str2double(MATLABFLAG_PLOTTESTTRACK_ALIGNMATLABLLAPLOTTINGIMAGES_LAT);
    offset_Lon  = str2double(MATLABFLAG_PLOTTESTTRACK_ALIGNMATLABLLAPLOTTINGIMAGES_LON);
end


sizeOfMarkers = 10;
geoplot(LLA_data_to_plot(:,1)+offset_Lat,LLA_data_to_plot(:,2)+offset_Lon, '-','Color',plot_color,'Linewidth',line_width,'Markersize',sizeOfMarkers);

% Plot the points?
if flag_plot_points
    geoplot(LLA_data_to_plot(:,1)+offset_Lat,LLA_data_to_plot(:,2)+offset_Lon, '.','Color',plot_color,'Linewidth',line_width,'Markersize',round(sizeOfMarkers*2));
    geoplot(LLA_data_to_plot(:,1)+offset_Lat,LLA_data_to_plot(:,2)+offset_Lon, '.','Color',[0 0 0],'Linewidth',line_width,'Markersize',round(sizeOfMarkers*0.5));
end

% Plot headers and tailers?
if flag_plot_headers_and_tailers
    if length(LLA_data_to_plot(:,1))>4
        geoplot(LLA_data_to_plot(1,1)+offset_Lat,LLA_data_to_plot(1,2)+offset_Lon, 'o','Color',[0 1 0],'Linewidth',line_width,'Markersize',sizeOfMarkers);
        geoplot(LLA_data_to_plot(end,1)+offset_Lat,LLA_data_to_plot(end,2)+offset_Lon, 'x','Color',[1 0 0],'Linewidth',line_width,'Markersize',sizeOfMarkers);

        % Plot green headers
        geoplot(LLA_data_to_plot(1:2,1)+offset_Lat,LLA_data_to_plot(1:2,2)+offset_Lon, '-','Color',[0 1 0],'Linewidth',line_width,'Markersize',sizeOfMarkers);

        % Plot red tailers
        geoplot(LLA_data_to_plot(end-1:end,1)+offset_Lat,LLA_data_to_plot(end-1:end,2)+offset_Lon, '-','Color',[1 0 0],'Linewidth',line_width,'Markersize',sizeOfMarkers);
    else
        ENU_data_to_plot  = gps_object.WGSLLA2ENU(LLA_data_to_plot(:,1), LLA_data_to_plot(:,2), LLA_data_to_plot(:,3));

        % Plot green headers - calculated from vector direction
        vector_direction_start = ENU_data_to_plot(2,1:2) - ENU_data_to_plot(1,1:2);
        start_length = sum(vector_direction_start.^2,2).^0.5;
        unit_vector_direction_start = vector_direction_start./start_length;
        max_length = min(10,start_length*0.2);
        offset_start = ENU_data_to_plot(1,1:2) + max_length*unit_vector_direction_start;
        ENU_vector = [ENU_data_to_plot(1,1:2) 0; offset_start, 0];
        LLA_vector =  gps_object.ENU2WGSLLA(ENU_vector');

        geoplot(LLA_vector(:,1)+offset_Lat,LLA_vector(:,2)+offset_Lon, '-','Color',[0 1 0],'Linewidth',3,'Markersize',sizeOfMarkers);

        % Plot red tailers - calculated from vector direction
        vector_direction_end = (ENU_data_to_plot(end,1:2) - ENU_data_to_plot(end-1,1:2));
        end_length = sum(vector_direction_end.^2,2).^0.5;
        unit_vector_direction_end = vector_direction_end./end_length;
        max_length = min(10,end_length*0.2);
        offset_end = ENU_data_to_plot(end,1:2) - max_length*unit_vector_direction_end;
        ENU_vector = [offset_end, 0; ENU_data_to_plot(end,1:2) 0];
        LLA_vector =  gps_object.ENU2WGSLLA(ENU_vector');

        geoplot(LLA_vector(:,1)+offset_Lat,LLA_vector(:,2)+offset_Lon, '-','Color',[1 0 0],'Linewidth',3,'Markersize',sizeOfMarkers);


        geoplot(LLA_data_to_plot(1,1)+offset_Lat,LLA_data_to_plot(1,2)+offset_Lon, 'o','Color',[0 1 0],'Linewidth',line_width,'Markersize',sizeOfMarkers);
        geoplot(LLA_data_to_plot(end,1)+offset_Lat,LLA_data_to_plot(end,2)+offset_Lon, 'x','Color',[1 0 0],'Linewidth',line_width,'Markersize',sizeOfMarkers);
    end
end

end % Ends fcn_INTERNAL_plotData
