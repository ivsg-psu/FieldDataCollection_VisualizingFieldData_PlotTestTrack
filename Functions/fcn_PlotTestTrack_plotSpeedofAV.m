function SpeedofAV  = fcn_PlotTestTrack_plotSpeedofAV(...
    csvFilename, varargin)
%% fcn_PlotTestTrack_plotSpeedofAV
% Takes the input csv file, reads the LLA and time data from those files
% and calculates the speed of the Av at every point. Also plots the speed
% of the AV in different colours
%
% FORMAT:
%
%      SpeedofAV  = fcn_PlotTestTrack_plotSpeedofAV(...
%       csvFilename, (base_station_coordinates, maxVelocity, minVelocity, plot_color, LLA_fig_num, ENU_fig_num))
%
% INPUTS:
%
%      csv_filenames: The name of the .csv file that contains the latitude,
%                    longitude and optionally the altitude alsong with the 
%                    time at the of the location at which the OBU sent out 
%                    the BSM message to the RSU that was in range
%
%      (OPTIONAL INPUTS)
%
%       base_station_coordinates: the reference latitude, reference
%       longitude and reference altitude for the base station that we can
%       use to convert ENU2LLA and vice-versa
%
%       maxVelocity: maximum velocity allowed in mph
%
%       minVelocity: minimum velocity allowed in mph
%
%       plot_color: a color specifier such as [1 0 0] or 'r' indicating
%       what color the traces should be plotted
%
%       LLA_fig_num: a figure number for the LLA plot
%
%       ENU_fig_num: a figure number for the ENU plot
%
% OUTPUTS:
%
%       SpeedofAV: a 1XN matirx with the speed of the AV in mph that 
%       correspondes to every LLA location of the AV from the BSMs sent by OBU 
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
%       script_test_fcn_PlotTestTrack_plotSpeedofAV.m for a full
%       test suite.
%
% This function was written on 2024_07_14 by V. Wagh
% Questions or comments? vbw5054@psu.edu

% Revision history:
% 2024_07_14 by V. Wagh
% -- start writing function from fcn_PlotTestTrack_plotPointsAnywhere


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
    narginchk(1,7);
end

% base station coordinates
% Prep for GPS conversions
% The true location of the track base station is [40.86368573°, -77.83592832°, 344.189 m].
reference_latitude = 40.86368573;
reference_longitude = -77.83592832;
reference_altitude = 344.189;
base_station_coordinates = [reference_latitude, reference_longitude, reference_altitude]; % Default
if 2 <= nargin
    temp = varargin{1};
    if ~isempty(temp)
        base_station_coordinates = temp;
    end
end

% maxVelocity
maxVelocity = 85; % Default is at 85mph with is the fastest highway speed assigned in the US
if 3 <= nargin 
    temp = varargin{2};
    if ~isempty(temp) % if temp is not empty
        maxVelocity = temp;  
    end
end

% minVelocity
minVelocity = 15; % Default is at 15mph with is the slowest speed limit assigned in the US
if 4 <= nargin 
    temp = varargin{3}; 
    if ~isempty(temp) % if temp is not empty
        maxVelocity = temp;
    end
end

% Does user want to specify plot_color?
plot_color = [1 0 1]; % Default
if 5 <= nargin 
    temp = varargin{4};
    if ~isempty(temp) 
        plot_color = temp; 
    end
end

% Does user want to specify LLA_fig_num?
LLA_fig_num = 100; % Default
if 6 <= nargin
    temp = varargin{5};
    if ~isempty(temp)
        LLA_fig_num = temp;
    end
end

% Does user want to specify ENU_fig_num?
ENU_fig_num = 200; % Default is do not plot
if 7 <= nargin
    temp = varargin{6};
    if ~isempty(temp)
        ENU_fig_num = temp;
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

% Prep for GPS conversions
% The true location of the track base station is [40.86368573°,
% -77.83592832°, 344.189 m] for the default
gps_object = GPS(reference_latitude,reference_longitude,reference_altitude); % Load the GPS class

% read the csv file
% Read csv file containing LLA coordinates and time of the OBU when the BSM
% message was sent out to the RSU
csvfile_FID = fopen(csvFilename);
temp = fscanf(csvfile_FID,'%s, %s, %s, %s, %s',inf);
fclose(csvfile_FID);

