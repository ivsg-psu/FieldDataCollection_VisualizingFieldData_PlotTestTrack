% script_test_fcn_PlotTestTrack_plotBSMfromOBUtoRSU.m
% This is a script to exercise the function: fcn_PlotTestTrack_plotBSMfromOBUtoRSU.m
% This function was written on 2024_06_02 by V. Wagh, vbw5054@psu.edu

% Revision history:
% 2024_06_02
% -- first write of the code

close all;

%% Basic Example
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   ____            _        ______                           _
%  |  _ \          (_)      |  ____|                         | |
%  | |_) | __ _ ___ _  ___  | |__  __  ____ _ _ __ ___  _ __ | | ___
%  |  _ < / _` / __| |/ __| |  __| \ \/ / _` | '_ ` _ \| '_ \| |/ _ \
%  | |_) | (_| \__ \ | (__  | |____ >  < (_| | | | | | | |_) | |  __/
%  |____/ \__,_|___/_|\___| |______/_/\_\__,_|_| |_| |_| .__/|_|\___|
%                                                      | |
%                                                      |_|
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=Basic%20Example
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%§

%% Basic example 1 - RSU range test at the pendulum for 50ft

csv_filename = 'Pendulum50ft.csv';
flag_plot_spokes = 1;
flag_plot_hubs = 1;
flag_plot_LLA = 1;
flag_plot_ENU = 0;
flag_plot_STH = 0;
plot_color = [];
fig_num = 11;

[LLA_BSM_coordinates, ENU_BSM_coordinates, STH_BSM_coordinates]  = ...
    fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
    csv_filename);
%%  Basic example 2 - RSU range test at the bridge tower for 30ft

csv_filename = 'Bridge20ft.csv';
flag_plot_spokes = 1;
flag_plot_hubs = 1;
flag_plot_LLA = 1;
flag_plot_ENU = 0;
flag_plot_STH = 0;
plot_color = [];
fig_num = [];

[LLA_BSM_coordinates, ENU_BSM_coordinates, STH_BSM_coordinates]  = ...
    fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
    csv_filename,fig_num);

%%  Basic example 3 - RSU range test at the loading doack tower for 20ft, plot spokes and hubs

csv_filename = '20ft.csv';
flag_plot_spokes = 1;
flag_plot_hubs = 1;
flag_plot_LLA = 1;
flag_plot_ENU = 0;
flag_plot_STH = 0;
plot_color = [];
fig_num = 122;

[LLA_BSM_coordinates, ENU_BSM_coordinates, STH_BSM_coordinates]  = fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
       csv_filename, flag_plot_spokes,flag_plot_hubs,flag_plot_LLA,...
      flag_plot_ENU,flag_plot_STH,plot_color,fig_num);

%%  Basic example 4 - RSU range test at the loading doack tower for 20ft, do not plot spokes and hubs

csv_filename ='PittsburgTestMiddle.csv';
flag_plot_spokes = 0;
flag_plot_hubs = 0;
flag_plot_LLA = 1;
flag_plot_ENU = 0;
flag_plot_STH = 0;
plot_color = [1 0 0];
fig_num = 123;

[LLA_BSM_coordinates, ENU_BSM_coordinates, STH_BSM_coordinates]  = fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
       csv_filename, flag_plot_spokes,flag_plot_hubs,flag_plot_LLA,...
      flag_plot_ENU,flag_plot_STH,plot_color,fig_num);

%% 5

csv_filename_one = 'PittsburgTestStartMiddlePart1.csv';
csv_filename_two = 'PittsburgTestStartMiddlePart2.csv';
flag_plot_spokes = 0;
flag_plot_hubs = 0;
flag_plot_LLA = 1;
flag_plot_ENU = 0;
flag_plot_STH = 0;
plot_color_one = [1 0 0];
plot_color_two = [1 1 0];
fig_num = 124;
figure(fig_num);
[LLA_BSM_coordinates_one, ENU_BSM_coordinates_onw, STH_BSM_coordinates_one]  = fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
       csv_filename_one, flag_plot_spokes,flag_plot_hubs,flag_plot_LLA,...
      flag_plot_ENU,flag_plot_STH,plot_color_one,fig_num);
[LLA_BSM_coordinates_two, ENU_BSM_coordinates_two, STH_BSM_coordinates_two]  = fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
       csv_filename_two, flag_plot_spokes,flag_plot_hubs,flag_plot_LLA,...
      flag_plot_ENU,flag_plot_STH,plot_color_two,fig_num);

%%  Basic example 6 - RSU range test at Pittsburg with time 10/07/2024

csv_filename ='Pittssburgh_Test_Run_noTime.csv';
flag_plot_spokes = 0;
flag_plot_hubs = 0;
flag_plot_LLA = 1;
flag_plot_ENU = 0;
flag_plot_STH = 0;
plot_color = [1 1 0];
fig_num = 444;

[LLA_BSM_coordinates, ENU_BSM_coordinates, STH_BSM_coordinates]  = fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
       csv_filename, flag_plot_spokes,flag_plot_hubs,flag_plot_LLA,...
      flag_plot_ENU,flag_plot_STH,plot_color,fig_num);

%%  Basic example 7 - RSU range test at Pittsburg with time 10/07/2024

csv_filename ='Pittsburgh_1_(Ended_Early)_noTime.csv';
flag_plot_spokes = 0;
flag_plot_hubs = 0;
flag_plot_LLA = 1;
flag_plot_ENU = 0;
flag_plot_STH = 0;
plot_color = [0 1 1];
fig_num = 444;

[LLA_BSM_coordinates, ENU_BSM_coordinates, STH_BSM_coordinates]  = fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
       csv_filename, flag_plot_spokes,flag_plot_hubs,flag_plot_LLA,...
      flag_plot_ENU,flag_plot_STH,plot_color,fig_num);