function [LLA_trace, ENU_trace, STH_trace]  = fcn_PlotTestTrack_plotTraces(...
    Trace_coordinates, input_coordinates_type, varargin)
%% fcn_PlotTestTrack_plotTraces
% Creates a plot of entered traces in either LLA, ENU, or STH-linear
% Creates a plot of selected traces in either LLA, ENU, or STH-linear
% formats.
%
% FORMAT:
%
%       fcn_PlotTestTrack_plotTraces(...
%          Trace_coordinates, input_coordinates_type,...
%          (plot_color,line_width,...
%          LLA_fig_num,ENU_fig_num,STH_fig_num,reference_unit_tangent_vector,...
%          flag_plot_headers_and_tailers, flag_plot_points));
%
% INPUTS:
%
%       Trace_coordinates: a matrix of Nx2 or Nx3 containing the LLA or ENU
%       or STH coordinates of the trace that is to be plotted
%       TraceNames: a cell array of strings OR a structure containing the
%       fields:
%
%       input_coordinates_type = A string stating the type of
%       Trace_coordinates that have been the input. String can be "LLA" or
%       "ENU" or "STH".
%
%      (OPTIONAL INPUTS)
%
%       plot_color: a color specifier such as [1 0 0] or 'r' indicating
%       what color the traces should be plotted
%
%       line_width: the line width to plot the traces
%
%       LLA_fig_num: a figure number for the LLA plot
%
%       ENU_fig_num: a figure number for the ENU plot
%
%       STH_fig_num: a figure number for the STH plot
%
%       reference_unit_tangent_vector: the reference vector for the STH
%       coordinate frame to use for STH plotting
%
%       flag_plot_headers_and_tailers: set to 1 to plot the head/tail of
%       the trace (default), and 0 to just plot the entire trace alone
%
%       flag_plot_points: set to 1 to plot the points as color-enclosed
%       circles (default), and 0 to plot just the line portion without
%       points.
%
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
%       script_test_fcn_PlotTestTrack_plotTraces.m for a full
%       test suite.
%
% This function was written on 2024_03_23 by V. Wagh
% Questions or comments? vbw5054@psu.edu

% Revision history:
% 2024_03_23 by V. Wagh
% -- start writing function from fcn_LoadWZ_plotTrace
% 2024_03_28 by V.Wagh
% -- added warning to ask user for unit vector for STH coordinates
% -- changed the name of the function and the script

%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==10 && isequal(varargin{end},-1))
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
    if flag_check_inputs == 11
        % Are there the right number of inputs?
        narginchk(2,10);
    end
end

% Does user want to specify plot_color?
plot_color = [1 0 1]; % Default
if 3 <= nargin
    temp = varargin{1};
    if ~isempty(temp)
        plot_color = temp;
    end
end

% Does user want to specify line_width?
line_width = 3; % Default
if 4<= nargin
    temp = varargin{2};
    if ~isempty(temp)
        line_width = temp;
    end
end

% Does user want to specify LLA_fig_num?
LLA_fig_num = []; % Default
if 5<= nargin
    temp = varargin{3};
    if ~isempty(temp)
        LLA_fig_num = temp;
    end
end

% Does user want to specify ENU_fig_num?
ENU_fig_num = []; % Default is do not plot
if 6<= nargin
    temp = varargin{4};
    if ~isempty(temp)
        ENU_fig_num = temp;
    end
end

% Does user want to specify STH_fig_num?
STH_fig_num = []; % Default is do not plot
if 7<= nargin
    temp = varargin{5};
    if ~isempty(temp)
        STH_fig_num = temp;
    end
end

hard_coded_reference_unit_tangent_vector_outer_lanes   = [0.793033249943519   0.609178351949592];
hard_coded_reference_unit_tangent_vector_LC_south_lane = [0.794630317120972   0.607093616431785];
STH_vector = [];
reference_unit_tangent_vector = hard_coded_reference_unit_tangent_vector_LC_south_lane; % Initialize the reference vector
if 8 <= nargin
    temp = varargin{6};
    if ~isempty(STH_vector)
        reference_unit_tangent_vector = temp;
    else
        reference_unit_tangent_vector = hard_coded_reference_unit_tangent_vector_LC_south_lane; % Initialize the reference vector
    end
