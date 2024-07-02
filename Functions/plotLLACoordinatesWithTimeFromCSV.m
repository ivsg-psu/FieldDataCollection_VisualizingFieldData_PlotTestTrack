% function plotCoordinatesWithTimeFromCSV(csvFile)
% % Function to plot x,y coordinates with time labels from a CSV file
%     % Read the CSV file
%     data = readmatrix(csvFile);
%     
%     % Check if the input matrix has three columns
%     if size(data, 2) ~= 3
%         error('The CSV file must contain exactly three columns: x, y, and time.');
%     end
%     
%     % Extract x and y coordinates and time values
%     x = data(:, 1);
%     y = data(:, 2);
%     time = data(:, 3);
% 
% % Create a figure
% figure;
% 
% % Initialize the plot with the first point
% h = plot(x(1), y(1), 'bs', 'MarkerSize', 10); 
% axis([0 15 0 15]);        % Set the axis limits
% hold on;
% 
% % Loop through the data points to update the plot
% for k = 2:length(x)
%     % Calculate the number of frames for smooth animation between points
%     num_frames = 100; % Adjust for smoother animation
%     for j = 1:num_frames
%         % Interpolate between the current and next point
%         xt = x(k-1) + (x(k) - x(k-1)) * (j / num_frames);
%         yt = y(k-1) + (y(k) - y(k-1)) * (j / num_frames);
%         
%         % Update the X and Y data of the plot
%         set(h, 'XData', xt, 'YData', yt);
%         
%         % Calculate the pause duration for each frame
%         pause_duration = (time(k) - time(k-1)) / num_frames;
%         pause(pause_duration);  % Pause for the calculated duration
%         
%         % Display the current time as text on the plot
%             %t = text(1, 0.5, sprintf('Time: %.2f', 0:0.1:time(end)), 'FontSize', 12);
%         
%     end
% end
% 
% hold off;
% 
% 
% end
% 

% 
% function plotLLACoordinatesWithTimeFromCSV(csvFile)
% % Function to plot latitude, longitude coordinates with time labels from a CSV file
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
%     long = data(:, 2)/10000000;
%     elv = data(:, 3);
%     time = data(:, 4);
%     
%     % Create a figure
%     figure;
%     % Plot the base station with a green star. This sets up the figure for
%     % the first time, including the zoom into the test track area.
%     h_geoplot = geoplot(40.8637, -77.8359, '*','Color',[0 1 0],'Linewidth',3,'Markersize',10);
% 
%     h_parent =  get(h_geoplot,'Parent');
%     set(h_parent,'ZoomLevel',16.375);
%     try
%         geobasemap satellite
%     catch
%         geobasemap openstreetmap
%     end
%     hold on;
%     
%     % Initialize the plot with the first point
%     h = geoplot(lat(:,1), long(:,2), 'bs', 'MarkerSize', 10, 'MarkerFaceColor', 'b');
%     hold on;
%     
%     % Initialize the clock text
% %     clock_text = text(min(lat), max(long) + 0.001, 'Time: 0.00', 'FontSize', 12);
%     
%     % Loop through the data points to update the plot
%     for k = 2:length(lat)
%         % Calculate the number of frames for smooth animation between points
%         num_frames = 10; % Adjust for smoother animation
%         for j = 1:num_frames
%             % Interpolate between the current and next point
%             interp_lat = lat(k-1) + (lat(k) - lat(k-1)) * (j / num_frames);
%             interp_long = long(k-1) + (long(k) - long(k-1)) * (j / num_frames);
%             
%             % Update the X and Y data of the plot
%             set(h, 'LatitudeData', interp_lat, 'LongitudeData', interp_long);
%             
% %             % Calculate the current time
% %             current_time = time(k-1) + (time(k) - time(k-1)) * (j / num_frames);
% %             
% %             % Update the clock text
% %             set(clock_text, 'String', sprintf('Time: %.2f', current_time));
% %             
% %             % Calculate the pause duration for each frame
%             pause_duration = (time(k) - time(k-1)) / num_frames;
%             pause(pause_duration);  % Pause for the calculated duration
%         end
%     end
%     
%     hold off;
% end
% 




function plotLLACoordinatesWithTimeFromCSV(csvFile)
% Function to plot latitude, longitude coordinates with time labels from a CSV file

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
    
    % Create a figure
    figure;
    % Plot the base station with a green star. This sets up the figure for
    % the first time, including the zoom into the test track area.
    h_geoplot = geoplot(40.8637, -77.8359, '*','Color',[0 1 0],'Linewidth',3,'Markersize',10);

    h_parent =  get(h_geoplot,'Parent');
    set(h_parent,'ZoomLevel',16.375);
    try
        geobasemap satellite
    catch
        geobasemap openstreetmap
    end
    hold on;
    
    % Initialize the plot with the first point
    h = geoplot(lat(1), lon(1), 'bs', 'MarkerSize', 10, 'MarkerFaceColor', 'b');
    hold on;
    
    % Initialize the clock text
    clock_text = text(min(lon), max(lat) + 0.001, 'Time: 0.00', 'FontSize', 12);
    
    % Loop through the data points to update the plot
    for k = 2:length(lat)
        % Calculate the number of frames for smooth animation between points
        num_frames = 3; % Adjust for smoother animation
        for j = 1:num_frames
            % Interpolate between the current and next point
            interp_lat = lat(k-1) + (lat(k) - lat(k-1)) * (j / num_frames);
            interp_lon = lon(k-1) + (lon(k) - lon(k-1)) * (j / num_frames);
            
            % Update the Latitude and Longitude data of the plot
            set(h, 'LatitudeData', interp_lat, 'LongitudeData', interp_lon);
            
            % Calculate the current time
            current_time = time(k-1) + (time(k) - time(k-1)) * (j / num_frames);
            
            % Update the clock text
            set(clock_text, 'String', sprintf('Time: %.2f', current_time));
            
            % Calculate the pause duration for each frame
            pause_duration = (time(k) - time(k-1)) / num_frames;
            pause(pause_duration);  % Pause for the calculated duration
        end
        
        % Update the plot to the next point
        set(h, 'LatitudeData', lat(1:k), 'LongitudeData', lon(1:k));
    end
    
    hold off;
end

