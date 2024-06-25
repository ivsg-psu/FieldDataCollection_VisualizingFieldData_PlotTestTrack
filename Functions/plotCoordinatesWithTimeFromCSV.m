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
    times = data(:, 3);
    
    % Plot the coordinates
    figure;
    plot(x, y, 'o'); % Plot points as circles
    hold on;
    
    % Annotate each point with the corresponding time
    for i = 1:length(x)
        text(x(i), y(i), num2str(times(i)), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    end
    
    % Label the axes
    xlabel('X');
    ylabel('Y');
    title('Coordinates with Time Labels');
    grid on;
    hold off;
end