end

% Does user want to specify flag_plot_headers_and_tailers?
flag_plot_headers_and_tailers   = 1;
if 9 <= nargin
    temp = varargin{7};
    if ~isempty(temp)
        flag_plot_headers_and_tailers = temp;
    end
end

% Does user want to specify flag_plot_headers_and_tailers?
flag_plot_points   = 1;
if 10 <= nargin
    temp = varargin{8};
    if ~isempty(temp)
        flag_plot_points = temp;
    end
end


% If all are empty, default to LLA
if isempty(LLA_fig_num) && isempty(ENU_fig_num) && isempty(STH_fig_num)
    LLA_fig_num = 678532;
end

% Setup figures if there is debugging
if flag_do_debug
    fig_debug = 9999;
else
    fig_debug = []; %#ok<*NASGU>
end

flag_do_plots = 0;
if (0==flag_max_speed) && (10<= nargin)
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

% steps
% 1. if given trace coordinates are in LLA, convert to ENU and STH
% if given trace coordinaes are in ENU, convert to LLA and STH
% if given trace coordinates are in STH, convert to ENU and LLA

% initializing empty arrays
LLA_trace = [];
ENU_trace =[];
STH_trace = [];

% if given trace_coordinates are LLA coordinates
if input_coordinates_type == "LLA"

    LLA_trace = Trace_coordinates;

    % get ENU
    ENU_data_with_nan = [];
    [ENU_positions_cell_array, LLA_positions_cell_array] = ...
        fcn_INTERNAL_prepDataForOutput(ENU_data_with_nan,Trace_coordinates);

    ENU_trace = ENU_positions_cell_array{1};

    % get STH
    for ith_array = 1:length(ENU_positions_cell_array)
        if ~isempty(ENU_positions_cell_array{ith_array})
            ST_positions = fcn_PlotTestTrack_convertXYtoST(ENU_positions_cell_array{ith_array}(:,1:2),reference_unit_tangent_vector);
            STH_trace = ST_positions;
        end
    end

elseif input_coordinates_type == "ENU"

    ENU_trace = Trace_coordinates;
    % get LLA
    LLA_data_with_nan = [];
    [ENU_positions_cell_array, LLA_positions_cell_array] = ...
        fcn_INTERNAL_prepDataForOutput(Trace_coordinates,LLA_data_with_nan);

    LLA_trace = LLA_positions_cell_array;

    % get STH
    for ith_array = 1:length(ENU_positions_cell_array)
        if ~isempty(ENU_positions_cell_array{ith_array})
            ST_positions = fcn_PlotTestTrack_convertXYtoST(ENU_positions_cell_array{ith_array}(:,1:2),reference_unit_tangent_vector);
            STH_trace = ST_positions;
        end
    end

elseif input_coordinates_type == "STH"

    STH_trace = Trace_coordinates;

    % find ENU coordinates from ST coordiantes
    ENU_trace = fcn_PlotTestTrack_convertSTtoXY(STH_trace(:,1:2),reference_unit_tangent_vector);

    % find LLA
    ENU_trace_3_cols = [ENU_trace ENU_trace(:,1)*0];
    LLA_data_with_nan = [];
    [ENU_positions_cell_array, LLA_positions_cell_array] = ...
        fcn_INTERNAL_prepDataForOutput(ENU_trace_3_cols,LLA_data_with_nan);

    LLA_trace = LLA_positions_cell_array{1};

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

    % call a function to plot the traces
    fcn_INTERNAL_plotSingleTrace(plot_color, line_width, ...
        LLA_positions_cell_array, ENU_positions_cell_array, ...
        LLA_fig_num, ENU_fig_num, STH_fig_num, reference_unit_tangent_vector, flag_plot_headers_and_tailers, flag_plot_points);
end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end

end % Ends main function for fcn_PlotTestTrack_plotTraces

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
function fcn_INTERNAL_plotSingleTrace(plot_color, line_width, ...
    LLA_positions_cell_array, ENU_positions_cell_array, ...
    LLA_fig_num, ENU_fig_num, STH_fig_num, STH_vector, flag_plot_headers_and_tailers, flag_plot_points)

