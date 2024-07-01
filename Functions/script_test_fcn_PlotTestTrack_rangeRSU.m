close all;
csv_filenames = {'20ft.csv', '30ft.csv'};

optional_parameters = {
    {[1, 0, 0], 20, [-41.54388324160499, -111.0086546354483, -12.592103434894112], 1, 200}, 
    {[0, 0, 1], 10, [29.746349250935626, 124.74785860585521, -9.039292080071405], 1, 200}   
};

fcn_PlotTestTrack_rangeRSU(csv_filenames, optional_parameters);

%% Basic example 2: 20ft vs 50ft

close all;
csv_filenames = {'30ft.csv', '50ft.csv'};

optional_parameters = {
    {[1, 0, 0], 20, [-41.54388324160499, -111.0086546354483, -12.592103434894112], 1, 200}, 
    {[0, 0, 1], 10, [29.746349250935626, 124.74785860585521, -9.039292080071405], 1, 200}   
};

fcn_PlotTestTrack_rangeRSU(csv_filenames, optional_parameters);

%% Pittsburg Test Site

close all;
csv_filenames = {'PittsburgTestStartMiddlePart1.csv', 'PittsburgTestStartMiddlePart2.csv'};

RSU_Location1 = load("pole_coordinates.mat","pole8_coordinates_enu");
RSU_Location2 = load("pole_coordinates.mat","pole9_coordinates_enu");


optional_parameters = {
    {[1, 1, 0], 10, RSU_Location1.pole8_coordinates_enu, 1, 1000}, 
    {[0, 1, 1], 10, RSU_Location2.pole9_coordinates_enu, 1, 1000}   
};

fcn_PlotTestTrack_rangeRSU(csv_filenames, optional_parameters);

legend("BSM plot at RSU 1","RSU1 location","BSM plot at RSU2","RSU2locatiobn");

%% 

close all;
csv_filenames = {'PittsburgTestStartMiddlePart1.csv'};

RSU_Location1 = load("pole_coordinates.mat","pole8_coordinates_enu");



optional_parameters = {
    {[1, 1, 0], 10, RSU_Location1.pole8_coordinates_enu, 1, 1000}, 
  
};

fcn_PlotTestTrack_rangeRSU(csv_filenames, optional_parameters);

legend("BSM plot at RSU 1","RSU1 location");

%% 

close all;
csv_filenames = {'PittsburgTestStartMiddlePart2.csv'};

RSU_Location2 = load("pole_coordinates.mat","pole9_coordinates_enu");


optional_parameters = {
    {[0, 1, 1], 10, RSU_Location2.pole9_coordinates_enu, 1, 1000}   
};

fcn_PlotTestTrack_rangeRSU(csv_filenames, optional_parameters);

legend("BSM plot at RSU2","RSU2 location");