%% script_test_fcn_plotTestTrack_animated_rectangle.m 

%% example 1

csvFile = 'Test Track1.csv';
car_width = 6;
car_length = 14;
baseLat = [];
baseLon = [];
baseAlt = []; 
fcn_plotTestTrack_animated_rectangle(csvFile, car_width, car_length, baseLat, baseLon, baseAlt);

%% example for fcn_plotTestTrack_rangeRSU_rectangle function

csvFile = 'Test Track1.csv';
width = 6;
length = 14;
reference_latitude = [];
reference_longitude = [];
reference_altitude = []; 
rsu_coordinates_lla = [40.79382193, -77.91282763, 0];

gps_object = GPS(reference_latitute,reference_longitude,reference_altitude);
rsu_coordinates_enu = gps_object.WGSLLA2ENU(rsu_coordinates_lla(:,1), rsu_coordinates_lla(:,2), rsu_coordinates_lla(:,3));

fcn_plotTestTrack_rangeRSU_rectangle(reference_latitude, reference_longitude, reference_altitude, rsu_coordinates_enu, width, length)
