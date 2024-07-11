%% Pittsburg Stattion Coordinates
reference_latitute = 40.44181017;
reference_longitude = -79.76090840;
reference_altitude = 327.428;

rsu_coordinates_lla = [40.43073, -79.87261, 0];

gps_object = GPS(reference_latitute,reference_longitude,reference_altitude);
rsu_coordinates_enu = gps_object.WGSLLA2ENU(rsu_coordinates_lla(:,1), rsu_coordinates_lla(:,2), rsu_coordinates_lla(:,3));

radius = 1000;
fcn_PlotTestTrack_rangeRSU_circle(reference_latitute, reference_longitude, reference_altitude, rsu_coordinates_enu, radius);

%% Pittsburg Stattion Coordinates
reference_latitute = 40.44181017;
reference_longitude = -79.76090840;
reference_altitude = 327.428;

rsu_coordinates_lla = [40.43073, -79.87261, 0];

gps_object = GPS(reference_latitute,reference_longitude,reference_altitude);
rsu_coordinates_enu = gps_object.WGSLLA2ENU(rsu_coordinates_lla(:,1), rsu_coordinates_lla(:,2), rsu_coordinates_lla(:,3));

radius = 1000;

plot_color = [1 1 0];
MarkerSize = 20;
fcn_PlotTestTrack_rangeRSU_circle(reference_latitute, reference_longitude, reference_altitude, rsu_coordinates_enu, radius, plot_color, MarkerSize);