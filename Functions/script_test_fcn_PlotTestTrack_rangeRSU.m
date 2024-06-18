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

%%