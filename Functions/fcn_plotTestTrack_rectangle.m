function fcn_plotTestTrack_rangeRSU_rectangle2(csvFile, car_width, car_length, baseLat, baseLon, baseAlt)
    
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
    defaultWidth = 0.00005;   % Default width
    defaultLength = 0.0001;  % Default length

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
    
    % Loop through each point and calculate the rectangle coordinates
    for i = 1:length(lat)
        % Calculate the rectangle coordinates
        lat_coords = [lat(i) - car_width/2, lat(i) + car_width/2, lat(i) + car_width/2, lat(i) - car_width/2, lat(i) - car_width/2];
        lon_coords = [lon(i) - car_length/2, lon(i) - car_length/2, lon(i) + car_length/2, lon(i) + car_length/2, lon(i) - car_length/2];
       
        % Plot the rectangle for each position
        geoplot(lat_coords, lon_coords, 'b-'); % 'b-' means blue solid line
        hold on;
    end
    
    % Plot the initial car position as a red circle
    geoplot(lat(1), lon(1), 'ro'); % Plot the center point as a red circle
    hold off;
end
