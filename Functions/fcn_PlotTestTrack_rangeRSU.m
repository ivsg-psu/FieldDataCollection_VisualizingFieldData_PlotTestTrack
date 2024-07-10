function fcn_PlotTestTrack_rangeRSU(csv_filenames, optional_parameters)

%% fcn_PlotTestTrack_rangeRSU
% Creates a plot of entered traces in either LLA, ENU, or STH-linear
% formats.
%
% FORMAT:
%
%       function fcn_PlotTestTrack_rangeRSU(csv_filenames, (color, markersize, location, flag_show_boundary, boundary_range))
%
% INPUTS:
%
%      csv_filename: The name of the .csv file that contains the latitude,
%                    longitude and optionally the altitude of the location
%                    at which the OBU sent out the BSM message to the RSU
%                    that was in range.
%
%      (OPTIONAL INPUTS)

%
%       color: a color specifier such as [1 0 0] or 'r' indicating
%       what color the traces should be plotted
%
%       markersize: a marker size specifier indicating the thickness the 
%       traces should be plotted
%
%       location: enter location of RSU during data collection in LLA 
%       coordiates. Example; [-41.54388324160499, -111.0086546354483,...
%       -12.592103434894112]
%
%       flag_show_boundary: true (1) or false (0) to plot in RSU boudnary
%
%       boundary_range: input RSU range detection radius in meters.
%
%     
% OUTPUTS:
%
%       LLA_BSM_coordinates: Array of LLA coordinates of BSM locations
%
%      
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
%       script_test_fcn_PlotTestTrack_rangeRSU.m for a full
%       test suite.
%
% This function was written on 2024_06_14 by Aryaan
% Questions or comments? ????

% Revision history:
% 
% 

% To Do:
%

% start of code

    % Set reference location for plot at PSU test track
    reference_latitude = 40.86368573;
    reference_longitude = -77.83592832;
    reference_altitude = 344.189;
    % Use GPS function, which handles various coordinate transformations 
    % between different geospatial coordinate systems (ENU, LLA, XYZ)
    gps_object = GPS(reference_latitude,reference_longitude,reference_altitude); 
    
    % Create a figure
    figure(1);

    % Plot the base station with a green star. This sets up the figure for
    % the first time, including the zoom into the test track area.
    %h_geoplot = geoplot(40.8637, -77.8359, '*','Color',[0 1 0],'Linewidth',3,'Markersize',10);
    %h_parent =  get(h_geoplot,'Parent');
    %set(h_parent,'ZoomLevel',16.375);
    
    try
        geobasemap satellite
    catch
        geobasemap openstreetmap
    end
    geotickformat -dd;
    hold on;
    
    % Loops through each RSU's cvs file
    for i = 1:length(csv_filenames)
        csv_file = csv_filenames{i};
        params = optional_parameters{i};
        % Optional parameters
        color = params{1};                  % Color of each RSU's BSM data
        markersize = params{2};             % Marker size of data
        location = params{3};               % Location of RSU
        flag_show_boundary = params{4};     % 1 = true, 0 = false
        boundary_range = params{5};         % Radius of RSU detection range (m)

        % Read csv file containing LLA coordinates of the OBU when the BSM
        % message was sent out to the RSU
        BSM_LLA = csvread(csv_file, 1);
        BSMs_LLA_corrected = [BSM_LLA(:,1)/10000000 BSM_LLA(:,2)/10000000 BSM_LLA(:,3)]; % Scale location coordinates
        % setting up for output of function
        LLA_BSM_coordinates = BSMs_LLA_corrected;

        geoplot(LLA_BSM_coordinates(:,1), LLA_BSM_coordinates(:,2), '.','Color',color,'Markersize',markersize);

        % Convert BSM location coordinates from ENU to LLA
        rsu_coordinates_enu = location;
        Trace_coordinates_LLA =  gps_object.ENU2WGSLLA(rsu_coordinates_enu);
        geoplot(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'*', 'Color', color, 'MarkerSize',20);

        % Plot each RSU detection range
        if flag_show_boundary == 1
            theta = 0:0.01:2*pi;
            circle_radius = boundary_range / 111000;  
            circle_lat = Trace_coordinates_LLA(1) + circle_radius * cos(theta);
            circle_lon = Trace_coordinates_LLA(2) + circle_radius * sin(theta) / cos(Trace_coordinates_LLA(1));
            geoplot(circle_lat, circle_lon, 'Color', color, 'LineWidth', 1.5);
        end
    end

    hold off;
end
