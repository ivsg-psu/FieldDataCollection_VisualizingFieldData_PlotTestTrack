function [speed,position] = fcn_PlotTestTrack_PostionvsVelocity(csvFile)
%% fcn_PlotTestTrack_PostionvsVelocity
% plot velocity of van vs position respect to time 
%
% FORMAT:
%
%       function [speed,position] = fcn_PlotTestTrack_PostionvsVelocity(csvFile,varargin)
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
%    
%
% OUTPUTS:
%
%      Plot of velocity vs position 
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
%       script_test_fcn_PlotTestTrack_PostionvsVelocity.m
%
% This function was written on 2024_07_15 by Jiabao Zhao
% --Start to write the function 
% Questions or comments? jpz5469@psu.edu



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
varargin = 0;
if flag_check_inputs == 1
    % Are there the right number of inputs?
    narginchk(0,2);

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
% load the matrix data into workspace 
LLA = csvFile(:,1:3);
LLA_Trace = table2array(LLA);
LLA_Trace_Lat = LLA_Trace(:,1)/10000000;
LLA_Trace_Long = LLA_Trace(:,2)/10000000;
LLA_Trace_Elev = LLA_Trace(:,3);
LLA_Trace = [LLA_Trace_Lat,LLA_Trace_Long,LLA_Trace_Elev];


% initializing empty arrays
%reference_unit_tangent_vector = [0.794630317120972   0.607093616431785]; % 

% initializing empty arrays
LLA_trace = [];
ENU_trace =[];
ENU_trace = [];

% get ENU
ENU_data_with_nan = [];
[ENU_positions_cell_array, ~] = ...
    fcn_INTERNAL_prepDataForOutput(ENU_data_with_nan,LLA_Trace);

ENU_trace = ENU_positions_cell_array{1};



% Abstract Lat, Long and Elev from matrix 
LocationOBU = ENU_trace(:,1:2);
Elev = LLA_Trace(:,3);


% Extract the 'timediff' column from the table
timeStrings = csvFile.timediff;

% Initialize an array to hold the total seconds
t = zeros(height(timeStrings), 1);

% Loop through each time string and convert to total seconds
if iscell(timeStrings)
    for i = 1:height(timeStrings)
        % Convert each entry to a string
        timeStr = char(timeStrings{i});
        % Split the time string into minutes and seconds
        timeParts = split(timeStr, ':');

        % Convert minutes and seconds to numeric values
        minutes = str2double(timeParts{1});
        seconds = str2double(timeParts{2});

        % Calculate total seconds
        t(i) = minutes * 60 + seconds;

    end
else 
    timeStrings = cellstr(timeStrings);
    for i = 1:height(timeStrings)
        % Convert each entry to a string
        timeStr = char(timeStrings{i});
        % Split the time string into minutes and seconds
        timeParts = split(timeStr, ':');

        % Convert minutes and seconds to numeric values
        hours = str2double(timeParts{1});
        minutes = str2double(timeParts{2});
        seconds = str2double(timeParts{3});

        % Calculate total seconds
        t(i) = hours*3600 + minutes * 60 + seconds;

    end
end

% retrun each variable into non repeatable number
ULatLong_RepTime = unique(LocationOBU,'rows','stable');
t1 = unique(t);
Position = 0;

%IF statement is used to check which variable has the smallest length
if (length(ULatLong_RepTime(:,1)) < length(t1))
  [~, indices] = ismember(ULatLong_RepTime,LocationOBU,'rows');  % find indices

    % return all variable in same size
    ULatLong = LocationOBU(indices,:);
    t_real = t(indices);

    % use for loop to calculate the speech of every two points and position
    East = ULatLong(:,1);
    North = ULatLong(:,2);
    for n = 1:length(indices)-1
        East1 = East(n+1)-East(n);
        North1 = North(n+1)-North(n);
        delta_t = t_real(n+1)-t_real(n);
        displacement = sqrt(East1^2+North1^2);
        speed(n) = abs(displacement/delta_t);
        Position = Position + displacement;
        New_position(n) = Position;
    end
else
    [~, indices] = ismember(t1,t); % find indices

    % return all variable in same size
    ULatLong = LocationOBU(indices,:);
    t_real = t(indices);

    % use for loop to calculate the speech of every two points and position
    East = ULatLong(:,1);
    North = ULatLong(:,2);
    for n = 1:length(indices)-1
        East1 = East(n+1)-East(n);
        North1 = North(n+1)-North(n);
        delta_t = t_real(n+1)-t_real(n);
        displacement = sqrt(East1^2+North1^2);
        speed(n) = abs(displacement/delta_t);
        Position = Position + displacement;
        New_position(n) = Position;
    end
end

position = New_position;
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
speed_mph = speed * 2.23694;
plot(New_position,speed);
xlabel('Position (m)')
ylabel('Speed (mph)')
if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end
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

end
