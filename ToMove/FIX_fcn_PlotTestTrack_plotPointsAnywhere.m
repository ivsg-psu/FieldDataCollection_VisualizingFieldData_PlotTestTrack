function [LLA_coordinates, ENU_coordinates]  = fcn_PlotTestTrack_plotPointsAnywhere(...
    initial_points, input_coordinates_type, varargin)
%% fcn_PlotTestTrack_plotPointsAnywhere
% Takes the input points in any format, LLA/ENU and plots them as
% points in all LLA and ENU coordinates if specified
%
% FORMAT:
%
%      [LLA_coordinates, ENU_coordinates]  = fcn_PlotTestTrack_plotPointsAnywhere(...
%       initial_points, input_coordinates_type, (base_station_coordinates,
%       plot_color, MarkerSize, LLA_fig_num, ENU_fig_num))
%
% INPUTS:
%
%      initial_points: a matrix of NX2 for LLA or ENU coordinates
%
%       input_coordinates_type = A string stating the type of
%       initial_points that have been the input. String can be "LLA" or
%       "ENU"
%
%      (OPTIONAL INPUTS)
%
%       base_station_coordinates: the reference latitude, reference
%       longitude and reference altitude for the base station that we can
%       use to convert ENU2LLA and vice-versa
%
%       plot_color: a color specifier such as [1 0 0] or 'r' indicating
%       what color the traces should be plotted
%
%       MarkerSize: the line width to plot the traces
%
%       LLA_fig_num: a figure number for the LLA plot
%
%       ENU_fig_num: a figure number for the ENU plot
%
% OUTPUTS:
%
%       (none)
%
% DEPENDENCIES:
%
%      fcn_plotRoad_breakArrayByNans
%
% EXAMPLES:
%
%       See the script:
%       script_test_fcn_PlotTestTrack_plotPointsAnywhere.m for a full
%       test suite.
%
% This function was written on 2024_07_01 by V. Wagh
% Questions or comments? vbw5054@psu.edu

% Revision history:
% 2024_03_23 by V. Wagh
% -- start writing function from fcn_PlotTestTrack_plotTraces


%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==8 && isequal(varargin{end},-1))
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
        narginchk(2,8);
    end
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
if 4 <= nargin % 4th variable input of the entire function
    temp = varargin{2}; % 2nd variable input of the optional inputs is assigned to the temp variable
    if ~isempty(temp) % if temp is not empty
        plot_color = temp; % make plot_color to be same as temp
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

flag_do_plots = 0;
if (0==flag_max_speed) && (7<= nargin)
    temp = varargin{end};
    temp2 = varargin{end-1};
    if ~isempty(temp)
        ENU_fig_num = temp;
        flag_do_plots = 1;
    end
    if ~isempty(temp2)
        LLA_fig_num = temp2;
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

% steps
% 1. if given trace coordinates are in LLA, convert to ENU
% if given trace coordinaes are in ENU, convert to LLA

% initializing empty arrays
LLA_coordinates = [];
ENU_coordinates =[];

% if given trace_coordinates are LLA coordinates
if input_coordinates_type == "LLA"

    LLA_coordinates = initial_points;

    % get ENU
    ENU_data_with_nan = [];
    [ENU_positions_cell_array, ~] = ...
        fcn_INTERNAL_prepDataForOutput(ENU_data_with_nan,initial_points,base_station_coordinates);

    ENU_coordinates = ENU_positions_cell_array{1};

elseif input_coordinates_type == "ENU"

    ENU_coordinates = initial_points;
    % get LLA
    LLA_data_with_nan = [];
    [~, LLA_positions_cell_array] = ...
        fcn_INTERNAL_prepDataForOutput(initial_points,LLA_data_with_nan,base_station_coordinates);

    LLA_coordinates = LLA_positions_cell_array{1};

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

% % Plot the inputs?
if flag_do_plots == 1
    % call a function to plot the points
    fcn_INTERNAL_plotSinglePoint(plot_color, MarkerSize, ...
        LLA_coordinates, ENU_coordinates, base_station_coordinates, ...
        LLA_fig_num, ENU_fig_num);
