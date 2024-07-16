<<<<<<< Updated upstream
function fcn_plotTestTrack_rangeRSU_rectangle(reference_latitude, reference_longitude, reference_altitude, rsu_coordinates_enu, width, length)
=======
function plotTestTrack_rangeRSU_rectangle(reference_latitude, reference_longitude, reference_altitude, rsu_coordinates_enu, width, length)
>>>>>>> Stashed changes
    reference_latitude = 40.86368573;
    reference_longitude = -77.83592832;
    reference_altitude = 344.189;
    gps_object = GPS(reference_latitude, reference_longitude, reference_altitude);

    lla_coords = gps_object.ENU2WGSLLA(rsu_coordinates_enu);

    half_width = width / 2;
    half_length = length / 2;
    rectangle_enu = [
        rsu_coordinates_enu(1) - half_width, rsu_coordinates_enu(2) - half_length;
        rsu_coordinates_enu(1) + half_width, rsu_coordinates_enu(2) - half_length;
        rsu_coordinates_enu(1) + half_width, rsu_coordinates_enu(2) + half_length;
        rsu_coordinates_enu(1) - half_width, rsu_coordinates_enu(2) + half_length;
        rsu_coordinates_enu(1) - half_width, rsu_coordinates_enu(2) - half_length;
    ];

    rectangle_lla = gps_object.ENU2WGSLLA(rectangle_enu);

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

    geoplot(rectangle_lla(:,1), rectangle_lla(:,2), 'Color', [0 0 1], 'LineWidth', 1.5);

    hold off;

    figure;
    plot(rsu_coordinates_enu(1), rsu_coordinates_enu(2), '*', 'Color', [0 1 0], 'LineWidth', 3, 'MarkerSize', 10);
    hold on;

    plot(rectangle_enu(:,1), rectangle_enu(:,2), 'Color', [0 0 1], 'LineWidth', 1.5);

    hold off;
    xlabel('East (m)');
    ylabel('North (m)');
    axis equal;
end
