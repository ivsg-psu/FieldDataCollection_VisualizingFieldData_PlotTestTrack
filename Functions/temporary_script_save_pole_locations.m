% Reference location for GPS conversion
reference_latitude = 40.86368573;
reference_longitude = -77.83592832;
reference_altitude = 344.189;
gps_object = GPS(reference_latitude, reference_longitude, reference_altitude);

% Power Pole by the garage, Height ~ 8 meters
pole1_coordinates_enu = [-41.54388324160499, -111.0086546354483, -12.592103434894112];
pole1_coordinates_lla = gps_object.ENU2WGSLLA(pole1_coordinates_enu);

% Pole with the time led, Height ~ 13 meters
pole2_coordinates_enu = [29.746349250935626, 124.74785860585521, -9.039292080071405];
pole2_coordinates_lla = gps_object.ENU2WGSLLA(pole2_coordinates_enu);

% Power pole by the gas tank, Height ~ 10 meters
pole3_coordinates_enu = [-21.40996058267557, -155.877934772639, -12.619945213934377];
pole3_coordinates_lla = gps_object.ENU2WGSLLA(pole3_coordinates_enu);

% Power pole by the detour, Height ~ 9 meters
pole4_coordinates_enu = [78.71383357714284, -60.13763178116716, -10.848769161102917];
pole4_coordinates_lla = gps_object.ENU2WGSLLA(pole4_coordinates_enu);

% Pole by the lane test area, Height ~ 10.5 meters
pole5_coordinates_enu = [261.5226068612395, 0.9362222334994122, -10.041353704834773];
pole5_coordinates_lla = gps_object.ENU2WGSLLA(pole5_coordinates_enu);

% Pole at the crash test area - East, Height ~ 13 meters
pole6_coordinates_enu = [236.28759539790076, 183.8291816550618, -7.3790257131302175];
pole6_coordinates_lla = gps_object.ENU2WGSLLA(pole6_coordinates_enu);

% Pole at the crash test area - Middle, Height ~ 13 meters
pole7_coordinates_enu = [128.68142817896114, 169.2357589741786, -8.40854669915419];
pole7_coordinates_lla = gps_object.ENU2WGSLLA(pole7_coordinates_enu);

% RSU test location 1 at Pittsburg live site
reference_latitude_pitts = 40.44181017;
reference_longitude_pitts = -79.76090840;
reference_altitude_pitts = 327.428;
pole8_coordinates_lla = [40.43073, -79.87261 0];
pole8_coordinates_enu = gps_object.WGSLLA2ENU(pole8_coordinates_lla(:,1),...
    pole8_coordinates_lla(:,2), pole8_coordinates_lla(:,3), reference_latitude,...
    reference_longitude,reference_altitude);

% RSU test location 2 at Pittsburg live site
pole9_coordinates_lla = [40.44582, -79.84637 0];
pole9_coordinates_enu = gps_object.WGSLLA2ENU(pole9_coordinates_lla(:,1),...
    pole9_coordinates_lla(:,2), pole9_coordinates_lla(:,3), reference_latitude,...
    reference_longitude,reference_altitude);



save('pole_coordinates.mat', ...
     'pole1_coordinates_enu', 'pole1_coordinates_lla', ...
     'pole2_coordinates_enu', 'pole2_coordinates_lla', ...
     'pole3_coordinates_enu', 'pole3_coordinates_lla', ...
     'pole4_coordinates_enu', 'pole4_coordinates_lla', ...
     'pole5_coordinates_enu', 'pole5_coordinates_lla', ...
     'pole6_coordinates_enu', 'pole6_coordinates_lla', ...
     'pole7_coordinates_enu', 'pole7_coordinates_lla',...
     'pole8_coordinates_enu', 'pole8_coordinates_lla',...
     'pole9_coordinates_enu', 'pole9_coordinates_lla');