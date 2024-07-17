%%  Basic example 3 - RSU range test at the loading doack tower for 20ft, plot spokes and hubs

csvFile = '50ft.csv';

fcn_plotTestTrack_rectangle(csvFile, [], [], [], [], []);

%% Example 2, site 2, test 3

baseLat = 40.8471670113384;
baseLon = -80.26182223666619;
baseAlt = 344.00;
csvFile = 'PA_288_4.csv';
car_width = [];
car_length = [];

fcn_plotTestTrack_rectangle(csvFile, car_width, car_length, baseLat, baseLon, baseAlt)


%%  Basic example 


baseLat = 40.8471670113384;
baseLon = -80.26182223666619;
baseAlt = 344.00;
csvFile = 'PA_288_4.csv';
fcn_plotTestTrack_animated_rectangle(csvFile, car_width, car_length, baseLat, baseLon, baseAlt);