end
if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end

end % Ends main function for fcn_PlotTestTrack_plot

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

%% fcn_INTERNAL_plotSingleTrace
function fcn_INTERNAL_plotSinglePoint(plot_color, MarkerSize, ...
    LLA_coordinates, ENU_coordinates, base_station_coordinates, ...
    LLA_fig_num, ENU_fig_num)
nanArray = NaN(size(LLA_coordinates,1),1);

% LLA plot?
if exist('LLA_fig_num','var') && ~isempty(LLA_fig_num)
    if ~isempty(LLA_coordinates)

        f = figure(LLA_fig_num);
        %clf;
        hold on
        if f.Tag ~= "1"
            hold off
            h_geoplot = geoplot(base_station_coordinates(:,1), base_station_coordinates(:,2), '*','Color',[0 1 0],'Linewidth',3,'Markersize',10);
            h_parent =  get(h_geoplot,'Parent');
            set(h_parent);

            try
                geobasemap satellite

            catch
                geobasemap openstreetmap
            end
            geotickformat -dd
        end
        f.Tag = "1";

        hold on
    end

    gp = geoplot(nanArray(:),nanArray(:), '.','Color',plot_color,'Markersize',MarkerSize);

    set(gp,"XData",LLA_coordinates(:,1));
    set(gp,"YData",LLA_coordinates(:,2));
    title(sprintf('LLA Coordinates'));
end


% ENU plot?
if exist('ENU_fig_num','var') && ~isempty(ENU_fig_num)

    if ~isempty(ENU_coordinates)
        hold on;
        f = figure(ENU_fig_num);
        %clf;

        axis equal;
        p = plot(nanArray(:),nanArray(:),'.','Color',plot_color,'MarkerSize',MarkerSize);

        set(p,"XData",ENU_coordinates(:,1));
        set(p,"YData",ENU_coordinates(:,2));

        title(sprintf('ENU coordinates'));
    end
end

end % Ends fcn_INTERNAL_plotSingleTrace

%% fcn_INTERNAL_prepDataForOutput
function [ENU_positions_cell_array, LLA_positions_cell_array] = ...
    fcn_INTERNAL_prepDataForOutput(ENU_data_with_nan,LLA_data_with_nan,base_station_coordinates)
% This function breaks data into sub-arrays if separated by NaN, and as
% well fills in ENU data if this is empty via LLA data, or vice versa

% Prep for GPS conversions
% The true location of the track base station is [40.86368573°, -77.83592832°, 344.189 m].

gps_object = GPS(base_station_coordinates(1),base_station_coordinates(2),base_station_coordinates(3)); % Load the GPS class


if isempty(ENU_data_with_nan) && isempty(LLA_data_with_nan)
    error('At least one of the ENU or LLA data arrays must be filled.');
elseif isempty(ENU_data_with_nan)
    ENU_data_with_nan  = gps_object.WGSLLA2ENU(LLA_data_with_nan(:,1), LLA_data_with_nan(:,2), LLA_data_with_nan(:,3));
elseif isempty(LLA_data_with_nan)
    LLA_data_with_nan =  gps_object.ENU2WGSLLA(ENU_data_with_nan);
end


% The data passed in may be separated into sections, separated by NaN
% values. Here, we break them into sub-arrays
indicies_cell_array = fcn_plotRoad_breakArrayByNans(ENU_data_with_nan);
ENU_positions_cell_array{length(indicies_cell_array)} = {};
LLA_positions_cell_array{length(indicies_cell_array)} = {};
for ith_array = 1:length(indicies_cell_array)
    current_indicies = indicies_cell_array{ith_array};
    ENU_positions_cell_array{ith_array} = ENU_data_with_nan(current_indicies,:);
    LLA_positions_cell_array{ith_array} = LLA_data_with_nan(current_indicies,:);
end
end % Ends fcn_INTERNAL_prepDataForOutput


