function plotCoordinatesWithTimeFromCSV(csvFile)
% Function to plot x,y coordinates with time labels from a CSV file
    % Read the CSV file
    data = readmatrix(csvFile);
    
    % Check if the input matrix has three columns
    if size(data, 2) ~= 3
        error('The CSV file must contain exactly three columns: x, y, and time.');
    end
    
    % Extract x and y coordinates and time values
    x = data(:, 1);
    y = data(:, 2);
    time = data(:, 3);

% Create a figure
figure;

% Initialize the plot with the first point
h = plot(x(1), y(1), 'bs', 'MarkerSize', 10); 
axis([0 15 0 15]);        % Set the axis limits
hold on;

% Loop through the data points to update the plot
for k = 2:length(x)
    % Calculate the number of frames for smooth animation between points
    num_frames = 100; % Adjust for smoother animation
    for j = 1:num_frames
        % Interpolate between the current and next point
        xt = x(k-1) + (x(k) - x(k-1)) * (j / num_frames);
        yt = y(k-1) + (y(k) - y(k-1)) * (j / num_frames);
        
        % Update the X and Y data of the plot
        set(h, 'XData', xt, 'YData', yt);
        
        % Calculate the pause duration for each frame
        pause_duration = (time(k) - time(k-1)) / num_frames;
        pause(pause_duration);  % Pause for the calculated duration
        
        % Display the current time as text on the plot
            %t = text(1, 0.5, sprintf('Time: %.2f', 0:0.1:time(end)), 'FontSize', 12);
        
    end
end

hold off;


end
