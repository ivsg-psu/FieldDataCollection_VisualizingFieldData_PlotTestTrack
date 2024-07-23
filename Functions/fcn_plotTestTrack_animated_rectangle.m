function fcn_plotTestTrack_animated_rectangle(csvFile, car_width, car_length, baseLat, baseLon, baseAlt)
%% fcn_plotTestTrack_animated_rectangle
% create animated plot of the AV represented as a rectangle 
% moving in LLA coordinates with respect to time. 
% 
%
% FORMAT:
%
%       fcn_plotTestTrack_animated_rectangle(csvFile, car_width, car_length, baseLat, baseLon, baseAlt)
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
%      car_width: Width of AV in LLA coordinates. Default is 0.00015.
%
%      car_length: Length of AV in LLA coordinates. Default is 0.000055.
%
%      baseLat: Latitude of the base location. Default is 40.8637.
%
%      baseLon: Longitude of the base location. Default is -77.8359.
%
%      baseAlt: Altitude of the base location. Default is 344.189.
%
%
% OUTPUTS:
%
%      Plot of a rectangle to represent the AV in LLA coordinates 
%      with respect to time.
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
%       script_test_fcn_plotTestTrack_animated_rectangle.m
%
% This function was written on 2024_07_15 by Rachel Ross
% Questions or comments? rkr5407@psu.edu

% Revision History
% 
%

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
    
    % Default base location coordinates (PSU test track)
    defaultBaseLat = 40.8637;
    defaultBaseLon = -77.8359;
    defaultBaseAlt = 344.189;
    
    % Default vehicle dimensions in LLA
    defaultWidth = 0.00015;   % Default width
    defaultLength = 0.000055;  % Default length

    % Check for optional inputs and set defaults if necessary
    if nargin < 2 || isempty(car_width)
        car_width = defaultWidth;
    end
    if nargin < 3 || isempty(car_length)
        car_length = defaultLength;
    end
    if nargin < 4 || isempty(baseLat)
        baseLat = defaultBaseLat;
    end
    if nargin < 5 || isempty(baseLon)
        baseLon = defaultBaseLon;
    end
    if nargin < 6 || isempty(baseAlt)
        baseAlt = defaultBaseAlt;
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
    
    % Read the CSV file
    data = readmatrix(csvFile);
    
    % Check if the input matrix has four columns
    if size(data, 2) ~= 4
        error('The CSV file must contain exactly four columns: latitude, longitude, elevation, and time.');
    end
    
    % Extract latitude, longitude, elevation, and time values
    lat = data(:, 1) / 10000000;
    lon = data(:, 2) / 10000000;
    elv = data(:, 3);
    
    % Read the converted time values
    time = convertTimeToSeconds(data(:, 4));
    
    % Initialize plot
    figure;
    % Zoom in on base location
    h_geoplot = geoplot(baseLat, baseLon, '*','Color',[0 1 0],'LineWidth',3,'MarkerSize',10);
    h_parent = get(h_geoplot, 'Parent');
    set(h_parent, 'ZoomLevel', 16.375);
    try
        geobasemap satellite;
    catch
        geobasemap openstreetmap;
    end
    hold on;
    
    % Create an empty geoplot for updating later
    h = geoplot(nan, nan, 'b-'); % 'b-' means blue solid line
    hold on;
        
    % Loop through each point and calculate the rectangle coordinates with orientation
    for i = 1:length(lat)
        if i < length(lat)
            bearing = calculateBearing(lat(i), lon(i), lat(i+1), lon(i+1));
        else
            bearing = calculateBearing(lat(i-1), lon(i-1), lat(i), lon(i)); % Use previous bearing for last point
        end
        
        % Calculate the rectangle coordinates without rotation
        lat_coords = [lat(i) - car_width/2, lat(i) + car_width/2, lat(i) + car_width/2, lat(i) - car_width/2, lat(i) - car_width/2];
        lon_coords = [lon(i) - car_length/2, lon(i) - car_length/2, lon(i) + car_length/2, lon(i) + car_length/2, lon(i) - car_length/2];
        
        % Rotate the coordinates around the center point
        [lat_rot, lon_rot] = rotateCoordinates(lat_coords, lon_coords, lat(i), lon(i), bearing);
        
        % Update the plot with the new rectangle coordinates
        set(h, 'LatitudeData', lat_rot, 'LongitudeData', lon_rot);
        
        % Pause to simulate real-time plotting
        if i > 1
            pause_duration = (time(i) - time(i-1));
            pause(pause_duration);  % Pause for the calculated duration
        end
    end
    
    hold off;
end
%% Functions follow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   ______                _   _
%  |  ____|              | | (_)
%  | |__ _   _ _ __   ___| |_ _  ___  _ __  ___
%  |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
%  | |  | |_| | | | | (__| |_| | (_) | | | \__ \
%  |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Function to calculate the bearing between two points
    function bearing = calculateBearing(lat1, lon1, lat2, lon2)
        dLon = deg2rad(lon2 - lon1);
        y = sin(dLon) * cos(deg2rad(lat2));
        x = cos(deg2rad(lat1)) * sin(deg2rad(lat2)) - sin(deg2rad(lat1)) * cos(deg2rad(lat2)) * cos(dLon);
        bearing = atan2(y, x);
    end

    % Function to rotate a set of coordinates around a center point
    function [lat_rot, lon_rot] = rotateCoordinates(lat_coords, lon_coords, center_lat, center_lon, angle)
        R = [cos(angle), -sin(angle); sin(angle), cos(angle)];
        coords = R * [lat_coords - center_lat; lon_coords - center_lon];
        lat_rot = coords(1, :) + center_lat;
        lon_rot = coords(2, :) + center_lon;
    end
    
    function [time_in_seconds] = convertTimeToSeconds(time_column)
        % Initialize an array to hold the converted time values in seconds
        time_in_seconds = zeros(length(time_column), 1);
        
        % Loop through each row in the table
        for i = 1:length(time_column)
            % Extract the time string
            time_str = num2str(time_column(i));
            
            % Split the time string into minutes and seconds
            parts = split(time_str, ':');
            
            % Check if parts contains two elements
            if length(parts) ~= 2
                error('Time string does not contain minutes and seconds in the expected format.');
            end
     
            minutes = str2double(parts{1});
            
            % Split the seconds part into whole seconds and fractional seconds
            seconds_parts = split(parts{2}, '.');
            
            % Check if seconds_parts contains two elements
            if length(seconds_parts) ~= 2
                error('Seconds part does not contain both whole and fractional seconds.');
            end
            
            seconds = str2double(seconds_parts{1});
            fractions = str2double(['0.' seconds_parts{2}]);
            
            % Convert the time to seconds
            total_seconds = minutes * 60 + seconds + fractions;
            
            % Store the result in the array
            time_in_seconds(i) = total_seconds;
        end
    end
