function plotLaneWithTimeFromCSV(csvFile)
    % Function to plot x,y coordinates with time labels from a CSV file
    % with square markers of side length 3 and lines connecting consecutive points
    
    % Read the CSV file
    data = readmatrix(csvFile);
    
    % Check if the input matrix has three columns
    if size(data, 2) ~= 3
        error('The CSV file must contain exactly three columns: x, y, and time.');
    end
    
    % Extract x and y coordinates and time values
    x = data(:, 1);
    y = data(:, 2);
    times = data(:, 3);
    
    % Plot the coordinates with square markers of size 3 and lines
    figure;
    plot(x, y, 's', 'MarkerSize', 15); % 's' for square markers, 'MarkerSize' is in points, set to 9 (approximately side length of 3)
    hold on;
    
    % Annotate each point with the corresponding time
    for i = 1:length(x)
        text(x(i), y(i), num2str(times(i)), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    end
    
    % Plot lines connecting consecutive points
    lineColor = [0.9290, 0.6940, 0.1250]
    for i = 1:length(x)-1
        plot(x(i:i+1), y(i:i+1), '-','LineWidth', 1, 'Color', lineColor); % Connect consecutive points with a line
    end
    
    % Label the axes
    xlabel('X');
    ylabel('Y');
    title('Coordinates with Time Labels and Connecting Lines');
    grid on;
    hold off;
end
