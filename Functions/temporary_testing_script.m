%% script to test some functions temporarily

%% fcn_PlotTestTrack_rangeRSU_circle

% pittsburg base station coordinates
reference_latitude = 40.44181017;
reference_longitude = -79.76090840;
reference_altitude = 327.428; 

rsu_coordinates_lla = [40.43073, -79.87261 0];

gps_object = GPS(reference_latitude, reference_longitude, reference_altitude);
rsu_coordinates_enu = gps_object.WGSLLA2ENU(rsu_coordinates_lla(:,1),rsu_coordinates_lla(:,2), rsu_coordinates_lla(:,3),reference_latitude, reference_longitude, reference_altitude);

radius = 1000;
fcn_PlotTestTrack_rangeRSU_circle(reference_latitude, reference_longitude, reference_altitude, rsu_coordinates_enu, radius)

%% fcn_plotTestTrack_rangeRSU_rectangle

% pittsburg base station coordinates
reference_latitude = 40.44181017;
reference_longitude = -79.76090840;
reference_altitude = 327.428; 

rsu_coordinates_lla = [40.43073, -79.87261 0];

gps_object = GPS(reference_latitude, reference_longitude, reference_altitude);
rsu_coordinates_enu = gps_object.WGSLLA2ENU(rsu_coordinates_lla(:,1),rsu_coordinates_lla(:,2), rsu_coordinates_lla(:,3),reference_latitude, reference_longitude, reference_altitude);

width = 100;
length = 200;
fcn_plotTestTrack_rangeRSU_rectangle(reference_latitude, reference_longitude, reference_altitude, rsu_coordinates_enu, width, length)