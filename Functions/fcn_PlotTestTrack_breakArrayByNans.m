%%  fcn_PlotTestTrack_breakArrayByNans
function indicies_cell_array = fcn_PlotTestTrack_breakArrayByNans(input_array)
% Finds sections of nan, and breaks indicies into segments of non-nan data,
% returning indicies of each segment
%
% FORMAT:
%
%       indicies_cell_array = fcn_PlotTestTrack_breakArrayByNans(input_array)
%
% INPUTS:
%
%       input_array: a matrix where some rows contain NaN values
%
% OUTPUTS:
%
%       indicies_cell_array: a cell array of indicies, one array for each
%       section of the matrix that is separated by NaN values
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
%       script_test_fcn_PlotTestTrack_breakArrayByNans.m for a full
%       test suite.
%
% This function was written on 2023_07_14 by S. Brennan
% Questions or comments? sbrennan@psu.edu


% Revision history:
% 2023_07_14 by S. Brennan
% -- start writing function
% 2024_07_17 - A. Kim
% -- Added improved debugging and input checking section

%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==1 && isequal(varargin{end},-1))
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
    narginchk(1,1);

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

N_points = length(input_array(:,1));
good_indicies = find(~isnan(input_array(:,1)));
if isempty(good_indicies)
    % There is nothing but Nans
    indicies_cell_array = {[]};
    return
elseif length(good_indicies)==1
    % Everything but 1 value is Nan
    indicies_cell_array = {good_indicies};
    return
else
    jumps = find(diff(good_indicies)>1);
    if isempty(jumps)
        % Good indicies strictly increasing
        indicies_cell_array = {good_indicies};
    else
        % Initialize the array
        indicies_cell_array{length(jumps)+1} = [];
        prior_value = 1;
        for ith_jump = 1:length(jumps)
            current_jump = jumps(ith_jump);
            current_value = good_indicies(current_jump);
            indicies_cell_array{ith_jump} = (prior_value:current_value)';
            next_good_index = find(good_indicies>good_indicies(current_jump),1);
            if ~isempty(next_good_index)
                prior_value = good_indicies(next_good_index);
            else
                % Shift it past the end
                prior_value = N_points+1;
            end
        end
        if prior_value<=good_indicies(end)
            indicies_cell_array{length(jumps)+1} = (prior_value:good_indicies(end))';
        else
            indicies_cell_array{length(jumps)+1} = [];
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

end % Ends main function for  fcn_PlotTestTrack_breakArrayByNans

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
