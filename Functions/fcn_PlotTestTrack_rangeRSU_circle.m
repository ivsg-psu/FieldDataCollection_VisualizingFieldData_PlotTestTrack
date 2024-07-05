function fcn_PlotTestTrack_rangeRSU_circle(reference_latitude, reference_longitude, reference_altitude, rsu_coordinates_enu, radius)
    reference_latitude = 40.86368573;
    reference_longitude = -77.83592832;
    reference_altitude = 344.189;
    gps_object = GPS(reference_latitude, reference_longitude, reference_altitude);

    lla_coords = gps_object.ENU2WGSLLA(rsu_coordinates_enu);

    figure;
    h_geoplot = geoplot(lla_coords(1), lla_coords(2), '*','Color',[0 1 0],'LineWidth',3,'MarkerSize',10);

    h_parent = get(h_geoplot, 'Parent');
    set(h_parent, 'ZoomLevel', 16.375);
    try
        geobasemap satellite;
    catch
        geobasemap openstreetmap;
    end
    hold on;

    theta = linspace(0, 2*pi, 100);
    radius_in_degrees = radius / 111000;
    circle_lat = lla_coords(1) + radius_in_degrees * cos(theta);
    circle_lon = lla_coords(2) + radius_in_degrees * sin(theta) ./ cosd(lla_coords(1));
    geoplot(circle_lat, circle_lon, 'Color', [0 0 1], 'LineWidth', 1.5);

    hold off;

    figure;
    plot(rsu_coordinates_enu(1), rsu_coordinates_enu(2), '*', 'Color', [0 1 0], 'LineWidth', 3, 'MarkerSize', 10);
    hold on;

    circle_x = rsu_coordinates_enu(1) + radius * cos(theta);
    circle_y = rsu_coordinates_enu(2) + radius * sin(theta);
    plot(circle_x, circle_y, 'Color', [0 0 1], 'LineWidth', 1.5);

    hold off;
    xlabel('East (m)');
    ylabel('North (m)');
    axis equal;
end
