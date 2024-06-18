function fcn_LoadWZ_plotTraceENU(ENU_data, varargin)
%% fcn_LoadWZ_plotTraceENU
% Plots trace of ENU data via plot.
%
% FORMAT:
%
%       fcn_LoadWZ_plotTraceENU(ENU_data,(plot_color),(fig_num))
%
% INPUTS:
%
%      (MANDATORY INPUTS)
%
%       ENU_data: a NX2 vector of [X Y] data for the lane marker positions
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
%       script_test_fcn_LoadWZ_plotTraceENU.m for a full
%       test suite.
%
% This function was written on 2023_07_25 by S. Brennan
% Questions or comments? sbrennan@psu.edu


% Revision history:
% 2023_07_25 by S. Brennan, sbrennan@psu.edu
% -- start writing function


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


% Prep a figure
figure(fig_num);


% Set background to near-black?
h_axis = gca;
if isempty(h_axis.Children)
    set(gca,'Color',[1 1 1]*0.4);
    grid on;
    set(gca,'GridColor', [1 1 1]*0.85);

    axis equal
    hold on;

    % Plot the base station with a green star
    plot(0, 0, '*','Color',[0 1 0],'Linewidth',line_width,'Markersize',15);
end


% Plot ENU results as cell?
if iscell(ENU_data)
    for ith_data = 1:length(ENU_data)
        ENU_data_to_plot = ENU_data{ith_data};
        fcn_INTERNAL_plotData(ENU_data_to_plot,plot_color,line_width,flag_plot_headers_and_tailers, flag_plot_points)
    end
else
    fcn_INTERNAL_plotData(ENU_data,plot_color,line_width,flag_plot_headers_and_tailers, flag_plot_points);
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

%% fcn_INTERNAL_plotData
function fcn_INTERNAL_plotData(ENU_data_to_plot,plot_color,line_width,flag_plot_headers_and_tailers, flag_plot_points)

if ~isempty(ENU_data_to_plot)
    sizeOfMarkers = 10;
    plot(ENU_data_to_plot(:,1),ENU_data_to_plot(:,2), '-','Color',plot_color,'Linewidth',line_width,'Markersize',sizeOfMarkers);

    % Plot the points?
    if flag_plot_points
        plot(ENU_data_to_plot(:,1),ENU_data_to_plot(:,2), '.','Color',plot_color,'Linewidth',line_width,'Markersize',round(sizeOfMarkers*2));
        plot(ENU_data_to_plot(:,1),ENU_data_to_plot(:,2), '.','Color',[0 0 0],'Linewidth',line_width,'Markersize',round(sizeOfMarkers*0.5));
    end

    % Plot headers and tailers?
    if flag_plot_headers_and_tailers
        if length(ENU_data_to_plot(:,1))>4
            plot(ENU_data_to_plot(1,1),ENU_data_to_plot(1,2), 'o','Color',[0 1 0],'Linewidth',line_width,'Markersize',sizeOfMarkers);
            plot(ENU_data_to_plot(end,1),ENU_data_to_plot(end,2), 'x','Color',[1 0 0],'Linewidth',line_width,'Markersize',sizeOfMarkers);

            % Plot green headers
            plot(ENU_data_to_plot(1:2,1),ENU_data_to_plot(1:2,2), '-','Color',[0 1 0],'Linewidth',line_width,'Markersize',sizeOfMarkers);

            % Plot red tailers
            plot(ENU_data_to_plot(end-1:end,1),ENU_data_to_plot(end-1:end,2), '-','Color',[1 0 0],'Linewidth',line_width,'Markersize',sizeOfMarkers);
        else

            % Plot green headers - calculated from vector direction
            vector_direction_start = ENU_data_to_plot(2,1:2) - ENU_data_to_plot(1,1:2);
            start_length = sum(vector_direction_start.^2,2).^0.5;
            unit_vector_direction_start = vector_direction_start./start_length;
            max_length = min(10,start_length*0.2);
            offset_start = ENU_data_to_plot(1,1:2) + max_length*unit_vector_direction_start;
            ENU_vector = [ENU_data_to_plot(1,1:2) 0; offset_start, 0];
            plot(ENU_vector(:,1),ENU_vector(:,2), '-','Color',[0 1 0],'Linewidth',3,'Markersize',sizeOfMarkers);

            % Plot red tailers - calculated from vector direction
            vector_direction_end = (ENU_data_to_plot(end,1:2) - ENU_data_to_plot(end-1,1:2));
            end_length = sum(vector_direction_end.^2,2).^0.5;
            unit_vector_direction_end = vector_direction_end./end_length;
            max_length = min(10,end_length*0.2);
            offset_end = ENU_data_to_plot(end,1:2) - max_length*unit_vector_direction_end;
            ENU_vector = [offset_end, 0; ENU_data_to_plot(end,1:2) 0];
            plot(ENU_vector(:,1),ENU_vector(:,2), '-','Color',[1 0 0],'Linewidth',3,'Markersize',sizeOfMarkers);


            plot(ENU_data_to_plot(1,1),ENU_data_to_plot(1,2), 'o','Color',[0 1 0],'Linewidth',line_width,'Markersize',sizeOfMarkers);
            plot(ENU_data_to_plot(end,1),ENU_data_to_plot(end,2), 'x','Color',[1 0 0],'Linewidth',line_width,'Markersize',sizeOfMarkers);
        end
    end
end
end % Ends fcn_INTERNAL_plotData