% LLA plot?
if exist('LLA_fig_num','var') && ~isempty(LLA_fig_num)
    if iscell(LLA_positions_cell_array)
        if ~isempty(LLA_positions_cell_array{1})
            fcn_PlotTestTrack_plotTraceLLA(LLA_positions_cell_array,plot_color,line_width, flag_plot_headers_and_tailers, flag_plot_points, LLA_fig_num);
            title(sprintf('LLA Trace geometry'));
        end
    else
        error('Expecting a cell array for LLA data')
    end
end

% ENU plot?
if exist('ENU_fig_num','var') && ~isempty(ENU_fig_num)
    if iscell(ENU_positions_cell_array)
        if ~isempty(ENU_positions_cell_array{1})
            fcn_PlotTestTrack_plotTraceENU(ENU_positions_cell_array,plot_color,line_width, flag_plot_headers_and_tailers, flag_plot_points, ENU_fig_num);
            title(sprintf('ENU Trace geometry'));
        end
    else
        error('Expecting a cell array for ENU data')
    end
end

% STH plot?

% tell the user that if they do not enter a reference_unit_tangent_vector
% then the default will be used
if exist('STH_fig_num','var') && ~isempty(STH_fig_num) && isempty(STH_vector)
    warning(['You have not entered a unit vector for plotting the STH coordinates, ' ...
        'so the default unit_vector is used.' ...
        'The deafult unit vector is for the ' ...
        'hard_coded_reference_unit_tangent_vector_LC_south_lane ' ...
        '= [0.794630317120972   0.607093616431785];'])
end

if exist('STH_fig_num','var') && ~isempty(STH_fig_num) && exist('reference_unit_tangent_vector','var') && ~isempty(reference_unit_tangent_vector)
    for ith_array = 1:length(ENU_positions_cell_array)
        if ~isempty(ENU_positions_cell_array{ith_array})
            ST_positions = fcn_PlotTestTrack_convertXYtoST(ENU_positions_cell_array{ith_array}(:,1:2),reference_unit_tangent_vector);
            fcn_PlotTestTrack_plotTraceENU(ST_positions,plot_color,line_width, flag_plot_headers_and_tailers, flag_plot_points, STH_fig_num);
            title(sprintf('STH Trace geometry'));
            STH_trace = ST_positions;
        end
    end
end

end % Ends fcn_INTERNAL_plotSingleTrace

%% fcn_INTERNAL_prepDataForOutput
function [ENU_positions_cell_array, LLA_positions_cell_array] = ...
    fcn_INTERNAL_prepDataForOutput(ENU_data_with_nan,LLA_data_with_nan)
% This function breaks data into sub-arrays if separated by NaN, and as
% well fills in ENU data if this is empty via LLA data, or vice versa

% Prep for GPS conversions
% The true location of the track base station is [40.86368573°, -77.83592832°, 344.189 m].
reference_latitude = 40.86368573;
reference_longitude = -77.83592832;
reference_altitude = 344.189;
gps_object = GPS(reference_latitude,reference_longitude,reference_altitude); % Load the GPS class


if isempty(ENU_data_with_nan) && isempty(LLA_data_with_nan)
    error('At least one of the ENU or LLA data arrays must be filled.');
elseif isempty(ENU_data_with_nan)
    ENU_data_with_nan  = gps_object.WGSLLA2ENU(LLA_data_with_nan(:,1), LLA_data_with_nan(:,2), LLA_data_with_nan(:,3));
elseif isempty(LLA_data_with_nan)
    LLA_data_with_nan =  gps_object.ENU2WGSLLA(ENU_data_with_nan');
end


% The data passed in may be separated into sections, separated by NaN
% values. Here, we break them into sub-arrays
indicies_cell_array = fcn_PlotTestTrack_breakArrayByNans(ENU_data_with_nan);
ENU_positions_cell_array{length(indicies_cell_array)} = {};
LLA_positions_cell_array{length(indicies_cell_array)} = {};
for ith_array = 1:length(indicies_cell_array)
    current_indicies = indicies_cell_array{ith_array};
    ENU_positions_cell_array{ith_array} = ENU_data_with_nan(current_indicies,:);
    LLA_positions_cell_array{ith_array} = LLA_data_with_nan(current_indicies,:);
end
end % Ends fcn_INTERNAL_prepDataForOutput