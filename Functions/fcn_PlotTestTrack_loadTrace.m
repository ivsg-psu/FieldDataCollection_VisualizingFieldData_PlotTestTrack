function [LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_PlotTestTrack_loadTrace(LaneIdentifier, varargin)
%% fcn_PlotTestTrack_loadTrace
% Loads the coordinates of traces in ENU and LLA formats,
% saving cluster as a cell array
%
% FORMAT:
%
%     [LLA_positions_cell_array, ENU_positions_cell_array] = ...
%         fcn_PlotTestTrack_loadTrace(LaneIdentifier,(plot_color),(line_width),(fig_num))
%
% INPUTS:
%
%      LaneIdentifier: an identifier for the lane to be loaded. This can
%      be requested either as a string matching one of the lane
%      names, or an integer representing the trace corresponding
%      to existing names.
%
%      (OPTIONAL INPUTS)
%
%      flag_bypass_full_load: set this flag to 1  to bypass the full
%      loading of all data into memory, which is slow and makes debugging
%      difficult. Defaults is 0, to load all data into memory.
%
%      plot_color: the color to plot the data (default is cyan)
%
%      line_width: the line width to use (default is 0.5)
%
%      fig_num: a figure number to plot result
%
% OUTPUTS:
%
%      LLA and ENU cell arrays: The cell array stores one matrix per lane
%      stripe, with each matrix in Nx3 format, [x y z] that denotes the
%      lane geometry. Note that a lane geometry is a cell array, as some
%      lanes will start and stop at different areas. Each area is a
%      separate array of data.
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
%       script_test_fcn_PlotTestTrack_loadTrace for a full
%       test suite.
%
% This function was written on 2023_08_22 by S. Brennan
% Questions or comments? sbrennan@psu.edu


% Revision history:
% 2023_08_22 by S. Brennan
% -- start writing function, converted fcn_PlotTestTrack_loadLaneMarkerCoords
% 2023_09_08 by S. Brennan
% -- added missing traces for detour area, aligned versions, stop
% lines, etc.
% -- renamed data file to be AllTracesData.mat instead of AllLaneMarkerData.mat
% 2023_09_12
% -- updated all traces for offsets error
% 2023_09_15
% -- corrected the header comments
% 2023_09_24
% -- added check function to make sure trace is well-formed
% -- fixed roughly 5 traces that were in error.
% 2023_09_30 - S. Brennan
% -- Added OuterTrack start and finish lines
% 2023_10_02 - S. Brennan
% -- added flag_bypass_full_load to enable direct loading of individual data
% 2023_10_21 - S. Brennan
% -- added StopLine_BetweenNewLine2AndNewLine3SolidWhite
% 2024_01_30 - S. Brennan
% -- removed references to Marker Clusters in names of functions and
% variables

% To Do:
% 2023_08_20 by V.Wagh
% -- measure and add Detour Stop Lines and Handling Area Detour Lines (end at
% gravel)

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
    narginchk(1,5);

end

% Did user specify flag_bypass_full_load?
flag_bypass_full_load = 0;
if 2 <= nargin
    temp = varargin{1};
    if ~isempty(temp)
        flag_bypass_full_load = temp;
    end
end

% Did user specify plot_color?
plot_color = [1 0 1]; % Default is to not do any plotting
if 3 <= nargin
    temp = varargin{2};
    if ~isempty(temp)
        plot_color = temp;
    end
end


% Did user specify line_width?
line_width = 0.5;
if 4 <= nargin
    temp = varargin{3};
    if ~isempty(temp)
        line_width = temp;
    end
end

% Did user specify fig_num?
flag_do_plots = 0; % Default is to not do any plotting
if 5 == nargin
    temp = varargin{end};
    if ~isempty(temp)
        fig_num = temp;
        flag_do_plots = 1;
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


persistent permanent_TraceNames permanent_TraceLocations_ENU permanent_TraceLocations_LLA permanent_file_date

TraceNames = [fcn_PlotTestTrack_nameTraces(1) fcn_PlotTestTrack_nameTraces];

if ischar(LaneIdentifier) && ~any(strcmp(TraceNames,LaneIdentifier))
    error('Unknown LaneIdentifier string: %s\n',LaneIdentifier);
end

if flag_bypass_full_load

    % Grab one string of corresponding data based on the string
    [ENU_positions_cell_array, LLA_positions_cell_array] = fcn_INTERNAL_loadTraceData(LaneIdentifier);

    % For the cell arrays, need to pull the array back out one level as
    % entire array saved into one cell. Or, may need to convert raw matrix
    % into cell array
    if ~iscell(LLA_positions_cell_array)
        LLA_positions_cell_array = {LLA_positions_cell_array};
        ENU_positions_cell_array = {ENU_positions_cell_array};
    elseif iscell(LLA_positions_cell_array{1})
        LLA_positions_cell_array = LLA_positions_cell_array{1};
        ENU_positions_cell_array = ENU_positions_cell_array{1};

    end
else
    % Need to load everything into memory

    % Check to see if data was loaded earlier
    mat_filename = fullfile(cd,'Data','AllTracesData.mat'); %%%% not loading centerline data

    flag_load_all_data = 0; % Default value
    if isempty(permanent_TraceNames) || isempty(permanent_TraceLocations_ENU) || isempty(permanent_TraceLocations_LLA) || isempty(permanent_file_date)

        % Does the file exist?
        if exist(mat_filename,'file')
            load(mat_filename,'permanent_TraceLocations_ENU','permanent_TraceLocations_LLA','permanent_TraceNames','permanent_file_date');
        else
            % File does not exist - need to load it
            flag_load_all_data = 1;
        end
    end


    % Does the data match?
    if ~isempty(permanent_TraceNames)
        if ~isequal(TraceNames,permanent_TraceNames)
            flag_load_all_data = 1;
        end

        % Check the file's date of creation - if it doesn't match, the file has
        % been edited and needs to be reloaded
        st = dbstack;
        this_function = st(1).file;
        file_info = dir(which(this_function));
        file_date = file_info.date;

        if ~exist('permanent_file_date','var') || ~strcmp(file_date,permanent_file_date)
            flag_load_all_data = 1;
        end

    else
        flag_load_all_data = 1;
    end

    if flag_load_all_data

        % Load the data from scratch
        [permanent_TraceLocations_ENU,permanent_TraceLocations_LLA, permanent_TraceNames] = fcn_INTERNAL_loadAllTracesData;

        % Grab the file's date of creation
        st = dbstack;
        this_function = st(1).file;
        file_info = dir(which(this_function));
        permanent_file_date = file_info.date;

        % Save the results
        save(mat_filename,'permanent_TraceLocations_ENU','permanent_TraceLocations_LLA','permanent_TraceNames','permanent_file_date');

    end

    %% Determine which specific trace the user wants
    [TraceNameString, ~] = fcn_INTERNAL_extractTraceSearchString(LaneIdentifier, permanent_TraceNames, length(permanent_TraceNames));


    % Find the index
    index_data = find(strcmp(permanent_TraceNames,TraceNameString));

    if ~isempty(index_data)
        LLA_positions_cell_array = permanent_TraceLocations_LLA{index_data};
        ENU_positions_cell_array = permanent_TraceLocations_ENU{index_data};

        % For the cell arrays, need to pull the array back out one level as
        % entire array saved into one cell.
        if iscell(LLA_positions_cell_array{1})
            LLA_positions_cell_array = LLA_positions_cell_array{1};
            ENU_positions_cell_array = ENU_positions_cell_array{1};
        end
    else
        error('Unrecognized trace string: %s', TraceNameString);
    end
end % Ends if flag_bypass_full_load

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

    % Plot LLA results
    flag_plot_headers_and_tailers = 1;
    flag_plot_points = 1;
    fcn_PlotTestTrack_plotTraceLLA(LLA_positions_cell_array,plot_color,line_width, flag_plot_headers_and_tailers, flag_plot_points, fig_num);

    % Add text label, plot data, etc?
    if ~flag_bypass_full_load
        traceNumber = find(contains(permanent_TraceNames,TraceNameString),1,'first');
        if iscell(LLA_positions_cell_array)
            location = LLA_positions_cell_array{1}(1,1:2);
        else
            location = LLA_positions_cell_array(1,1:2);
        end
        nudge = 0.000002;
        temp_h = text(location(1),location(2)+nudge,sprintf('%.0d',traceNumber),'Color',[0 1 0],'FontSize',12,'FontWeight','bold');

        % ADD SMART DATA CURSORS - THIS REQUIRES ANOTHER FUNCTION AND LOTS OF
        % SETUP
        % List all the data inside the plot, with the trace number
        all_data = get(gcf,'UserData');
        if iscell(LLA_positions_cell_array)
            for ith_data = 1:length(LLA_positions_cell_array)
                ones_vector = ones(length(LLA_positions_cell_array{ith_data}(:,1)),1);
                index_vector = (1:length(LLA_positions_cell_array{ith_data}(:,1)))';
                all_data = [all_data; LLA_positions_cell_array{ith_data}(:,1:2) ENU_positions_cell_array{ith_data}(:,1:2) ones_vector*traceNumber index_vector]; %#ok<AGROW>
            end
        else
            ones_vector = ones(length(LLA_positions_cell_array(:,1)),1);
            index_vector = (1:length(LLA_positions_cell_array(:,1)))';
            all_data = [all_data; LLA_positions_cell_array(:,1:2) ENU_positions_cell_array(:,1:2) ones_vector*traceNumber index_vector];
        end
        set(gcf,'UserData',all_data);

        % Add data cursor
        % See also: https://www.mathworks.com/help/matlab/ref/matlab.graphics.shape.internal.datacursormanager.html

        dcm = datacursormode;
        dcm.Enable = 'off';
        dcm.Interpreter = 'none';
        dcm.UpdateFcn = @fcn_PlotTestTrack_plotShowDataTrace;
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


%% fcn_INTERNAL_loadAllTracesData
function [permanent_TraceLocations_ENU, permanent_TraceLocations_LLA, permanent_TraceNames] = fcn_INTERNAL_loadAllTracesData

permanent_TraceNames = [fcn_PlotTestTrack_nameTraces(1) fcn_PlotTestTrack_nameTraces];


% Loop through names
N_Traces = length(permanent_TraceNames);
permanent_TraceLocations_ENU{N_Traces} = {};
permanent_TraceLocations_LLA{N_Traces} = {};

fprintf(1,'\nLoading all Traces into memory (done once, or whenever trace data is changed):\n')
for ith_name = 1:N_Traces
    LaneIdentifier = permanent_TraceNames{ith_name};

    fprintf(1,'\tLoading trace (%.0d of %.0d): %s\n',ith_name,N_Traces,LaneIdentifier)

    % Grab the corresponding data based on the string
    [ENU_positions_cell_array, LLA_positions_cell_array] = fcn_INTERNAL_loadTraceData(LaneIdentifier);

    % Fill in array
    permanent_TraceLocations_ENU{ith_name} = {ENU_positions_cell_array};
    permanent_TraceLocations_LLA{ith_name} = {LLA_positions_cell_array};

end % Ends looping through all the clusters
end % Ends fcn_INTERNAL_loadAllTracesData

%% fcn_INTERNAL_extractTraceSearchString
function [TraceSearchString, flag_extract_submatrix, sub_matrix_index] = fcn_INTERNAL_extractTraceSearchString(LaneIdentifier, AllTraceNames, N_MarkerClusters)
% Determine which specific trace the user wants
% Check the LaneIdentifier to see if it is a string or integer
if ~ischar(LaneIdentifier)
    % If it is not a string, is it within the right range?
    Trace_integer = round(LaneIdentifier);
    if Trace_integer<1 || Trace_integer>N_MarkerClusters
        error('The trace identifier: %.0d is not in expected range of: 1 to %.0d',Trace_integer,N_MarkerClusters);
    end
    CurrentTraceString = AllTraceNames{Trace_integer};
else
    CurrentTraceString = LaneIdentifier;
end

% Check if the name ends in an integer - if so, then we need to load the
% Trace and give ONLY the requested matrix. The end character will
% be separated by an underscore, so we partition the string using regular
% expression function, regexp:

string_parts = regexp(CurrentTraceString, '_','split');
% First part is major region
% Second part is general location
% Third part is specific trace cluster
% Fourth part is line type and color
% Last part, if there, is sub-matrix
sub_matrix_index = str2double(string_parts{end});

flag_extract_submatrix = 0;
if ~isnan(sub_matrix_index)
    % A number was found at the end of the string - so need to
    % reconstruct the string for searching.

    flag_extract_submatrix = 1;
    TraceSearchString = string_parts{1};
    if length(string_parts)>=3
        for ith_part = 2:(length(string_parts)-1)
            TraceSearchString = cat(2,TraceSearchString,'_',string_parts{ith_part});
        end
    end
else
    % No number found at end of string, just search
    TraceSearchString = CurrentTraceString;
end
end % Ends fcn_INTERNAL_extractTraceSearchString

%% fcn_INTERNAL_loadTraceData
function [ENU_positions_cell_array, LLA_positions_cell_array] = fcn_INTERNAL_loadTraceData(LaneIdentifier)

% Pull out the search string
[TraceSearchString, flag_extract_submatrix, sub_matrix_index] = fcn_INTERNAL_extractTraceSearchString(LaneIdentifier);


% Prep for GPS conversions
% The true location of the track base station is [40.86368573°, -77.83592832°, 344.189 m].
reference_latitude = 40.86368573;
reference_longitude = -77.83592832;
reference_altitude = 344.189;
gps_object = GPS(reference_latitude,reference_longitude,reference_altitude); % Load the GPS class



% Grab the corresponding data based on the string
switch TraceSearchString

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    %   ______ _      _     _    __  __                                                    _
    %  |  ____(_)    | |   | |  |  \/  |                                                  | |
    %  | |__   _  ___| | __| |  | \  / | ___  __ _ ___ _   _ _ __ ___ _ __ ___   ___ _ __ | |_ ___
    %  |  __| | |/ _ \ |/ _` |  | |\/| |/ _ \/ _` / __| | | | '__/ _ \ '_ ` _ \ / _ \ '_ \| __/ __|
    %  | |    | |  __/ | (_| |  | |  | |  __/ (_| \__ \ |_| | | |  __/ | | | | |  __/ | | | |_\__ \
    %  |_|    |_|\___|_|\__,_|  |_|  |_|\___|\__,_|___/\__,_|_|  \___|_| |_| |_|\___|_| |_|\__|___/
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



    case 'FieldMeasurements_OriginalTrackLane_OuterMarkerClusterSolidWhite'
        load ENU_OuterLane_SolidWhiteLine_2023_07_20.mat ENU_OuterLane_SolidWhiteLine_2023_07_20;
        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            ENU_OuterLane_SolidWhiteLine_2023_07_20,...
            []);

    case 'FieldMeasurements_OriginalTrackLane_InnerMarkerClusterOuterDoubleYellow'
        % Fixed on 2023_09_08 by S. Brennan - a point was out of order
        % Fixed on 2023_09_12 - another point was out of order
        load ENU_OuterLane_DoubleYellow_Outer_2023_07_20.mat ENU_OuterLane_DoubleYellow_Outer_2023_07_20;
        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            ENU_OuterLane_DoubleYellow_Outer_2023_07_20,...
            []);

    case 'FieldMeasurements_OriginalTrackLane_InnerMarkerClusterCenterDoubleYellow'
        load ENU_OuterLane_DoubleYellow_Center_2023_07_20.mat ENU_OuterLane_DoubleYellow_Center_2023_07_20;
        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            ENU_OuterLane_DoubleYellow_Center_2023_07_20,...
            []);

    case 'FieldMeasurements_OriginalTrackLane_InnerMarkerClusterInnerDoubleYellow'
        load ENU_OuterLane_DoubleYellow_Inner_2023_07_20.mat ENU_OuterLane_DoubleYellow_Inner_2023_07_20;
        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            ENU_OuterLane_DoubleYellow_Inner_2023_07_20,...
            []);

    case 'FieldMeasurements_OriginalLaneChangeArea_SouthMarkerCluster_SolidWhite'
        % Fixed on 2023_09_08 by S. Brennan - a point was out of order
        % (kept the repeat as this is a calibration line)
        % Refixed on 2023_09_24 because it's throwing errors.
        load ENU_southLCarea_SolidYellowLine_2023_07_10.mat ENU_southLCarea_SolidYellowLine_2023_07_10;
        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            ENU_southLCarea_SolidYellowLine_2023_07_10,...
            []);


    case 'FieldMeasurements_OriginalLaneChangeArea_SouthMarkerCluster_SolidWhite_ORIGINAL'
        % Fixed on 2023_09_08 by S. Brennan - a point was out of order
        % (kept the repeat as this is a calibration line)
        % Refixed on 2023_09_24 because it's throwing errors.
        load ENU_southLCarea_SolidYellowLine_2023_07_10_original.mat ENU_southLCarea_SolidYellowLine_2023_07_10_original;
        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            ENU_southLCarea_SolidYellowLine_2023_07_10_original,...
            []);


    case 'FieldMeasurements_OriginalLaneChangeArea_MiddleMarkerCluster_BrokenWhite'
        load ENU_middleLCarea_DashedWhiteLine_2023_07_10.mat ENU_middleLCarea_DashedWhiteLine_2023_07_10;
        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            ENU_middleLCarea_DashedWhiteLine_2023_07_10,...
            []);

        % LLA_positions_cell_array{1}
        %
        % ans =
        %
        %    1.0e+02 *
        %
        %    0.408630896876797  -0.778334312702982   3.676679999994428
        %    0.408630985341771  -0.778334157087045   3.676880000143829
        %    0.408631058036463  -0.778334033759172   3.676760000143241
        %    0.408631233679251  -0.778333730342883   3.676949999788593
        %    0.408631310328849  -0.778333597403618   3.676730000147731
        %    0.408631485925352  -0.778333292478860   3.676899999935235
        %    0.408631566513542  -0.778333158010950   3.676849999965089
        %    0.408631738664267  -0.778332854965247   3.677050000012636
        %
        % LLA_positions_cell_array{2}
        %
        % ans =
        %
        %    1.0e+02 *
        %
        %    0.408633398784086  -0.778330002331960   3.678200000062362
        %    0.408633555898291  -0.778329726567287   3.678290000006483
        %    0.408633634925311  -0.778329592417954   3.678289999875901
        %    0.408633803325780  -0.778329295707284   3.678350000409370
        %    0.408633880701406  -0.778329162600594   3.678390000313330
        %    0.408634063659717  -0.778328875981662   3.677739999581607
        %    0.408634123585777  -0.778328733901202   3.679689999986841
        %    0.408634304586427  -0.778328433956375   3.678720000347738
        %    0.408634388326562  -0.778328291811264   3.678720000004621
        %    0.408634554650849  -0.778328000606063   3.678819999987409
        %    0.408634633054471  -0.778327867502965   3.678929999809208
        %    0.408634806565774  -0.778327569261012   3.678859999945882
        %    0.408634882512588  -0.778327442141385   3.679040000194908
        %    0.408635052653889  -0.778327152392032   3.679289999908470
        %
        % LLA_positions_cell_array{3}
        %
        % ans =
        %
        %    1.0e+02 *
        %
        %    0.408636729047432  -0.778324265335193   3.679720000042479
        %    0.408636917297174  -0.778323939028785   3.679999999426486
        %    0.408636973723845  -0.778323844438760   3.680010000181451
        %    0.408637154737721  -0.778323526352728   3.680080000058561
        %    0.408637226973279  -0.778323403227271   3.680099999964947
        %    0.408637401016563  -0.778323098767284   3.680180000008994
        %    0.408637476738377  -0.778322968954889   3.680130000034799
        %    0.408637565319714  -0.778322815076071   3.680339999689219

    case 'FieldMeasurements_OriginalLaneChangeArea_NorthMarkerCluster_SolidYellow'
        load ENU_northLCarea_SolidYellowLine_2023_07_10.mat ENU_northLCarea_SolidYellowLine_2023_07_10;
        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            ENU_northLCarea_SolidYellowLine_2023_07_10,...
            []);

    case 'FieldMeasurements_OriginalLaneChangeArea_CenterlineReference_SolidYellow'
        load ENU_LCArea_SolidYellow_2023_07_20.mat ENU_LCArea_SolidYellow_2023_07_20;
        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            ENU_LCArea_SolidYellow_2023_07_20,...
            []);

    case 'FieldMeasurements_OriginalLaneChangeArea_CenterlineReference_SolidWhite'
        load ENU_LCArea_SolidWhite_2023_07_20.mat ENU_LCArea_SolidWhite_2023_07_20;
        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            ENU_LCArea_SolidWhite_2023_07_20,...
            []);


    case 'FieldMeasurements_OriginalHandlingCircle_SolidYellow'
        load ENU_HandlingCircle_SolidYellow_2023_07_20.mat ENU_HandlingCircle_SolidYellow_2023_07_20;
        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            ENU_HandlingCircle_SolidYellow_2023_07_20,...
            []);

    case 'FieldMeasurements_AcousticTestingArea_SouthSolidWhite'
        MarkerCluster_acoustic{1} = [
            40.86270144666667, -77.83465680166667, 367.204
            40.862803731666666, -77.83448615166667, 367.386
            ];  % East side, from south to north

        MarkerCluster_acoustic{2} = [
            40.86274482333334, -77.83470091166667, 367.224
            40.86284792666667, -77.83452934333333, 367.409
            ]; % West side, from south to north
        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            [],...
            MarkerCluster_acoustic{1});

    case 'FieldMeasurements_AcousticTestingArea_NorthSolidWhite'
        MarkerCluster_acoustic{1} = [
            40.86270144666667, -77.83465680166667, 367.204
            40.862803731666666, -77.83448615166667, 367.386
            ];  % East side, from south to north

        MarkerCluster_acoustic{2} = [
            40.86274482333334, -77.83470091166667, 367.224
            40.86284792666667, -77.83452934333333, 367.409
            ]; % West side, from south to north
        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            [],...
            MarkerCluster_acoustic{2});

    case 'FieldMeasurements_DetourLines_NorthExitSingleSolidWhite'

        ENU_positions_cell_array = [
            7.51874888385 134.144398667 -9.51141841851
            2.86498162768 127.767591666 -9.83828339934
            ];
        LLA_positions_cell_array  =  gps_object.ENU2WGSLLA(ENU_positions_cell_array');

    case 'FieldMeasurements_DetourLines_NorthExitRightDoubleYellow'

        ENU_positions_cell_array = [
            -3.57027923865 124.698894616 -10.303222866
            4.2307830602 135.095649889 -9.5414355638
            ];
        LLA_positions_cell_array  =  gps_object.ENU2WGSLLA(ENU_positions_cell_array');

    case 'FieldMeasurements_DetourLines_NorthExitLeftDoubleYellow'

        ENU_positions_cell_array = [
            -3.74128033931 124.87775381 -10.2932264585
            4.05279933785 135.261888455 -9.53743891813
            ];
        LLA_positions_cell_array  =  gps_object.ENU2WGSLLA(ENU_positions_cell_array');

    case 'FieldMeasurements_DetourLines_CrossroadEntryRightSolidYellow'

        ENU_positions_cell_array = [
            -48.9313994654 19.7149982262 -12.1162179538
            -63.7706442166 30.5648131346 -12.7493917332
            ];
        LLA_positions_cell_array  =  gps_object.ENU2WGSLLA(ENU_positions_cell_array');

    case 'FieldMeasurements_DetourLines_CrossroadEntryLeftSolidYellow'

        ENU_positions_cell_array = [
            -49.0989272149 19.531858818 -12.1122186796
            -63.921148616 30.3664659756 -12.7393922957
            ];
        LLA_positions_cell_array  =  gps_object.ENU2WGSLLA(ENU_positions_cell_array');

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %   _____            _               _____                     _
        %  |  __ \          (_)             |  __ \                   (_)
        %  | |  | | ___  ___ _  __ _ _ __   | |  | |_ __ __ ___      ___ _ __   __ _ ___
        %  | |  | |/ _ \/ __| |/ _` | '_ \  | |  | | '__/ _` \ \ /\ / / | '_ \ / _` / __|
        %  | |__| |  __/\__ \ | (_| | | | | | |__| | | | (_| |\ V  V /| | | | | (_| \__ \
        %  |_____/ \___||___/_|\__, |_| |_| |_____/|_|  \__,_| \_/\_/ |_|_| |_|\__, |___/
        %                       __/ |                                           __/ |
        %                      |___/                                           |___/
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %    ____       _       _             _ _______             _    _
        %   / __ \     (_)     (_)           | |__   __|           | |  | |
        %  | |  | |_ __ _  __ _ _ _ __   __ _| |  | |_ __ __ _  ___| | _| |     __ _ _ __   ___
        %  | |  | | '__| |/ _` | | '_ \ / _` | |  | | '__/ _` |/ __| |/ / |    / _` | '_ \ / _ \
        %  | |__| | |  | | (_| | | | | | (_| | |  | | | | (_| | (__|   <| |___| (_| | | | |  __/
        %   \____/|_|  |_|\__, |_|_| |_|\__,_|_|  |_|_|  \__,_|\___|_|\_\______\__,_|_| |_|\___|
        %                  __/ |
        %                 |___/
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    case 'DesignDrawings_OuterTrackLane_StartLineSolidWhite'
        % Added on 2023_09_25 by copying from fcn_PlotTestTrack_loadObjectsforScenarios.m
        StartEndLLACellArray = fcn_PlotTestTrack_parseKML('Scenario1-1_StartLine.kml');


        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            [],...
            StartEndLLACellArray{1}(3:4,:));

    case 'DesignDrawings_OuterTrackLane_FinishLineSolidWhite'
        % Added on 2023_09_25 by copying from fcn_PlotTestTrack_loadObjectsforScenarios.m
        StartEndLLACellArray = fcn_PlotTestTrack_parseKML('Scenario1-1_StartLine.kml');


        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            [],...
            StartEndLLACellArray{1}(2:-1:1,:));

    case 'DesignDrawings_OuterTrackLane_EntryJunctionStartLineSolidClear'

        % Added on 2023_10_20 for Scenario 4.3
        EntryJunctionStartLine_LLA = [
            40.862089426238128 -77.835057931202002 0;
            40.862120012317071 -77.835069867101765 0;
            ];

        offsets = [-8.000000000000000e-07 5.400000000000000e-06 0];

        EntryJunctionStartLine_LLA = EntryJunctionStartLine_LLA-ones(2,1)*offsets;

        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            [],...
            EntryJunctionStartLine_LLA);

    case 'DesignDrawings_OuterTrackLane_DetourStartLineSolidWhite'
        % Added on 2023_10_12 from hand measurements in the field
        ENU_position_array = [
            -126.245016932 -42.0345622171 -11.2933863864
            -123.230250738 -41.6024408754 -11.6193246846
            -122.951980258 -41.5514207604 -11.6493189762
            -122.814758023 -42.5499390014 -11.6683229437
            -123.065368529 -42.5850581549 -11.6413280088
            -126.10003428 -43.045038467 -11.2853902764
            ];

        % % For debugging
        % figure(38383);
        % clf;
        % hold on;
        % grid on;
        % axis equal;
        % plot(ENU_position_array(:,1),ENU_position_array(:,2),'k.-');
        % for ith_point = 1:length(ENU_position_array(:,1))
        %     current_point = ENU_position_array(ith_point,:);
        %     text(current_point(1,1),current_point(1,2),sprintf('%.0d',ith_point));
        % end

        startline_position_ENU = [ENU_position_array(6,:); ENU_position_array(4,:)];

        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            startline_position_ENU,...
            []);

    case 'DesignDrawings_OuterTrackLane_DetourFinishLineSolidWhite'

        % Added on 2023_10_12 from hand measurements in the field
        ENU_position_array = [
            -126.245016932 -42.0345622171 -11.2933863864
            -123.230250738 -41.6024408754 -11.6193246846
            -122.951980258 -41.5514207604 -11.6493189762
            -122.814758023 -42.5499390014 -11.6683229437
            -123.065368529 -42.5850581549 -11.6413280088
            -126.10003428 -43.045038467 -11.2853902764
            ];

        finishline_position_ENU = [ENU_position_array(1,:); ENU_position_array(3,:)];

        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            finishline_position_ENU,...
            []);

    case 'DesignDrawings_OuterTrackLane_DetourReentryLineSolidClear'

        % Added on 2023_10_12 from Design Drawings
        ENU_reentry_line = [
            -8.980921341977650 142.9699971421374 0
            -8.220403663434682 140.0705457341435 0
            ];

        transverse_vector = (ENU_reentry_line(2,:) - ENU_reentry_line(1,:));
        length_transverse_vector = sum(transverse_vector.^2,2).^0.5;
        unit_transverse = transverse_vector./length_transverse_vector;

        extension_distance = 5;
        extended_line = [...
            ENU_reentry_line(1,:) - extension_distance*unit_transverse;
            ENU_reentry_line(2,:) + extension_distance*unit_transverse];

        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            extended_line,...
            []);



    case 'DesignDrawings_OriginalTrackLane_OuterMarkerClusterSolidWhite'
        % Fixed on 2023_09_07 - one point is out of order (2nd and 3rd
        % point)
        % Added edits on 2023_09_24 to fix close points
        [LLA_single_white_line_original,         ENU_single_white_line_original, ...
            ~, ~,...
            ~, ~,...
            ~, ~] = ...
            fcn_PlotTestTrack_loadExistingLaneMarkers;


        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            ENU_single_white_line_original,...
            LLA_single_white_line_original);

    case 'DesignDrawings_OriginalTrackLane_InnerMarkerClusterOuterDoubleYellow'
        % Fixed on 2023_09_07 - one point is out of order (2nd and 3rd
        % point)
        % Added edits on 2023_09_24 to fix close points
        [~,         ~, ...
            ~, ~,...
            LLA_double_solid_yellow_outer_original, ENU_double_solid_yellow_outer_original,...
            ~, ~] = ...
            fcn_PlotTestTrack_loadExistingLaneMarkers;

        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            ENU_double_solid_yellow_outer_original,...
            LLA_double_solid_yellow_outer_original);

    case 'DesignDrawings_OriginalTrackLane_InnerMarkerClusterInnerDoubleYellow'
        % Fixed on 2023_09_10 - one point is out of order (again)
        [~,         ~, ...
            LLA_double_solid_yellow_inner_original, ENU_double_solid_yellow_inner_original,...
            ~, ~,...
            ~, ~] = ...
            fcn_PlotTestTrack_loadExistingLaneMarkers;

        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            ENU_double_solid_yellow_inner_original,...
            LLA_double_solid_yellow_inner_original);


    case 'DesignDrawings_OriginalTrackLane_InnerMarkerClusterCenterline'
        [~,         ~, ...
            ~, ~,...
            ~, ~,...
            LLA_Standard_centerline, ENU_Standard_centerline] = ...
            fcn_PlotTestTrack_loadExistingLaneMarkers;

        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            ENU_Standard_centerline,...
            LLA_Standard_centerline);

    case 'DesignDrawings_OriginalHandlingCircle_SolidYellow'
        % Copied from field measurements
        load ENU_HandlingCircle_SolidYellow_2023_07_20.mat ENU_HandlingCircle_SolidYellow_2023_07_20;
        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            ENU_HandlingCircle_SolidYellow_2023_07_20,...
            []);

    case 'DesignDrawings_AcousticTestingArea_SouthSolidWhite'
        % Copied from field measurements
        MarkerCluster_acoustic{1} = [
            40.86270144666667, -77.83465680166667, 367.204
            40.862803731666666, -77.83448615166667, 367.386
            ];  % East side, from south to north

        MarkerCluster_acoustic{2} = [
            40.86274482333334, -77.83470091166667, 367.224
            40.86284792666667, -77.83452934333333, 367.409
            ]; % West side, from south to north
        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            [],...
            MarkerCluster_acoustic{1});

    case 'DesignDrawings_AcousticTestingArea_NorthSolidWhite'
        % Copied from field measurements
        MarkerCluster_acoustic{1} = [
            40.86270144666667, -77.83465680166667, 367.204
            40.862803731666666, -77.83448615166667, 367.386
            ];  % East side, from south to north

        MarkerCluster_acoustic{2} = [
            40.86274482333334, -77.83470091166667, 367.224
            40.86284792666667, -77.83452934333333, 367.409
            ]; % West side, from south to north
        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            [],...
            MarkerCluster_acoustic{2});



        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %   _   _               _      _
        %  | \ | |             | |    (_)
        %  |  \| | _____      _| |     _ _ __   ___
        %  | . ` |/ _ \ \ /\ / / |    | | '_ \ / _ \
        %  | |\  |  __/\ V  V /| |____| | | | |  __/
        %  |_| \_|\___| \_/\_/ |______|_|_| |_|\___|
        %
        % See: http://patorjk.com/software/taag/#p=display&f=Big&t=NewLine

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    case {...
            'DesignDrawings_NewLine2_Right_SolidYellow',...
            'DesignDrawings_NewLine2_Left_DashedYellow',...
            'DesignDrawings_NewLine3_Right_DashedYellow',...
            'DesignDrawings_NewLine3_Left_SolidYellow',...
            'DesignDrawings_NewLine4_Center_SolidWhite',...
            }

        % Get data from KML file
        % Open KML file directly - show this using scenario 1_4

        scenario_1_4_KML_file_name = 'Scenario_1_4_lines_only_complete.kml';
        scenario_1_4_data_matricies = fcn_PlotTestTrack_parseKML(scenario_1_4_KML_file_name);

        switch TraceSearchString
            case 'DesignDrawings_NewLine2_Right_SolidYellow'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    flipud(scenario_1_4_data_matricies{8}));


            case 'DesignDrawings_NewLine2_Left_DashedYellow'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    flipud(scenario_1_4_data_matricies{7}));

            case 'DesignDrawings_NewLine3_Right_DashedYellow'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    flipud(scenario_1_4_data_matricies{5}));


            case 'DesignDrawings_NewLine3_Left_SolidYellow'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    flipud(scenario_1_4_data_matricies{6}));


            case 'DesignDrawings_NewLine4_Center_SolidWhite'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    flipud(scenario_1_4_data_matricies{3}));
            otherwise
                error('Unknown situation for: %s', TraceSearchString);
        end




    case {...
            'DesignDrawings_NewLine1_Center_SolidWhite',...
            'DesignDrawings_NewLine2_Center_DashedWhite',...
            'DesignDrawings_NewLine4_Left_SolidYellow',...
            'DesignDrawings_NewLine4_Right_SolidYellow',...
            'DesignDrawings_NewLine3_Center_DashedWhite',...
            }

        % Get data from KML file
        % Open KML file directly - show this using scenario 1_6
        scenario_1_6_KML_file_name = 'Scenario_1_6_modified_lines.kml';
        scenario_1_6_data_matricies = fcn_PlotTestTrack_parseKML(scenario_1_6_KML_file_name);

        switch TraceSearchString
            case 'DesignDrawings_NewLine1_Center_SolidWhite'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    flipud(scenario_1_6_data_matricies{7}));

            case 'DesignDrawings_NewLine2_Center_DashedWhite'
                % Test here
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    flipud(scenario_1_6_data_matricies{8}));

            case 'DesignDrawings_NewLine4_Left_SolidYellow'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    flipud(scenario_1_6_data_matricies{3}));

            case 'DesignDrawings_NewLine4_Right_SolidYellow'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    flipud(scenario_1_6_data_matricies{6}));


            case 'DesignDrawings_NewLine3_Center_DashedWhite'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    flipud(scenario_1_6_data_matricies{9}));
            otherwise
                error('Unknown situation for: %s', TraceSearchString);
        end


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %   ______       _           _______                  _ _   _
        %  |  ____|     | |         |__   __|                (_) | (_)
        %  | |__   _ __ | |_ _ __ _   _| |_ __ __ _ _ __  ___ _| |_ _  ___  _ __  ___
        %  |  __| | '_ \| __| '__| | | | | '__/ _` | '_ \/ __| | __| |/ _ \| '_ \/ __|
        %  | |____| | | | |_| |  | |_| | | | | (_| | | | \__ \ | |_| | (_) | | | \__ \
        %  |______|_| |_|\__|_|   \__, |_|_|  \__,_|_| |_|___/_|\__|_|\___/|_| |_|___/
        %                          __/ |
        %                         |___/
        % See: http://patorjk.com/software/taag/#p=display&f=Big&t=EntryTransitions
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    case {...
            'DesignDrawings_EntryTransitions_ToNewLine1_FromOuterMarkerClusterSolidWhite_FarWest_DottedWhite',...
            'DesignDrawings_EntryTransitions_ToNewLine2Right_FromInnerMarkerClusterOuterDoubleYellow_SolidYellow',...
            'DesignDrawings_EntryTransitions_ToNewLine2Left_FromInnerMarkerClusterInnerDoubleYellow_SolidYellow',...
            'DesignDrawings_ExitTransitions_ToInnerMarkerClusterOuterDoubleYellow_FromNewLine2Right_SolidYellow',...
            'DesignDrawings_ExitTransitions_ToInnerMarkerClusterInnerDoubleYellow_FromNewLine2Left_SolidYellow',...
            'DesignDrawings_LaneExtension_ToStopLine_FromNewLine2Right_SolidYellow',...
            'DesignDrawings_LaneExtension_ToStopLine_FromNewLine2Left_SolidYellow',...
            'DesignDrawings_LaneExtension_ToNewLine2CenterMiddle_FromNewLine2CenterStart_SolidWhite',...
            'DesignDrawings_LaneExtension_ToNewLine2RightEnd_FromNewLine2RightMiddle_SolidYellow',...
            'DesignDrawings_LaneExtension_ToNewLine2LeftEnd_FromNewLine2LeftMiddle_SolidYellow',...
            'DesignDrawings_LaneToLaneTransition_ToNewLine1_FromNewLine2_SolidWhite',...
            'DesignDrawings_StopLine_BetweenNewLine1AndNewLine2SolidWhite',...
            'DesignDrawings_StopLine_BetweenNewLine1AndNewLine2SolidWhite_StartOfStopLine',...
            'DesignDrawings_StopLine_BetweenNewLine1AndNewLine2SolidWhite_FinishOfStopLine',...
            'DesignDrawings_StopLine_BetweenNewLine2AndNewLine3SolidWhite',...
            'DesignDrawings_StopLine_BetweenNewLine2AndNewLine3SolidWhite_StartOfStopLine',...
            'DesignDrawings_StopLine_BetweenNewLine2AndNewLine3SolidWhite_FinishOfStopLine',...
            }

        % Get data from KML file
        % Open KML file directly - show this using scenario 2_4
        scenario_2_4_KML_file_name = 'Scenario_2_4_modified_lines.kml';
        scenario_2_4_data_matricies = fcn_PlotTestTrack_parseKML(scenario_2_4_KML_file_name);

        switch TraceSearchString
            case 'DesignDrawings_EntryTransitions_ToNewLine1_FromOuterMarkerClusterSolidWhite_FarWest_DottedWhite'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [scenario_2_4_data_matricies{20}; scenario_2_4_data_matricies{21}]); % SNB Edited 2023_07_25 to remove repeated end transition on the East side, edited on 2023_10_14 to extend line


            case 'DesignDrawings_EntryTransitions_ToNewLine2Right_FromInnerMarkerClusterOuterDoubleYellow_SolidYellow'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [scenario_2_4_data_matricies{13}]);  % SNB Edited 2023_07_25 to force end of east transition to land on outer lane


            case 'DesignDrawings_EntryTransitions_ToNewLine2Left_FromInnerMarkerClusterInnerDoubleYellow_SolidYellow'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [scenario_2_4_data_matricies{14}]);  % SNB Edited 2023_07_25 to force end of east transition to land on outer lane

            case 'DesignDrawings_ExitTransitions_ToInnerMarkerClusterOuterDoubleYellow_FromNewLine2Right_SolidYellow'
                % transition curves , scn_1.3,1.4,1.5,2.3,2.4,1.6(s.w),5.2(sw) (lane 4, DY,SW) (?????? the
                % single white in center is in another scenario and does not fully fit
                % inside the double yellow)
                [~, ~, ...
                    ~,  ~,...
                    LLA_double_solid_yellow_outer_original, ENU_double_solid_yellow_outer_original, ~, ~] = ...
                    fcn_PlotTestTrack_loadExistingLaneMarkers;

                [~, temp_LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    ENU_double_solid_yellow_outer_original,...
                    LLA_double_solid_yellow_outer_original);

                temp_data = flipud(scenario_2_4_data_matricies{15});

                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [temp_data(1:end-1,:); temp_LLA_positions_cell_array{4}(1,:)]); % SNB Edited 2023_07_25 to force end of east transition to land on outer lane


            case 'DesignDrawings_ExitTransitions_ToInnerMarkerClusterInnerDoubleYellow_FromNewLine2Left_SolidYellow'
                [~,         ~, ...
                    LLA_double_solid_yellow_inner_original, ENU_double_solid_yellow_inner_original,...
                    ~ , ~, ~, ~] = ...
                    fcn_PlotTestTrack_loadExistingLaneMarkers;

                [~, temp_LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    ENU_double_solid_yellow_inner_original,...
                    LLA_double_solid_yellow_inner_original);

                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [scenario_2_4_data_matricies{16}(1:end-1,:); temp_LLA_positions_cell_array{4}(1,:)]);  % SNB Edited 2023_07_25 to force end of east transition to land on outer lane


            case 'DesignDrawings_LaneExtension_ToStopLine_FromNewLine2Right_SolidYellow'
                % lane stops/lane breaks on Scenario 2.4 (lane 4, double yellow)
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    flipud(scenario_2_4_data_matricies{9}); nan(1,3); ...
                    ]);

            case 'DesignDrawings_LaneExtension_ToStopLine_FromNewLine2Left_SolidYellow'
                % lane stops/lane breaks on Scenario 2.4 (lane 4, double yellow)
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    flipud(scenario_2_4_data_matricies{10}); nan(1,3); ...
                    ]);

            case 'DesignDrawings_LaneExtension_ToNewLine2CenterMiddle_FromNewLine2CenterStart_SolidWhite'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    flipud(scenario_2_4_data_matricies{24}(1:2,:)); nan(1,3); ...
                    ]);

            case 'DesignDrawings_LaneExtension_ToNewLine2RightEnd_FromNewLine2RightMiddle_SolidYellow'
                % lane stops/lane breaks on Scenario 2.4 (lane 4, double yellow)
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    flipud(scenario_2_4_data_matricies{11})...
                    ]);

            case 'DesignDrawings_LaneExtension_ToNewLine2LeftEnd_FromNewLine2LeftMiddle_SolidYellow'
                % lane stops/lane breaks on Scenario 2.4 (lane 4, double yellow)
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    flipud(scenario_2_4_data_matricies{12})...
                    ]);


            case 'DesignDrawings_LaneToLaneTransition_ToNewLine1_FromNewLine2_SolidWhite'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    flipud(scenario_2_4_data_matricies{19})...
                    ]);

            case 'DesignDrawings_StopLine_BetweenNewLine1AndNewLine2SolidWhite'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    scenario_2_4_data_matricies{1}; nan(1,3);...
                    ]);

            case 'DesignDrawings_StopLine_BetweenNewLine1AndNewLine2SolidWhite_StartOfStopLine'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    flipud(scenario_2_4_data_matricies{1}(2:3,:)); nan(1,3);...
                    ]);

            case 'DesignDrawings_StopLine_BetweenNewLine1AndNewLine2SolidWhite_FinishOfStopLine'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    scenario_2_4_data_matricies{1}(4:5,:); nan(1,3);...
                    ]);

            case 'DesignDrawings_StopLine_BetweenNewLine2AndNewLine3SolidWhite'

                % % For debugging
                % figure(3883);
                % clf;
                %
                % grid on;
                % for ith_trace = 1:length(scenario_2_4_data_matricies)
                %     data_to_plot = scenario_2_4_data_matricies{ith_trace};
                %     fprintf(1,'Trace: %.0d\n',ith_trace);
                %     geoplot(data_to_plot(:,1),data_to_plot(:,2),'-','LineWidth',3);
                %     hold on;
                %     geoplot(data_to_plot(1,1),data_to_plot(1,2),'.','MarkerSize',20);
                %     pause;
                % end

                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    scenario_2_4_data_matricies{5}; nan(1,3);...
                    ]);

            case 'DesignDrawings_StopLine_BetweenNewLine2AndNewLine3SolidWhite_StartOfStopLine'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    scenario_2_4_data_matricies{5}(1,:); ...
                    scenario_2_4_data_matricies{5}(4,:); ...
                    nan(1,3);...
                    ]);

            case 'DesignDrawings_StopLine_BetweenNewLine2AndNewLine3SolidWhite_FinishOfStopLine'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    scenario_2_4_data_matricies{5}(2,:); ...
                    scenario_2_4_data_matricies{5}(3,:); ...
                    nan(1,3);...
                    ]);


            otherwise
                error('Unknown situation for: %s', TraceSearchString);
        end

    case {...
            'DesignDrawings_EntryTransitions_ToNewLine2Center_FromOuterMarkerClusterSolidWhite_2_DottedWhite',...
            'DesignDrawings_EntryTransitions_ToNewLine1_FromOuterMarkerClusterSolidWhite_NearWest_DottedWhite',...
            'DesignDrawings_EntryTransitions_ToNewLine4Right_FromInnerMarkerClusterOuterDoubleYellow_SolidYellow',...
            'DesignDrawings_EntryTransitions_ToNewLine4Left_FromInnerMarkerClusterInnerDoubleYellow_SolidYellow',...
            'DesignDrawings_ExitTransitions_ToOuterMarkerClusterSolidWhite_FromNewLine1Center_DottedWhite',...
            'DesignDrawings_ExitTransitions_ToOuterMarkerClusterSolidWhite_FromNewLine1Center_2_DottedWhite',...
            'DesignDrawings_ExitTransitions_ToInnerMarkerClusterOuterDoubleYellow_FromNewLine4Right_SolidYellow',...
            'DesignDrawings_ExitTransitions_ToInnerMarkerClusterInnerDoubleYellow_FromNewLine4Left_SolidYellow',...
            'DesignDrawings_LaneToLaneTransition_ToNewLine1CenterEnd_FromNewLine2CenterMiddle_SolidWhite',...
            'DesignDrawings_LaneExtension_ToNewLine2CenterEnd_FromNewLine2CenterMiddle_SmallDashedWhite',...
            'DesignDrawings_LaneExtension_ToNewLine2CenterEnd_FromNewLine2CenterMiddle2_SolidWhite',...
            'DesignDrawings_LaneExtension_ToNewLine2CenterEnd_FromNewLine2CenterMiddle3_SolidWhite',...
            'DesignDrawings_LaneExtension_ToNewLine1CenterEnd_FromNewLine1CenterMiddle_SolidWhite',...
            'DesignDrawings_LaneExtension_ToNewLine2CenterMiddleish_FromNewLine2CenterStart2_SolidWhite',...
            }

        % Get data from KML file
        % Open KML file directly - show this using scenario 2_4
        scenario_4_2_KML_file_name = 'Scenario_4_2_modified_lines.kml';
        scenario_4_2_data_matricies = fcn_PlotTestTrack_parseKML(scenario_4_2_KML_file_name);

        switch TraceSearchString
            case 'DesignDrawings_EntryTransitions_ToNewLine2Center_FromOuterMarkerClusterSolidWhite_2_DottedWhite'
                % Load the MC002 data as it intersects and needs to be appended
                [~,         ~, ...
                    LLA_double_solid_yellow_inner_original, ENU_double_solid_yellow_inner_original,...
                    ~ , ~, ~, ~] = ...
                    fcn_PlotTestTrack_loadExistingLaneMarkers;

                [~, temp_LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    ENU_double_solid_yellow_inner_original,...
                    LLA_double_solid_yellow_inner_original);

                temp_point = temp_LLA_positions_cell_array{7}(15,:);
                temp_point(1,3) = scenario_4_2_data_matricies{16}(end-1,3);

                % % For debugging
                % figure(3883);
                % clf;
                %
                % grid on;
                % geoplot(scenario_4_2_data_matricies{16}(:,1),scenario_4_2_data_matricies{16}(:,2),'-','LineWidth',3);
                % hold on;
                % geoplot(scenario_4_2_data_matricies{16}(1,1),scenario_4_2_data_matricies{16}(1,2),'.','MarkerSize',20);
                %
                % geoplot(temp_LLA_positions_cell_array{7}(15,1),temp_LLA_positions_cell_array{7}(15,2),'-','LineWidth',3);
                % hold on;
                % geoplot(temp_LLA_positions_cell_array{7}(15,1),temp_LLA_positions_cell_array{7}(15,2),'.','MarkerSize',20);
                %
                % grid on;
                % geoplot(scenario_4_2_data_matricies{9}(:,1),scenario_4_2_data_matricies{9}(:,2),'-','LineWidth',3);
                % hold on;
                % geoplot(scenario_4_2_data_matricies{9}(1,1),scenario_4_2_data_matricies{9}(1,2),'.','MarkerSize',20);


                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    scenario_4_2_data_matricies{16}(1:end-1,:); temp_point; % SNB Edited 2023_07_25 to force match to MC
                    scenario_4_2_data_matricies{9}(2:end,:); % Added by SNB on 2023_10_16 to correct for missing data on curve
                    ]);

                % [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                %     fcn_INTERNAL_prepDataForOutput(...
                %     [],...
                %     [...
                %     scenario_4_2_data_matricies{16}(1:end-1,:); temp_LLA_positions_cell_array{7}(15,:); nan(1,3);... % SNB Edited 2023_07_25 to force match to MC
                %     scenario_4_2_data_matricies{9}; % Added by SNB on 2023_10_16 to correct for missing data on curve
                %     ]);

            case 'DesignDrawings_EntryTransitions_ToNewLine1_FromOuterMarkerClusterSolidWhite_NearWest_DottedWhite'

                % Load the MC002 data as it intersects and needs to be appended
                [~,         ~, ...
                    LLA_double_solid_yellow_inner_original, ENU_double_solid_yellow_inner_original,...
                    ~ , ~, ~, ~] = ...
                    fcn_PlotTestTrack_loadExistingLaneMarkers;

                [~, temp_LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    ENU_double_solid_yellow_inner_original,...
                    LLA_double_solid_yellow_inner_original);

                temp_data = flipud(scenario_4_2_data_matricies{18});
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    temp_LLA_positions_cell_array{7}(15,:); temp_data(2:end,:)...  % SNB Edited 2023_07_25 to force match to MC
                    ]);

            case 'DesignDrawings_EntryTransitions_ToNewLine4Right_FromInnerMarkerClusterOuterDoubleYellow_SolidYellow'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [scenario_4_2_data_matricies{5}]);



            case 'DesignDrawings_EntryTransitions_ToNewLine4Left_FromInnerMarkerClusterInnerDoubleYellow_SolidYellow'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [scenario_4_2_data_matricies{2}]);


            case 'DesignDrawings_ExitTransitions_ToOuterMarkerClusterSolidWhite_FromNewLine1Center_DottedWhite'
                % Load the MC002 data as it intersects and needs to be appended
                [~,         ~, ...
                    LLA_double_solid_yellow_inner_original, ENU_double_solid_yellow_inner_original,...
                    ~ , ~, ~, ~] = ...
                    fcn_PlotTestTrack_loadExistingLaneMarkers;

                [~, temp_LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    ENU_double_solid_yellow_inner_original,...
                    LLA_double_solid_yellow_inner_original);

                temp_data = flipud(scenario_4_2_data_matricies{17});

                % For debugging
                % figure(3883);
                %
                % grid on;
                % for ith_trace = 1:length(scenario_4_2_data_matricies)
                %     data_to_plot = scenario_4_2_data_matricies{ith_trace};
                %     fprintf(1,'Trace: %.0d\n',ith_trace);
                %     geoplot(data_to_plot(:,1),data_to_plot(:,2),'-','LineWidth',3);
                %     hold on;
                %     geoplot(data_to_plot(1,1),data_to_plot(1,2),'.','MarkerSize',20);
                %     pause;
                % end

                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [ temp_data(1:2,:); [temp_LLA_positions_cell_array{3}(1,1:2) temp_data(1,3)]; temp_data(5:end,:); nan(1,3)]); % SNB Edited 2023_10_15 to force match to MC, and to remove 2 repeated points, correct a point, and fix altitude


            case 'DesignDrawings_ExitTransitions_ToOuterMarkerClusterSolidWhite_FromNewLine1Center_2_DottedWhite'
                % transition curves, scn 4.1a, 4.1b, 4.2,4.3,5.1a,5.1b,6.1 (lane 4, small dashed white)
                % Load the MC002 data as it intersects and needs to be appended
                [~,         ~, ...
                    LLA_double_solid_yellow_inner_original, ENU_double_solid_yellow_inner_original,...
                    ~ , ~, ~, ~] = ...
                    fcn_PlotTestTrack_loadExistingLaneMarkers;

                [~, temp_LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    ENU_double_solid_yellow_inner_original,...
                    LLA_double_solid_yellow_inner_original);

                temp_data = flipud(scenario_4_2_data_matricies{17});

                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    temp_data(1:2,:); temp_LLA_positions_cell_array{3}(1,:); nan(1,3);... % SNB Edited 2023_07_25 to force match to MC
                    ]);

            case 'DesignDrawings_ExitTransitions_ToInnerMarkerClusterOuterDoubleYellow_FromNewLine4Right_SolidYellow'
                % transition curves, scn 4.1a, 4.1b, 4.2,4.3,5.1a,5.1b,6.1 (lane 6, double yellow)
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    % scenario_4_2_data_matricies{5}; nan(1,3); ...
                    flipud(scenario_4_2_data_matricies{4})]); %#ok<*NBRAK>

            case 'DesignDrawings_ExitTransitions_ToInnerMarkerClusterInnerDoubleYellow_FromNewLine4Left_SolidYellow'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    %scenario_4_2_data_matricies{2}; nan(1,3); ...
                    flipud(scenario_4_2_data_matricies{1})]);

            case 'DesignDrawings_LaneToLaneTransition_ToNewLine1CenterEnd_FromNewLine2CenterMiddle_SolidWhite'
                % lane shift lines scn 4.2 (lane 4-3, single white)
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    flipud(scenario_4_2_data_matricies{11}); nan(1,3); ...
                    ]);


            case 'DesignDrawings_LaneExtension_ToNewLine2CenterEnd_FromNewLine2CenterMiddle_SmallDashedWhite'
                % lane shift lines scn 4.2 (lane 4, dashed white)
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [scenario_4_2_data_matricies{15}]);

            case 'DesignDrawings_LaneExtension_ToNewLine2CenterEnd_FromNewLine2CenterMiddle2_SolidWhite'
                % lane shift lines scn 4.2 (lane 4, single white)
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    scenario_4_2_data_matricies{14}...
                    ]);

            case 'DesignDrawings_LaneExtension_ToNewLine2CenterEnd_FromNewLine2CenterMiddle3_SolidWhite'
                % lane shift lines scn 4.2 (lane 4, single white)
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    flipud(scenario_4_2_data_matricies{13}); nan(1,3); ...
                    ]);

            case 'DesignDrawings_LaneExtension_ToNewLine1CenterEnd_FromNewLine1CenterMiddle_SolidWhite'
                % lane shift lines scn 4.2 (lane 4-3, single white)
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    flipud(scenario_4_2_data_matricies{12}) ...
                    ]);

            case 'DesignDrawings_LaneExtension_ToNewLine2CenterMiddleish_FromNewLine2CenterStart2_SolidWhite'
                % lane shift lines scn 4.2 (lane 4-3, single white)
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    flipud(scenario_4_2_data_matricies{7}); nan(1,3); ...
                    ]);


            otherwise
                error('Unknown situation for: %s', TraceSearchString);
        end



    case 'DesignDrawings_EntryTransitions_ToNewLine2Center_FromOuterMarkerClusterSolidWhite_DottedWhite'


        % Get data from KML files
        % Open KML file directly - show this using scenario 4_2
        scenario_4_2_KML_file_name = 'Scenario_4_2_modified_lines.kml';
        scenario_4_2_data_matricies = fcn_PlotTestTrack_parseKML(scenario_4_2_KML_file_name);

        % For debugging
        % figure(3883);
        % clf
        %
        % grid on;
        % for ith_trace = 1:length(scenario_4_2_data_matricies)
        %     data_to_plot = scenario_4_2_data_matricies{ith_trace};
        %     fprintf(1,'Trace: %.0d\n',ith_trace);
        %     geoplot(data_to_plot(:,1),data_to_plot(:,2),'-','LineWidth',3);
        %     hold on;
        %     geoplot(data_to_plot(1,1),data_to_plot(1,2),'.','MarkerSize',20);
        %     pause;
        % end


        % Open KML file directly - show this using scenario 1_6
        scenario_1_6_KML_file_name = 'Scenario_1_6_modified_lines.kml';
        scenario_1_6_data_matricies = fcn_PlotTestTrack_parseKML(scenario_1_6_KML_file_name);

        % Load the MC002 data as it intersects and needs to be appended
        [~,         ~, ...
            LLA_double_solid_yellow_inner_original, ENU_double_solid_yellow_inner_original,...
            ~ , ~, ~, ~] = ...
            fcn_PlotTestTrack_loadExistingLaneMarkers;

        [~, temp_LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            ENU_double_solid_yellow_inner_original,...
            LLA_double_solid_yellow_inner_original);

        % Load MC004 as it also needs to be appended
        [~, temp2_LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            [],...
            flipud(scenario_1_6_data_matricies{8}));

        temp_data = flipud(scenario_4_2_data_matricies{18});

        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            [],...
            [...
            temp_LLA_positions_cell_array{7}(15,:); scenario_4_2_data_matricies{9}(2:end,:); temp2_LLA_positions_cell_array{1}(1,:); nan(1,3); ... % SNB Edited 2023_07_25 to force match to MC, and it was also missing the last point! (?!)
            ]);



        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %   ______      _ _ _______                  _ _   _
        %  |  ____|    (_) |__   __|                (_) | (_)
        %  | |__  __  ___| |_ | |_ __ __ _ _ __  ___ _| |_ _  ___  _ __
        %  |  __| \ \/ / | __|| | '__/ _` | '_ \/ __| | __| |/ _ \| '_ \
        %  | |____ >  <| | |_ | | | | (_| | | | \__ \ | |_| | (_) | | | |
        %  |______/_/\_\_|\__||_|_|  \__,_|_| |_|___/_|\__|_|\___/|_| |_|
        %
        % See: http://patorjk.com/software/taag/#p=display&f=Big&t=ExitTransition%0A
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    case {...
            'DesignDrawings_ExitTransitions_ToOuterMarkerClusterSolidWhite_FromNewLine2Right_SmallDottedWhite',...
            'DesignDrawings_ExitTransitions_ToOuterMarkerClusterSolidWhite_FromNewLine2Right_SolidWhite',...
            'DesignDrawings_LaneExtension_ToNewLine2Center_FromHandlingArea_SolidWhite',...
            'DesignDrawings_LaneExtension_ToEastCurve_FromNewLine2CenterEnd_SolidWhite',...
            }

        % Get data from KML file
        % Open KML file directly - show this using scenario 5_1a
        scenario_5_1a_KML_file_name = 'Scenario_5_1a_modified_lines.kml';
        scenario_5_1a_data_matricies = fcn_PlotTestTrack_parseKML(scenario_5_1a_KML_file_name);

        switch TraceSearchString
            case 'DesignDrawings_ExitTransitions_ToOuterMarkerClusterSolidWhite_FromNewLine2Right_SmallDottedWhite'

                % % For debugging
                % figure(3883);
                % grid on;
                % for ith_trace = 1:length(scenario_5_1a_data_matricies)
                %     data_to_plot = scenario_5_1a_data_matricies{ith_trace};
                %     fprintf(1,'Trace: %.0d\n',ith_trace);
                %     geoplot(data_to_plot(:,1),data_to_plot(:,2),'-','LineWidth',3);
                %     hold on;
                %     geoplot(data_to_plot(1,1),data_to_plot(1,2),'.','MarkerSize',20);
                %     pause;
                % end

                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [flipud(scenario_5_1a_data_matricies{14})]);

            case 'DesignDrawings_ExitTransitions_ToOuterMarkerClusterSolidWhite_FromNewLine2Right_SolidWhite'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    flipud(scenario_5_1a_data_matricies{10});
                    flipud(scenario_5_1a_data_matricies{14}(2:end,:)); ...  % Updated on 2023_10_16 to fix issues with scenarios 6.1 and similar
                    ]);

            case 'DesignDrawings_LaneExtension_ToNewLine2Center_FromHandlingArea_SolidWhite'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    flipud(scenario_5_1a_data_matricies{12}); nan(1,3); ...
                    ]);
            case 'DesignDrawings_LaneExtension_ToEastCurve_FromNewLine2CenterEnd_SolidWhite'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    flipud(scenario_5_1a_data_matricies{11}); nan(1,3); ...
                    ]);

            otherwise
                error('Unknown situation for: %s', TraceSearchString);
        end





        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %   _                      ______      _                 _
        %  | |                    |  ____|    | |               (_)
        %  | |     __ _ _ __   ___| |__  __  _| |_ ___ _ __  ___ _  ___  _ __
        %  | |    / _` | '_ \ / _ \  __| \ \/ / __/ _ \ '_ \/ __| |/ _ \| '_ \
        %  | |___| (_| | | | |  __/ |____ >  <| ||  __/ | | \__ \ | (_) | | | |
        %  |______\__,_|_| |_|\___|______/_/\_\\__\___|_| |_|___/_|\___/|_| |_|
        %
        % See: http://patorjk.com/software/taag/#p=display&f=Big&t=LaneExtension%0A
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    case {...
            'DesignDrawings_LaneExtension_ToNewLine2Center_FromHandlingArea2_SolidWhite',...
            'DesignDrawings_LaneExtension_ToNewLine3Center_FromNewLine3CenterStart_SolidWhite',...
            'DesignDrawings_LaneToLaneTransition_ToNewLine1CenterEnd_FromNewLine2CenterStart_SolidWhite',...
            'DesignDrawings_LaneExtension_ToNewLine1CenterMiddleEnd_FromNewLine1CenterMiddle_SolidWhite',...
            'DesignDrawings_LaneExtension_ToNewLine2CenterMiddleEnd_FromNewLine2CenterMiddle_SolidWhite',...
            'DesignDrawings_LaneExtension_ToNewLine3CenterMiddleEnd_FromNewLine3CenterMiddle_SolidWhite',...
            'DesignDrawings_LaneExtension_ToNewLine2CenterEnd_FromNewLine2CenterNearEnd_SolidWhite',...
            'DesignDrawings_LaneExtension_ToNewLine3CenterEnd_FromNewLine3CenterNearEnd_SolidWhite',...
            'DesignDrawings_LaneExtension_ToNewLine2CenterEnd_FromNewLine2CenterVeryEnd_SolidWhite',...
            'DesignDrawings_LaneExtension_ToNewLine2CenterMiddleish_FromNewLine2CenterStart_SolidWhite',...
            'DesignDrawings_LaneToLaneTransition_ToNewLine2Center_FromNewLine3Center_SolidWhite',...
            'DesignDrawings_LaneToLaneTransition_ToNewLine3Center_FromNewLine4Center_SolidYellow',...
            'DesignDrawings_LaneToLaneTransition_ToNewLine2Center_FromNewLine1Center_SolidWhite',...
            'DesignDrawings_LaneToLaneTransition_ToNewLine3Center_FromNewLine2Center_SolidWhite',...
            'DesignDrawings_LaneToLaneTransition_ToNewLine4Center_FromNewLine3Center_SolidYellow',...
            }

        % Get data from KML file
        % Open KML file directly - show this using scenario 6_1
        scenario_6_1_KML_file_name = 'Scenario_6_1_modified_lines.kml';
        scenario_6_1_data_matricies = fcn_PlotTestTrack_parseKML(scenario_6_1_KML_file_name);


        switch TraceSearchString

            case 'DesignDrawings_LaneExtension_ToNewLine2Center_FromHandlingArea2_SolidWhite'
                % lane shift lines scn 6.1 (lane 4 - lane 3 - lane 4, single white)
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    flipud(scenario_6_1_data_matricies{12}); nan(1,3); ...
                    ]);


            case 'DesignDrawings_LaneExtension_ToNewLine3Center_FromNewLine3CenterStart_SolidWhite'
                % Scenario 6.1 (plot to find out)
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    flipud(scenario_6_1_data_matricies{8}); nan(1,3); ...
                    ]);

            case 'DesignDrawings_LaneToLaneTransition_ToNewLine1CenterEnd_FromNewLine2CenterStart_SolidWhite'
                % lane shift lines scn 6.1 (lane 4 - lane 3 - lane 4, single white)
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    flipud(scenario_6_1_data_matricies{22}); nan(1,3);  ...
                    ]);

            case 'DesignDrawings_LaneExtension_ToNewLine1CenterMiddleEnd_FromNewLine1CenterMiddle_SolidWhite'

                % lane shift lines scn 6.1 (lane 4 - lane 3 - lane 4, single white)
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    flipud(scenario_6_1_data_matricies{19}); nan(1,3);  ...
                    ]);

            case 'DesignDrawings_LaneExtension_ToNewLine2CenterMiddleEnd_FromNewLine2CenterMiddle_SolidWhite'

                % lane shift lines scn 6.1 (lane 5 - lane 4 - lane 5, single white)
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    flipud(scenario_6_1_data_matricies{20}); nan(1,3);...
                    ]);

            case 'DesignDrawings_LaneExtension_ToNewLine3CenterMiddleEnd_FromNewLine3CenterMiddle_SolidWhite'

                % Scenario 6.1 (plot to find out)
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    flipud(scenario_6_1_data_matricies{25}); nan(1,3); ...
                    ]);


            case 'DesignDrawings_LaneExtension_ToNewLine2CenterEnd_FromNewLine2CenterNearEnd_SolidWhite'
                % lane shift lines scn 6.1 (lane 4 - lane 3 - lane 4, single white)
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    flipud(scenario_6_1_data_matricies{17}); nan(1,3);   ...
                    ]);

            case 'DesignDrawings_LaneExtension_ToNewLine3CenterEnd_FromNewLine3CenterNearEnd_SolidWhite'
                % Scenario 6.1 (plot to find out)
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    flipud(scenario_6_1_data_matricies{18})...
                    ]);

            case 'DesignDrawings_LaneExtension_ToNewLine2CenterEnd_FromNewLine2CenterVeryEnd_SolidWhite'
                % lane shift lines scn 6.1 (lane 4 - lane 3 - lane 4, single white)
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    flipud(scenario_6_1_data_matricies{11}); nan(1,3);   ...
                    ]);

            case 'DesignDrawings_LaneExtension_ToNewLine2CenterMiddleish_FromNewLine2CenterStart_SolidWhite'
                % lane shift lines scn 6.1 (lane 4 - lane 3 - lane 4, single white)
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    flipud(scenario_6_1_data_matricies{7}); nan(1,3);  ...
                    ]);

            case 'DesignDrawings_LaneToLaneTransition_ToNewLine2Center_FromNewLine3Center_SolidWhite'
                % lane shift lines scn 6.1 (lane 5 - lane 4 - lane 5, single white)
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    flipud(scenario_6_1_data_matricies{21}); nan(1,3);...
                    ]);

            case 'DesignDrawings_LaneToLaneTransition_ToNewLine3Center_FromNewLine4Center_SolidYellow'  % Used to be called: DesignDrawings_LaneToLaneTransition_ToNewLine3Center_FromNewLine4Center_SolidWhite
                % % For debugging
                % figure(3883);
                %
                %
                % grid on;
                % for ith_trace = 1:length(scenario_6_1_data_matricies)
                %     data_to_plot = scenario_6_1_data_matricies{ith_trace};
                %     fprintf(1,'Trace: %.0d\n',ith_trace);
                %     geoplot(data_to_plot(:,1),data_to_plot(:,2),'-','LineWidth',3);
                %     hold on;
                %     geoplot(data_to_plot(1,1),data_to_plot(1,2),'.','MarkerSize',20);
                %     pause;
                % end

                % Scenario 6.1 (plot to find out)
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    flipud(scenario_6_1_data_matricies{26}); nan(1,3); ...
                    ]);



            case 'DesignDrawings_LaneToLaneTransition_ToNewLine2Center_FromNewLine1Center_SolidWhite'
                % lane shift lines scn 6.1 (lane 4 - lane 3 - lane 4, single white)
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    flipud(scenario_6_1_data_matricies{23}); nan(1,3);   ...
                    ]);

            case 'DesignDrawings_LaneToLaneTransition_ToNewLine3Center_FromNewLine2Center_SolidWhite'
                % lane shift lines scn 6.1 (lane 5 - lane 4 - lane 5, single white)
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    flipud(scenario_6_1_data_matricies{24})...
                    ]);

            case 'DesignDrawings_LaneToLaneTransition_ToNewLine4Center_FromNewLine3Center_SolidYellow'
                % Scenario 6.1 (plot to find out)
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    flipud(scenario_6_1_data_matricies{27}) ...
                    ]);

            otherwise
                error('Unknown situation for: %s', TraceSearchString);
        end


    case 'DesignDrawings_LaneExtension_ToNewLine3CenterEnd_FromNewLine3CenterMiddle_SolidWhite'
        % lane shift lines scn 2.3 (lane 3-5-3, single white)
        % load scenario for new data
        LL_new_SW  =  [
            40.862547246000076 -77.834126652999942                   0
            40.862976956526282 -77.833520483642005                   0
            NaN                 NaN                 NaN
            40.862976956526282 -77.833520483642005                   0
            40.864030809601267 -77.831713091231890                   0
            NaN                 NaN                 NaN
            40.864030809601267 -77.831713091231890                   0
            40.864059574000073 -77.831532981999942                   0
            ];



        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            [],...
            LL_new_SW);
        ENU_positions_cell_array = {ENU_positions_cell_array{2}}; %#ok<*CCAT1>  % FIX THIS WARNING
        LLA_positions_cell_array = {LLA_positions_cell_array{2}};






        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %   _                   _______    _                   _______                  _ _   _
        %  | |                 |__   __|  | |                 |__   __|                (_) | (_)
        %  | |     __ _ _ __   ___| | ___ | |     __ _ _ __   ___| |_ __ __ _ _ __  ___ _| |_ _  ___  _ __
        %  | |    / _` | '_ \ / _ \ |/ _ \| |    / _` | '_ \ / _ \ | '__/ _` | '_ \/ __| | __| |/ _ \| '_ \
        %  | |___| (_| | | | |  __/ | (_) | |___| (_| | | | |  __/ | | | (_| | | | \__ \ | |_| | (_) | | | |
        %  |______\__,_|_| |_|\___|_|\___/|______\__,_|_| |_|\___|_|_|  \__,_|_| |_|___/_|\__|_|\___/|_| |_|
        %
        %
        % See: http://patorjk.com/software/taag/#p=display&f=Big&t=LaneToLaneTransition%0A
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    case 'DesignDrawings_LaneToLaneTransition_ToNewLine3_FromNewLine1_SolidWhite'
        % lane shift lines scn 2.3 (lane 3-5-3, single white)
        % load scenario for new data
        LL_new_SW  =  [
            40.862547246000076 -77.834126652999942                   0
            40.862976956526282 -77.833520483642005                   0
            NaN                 NaN                 NaN
            40.862976956526282 -77.833520483642005                   0
            40.864030809601267 -77.831713091231890                   0
            NaN                 NaN                 NaN
            40.864030809601267 -77.831713091231890                   0
            40.864059574000073 -77.831532981999942                   0
            ];

        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            [],...
            LL_new_SW);
        ENU_positions_cell_array = {ENU_positions_cell_array{1}};
        LLA_positions_cell_array = {LLA_positions_cell_array{1}};


    case 'DesignDrawings_LaneToLaneTransition_ToNewLine4Right_FromNewLine2Right_SolidYellow'
        % lane shift lines scn 2.3 (lane 4-6-4, double yellow)
        LL_new_DY_outer = [

        40.862570108000057 -77.834149762999971                   0
        40.862999811669440 -77.833543602537219                   0
        NaN                 NaN                 NaN
        40.862999811669440 -77.833543602537219                   0
        40.864081413045056 -77.831688620161501                   0
        NaN                 NaN                 NaN
        40.864081413045056 -77.831688620161501                   0
        40.864415310000027 -77.830985178999981                   0];
        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            [],...
            LL_new_DY_outer);
        ENU_positions_cell_array = {ENU_positions_cell_array{1}};
        LLA_positions_cell_array = {LLA_positions_cell_array{1}};


    case 'DesignDrawings_LaneToLaneTransition_ToNewLine4Left_FromNewLine2Left_SolidYellow'
        % lane shift lines scn 2.3 (lane 4-6-4, double yellow)
        LL_new_DY_inner = [

        40.862572285000063 -77.834151964999990                   0
        40.863001992807654 -77.833545797119655                   0
        NaN                 NaN                 NaN
        40.863001992807654 -77.833545797119655                   0
        40.864083589927198 -77.831690822043029                   0
        NaN                 NaN                 NaN
        40.864083589927198 -77.831690822043029                   0
        40.864417487000033 -77.830987380999943                   0];

        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            [],...
            LL_new_DY_inner);
        ENU_positions_cell_array = {ENU_positions_cell_array{1}};
        LLA_positions_cell_array = {LLA_positions_cell_array{1}};



    case 'DesignDrawings_LaneToLaneTransition_ToNewLine1Center_FromNewLine3Center_SolidWhite'
        % lane shift lines scn 2.3 (lane 3-5-3, single white)
        % load scenario for new data
        LL_new_SW  =  [
            40.862547246000076 -77.834126652999942                   0
            40.862976956526282 -77.833520483642005                   0
            NaN                 NaN                 NaN
            40.862976956526282 -77.833520483642005                   0
            40.864030809601267 -77.831713091231890                   0
            NaN                 NaN                 NaN
            40.864030809601267 -77.831713091231890                   0
            40.864059574000073 -77.831532981999942                   0
            ];

        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            [],...
            LL_new_SW);
        ENU_positions_cell_array = {ENU_positions_cell_array{3}};
        LLA_positions_cell_array = {LLA_positions_cell_array{3}};


    case 'DesignDrawings_LaneExtension_ToNewLine4RightMiddle_FromNewLine4RightMiddle_SolidYellow'
        % lane shift lines scn 2.3 (lane 4-6-4, double yellow)
        LL_new_DY_outer = [

        40.862570108000057 -77.834149762999971                   0
        40.862999811669440 -77.833543602537219                   0
        NaN                 NaN                 NaN
        40.862999811669440 -77.833543602537219                   0
        40.864081413045056 -77.831688620161501                   0
        NaN                 NaN                 NaN
        40.864081413045056 -77.831688620161501                   0
        40.864415310000027 -77.830985178999981                   0];
        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            [],...
            LL_new_DY_outer);
        ENU_positions_cell_array = {ENU_positions_cell_array{2}};
        LLA_positions_cell_array = {LLA_positions_cell_array{2}};

        % TO_DO: move this as it has been renamed
    case 'DesignDrawings_LaneExtension_ToNewLine4LeftMiddle_FromNewLine4LeftMiddle_SolidYellow'
        % lane shift lines scn 2.3 (lane 4-6-4, double yellow)
        LL_new_DY_inner = [

        40.862572285000063 -77.834151964999990                   0
        40.863001992807654 -77.833545797119655                   0
        NaN                 NaN                 NaN
        40.863001992807654 -77.833545797119655                   0
        40.864083589927198 -77.831690822043029                   0
        NaN                 NaN                 NaN
        40.864083589927198 -77.831690822043029                   0
        40.864417487000033 -77.830987380999943                   0];

        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            [],...
            LL_new_DY_inner);
        ENU_positions_cell_array = {ENU_positions_cell_array{2}};
        LLA_positions_cell_array = {LLA_positions_cell_array{2}};



    case 'DesignDrawings_LaneToLaneTransition_ToNewLine2Right_FromNewLine4Right2_SolidYellow'
        % lane shift lines scn 2.3 (lane 4-6-4, double yellow)
        LL_new_DY_outer = [
            40.862570108000057 -77.834149762999971                   0
            40.862999811669440 -77.833543602537219                   0
            NaN                 NaN                 NaN
            40.862999811669440 -77.833543602537219                   0
            40.864081413045056 -77.831688620161501                   0
            NaN                 NaN                 NaN
            40.864081413045056 -77.831688620161501                   0
            40.864415310000027 -77.830985178999981                   0];
        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            [],...
            LL_new_DY_outer);
        ENU_positions_cell_array = {ENU_positions_cell_array{3}};
        LLA_positions_cell_array = {LLA_positions_cell_array{3}};

    case 'DesignDrawings_LaneToLaneTransition_ToNewLine2Left_FromNewLine4Left2_SolidYellow'
        % lane shift lines scn 2.3 (lane 4-6-4, double yellow)
        LL_new_DY_inner = [

        40.862572285000063 -77.834151964999990                   0
        40.863001992807654 -77.833545797119655                   0
        NaN                 NaN                 NaN
        40.863001992807654 -77.833545797119655                   0
        40.864083589927198 -77.831690822043029                   0
        NaN                 NaN                 NaN
        40.864083589927198 -77.831690822043029                   0
        40.864417487000033 -77.830987380999943                   0];

        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            [],...
            LL_new_DY_inner);
        ENU_positions_cell_array = {ENU_positions_cell_array{3}};
        LLA_positions_cell_array = {LLA_positions_cell_array{3}};


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %    _____ _              _      _
        %   / ____| |            | |    (_)
        %  | (___ | |_ ___  _ __ | |     _ _ __   ___
        %   \___ \| __/ _ \| '_ \| |    | | '_ \ / _ \
        %   ____) | || (_) | |_) | |____| | | | |  __/
        %  |_____/ \__\___/| .__/|______|_|_| |_|\___|
        %                  | |
        %                  |_|
        % See: http://patorjk.com/software/taag/#p=display&f=Big&t=StopLine
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    case {...
            'DesignDrawings_StopLine_DetourLines_NorthExitSolidWhite',...
            'DesignDrawings_StopLine_DetourLines_NorthExitSolidWhite_StartOfStopLine',...
            'DesignDrawings_StopLine_DetourLines_NorthExitSolidWhite_FinishOfStopLine',...
            'DesignDrawings_StopLine_DetourLines_CrossroadsSolidWhite',...
            'DesignDrawings_StopLine_DetourLines_CrossroadsSolidWhite_StartOfStopLine',...
            'DesignDrawings_StopLine_DetourLines_CrossroadsSolidWhite_FinishOfStopLine',...
            'DesignDrawings_StopLine_DetourLines_CurveAroundGarageSolidWhite',...
            'DesignDrawings_StopLine_DetourLines_CurveAroundGarageSolidWhite_StartOfStopLine',...
            'DesignDrawings_StopLine_DetourLines_CurveAroundGarageSolidWhite_FinishOfStopLine',...
            'DesignDrawings_StopLine_DetourLines_HandlingAreaOutflowSolidWhite',...
            'DesignDrawings_StopLine_DetourLines_HandlingAreaOutflowSolidWhite_StartOfStopLine',...
            'DesignDrawings_StopLine_DetourLines_HandlingAreaOutflowSolidWhite_FinishOfStopLine',...
            'DesignDrawings_StopLine_DetourLines_SouthWestSolidWhite',...
            'DesignDrawings_StopLine_DetourLines_SouthWestSolidWhite_StartOfStopLine',...
            'DesignDrawings_StopLine_DetourLines_SouthWestSolidWhite_FinishOfStopLine',...
            'DesignDrawings_DetourLines_HandlingAreaEntryOutboundRightSolidWhite',...
            'DesignDrawings_DetourLines_HandlingAreaEntryInboundRightSolidWhite',...
            'DesignDrawings_DetourLines_HandlingAreaEntryLeftDoubleYellow',...
            'DesignDrawings_DetourLines_HandlingAreaEntryRightDoubleYellow',...
            'DesignDrawings_DetourLines_HandlingAreaExitOutboundRightSolidWhite',...
            'DesignDrawings_DetourLines_HandlingAreaExitInboundRightSolidWhite',...
            'DesignDrawings_DetourLines_HandlingAreaExitLeftDoubleYellow',...
            'DesignDrawings_DetourLines_HandlingAreaExitRightDoubleYellow',...
            'DesignDrawings_DetourLines_NorthExitSingleSolidWhite',...
            'DesignDrawings_DetourLines_NorthExitRightDoubleYellow',...
            'DesignDrawings_DetourLines_NorthExitLeftDoubleYellow',...
            'DesignDrawings_DetourLines_CrossroadEntryRightSolidYellow',...
            'DesignDrawings_DetourLines_CrossroadEntryLeftSolidYellow',...
            'DesignDrawings_DetourLines_CurveAroundGarageRightDoubleYellow',...
            'DesignDrawings_DetourLines_CurveAroundGarageLeftDoubleYellow',...
            }

        % Get data from KML file
        % Open KML file directly - show this using scenario 1_4

        scenario_1_2_KML_file_name = 'Scenario_1_2_Modified_lines.kml';
        scenario_1_2_data_matricies = fcn_PlotTestTrack_parseKML(scenario_1_2_KML_file_name);

        switch TraceSearchString

            case 'DesignDrawings_StopLine_DetourLines_NorthExitSolidWhite'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [scenario_1_2_data_matricies{13}]);

            case 'DesignDrawings_StopLine_DetourLines_NorthExitSolidWhite_StartOfStopLine'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [flipud(scenario_1_2_data_matricies{13}(4:5,:))]);

            case 'DesignDrawings_StopLine_DetourLines_NorthExitSolidWhite_FinishOfStopLine'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [scenario_1_2_data_matricies{13}(2:3,:)]);

            case 'DesignDrawings_StopLine_DetourLines_CrossroadsSolidWhite'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [scenario_1_2_data_matricies{7}]);

            case 'DesignDrawings_StopLine_DetourLines_CrossroadsSolidWhite_StartOfStopLine'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [scenario_1_2_data_matricies{7}(2:3,:)]);

            case 'DesignDrawings_StopLine_DetourLines_CrossroadsSolidWhite_FinishOfStopLine'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [flipud(scenario_1_2_data_matricies{7}(4:5,:))]);

            case 'DesignDrawings_StopLine_DetourLines_CurveAroundGarageSolidWhite'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [scenario_1_2_data_matricies{1}]);

            case 'DesignDrawings_StopLine_DetourLines_CurveAroundGarageSolidWhite_StartOfStopLine'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [flipud(scenario_1_2_data_matricies{1}(4:5,:))]);

            case 'DesignDrawings_StopLine_DetourLines_CurveAroundGarageSolidWhite_FinishOfStopLine'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [scenario_1_2_data_matricies{1}(2:3,:)]);

            case 'DesignDrawings_StopLine_DetourLines_HandlingAreaOutflowSolidWhite'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    scenario_1_2_data_matricies{17}; nan(1,3); ...
                    ]);

            case 'DesignDrawings_StopLine_DetourLines_HandlingAreaOutflowSolidWhite_StartOfStopLine'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    flipud(scenario_1_2_data_matricies{17}(2:3,:)); nan(1,3); ...
                    ]);

            case 'DesignDrawings_StopLine_DetourLines_HandlingAreaOutflowSolidWhite_FinishOfStopLine'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    scenario_1_2_data_matricies{17}(4:5,:); nan(1,3); ...
                    ]);

            case 'DesignDrawings_StopLine_DetourLines_SouthWestSolidWhite'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    scenario_1_2_data_matricies{9}; nan(1,3); ...
                    ]);
            case 'DesignDrawings_StopLine_DetourLines_SouthWestSolidWhite_StartOfStopLine'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    flipud(scenario_1_2_data_matricies{9}(2:3,:)); nan(1,3); ...
                    ]);
            case 'DesignDrawings_StopLine_DetourLines_SouthWestSolidWhite_FinishOfStopLine'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    scenario_1_2_data_matricies{9}(4:5,:); nan(1,3); ...
                    ]);

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %
                %
                %   _____       _                   _      _
                %  |  __ \     | |                 | |    (_)
                %  | |  | | ___| |_ ___  _   _ _ __| |     _ _ __   ___  ___
                %  | |  | |/ _ \ __/ _ \| | | | '__| |    | | '_ \ / _ \/ __|
                %  | |__| |  __/ || (_) | |_| | |  | |____| | | | |  __/\__ \
                %  |_____/ \___|\__\___/ \__,_|_|  |______|_|_| |_|\___||___/
                %
                %
                % See: http://patorjk.com/software/taag/#p=display&f=Big&t=DetourLines
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            case 'DesignDrawings_DetourLines_HandlingAreaEntryOutboundRightSolidWhite'
                LLA_data_trace = scenario_1_2_data_matricies{23};
                ENU_data_trace  = gps_object.WGSLLA2ENU(LLA_data_trace(:,1), LLA_data_trace(:,2), LLA_data_trace(:,3));

                % Cut the trace at about 30% of the length
                ENU_data_trace = [ENU_data_trace(1,:); ENU_data_trace(1,:) + (0.3)*(ENU_data_trace(2,:)-ENU_data_trace(1,:))];

                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [ENU_data_trace],...
                    []);

            case 'DesignDrawings_DetourLines_HandlingAreaEntryInboundRightSolidWhite'
                LLA_data_trace = scenario_1_2_data_matricies{25};
                ENU_data_trace  = gps_object.WGSLLA2ENU(LLA_data_trace(:,1), LLA_data_trace(:,2), LLA_data_trace(:,3));

                % Cut the trace at about 30% of the length
                ENU_data_trace = [ENU_data_trace(1,:); ENU_data_trace(1,:) + (0.3)*(ENU_data_trace(2,:)-ENU_data_trace(1,:))];

                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [ENU_data_trace],...
                    []);


            case 'DesignDrawings_DetourLines_HandlingAreaEntryLeftDoubleYellow'
                LLA_data_trace = scenario_1_2_data_matricies{41};
                ENU_data_trace  = gps_object.WGSLLA2ENU(LLA_data_trace(:,1), LLA_data_trace(:,2), LLA_data_trace(:,3));

                % Cut the trace at about 30% of the length
                ENU_data_trace = [ENU_data_trace(1,:); ENU_data_trace(1,:) + (0.3)*(ENU_data_trace(2,:)-ENU_data_trace(1,:))];

                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [ENU_data_trace],...
                    []);

            case 'DesignDrawings_DetourLines_HandlingAreaEntryRightDoubleYellow'

                LLA_data_trace = scenario_1_2_data_matricies{40};
                ENU_data_trace  = gps_object.WGSLLA2ENU(LLA_data_trace(:,1), LLA_data_trace(:,2), LLA_data_trace(:,3));

                % Cut the trace at about 30% of the length
                ENU_data_trace = [ENU_data_trace(1,:); ENU_data_trace(1,:) + (0.3)*(ENU_data_trace(2,:)-ENU_data_trace(1,:))];

                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [ENU_data_trace],...
                    []);


            case 'DesignDrawings_DetourLines_HandlingAreaExitOutboundRightSolidWhite'
                LLA_data_trace = scenario_1_2_data_matricies{23};
                ENU_data_trace  = gps_object.WGSLLA2ENU(LLA_data_trace(:,1), LLA_data_trace(:,2), LLA_data_trace(:,3));

                % Cut the trace at about 30% of the length
                ENU_data_trace = [ENU_data_trace(1,:) + (0.3)*(ENU_data_trace(2,:)-ENU_data_trace(1,:)); ENU_data_trace(2,:)];

                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [ENU_data_trace],...
                    []);


            case 'DesignDrawings_DetourLines_HandlingAreaExitInboundRightSolidWhite'
                LLA_data_trace = scenario_1_2_data_matricies{25};
                ENU_data_trace  = gps_object.WGSLLA2ENU(LLA_data_trace(:,1), LLA_data_trace(:,2), LLA_data_trace(:,3));

                % Cut the trace at about 30% of the length
                ENU_data_trace = [ENU_data_trace(1,:) + (0.3)*(ENU_data_trace(2,:)-ENU_data_trace(1,:)); ENU_data_trace(2,:)];

                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [ENU_data_trace],...
                    []);

            case 'DesignDrawings_DetourLines_HandlingAreaExitLeftDoubleYellow'
                LLA_data_trace = scenario_1_2_data_matricies{41};
                ENU_data_trace  = gps_object.WGSLLA2ENU(LLA_data_trace(:,1), LLA_data_trace(:,2), LLA_data_trace(:,3));

                % Cut the trace at about 30% of the length
                ENU_data_trace = [ENU_data_trace(1,:) + (0.3)*(ENU_data_trace(2,:)-ENU_data_trace(1,:)); ENU_data_trace(2,:)];

                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [ENU_data_trace],...
                    []);

            case 'DesignDrawings_DetourLines_HandlingAreaExitRightDoubleYellow'
                LLA_data_trace = scenario_1_2_data_matricies{40};
                ENU_data_trace  = gps_object.WGSLLA2ENU(LLA_data_trace(:,1), LLA_data_trace(:,2), LLA_data_trace(:,3));

                % Cut the trace at about 30% of the length
                ENU_data_trace = [ENU_data_trace(1,:) + (0.3)*(ENU_data_trace(2,:)-ENU_data_trace(1,:)); ENU_data_trace(2,:)];

                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [ENU_data_trace],...
                    []);


            case 'DesignDrawings_DetourLines_NorthExitSingleSolidWhite'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [scenario_1_2_data_matricies{24}]);

            case 'DesignDrawings_DetourLines_NorthExitRightDoubleYellow'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [scenario_1_2_data_matricies{42}]);

            case 'DesignDrawings_DetourLines_NorthExitLeftDoubleYellow'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [scenario_1_2_data_matricies{43}]);

            case 'DesignDrawings_DetourLines_CrossroadEntryRightSolidYellow'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [scenario_1_2_data_matricies{26}]);

            case 'DesignDrawings_DetourLines_CrossroadEntryLeftSolidYellow'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [scenario_1_2_data_matricies{27}]);

            case 'DesignDrawings_DetourLines_CurveAroundGarageRightDoubleYellow'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [scenario_1_2_data_matricies{39};... 1st
                    scenario_1_2_data_matricies{38};...  2nd
                    scenario_1_2_data_matricies{37};...  3rd
                    scenario_1_2_data_matricies{36};...  4th
                    scenario_1_2_data_matricies{35};...  5th
                    scenario_1_2_data_matricies{34}]);...  6th

            case 'DesignDrawings_DetourLines_CurveAroundGarageLeftDoubleYellow'
                [ENU_positions_cell_array, LLA_positions_cell_array] = ...
                    fcn_INTERNAL_prepDataForOutput(...
                    [],...
                    [...
                    scenario_1_2_data_matricies{33}; ... 1st
                    scenario_1_2_data_matricies{32}; ... 2nd
                    scenario_1_2_data_matricies{31}; ... 3rd
                    scenario_1_2_data_matricies{22}; ... 4th
                    scenario_1_2_data_matricies{21}; ... 5th
                    scenario_1_2_data_matricies{20}; ... 6th

                    ]);


            otherwise
                error('Unknown situation for: %s', TraceSearchString);
        end




        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  _                       _____ _
        % | |                     / ____| |                              /\
        % | |     __ _ _ __   ___| |    | |__   __ _ _ __   __ _  ___   /  \   _ __ ___  __ _
        % | |    / _` | '_ \ / _ \ |    | '_ \ / _` | '_ \ / _` |/ _ \ / /\ \ | '__/ _ \/ _` |
        % | |___| (_| | | | |  __/ |____| | | | (_| | | | | (_| |  __// ____ \| | |  __/ (_| |
        % |______\__,_|_| |_|\___|\_____|_| |_|\__,_|_| |_|\__, |\___/_/    \_\_|  \___|\__,_|
        %                                                   __/ |
        %                                                  |___/
        % See: http://patorjk.com/software/taag/#p=display&f=Big&t=LaneChangeArea
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    case {...
            'DesignDrawings_OriginalLaneChangeArea_SouthMarkerCluster_SolidWhite',...
            'DesignDrawings_OriginalLaneChangeArea_MiddleMarkerCluster_BrokenWhite',...
            'DesignDrawings_OriginalLaneChangeArea_NorthMarkerCluster_SolidYellow',...
            'DesignDrawings_OriginalLaneChangeArea_CenterlineReference_SolidYellow',...
            'DesignDrawings_OriginalLaneChangeArea_CenterlineReference_SolidWhite'}

        % Fill in the lane change area design drawings

        [LLA_position_array, ENU_position_array] = ...
            fcn_PlotTestTrack_loadDesignLaneChangeAreaCoordinates(TraceSearchString);

        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            ENU_position_array,...
            LLA_position_array);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %    _____                    _    _       _      _
        %   / ____|                  | |  | |     | |    (_)
        %  | |     _____   _____ _ __| |  | |_ __ | |     _ _ __   ___  ___
        %  | |    / _ \ \ / / _ \ '__| |  | | '_ \| |    | | '_ \ / _ \/ __|
        %  | |___| (_) \ V /  __/ |  | |__| | |_) | |____| | | | |  __/\__ \
        %   \_____\___/ \_/ \___|_|   \____/| .__/|______|_|_| |_|\___||___/
        %                                   | |
        %                                   |_|
        % See: http://patorjk.com/software/taag/#p=display&f=Big&t=AlignedDesign
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    case 'DesignDrawings_CoverUpLine_CoverEntryTransition'
        % The following data is calculated in
        % script_test_fcn_PlotTestTrack_calculateCoverTrace
        ENU_position_array = 100*[
            0.088910715996530  -1.777780656976855                   0
            0.107906827196241  -1.780956863822956                   0
            0.138037544690753  -1.785068146364307                   0
            0.187477183142934  -1.789357061416710                   0
            0.212226934528090  -1.790899577090428                   0
            0.236961510306960  -1.792444305695909                   0
            0.286456801886743  -1.795360488860368                   0
            0.336038092253843  -1.796932847977409                   0
            0.385648044016868  -1.797019230020814                   0
            0.435243653981685  -1.795686269519557                   0
            0.484765053210879  -1.792525276793981                   0
            0.583265650499924  -1.780538174990616                   0
            0.632122586844591  -1.771960835423565                   0
            0.680736674094711  -1.762145179405451                   0
            0.729161030641389  -1.751344417074285                   0
            0.753225224793059  -1.745302670935126                   0
            0.777135956241743  -1.738686753510959                   0
            0.824582192053311  -1.724197733561031                   0
            0.871711374412371  -1.708714726013757                   0
            0.895103528584339  -1.700462905811329                   0
            0.918328728758036  -1.691746861716241                   0
            0.926884934754666  -1.688410600391031                   0
            0.964322112458295  -1.673156432216332                   0
            ];

        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            ENU_position_array,...
            []);

    case 'DesignDrawings_CoverUpLine_CoverEntryTransition2'
        % The following data is calculated in
        % script_test_fcn_PlotTestTrack_calculateCoverTrace
        ENU_position_array = 100*[
            0.107906827196241  -1.780956863822956                   0
            0.138037544690753  -1.785068146364307                   0
            0.187477183142934  -1.789357061416710                   0
            0.212226934528090  -1.790899577090428                   0
            0.236961510306960  -1.792444305695909                   0
            0.286456801886743  -1.795360488860368                   0
            0.336038092253843  -1.796932847977409                   0
            0.385648044016868  -1.797019230020814                   0
            0.435243653981685  -1.795686269519557                   0
            0.484765053210879  -1.792525276793981                   0
            0.583265650499924  -1.780538174990616                   0
            0.632122586844591  -1.771960835423565                   0
            0.680736674094711  -1.762145179405451                   0
            0.729161030641389  -1.751344417074285                   0
            0.753225224793059  -1.745302670935126                   0
            0.777135956241743  -1.738686753510959                   0
            0.824582192053311  -1.724197733561031                   0
            0.871711374412371  -1.708714726013757                   0
            0.895103528584339  -1.700462905811329                   0
            0.918328728758036  -1.691746861716241                   0
            0.926884934754666  -1.688410600391031                   0
            0.964322112458295  -1.673156432216332                   0
            ];

        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            ENU_position_array,...
            []);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %            _ _                      _ _____            _
        %      /\   | (_)                    | |  __ \          (_)
        %     /  \  | |_  __ _ _ __   ___  __| | |  | | ___  ___ _  __ _ _ __
        %    / /\ \ | | |/ _` | '_ \ / _ \/ _` | |  | |/ _ \/ __| |/ _` | '_ \
        %   / ____ \| | | (_| | | | |  __/ (_| | |__| |  __/\__ \ | (_| | | | |
        %  /_/    \_\_|_|\__, |_| |_|\___|\__,_|_____/ \___||___/_|\__, |_| |_|
        %                 __/ |                                     __/ |
        %                |___/                                     |___/
        % See: http://patorjk.com/software/taag/#p=display&f=Big&t=AlignedDesign
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    case 'AlignedDesign_OriginalTrackLane_InnerMarkerClusterCenterline'
        [LLA_position_array, ENU_position_array] = fcn_PlotTestTrack_shiftCenterline();

        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            ENU_position_array{1},...
            LLA_position_array{1});

        % HERE IS THE CORRECT FORMAT
        %             [LLA_position_array, ENU_position_array] = fcn_PlotTestTrack_shiftCenterline();
        %
        %             [ENU_positions_cell_array, LLA_positions_cell_array] = ...
        %                 fcn_INTERNAL_prepDataForOutput(...
        %                 ENU_position_array,...
        %                 LLA_position_array);

    case 'AlignedDesign_OuterTrackLane_DetourStartLineSolidWhite'
        % Added on 2023_10_12 from hand measurements in the field
        ENU_position_array = [
            -126.245016932 -42.0345622171 -11.2933863864
            -123.230250738 -41.6024408754 -11.6193246846
            -122.951980258 -41.5514207604 -11.6493189762
            -122.814758023 -42.5499390014 -11.6683229437
            -123.065368529 -42.5850581549 -11.6413280088
            -126.10003428 -43.045038467 -11.2853902764
            ];

        % % For debugging
        % figure(38383);
        % clf;
        % hold on;
        % grid on;
        % axis equal;
        % plot(ENU_position_array(:,1),ENU_position_array(:,2),'k.-');
        % for ith_point = 1:length(ENU_position_array(:,1))
        %     current_point = ENU_position_array(ith_point,:);
        %     text(current_point(1,1),current_point(1,2),sprintf('%.0d',ith_point));
        % end

        startline_position_ENU = [ENU_position_array(6,:); ENU_position_array(4,:)];

        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            startline_position_ENU,...
            []);

    case 'AlignedDesign_OuterTrackLane_DetourFinishLineSolidWhite'
        % Added on 2023_09_25 by copying from fcn_PlotTestTrack_loadObjectsforScenarios.m
        StartEndLLACellArray = fcn_PlotTestTrack_parseKML('Scenario1-1_StartLine.kml');
        % Added on 2023_10_12 from hand measurements in the field
        ENU_position_array = [
            -126.245016932 -42.0345622171 -11.2933863864
            -123.230250738 -41.6024408754 -11.6193246846
            -122.951980258 -41.5514207604 -11.6493189762
            -122.814758023 -42.5499390014 -11.6683229437
            -123.065368529 -42.5850581549 -11.6413280088
            -126.10003428 -43.045038467 -11.2853902764
            ];

        finishline_position_ENU = [ENU_position_array(1,:); ENU_position_array(3,:)];

        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            finishline_position_ENU,...
            []);


    case 'AlignedDesign_OuterTrackLane_EntryJunctionStartLineSolidClear'

        % Added on 2023_10_20 for Scenario 4.3
        EntryJunctionStartLine_LLA = [
            40.862089426238128 -77.835057931202002 0;
            40.862120012317071 -77.835069867101765 0;
            ];

        offsets = [-8.000000000000000e-07 5.400000000000000e-06 0];

        EntryJunctionStartLine_LLA = EntryJunctionStartLine_LLA-ones(2,1)*offsets;

        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            [],...
            EntryJunctionStartLine_LLA);

    case {...
            'AlignedDesign_OriginalTrackLane_OuterMarkerClusterSolidWhite',...
            'AlignedDesign_OriginalTrackLane_InnerMarkerClusterOuterDoubleYellow',...
            'AlignedDesign_OriginalTrackLane_InnerMarkerClusterOuterDoubleYellow_2',...
            'AlignedDesign_OriginalTrackLane_InnerMarkerClusterInnerDoubleYellow',...
            'AlignedDesign_OriginalHandlingCircle_SolidYellow',...
            'AlignedDesign_AcousticTestingArea_SouthSolidWhite',...
            'AlignedDesign_AcousticTestingArea_NorthSolidWhite',...
            'AlignedDesign_OuterTrackLane_StartLineSolidWhite',...
            'AlignedDesign_OuterTrackLane_FinishLineSolidWhite',...
            'AlignedDesign_OuterTrackLane_DetourReentryLineSolidClear',...
            'AlignedDesign_NewLine1_Center_SolidWhite',...
            'AlignedDesign_NewLine2_Right_SolidYellow',...
            'AlignedDesign_NewLine2_Center_DashedWhite',...
            'AlignedDesign_NewLine2_Left_DashedYellow',...
            'AlignedDesign_NewLine3_Right_DashedYellow',...
            'AlignedDesign_NewLine3_Center_DashedWhite',...
            'AlignedDesign_NewLine3_Left_SolidYellow',...
            'AlignedDesign_NewLine4_Right_SolidYellow',...
            'AlignedDesign_NewLine4_Center_SolidWhite',...
            'AlignedDesign_NewLine4_Left_SolidYellow',...
            'AlignedDesign_EntryTransitions_ToNewLine1_FromOuterMarkerClusterSolidWhite_FarWest_DottedWhite',...
            'AlignedDesign_EntryTransitions_ToNewLine2Right_FromInnerMarkerClusterOuterDoubleYellow_SolidYellow',...
            'AlignedDesign_EntryTransitions_ToNewLine2Left_FromInnerMarkerClusterInnerDoubleYellow_SolidYellow',...
            'AlignedDesign_EntryTransitions_ToNewLine2Center_FromOuterMarkerClusterSolidWhite_2_DottedWhite',...
            'AlignedDesign_EntryTransitions_ToNewLine2Center_FromOuterMarkerClusterSolidWhite_DottedWhite',...
            'AlignedDesign_EntryTransitions_ToNewLine1_FromOuterMarkerClusterSolidWhite_NearWest_DottedWhite',...
            'AlignedDesign_EntryTransitions_ToNewLine4Right_FromInnerMarkerClusterOuterDoubleYellow_SolidYellow',...
            'AlignedDesign_EntryTransitions_ToNewLine4Left_FromInnerMarkerClusterInnerDoubleYellow_SolidYellow',...
            'AlignedDesign_ExitTransitions_ToOuterMarkerClusterSolidWhite_FromNewLine1Center_DottedWhite',...
            'AlignedDesign_ExitTransitions_ToOuterMarkerClusterSolidWhite_FromNewLine2Right_SmallDottedWhite',...
            'AlignedDesign_ExitTransitions_ToInnerMarkerClusterOuterDoubleYellow_FromNewLine2Right_SolidYellow',...
            'AlignedDesign_ExitTransitions_ToInnerMarkerClusterInnerDoubleYellow_FromNewLine2Left_SolidYellow',...
            'AlignedDesign_ExitTransitions_ToOuterMarkerClusterSolidWhite_FromNewLine1Center_2_DottedWhite',...
            'AlignedDesign_ExitTransitions_ToInnerMarkerClusterOuterDoubleYellow_FromNewLine4Right_SolidYellow',...
            'AlignedDesign_ExitTransitions_ToInnerMarkerClusterInnerDoubleYellow_FromNewLine4Left_SolidYellow',...
            'AlignedDesign_ExitTransitions_ToOuterMarkerClusterSolidWhite_FromNewLine2Right_SolidWhite',...
            'AlignedDesign_LaneExtension_ToStopLine_FromNewLine2Right_SolidYellow',...
            'AlignedDesign_LaneExtension_ToStopLine_FromNewLine2Left_SolidYellow',...
            'AlignedDesign_LaneExtension_ToEastCurve_FromNewLine2CenterEnd_SolidWhite',...
            'AlignedDesign_LaneExtension_ToNewLine1CenterEnd_FromNewLine1CenterMiddle_SolidWhite',...
            'AlignedDesign_LaneToLaneTransition_ToNewLine1CenterEnd_FromNewLine2CenterStart_SolidWhite',...
            'AlignedDesign_LaneExtension_ToNewLine1CenterMiddleEnd_FromNewLine1CenterMiddle_SolidWhite',...
            'AlignedDesign_LaneExtension_ToNewLine2RightEnd_FromNewLine2RightMiddle_SolidYellow',...
            'AlignedDesign_LaneExtension_ToNewLine2Center_FromHandlingArea_SolidWhite',...
            'AlignedDesign_LaneExtension_ToNewLine2Center_FromHandlingArea2_SolidWhite',...
            'AlignedDesign_LaneExtension_ToNewLine2CenterMiddle_FromNewLine2CenterStart_SolidWhite',...
            'AlignedDesign_LaneExtension_ToNewLine2CenterMiddleEnd_FromNewLine2CenterMiddle_SolidWhite',...
            'AlignedDesign_LaneExtension_ToNewLine2CenterEnd_FromNewLine2CenterMiddle_SmallDashedWhite',...
            'AlignedDesign_LaneExtension_ToNewLine2CenterEnd_FromNewLine2CenterMiddle2_SolidWhite',...
            'AlignedDesign_LaneExtension_ToNewLine2CenterEnd_FromNewLine2CenterMiddle3_SolidWhite',...
            'AlignedDesign_LaneExtension_ToNewLine2CenterEnd_FromNewLine2CenterNearEnd_SolidWhite',...
            'AlignedDesign_LaneExtension_ToNewLine2CenterEnd_FromNewLine2CenterVeryEnd_SolidWhite',...
            'AlignedDesign_LaneExtension_ToNewLine2LeftEnd_FromNewLine2LeftMiddle_SolidYellow',...
            'AlignedDesign_LaneExtension_ToNewLine3CenterEnd_FromNewLine3CenterMiddle_SolidWhite',...
            'AlignedDesign_LaneExtension_ToNewLine3CenterMiddleEnd_FromNewLine3CenterMiddle_SolidWhite',...
            'AlignedDesign_LaneExtension_ToNewLine3Center_FromNewLine3CenterStart_SolidWhite',...
            'AlignedDesign_LaneExtension_ToNewLine3CenterEnd_FromNewLine3CenterNearEnd_SolidWhite',...
            'AlignedDesign_LaneExtension_ToNewLine4RightMiddle_FromNewLine4RightMiddle_SolidYellow',...
            'AlignedDesign_LaneExtension_ToNewLine4LeftMiddle_FromNewLine4LeftMiddle_SolidYellow',...
            'AlignedDesign_LaneToLaneTransition_ToNewLine1_FromNewLine2_SolidWhite',...
            'AlignedDesign_LaneToLaneTransition_ToNewLine1CenterEnd_FromNewLine2CenterMiddle_SolidWhite',...
            'AlignedDesign_LaneExtension_ToNewLine2CenterMiddleish_FromNewLine2CenterStart2_SolidWhite',...
            'AlignedDesign_LaneExtension_ToNewLine2CenterMiddleish_FromNewLine2CenterStart_SolidWhite',...
            'AlignedDesign_LaneToLaneTransition_ToNewLine1Center_FromNewLine3Center_SolidWhite',...
            'AlignedDesign_LaneToLaneTransition_ToNewLine2Right_FromNewLine4Right2_SolidYellow',...
            'AlignedDesign_LaneToLaneTransition_ToNewLine2Left_FromNewLine4Left2_SolidYellow',...
            'AlignedDesign_LaneToLaneTransition_ToNewLine2Center_FromNewLine1Center_SolidWhite',...
            'AlignedDesign_LaneToLaneTransition_ToNewLine2Center_FromNewLine3Center_SolidWhite',...
            'AlignedDesign_LaneToLaneTransition_ToNewLine3Center_FromNewLine2Center_SolidWhite',...
            'AlignedDesign_LaneToLaneTransition_ToNewLine3Center_FromNewLine4Center_SolidYellow',...
            'AlignedDesign_LaneToLaneTransition_ToNewLine3_FromNewLine1_SolidWhite',...
            'AlignedDesign_LaneToLaneTransition_ToNewLine4Center_FromNewLine3Center_SolidYellow',...
            'AlignedDesign_LaneToLaneTransition_ToNewLine4Left_FromNewLine2Left_SolidYellow',...
            'AlignedDesign_LaneToLaneTransition_ToNewLine4Right_FromNewLine2Right_SolidYellow',...
            'AlignedDesign_StopLine_BetweenNewLine1AndNewLine2SolidWhite',...
            'AlignedDesign_StopLine_BetweenNewLine1AndNewLine2SolidWhite_StartOfStopLine',...
            'AlignedDesign_StopLine_BetweenNewLine1AndNewLine2SolidWhite_FinishOfStopLine',...
            'AlignedDesign_StopLine_BetweenNewLine2AndNewLine3SolidWhite',...
            'AlignedDesign_StopLine_BetweenNewLine2AndNewLine3SolidWhite_StartOfStopLine',...
            'AlignedDesign_StopLine_BetweenNewLine2AndNewLine3SolidWhite_FinishOfStopLine',...
            'AlignedDesign_StopLine_DetourLines_NorthExitSolidWhite',...
            'AlignedDesign_StopLine_DetourLines_NorthExitSolidWhite_StartOfStopLine',...
            'AlignedDesign_StopLine_DetourLines_NorthExitSolidWhite_FinishOfStopLine',...
            'AlignedDesign_StopLine_DetourLines_CrossroadsSolidWhite',...
            'AlignedDesign_StopLine_DetourLines_CrossroadsSolidWhite_StartOfStopLine',...
            'AlignedDesign_StopLine_DetourLines_CrossroadsSolidWhite_FinishOfStopLine',...
            'AlignedDesign_StopLine_DetourLines_CurveAroundGarageSolidWhite',...
            'AlignedDesign_StopLine_DetourLines_CurveAroundGarageSolidWhite_StartOfStopLine',...
            'AlignedDesign_StopLine_DetourLines_CurveAroundGarageSolidWhite_FinishOfStopLine',...
            'AlignedDesign_StopLine_DetourLines_HandlingAreaOutflowSolidWhite',...
            'AlignedDesign_StopLine_DetourLines_HandlingAreaOutflowSolidWhite_StartOfStopLine',...
            'AlignedDesign_StopLine_DetourLines_HandlingAreaOutflowSolidWhite_FinishOfStopLine',...
            'AlignedDesign_StopLine_DetourLines_SouthWestSolidWhite',...
            'AlignedDesign_StopLine_DetourLines_SouthWestSolidWhite_StartOfStopLine',...
            'AlignedDesign_StopLine_DetourLines_SouthWestSolidWhite_FinishOfStopLine',...
            'AlignedDesign_DetourLines_NorthExitLeftDoubleYellow',...
            'AlignedDesign_DetourLines_NorthExitSingleSolidWhite',...
            'AlignedDesign_DetourLines_NorthExitRightDoubleYellow',...
            'AlignedDesign_DetourLines_CrossroadEntryLeftSolidYellow',...
            'AlignedDesign_DetourLines_CrossroadEntryRightSolidYellow',...
            'AlignedDesign_DetourLines_CurveAroundGarageRightDoubleYellow',...
            'AlignedDesign_DetourLines_CurveAroundGarageLeftDoubleYellow',...
            'AlignedDesign_DetourLines_HandlingAreaEntryLeftDoubleYellow',...
            'AlignedDesign_DetourLines_HandlingAreaEntryRightDoubleYellow',...
            'AlignedDesign_DetourLines_HandlingAreaEntryOutboundRightSolidWhite',...
            'AlignedDesign_DetourLines_HandlingAreaEntryInboundRightSolidWhite',...
            'AlignedDesign_DetourLines_HandlingAreaExitLeftDoubleYellow',...
            'AlignedDesign_DetourLines_HandlingAreaExitRightDoubleYellow',...
            'AlignedDesign_DetourLines_HandlingAreaExitOutboundRightSolidWhite',...
            'AlignedDesign_DetourLines_HandlingAreaExitInboundRightSolidWhite',...
            'AlignedDesign_OriginalLaneChangeArea_SouthMarkerCluster_SolidWhite',...
            'AlignedDesign_OriginalLaneChangeArea_MiddleMarkerCluster_BrokenWhite',...
            'AlignedDesign_OriginalLaneChangeArea_NorthMarkerCluster_SolidYellow',...
            'AlignedDesign_OriginalLaneChangeArea_CenterlineReference_SolidYellow',...
            'AlignedDesign_OriginalLaneChangeArea_CenterlineReference_SolidWhite',...
            }
        mat_filename = fullfile(cd,'Data',TraceSearchString);
        load(mat_filename,'fixed_ENU_positions_array');
        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            fixed_ENU_positions_array,...
            []);


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %               ____        _ _ _
        %     /\       |  _ \      (_) | |
        %    /  \   ___| |_) |_   _ _| | |_ ___
        %   / /\ \ / __|  _ <| | | | | | __/ __|
        %  / ____ \\__ \ |_) | |_| | | | |_\__ \
        % /_/    \_\___/____/ \__,_|_|_|\__|___/
        %
        % See:http://patorjk.com/software/taag/#p=display&f=Big&t=AsBuilts
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



    case 'AsBuilts_DetourLines_HandlingAreaTapedEntryRightDoubleYellow'

        ENU_positions = [
            109.7479 -152.3235 0
            100.7900 -129.7546 0
            ];
        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            ENU_positions,...
            []);


    case 'AsBuilts_DetourLines_HandlingAreaTapedEntryOutboundRightSolidWhite'

        ENU_positions = [
            112.6746 -150.9372 0
            103.7896 -128.5523 0
            ];

        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            ENU_positions,...
            []);

    case 'AsBuilts_DetourLines_HandlingAreaTapedEntryInboundRightSolidWhite'

        ENU_positions = [
            106.6094 -153.8328 0
            97.6892 -131.3592  0
            ];

        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            ENU_positions,...
            []);

    case 'AsBuilts_DetourLines_HandlingAreaTapedEntryLeftDoubleYellow'

        ENU_positions = [
            109.5287 -152.4283 0
            100.5760 -129.8725 0
            ];
        [ENU_positions_cell_array, LLA_positions_cell_array] = ...
            fcn_INTERNAL_prepDataForOutput(...
            ENU_positions,...
            []);


    otherwise
        error('Unrecognized trace string: %s',TraceSearchString);
end


% Extract the sub-matrix?
if flag_extract_submatrix
    try
        ENU_positions_cell_array = ENU_positions_cell_array{sub_matrix_index};
        LLA_positions_cell_array = LLA_positions_cell_array{sub_matrix_index};
    catch
        ENU_positions_cell_array = ENU_positions_cell_array{1};
        LLA_positions_cell_array = LLA_positions_cell_array{1};
        warning('Error detected in call to switch statement produced by case: %s. Unable to load ENU or LLA arrays due to a variable type mismatch, likely because a matrix was used to replace a cell array. Defaulting to first cell array.',TraceSearchString);
    end
end

% Make sure trace is well formed
too_close_distance = 0.20; % Units are meters
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_PlotTestTrack_checkPath(LLA_positions_cell_array, ENU_positions_cell_array, ...
    TraceSearchString, too_close_distance);

end % Ends fcn_INTERNAL_loadTraceData