LLAandTime = fscanf(csvFilename); %#ok<*CSVRD> %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%stopped here

% LLA is collected as an integer X 10^4, so convert back to standard
% decimal format for LLA
BSMs_LLA_corrected = [LLAandTime(:,1)/10000000 LLAandTime(:,2)/10000000 LLAandTime(:,3)];

% setting up for output of function
LLA_BSM_coordinates = BSMs_LLA_corrected;
ENU_BSM_coordinates =[];

% convert LLA to ENU
ENU_data_with_nan = [];
[ENU_positions_cell_array, LLA_positions_cell_array] = ...
    fcn_INTERNAL_prepDataForOutput(ENU_data_with_nan,BSMs_LLA_corrected);

ENU_BSM_coordinates = ENU_positions_cell_array{1};

% get the time from BSMs
Time_BSMs = LLAandTime(:,5);

% get speed
NumLength = length(ENU_BSM_coordinates)-1;
for ith_coordinate = 1:NumLength
    point1 = ENU_BSM_coordinates(ith_coordinate,1:2);
    point2 = ENU_BSM_coordinates(ith_coordinate+1,1:2);
    timeatpt1 = Time_BSMs(ith_coordinate,:);
    timeatpt2 = Time_BSMs(ith_coordinate+1,:);
    SpeedofAV_mps(ith_coordinate) = fcn_INTERNAL_calcSpeed(point1, point2, timeatpt1, timeatpt2);
end

% convert speed from m/s tp mph 
SpeedofAV = SpeedofAV_mps*2.23694;

% create speed categories
lowerLimit = minVelocity;
upperLimit = maxVelocity;
numCategories = 10; % default for now, later maake this an input
categories = fcn_INTERNAL_createCategories(lowerLimit, upperLimit, numCategories);

% assign colours to speed categories
for ith_category = 1:length(categories)
    plot_speedColor{ith_category} = plot_color*(ith_category*0.1);
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

% this is not yert done!!!!!!!!!!!!!!!!!!

% % Plot the speeds according to their speed categories
for ith_coordinate = 1:length(ENU_BSM_coordinates)


    for ith_category = 1:length(categories)

        if SpeedofAV(ith_coordinate) <= max(categories{ith_category})

            initial_points = ENU_BSM_coordinates;
            input_coordinates_type = "ENU";
            plot_color = plot_speedColor{ith_category};
            MarkerSize = [];
            fcn_PlotTestTrack_plotPointsAnywhere(...
                initial_points, input_coordinates_type, base_station_coordinates,...
                plot_color, MarkerSize, LLA_fig_num, ENU_fig_num);
        end
    end

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
%% fcn_INTERNAL_calcSpeed
function speed = fcn_INTERNAL_calcSpeed(point1, point2, timeatpt1, timeatpt2)

    % Calculate the distance between the two points
    distance = norm(point2 - point1);
    
    timeInterval = timeatpt2-timeatpt1;

    % Calculate the speed
    speed = distance / timeInterval;
end

%% fcn_INTERNAL_createCategories

function categories = fcn_INTERNAL_createCategories(lowerLimit, upperLimit, numCategories)
    % Check if the number of categories is valid
    if numCategories < 1
        error('Number of categories must be at least 1');
    end
    
    % Check if the limits are valid
    if lowerLimit >= upperLimit
        error('Lower limit must be less than upper limit');
    end
    
    % Calculate the step size
    stepSize = (upperLimit - lowerLimit) / numCategories;
    
    % Initialize the categories array
    categories = cell(numCategories, 1);
    
    % Populate the categories
    for i = 1:numCategories
        lowerBound = lowerLimit + (i-1) * stepSize;
        upperBound = lowerLimit + i * stepSize;
        categories{i} = [lowerBound, upperBound];
    end
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
indicies_cell_array = fcn_LoadWZ_breakArrayByNans(ENU_data_with_nan);
ENU_positions_cell_array{length(indicies_cell_array)} = {};
LLA_positions_cell_array{length(indicies_cell_array)} = {};
for ith_array = 1:length(indicies_cell_array)
    current_indicies = indicies_cell_array{ith_array};
    ENU_positions_cell_array{ith_array} = ENU_data_with_nan(current_indicies,:);
    LLA_positions_cell_array{ith_array} = LLA_data_with_nan(current_indicies,:);
end
end % Ends fcn_INTERNAL_prepDataForOutput

