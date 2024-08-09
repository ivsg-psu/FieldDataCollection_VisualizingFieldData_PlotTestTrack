function fcn_PlotTestTrack_geoPlotData(varargin)
%% fcn_PlotTestTrack_geoPlotData
% Plots data from an array one by one, created to plot data arrays for
% scenarios, using the "geoplot" command. If the user gives no data to
% plot, then the function initializes the figure.
%
% FORMAT:
%
%       fcn_PlotTestTrack_geoPlotData((data_array),(color),(text),(fig_num))
%
% INPUTS:
%
%      (OPTIONAL INPUTS)
%
%      data_array: an optional data array to plot. Data is assumed to be of
%      the form: Nx3 array with each row containing:
%          [Latitude Longitude Altitude]
%
%      color: an optional color to plot. Default is yellow ([1 1 0]).
%
%      text: an optional text to add to the plot.
%
%      fig_num: a figure number to plot result
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
%       script_test_fcn_PlotTestTrack_geoPlotData.m for a full
%       test suite.
%
% This function was written on 2023_06_06 by V. Wagh
% Questions or comments? vbw5054@psu.ed


% Revision history:
% 2023_06_06 by V. Wagh
% -- start writing function
% 2023_06_07 by S. Brennan (sbrennan@psu.edu)
% -- continued work on functionalization
% -- added test script
% 2023_07_25 by S. Brennan (sbrennan@psu.edu)
% -- added geotick formatting to be negative decimal degrees
% 2023_09_08 by V. Wagh
% -- added in line 197, 198
% offset_Lat = 0; % default offset
% offset_Lon = 0; % default offset
% to get rid of Unrecognized function or variable errors

%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==5 && isequal(varargin{end},-1))
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

if 0 == flag_max_speed
    if flag_check_inputs == 1
        % Are there the right number of inputs?
        narginchk(0,5);
    end
end

flag_do_debug = 0; % Flag to show the results for debugging
flag_do_plots = 0; % % Flag to plot the final results
flag_check_inputs = 1; % Flag to perform input checking


% Tell user where we are
if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
end

flag_plot_data = 0; % Default is not to plot the data
if 1 <= nargin
    temp = varargin{1};
    if ~isempty(temp)
        data_to_plot = temp;
        flag_plot_data = 1;
    end
end

color_to_plot = [1 1 0]; % Default is yellow
if 2<= nargin
    temp = varargin{2};
    if ~isempty(temp)
        color_to_plot = temp;
    end
end

label_text =''; % Default is empty
if 3<= nargin
    temp = varargin{3};
    if ~isempty(temp)
        label_text = temp;
    end
end

if 4 <= nargin
    temp = varargin{end};
    if ~isempty(temp)
        line_type = temp;
    else
        line_type = '-';
    end
end

flag_make_new_plot = 1; % Default to make a new plot, which will clear the plot and start a new plot
fig_num = 100; % Initialize the figure number to be empty
if 5 == nargin
    temp = varargin{4};
    if ~isempty(temp)
        fig_num = temp;
        %figure(fig_num);

        % Check to see if data is being plotting? If it is not, then we
        % need to replot the figure
        if 0==flag_plot_data
            flag_make_new_plot = 1;
        else
            % Do not replot the figure - data is given
            flag_make_new_plot = 0;
        end
    else % An empty figure number is given by user, so we have to make one
        %fig = figure; % create new figure with next default index
        fig_num = 2345;
        flag_make_new_plot = 1;
    end
end



% Is the figure number still empty? If so, then we need to open a new
% figure
if flag_make_new_plot && isempty(fig_num)
    %fig = figure; % create new figure with next default index
    fig_num = 47879;
    flag_make_new_plot = 1;
end


% Setup figures if there is debugging
if flag_do_debug
    fig_debug = 9999;
else
    fig_debug = []; %#ok<*NASGU>
end

flag_do_plots = 0;
if (0==flag_max_speed) && (5<= nargin)
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
% no calculations here

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

if flag_do_plots == 1
    % check that the figure has data
    figure(fig_num);
    temp_fig_handle = gcf;
    if isempty(temp_fig_handle.Children)
        flag_make_new_plot = 1;
    end

    % Check to see if we are forcing image alignment via Lat and Lon shifting,
    % when doing geoplot. This is added because the geoplot images are very, very
    % slightly off at the test track, which is confusing when plotting data
    % above them.
    offset_Lat = 0; % Default offset
    offset_Lon = 0; % Default offset
    MATLABFLAG_PLOTTESTTRACK_ALIGNMATLABLLAPLOTTINGIMAGES_LAT = getenv("MATLABFLAG_PLOTTESTTRACK_ALIGNMATLABLLAPLOTTINGIMAGES_LAT");
    MATLABFLAG_PLOTTESTTRACK_ALIGNMATLABLLAPLOTTINGIMAGES_LON = getenv("MATLABFLAG_PLOTTESTTRACK_ALIGNMATLABLLAPLOTTINGIMAGES_LON");
    if ~isempty(MATLABFLAG_PLOTTESTTRACK_ALIGNMATLABLLAPLOTTINGIMAGES_LAT) && ~isempty(MATLABFLAG_PLOTTESTTRACK_ALIGNMATLABLLAPLOTTINGIMAGES_LON)
        offset_Lat = str2double(MATLABFLAG_PLOTTESTTRACK_ALIGNMATLABLLAPLOTTINGIMAGES_LAT);
        offset_Lon  = str2double(MATLABFLAG_PLOTTESTTRACK_ALIGNMATLABLLAPLOTTINGIMAGES_LON);
    end

    if flag_make_new_plot
        %clf;
        % set up new plot, clear the figure, and initialize the


        % Plot the base station with a green star. This sets up the figure for
        % the first time, including the zoom into the test track area.

        reference_latitude = 40.86368573;
        reference_longitude = -77.83592832;
        reference_altitude = 344.189;

        h_geoplot = geoplot(reference_latitude+offset_Lat, reference_longitude+offset_Lon, '*','Color',[0 1 0],'Linewidth',3,'Markersize',10);
        h_parent =  get(h_geoplot,'Parent');
        set(h_parent,'ZoomLevel',16.375);
        try
            geobasemap satellite

        catch
            geobasemap openstreetmap
        end
        geotickformat -dd
        hold on
    end

    if flag_plot_data
        geoplot(data_to_plot(:,1)+offset_Lat,data_to_plot(:,2)+offset_Lon,'-','Color',color_to_plot,'Linewidth',1,'Markersize',20);
        %geoplot(data_to_plot(:,1)+offset_Lat,data_to_plot(:,2)+offset_Lon,'-','Color',color_to_plot,'Linewidth',1,'Markersize',20,'LineStyle', line_type);
        geoplot(data_to_plot(1,1)+offset_Lat, data_to_plot(1,2)+offset_Lon, 'o','Color',[0 1 0],'Linewidth',1,'Markersize',10);
        geoplot(data_to_plot(end,1)+offset_Lat, data_to_plot(end,2)+offset_Lon, 'x','Color',[1 0 0],'Linewidth',1,'Markersize',10);

        % Label the plots?
        if ~isempty(label_text)
            text(data_to_plot(1,1)+offset_Lat, data_to_plot(1,2)+offset_Lon,sprintf('%s',label_text),'Color',color_to_plot,'FontSize',14);
        end
    end
end
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