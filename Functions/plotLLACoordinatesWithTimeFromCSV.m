function plotLLACoordinatesWithTimeFromCSV(csvFile, baseLat, baseLon, showTrajectory)
%% plotLLACoordinatesWithTimeFromCSV
% Function to create animated plot of latitude, longitude coordinates with respect to time.
%
% FORMAT:
%
%       plotLLACoordinateesWithTimeFromCSV(csvFile)

% INPUTS:
%
%      csvFile: The name of the .csv file that contains the latitude,
%                    longitude, altitude, and time of the location
%                    at which the OBU sent out the BSM message to the RSU
%                    that was in range. The code assumes latitude in first
%                    column, longitude in second, altitude in third, and 
%                    time in fourth. 
%
%     (OPTIONAL INPUTS)
%
%      baseLat (optional): Latitude of the base location. Default is 40.8637.
%      baseLon (optional): Longitude of the base location. Default is -77.8359.
%      showTrajectory (optional): Boolean to toggle trajectory line. Default is true.
%
% OUTPUT:
%
%       Plot of LLA coordinates with respect to time
%
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
%       script_plotLLACoordinatesWithTimeFromCVS.m for a test suite.
%
% This function was written on 2024_07_01 by R. Ross
% Questions or comments? rkr5407@psu.edu

% Revision history:
% 

% To Do:

% start of code

% load('50ft.csv');

%%
    % Read the CSV file
    data = readmatrix(csvFile);
    
    % Check if the input matrix has four columns
    if size(data, 2) ~= 4
        error('The CSV file must contain exactly four columns: latitude, longitude, elevation, and time.');
    end
    
    % Extract latitude, longitude, elevation, and time values
    lat = data(:, 1)/10000000;
    lon = data(:, 2)/10000000;
    elv = data(:, 3);
    time = data(:, 4);
    
    % Default base location coordinates (PSU test track)
    defaultBaseLat = 40.8637;
    defaultBaseLon = -77.8359;
    % Default plots trajectory
    defaultShowTrajectory = true;

    % Check for optional inputs and set defaults if necessary
    if nargin < 2 || isempty(baseLat)
    baseLat = defaultBaseLat;
    end
    if nargin < 3 || isempty(baseLon)
    baseLon = defaultBaseLon;
    end
    if nargin < 4 || isempty(showTrajectory)
    showTrajectory = defaultShowTrajectory;
    end

    % Create a figure
    figure;

    % Plot the base station with a green star. This sets up the figure for
    % the first time, including the zoom into the test track area.
    h_geoplot = geoplot(baseLat, baseLon, '*','Color',[0 1 0],'Linewidth',3,'Markersize',10);
    h_parent = get(h_geoplot,'Parent');
    set(h_parent,'ZoomLevel',16.375);

    try
        geobasemap satellite
    catch
        geobasemap openstreetmap
    end

    hold on;
   
    % Initialize the plot with the first point fromthe cvs file
    h = geoplot(lat(1), lon(1), 'bs', 'MarkerSize', 10, 'MarkerFaceColor', 'b');
    
    hold on;
    
    % Plot the trajectory line if showTrajectory is true
    if showTrajectory
    traj = geoplot(lat(:), lon(:), 'r-', 'LineWidth', 2);
    end

    hold on;
    
    % Loop through the data points to update the plot
    for k = 2:length(lat)
        % Calculate the number of frames for smooth animation between points
        num_frames = 1; % Adjust for smoother animation if needed
        % Leave as 1 if data points are taken close together
        for j = 1:num_frames
            % Interpolate between the current and next point
            interp_lat = lat(k-1) + (lat(k) - lat(k-1)) * (j / num_frames);
            interp_lon = lon(k-1) + (lon(k) - lon(k-1)) * (j / num_frames);
            
            % Update the Latitude and Longitude data of the plot
            set(h, 'LatitudeData', interp_lat, 'LongitudeData', interp_lon);
            
            % Calculate the pause duration for each frame
        pause_duration = (time(k) - time(k-1)) / num_frames;
        pause(pause_duration);  % Pause for the calculated duration
        end
        
        % Update the plot to the next point
        set(h, 'LatitudeData', lat(1:k), 'LongitudeData', lon(1:k));
        
    end
    
    hold off;
end
