function fcn_PlotTestTrack_plotTraces(...
    TraceNames,isPlotted, varargin)
%% fcn_PlotTestTrack_plotTraces
% Creates a plot of selected traces in either LLA, ENU, or STH-linear
% formats.
%
% FORMAT:
%
%       fcn_PlotTestTrack_plotTraces(...
%          TraceNames,isPlotted,...
%          plot_color,line_width,...
%          LLA_fig_num,ENU_fig_num,STH_fig_num,reference_unit_tangent_vector,...
%          flag_plot_headers_and_tailers, flag_plot_points);
%
% INPUTS:
%
%       TraceNames: a cell array of strings OR a structure containing the
%       fields:
%
%            Name - a string given to the trace name
%
%            LLA_positions_cell_array - a cell array of LLA positions
%
%            ENU_positions_cell_array - a cell array of ENU positions
%
%       NOTE: if a structure is given, then isPlotted is not used and
%       can be left empty.
% 
%       isPlotted: a matrix of flags of same length as TraceNames
%       indicating 1 if the data should be plotted, 0 if not.
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
% This function was written on 2023_08_13 by S. Brennan
% Questions or comments? sbrennan@psu.edu

% Revision history:
% 2023_08_13 by S. Brennan
% -- start writing function
% 2023_09_20 by S. Brennan
% -- modified to allow single traces to be passed
% -- fixed bug where only first trace is plotted in cell array in STH
% coordinates. Now, all traces are plotted.
% 2023_11_03 by S. Brennan
% -- added flag_plot_points option
% 2024_07_17 - A. Kim
% -- Added improved debugging and input checking section

%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==10 && isequal(varargin{end},-1))
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
    narginchk(1,10);

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
ENU_fig_num = []; % Default
if 6<= nargin
    temp = varargin{4};
    if ~isempty(temp)
        ENU_fig_num = temp;
    end
end

% Does user want to specify STH_fig_num?
STH_fig_num = []; % Default is to have no tape on top
if 7<= nargin
    temp = varargin{5};
    if ~isempty(temp)
        STH_fig_num = temp;
    end
end

hard_coded_reference_unit_tangent_vector_outer_lanes   = [0.793033249943519   0.609178351949592];
hard_coded_reference_unit_tangent_vector_LC_south_lane = [0.794630317120972   0.607093616431785];
reference_unit_tangent_vector = hard_coded_reference_unit_tangent_vector_LC_south_lane; % Initialize the reference vector
if 8 <= nargin
    temp = varargin{6};
    if ~isempty(temp)
        reference_unit_tangent_vector = temp;
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
    LLA_fig_num = figure;
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

if isstruct(TraceNames)
    fcn_INTERNAL_plotSingleTrace(TraceNames.Name, plot_color, line_width, ...
        TraceNames.LLA_positions_cell_array, TraceNames.ENU_positions_cell_array, ...
        LLA_fig_num, ENU_fig_num, STH_fig_num, reference_unit_tangent_vector, flag_plot_headers_and_tailers, flag_plot_points);
else
    narginchk(2,10);
    if length(TraceNames) ~= length(isPlotted)
        error('Mismatch between Tracenames length: %.0d and isPlotted length: %.0d... did the list change?',length(TraceNames),length(isPlotted));
    end

    N_Traces = length(TraceNames);
    for ith_trace = 1:N_Traces
        if isPlotted(ith_trace)
            trace_name = TraceNames{ith_trace};
            [LLA_positions_cell_array, ENU_positions_cell_array] = ...
                fcn_PlotTestTrack_loadTrace(trace_name);
            fcn_INTERNAL_plotSingleTrace(trace_name, plot_color, line_width, ...
                LLA_positions_cell_array, ENU_positions_cell_array, ...
                LLA_fig_num, ENU_fig_num, STH_fig_num, reference_unit_tangent_vector, flag_plot_headers_and_tailers, flag_plot_points);
        end
    end
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
% if flag_do_plots
% 
%     
%     % Nothing to do here!
% end

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
function fcn_INTERNAL_plotSingleTrace(trace_name,  plot_color, line_width, ...
    LLA_positions_cell_array, ENU_positions_cell_array, ...
    LLA_fig_num, ENU_fig_num, STH_fig_num, reference_unit_tangent_vector, flag_plot_headers_and_tailers, flag_plot_points)

% LLA plot?
if exist('LLA_fig_num','var') && ~isempty(LLA_fig_num)
    if iscell(LLA_positions_cell_array)
        if ~isempty(LLA_positions_cell_array{1})
            fcn_PlotTestTrack_plotTraceLLA(LLA_positions_cell_array,plot_color,line_width, flag_plot_headers_and_tailers, flag_plot_points, LLA_fig_num);
            title(sprintf('LLA Trace geometry for trace name %s',trace_name),'Interpreter','none');
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
            title(sprintf('ENU Trace geometry for trace name %s', trace_name),'Interpreter','none');
        end
    else
        error('Expecting a cell array for ENU data')
    end
end

% STH plot?
if exist('STH_fig_num','var') && ~isempty(STH_fig_num) && exist('reference_unit_tangent_vector','var') && ~isempty(reference_unit_tangent_vector)
    for ith_array = 1:length(ENU_positions_cell_array)
        if ~isempty(ENU_positions_cell_array{ith_array})
            ST_positions = fcn_PlotTestTrack_convertXYtoST(ENU_positions_cell_array{ith_array}(:,1:2),reference_unit_tangent_vector);
            fcn_PlotTestTrack_plotTraceENU(ST_positions,plot_color,line_width, flag_plot_headers_and_tailers, flag_plot_points, STH_fig_num);
            title(sprintf('STH Trace geometry for trace name %s', trace_name),'Interpreter','none');
        end
    end
end

end % Ends fcn_INTERNAL_plotSingleTrace

