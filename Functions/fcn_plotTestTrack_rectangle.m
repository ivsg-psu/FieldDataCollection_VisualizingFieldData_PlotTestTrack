% function fcn_plotTestTrack_rangeRSU_rectangle2(csvFile, car_width, car_length, baseLat, baseLon, baseAlt)
%     
%     % Read the CSV file
%     data = readmatrix(csvFile);
%     
%     % Check if the input matrix has four columns
%     if size(data, 2) ~= 4
%         error('The CSV file must contain exactly four columns: latitude, longitude, elevation, and time.');
%     end
%     
%     % Extract latitude, longitude, elevation, and time values
%     lat = data(:, 1)/10000000;
%     lon = data(:, 2)/10000000;
%     elv = data(:, 3);
%     time = data(:, 4);
%     
%     % Default base location coordinates (PSU test track)
%     defaultBaseLat = 40.8637;
%     defaultBaseLon = -77.8359;
%     defaultBaseAlt = 344.189;
%     
%     % Default vehicle dimensions in ENU
%     defaultWidth = .05;
%     defaultLength = .05;
% 
%     % Check for optional inputs and set defaults if necessary
%     if nargin < 2 || isempty(car_width)
%     car_width = defaultWidth;
%     end
%     if nargin < 3 || isempty(car_length)
%     car_length = defaultLength;
%     end
%     if nargin < 4 || isempty(baseLat)
%     baseLat = defaultBaseLat;
%     end
%     if nargin < 5 || isempty(baseLon)
%     baseLon = defaultBaseLon;
%     end
%     if nargin < 6 || isempty(baseAlt)
%     baseAlt = defaultBaseAlt;
%     end
%     
%     %gps_object = GPS(baseLat, baseLon, baseAlt);
% 
%     %lla_coords = gps_object.ENU2WGSLLA(rsu_coordinates_enu);
%     
%     % Convert points from LLA to ENU
%     % ENU = WGSLLA2ENU(obj, latitude, longitude, altitude, reference_latitude, reference_longitude, reference_altitude)
% 
%     half_width = car_width / 2;
%     half_length = car_length / 2;
%     rectangle_lla = [
%         lat - half_width, lon - half_length, 0;
%         lat + half_width, lon - half_length, 0;
%         lat + half_width, lon + half_length, 0;
%         lat - half_width, lon + half_length, 0;
%       ];
% 
%     % Extract x, y, z coordinates
%     lat_coords = rectangle_lla(:,1);
%     lon_coords = rectangle_lla(:,2);
%     alt_coords = rectangle_lla(:,3);
% 
% 
%     % rectangle_lla = gps_object.ENU2WGSLLA(rectangle_enu);
% 
%     figure;
%     h_geoplot = geoplot(baseLat, baseLon, '*','Color',[0 1 0],'LineWidth',3,'MarkerSize',10);
%     h_parent = get(h_geoplot, 'Parent');
%     set(h_parent, 'ZoomLevel', 16.375);
%     try
%         geobasemap satellite;
%     catch
%         geobasemap openstreetmap;
%     end
%     hold on;
%     
%     % Plot the points
%     geoplot(lat_coords, lon_coords, 'Color', [0 0 1], 'o', 1.5);
%     hold on; 
%     
%     % Connect the points to form the rectangle
%     plot3([lat_coords; lat_coords(1)], [lon_coords; lon_coords(1)], '-'); % '-' for line
% 
%     hold off;
% 
% %     figure;
% %     plot(rsu_coordinates_enu(1), rsu_coordinates_enu(2), '*', 'Color', [0 1 0], 'LineWidth', 3, 'MarkerSize', 10);
% %     hold on;
% % 
% %     plot(rectangle_enu(:,1), rectangle_enu(:,2), 'Color', [0 0 1], 'LineWidth', 1.5);
% % 
% %     hold off;
% %     xlabel('East (m)');
% %     ylabel('North (m)');
% %     axis equal;
% end

function fcn_plotTestTrack_rectangle(csvFile, car_width, car_length, baseLat, baseLon, baseAlt)
    
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
    time = data(:, 4);
    
    % Default base location coordinates (PSU test track)
    defaultBaseLat = 40.8637;
    defaultBaseLon = -77.8359;
    defaultBaseAlt = 344.189;
    
    % Default vehicle dimensions in ENU
    defaultWidth = 0.5;   %---- width?
    defaultLength = 0.5;    %---- length?

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
    
    % Plot the rectangle
    h = geoplot(lat_coords, lon_coords, 'b-'); % 'b-' means blue solid line
    hold on; % Hold the current plot
    g = geoplot(lat(1), lon(1), 'ro'); % Plot the center point as a red circle
    hold off; % Release the plot hold
 
%     traj = geoplot(lat(:), lon(:), 'r-', 'LineWidth', 2);
%     hold on;
    
    % Loop through each point and calculate the rectangle coordinates
    for i = 2:length(lat)
        
        % Calculate the rectangle coordinates
       lat_coords = [lat(i) - car_width/2, lat(i) + car_width/2, lat(i) + car_width/2, lat(i) - car_width/2, lat(i) - car_width/2];
       lon_coords = [lon(i) - car_length/2, lon(i) - car_length/2, lon(i) + car_length/2, lon(i) + car_length/2, lon(i) - car_length/2];
       
       % Update the X and Y data of the plot
        set(h, 'XData', lat_coords, 'YData', lon_coords);
        set(g, 'XData', lat_coords, 'YData', lon_coords);
            
    end
    
end