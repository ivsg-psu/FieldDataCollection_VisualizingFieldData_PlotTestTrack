% script_test_fcn_PlotTestTrack_geoPlotData.m
% This is a script to exercise the function: fcn_PlotTestTrack_geoPlotData.m
% This function was written on 2023_06_07 by S. Brennan, sbrennan@psu.edu
% and Vaishnavi Wagh, vbw5054@psu.edu

% Revision history:
% 2023_06_07 
% -- first write of the code


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

%% BASIC example 1
% call the function with empty inputs, and it should create the plot with
% the focus on the test track, satellite view
fcn_PlotTestTrack_geoPlotData;

%% BASIC example 2
% call the function with empty inputs, but with a figure number,
% and it should create the plot with
% the focus on the test track, satellite view
% fcn_PlotTestTrack_geoPlotData((data_array),(color),(text),(fig_num))
data_array = []; % Make it empty to NOT plot data
plot_color = []; % Make it empty to use default
plot_text = ''; % Make it empty to NOT put text on
fig_num = 222; % Give a figure number to make it plot it the figure
fcn_PlotTestTrack_geoPlotData(data_array,plot_color,plot_text,fig_num);

%% BASIC example 3
% Plot data onto an empty figure. This will force the code to check to see
% if the figure has data inside it, and if not, it will prepare the figure
% the same way as a new figure.


% Fill in some dummy data (East curve from scenario 1_1)

data3 = [
    -77.83108116099999,40.86426763900005,0
    -77.83098509099995,40.86432365200005,0
    -77.83093857199998,40.86435301300003,0
    -77.83087253399998,40.86439877000004,0
    -77.83080882499996,40.86444684500003,0
    -77.83075077399997,40.86449883100005,0
    -77.83069596999997,40.86455288200005,0
    -77.83064856399994,40.86461089600004,0
    -77.83060707999994,40.86467151800008,0
    -77.83057291199998,40.86473474700006,0
    -77.83054614799994,40.86479999100004,0
    -77.83052443199995,40.86486635700004,0
    -77.83051053899999,40.86493399600005,0
    -77.83050385699994,40.86500232600008,0
    -77.83050469499995,40.86507096000003,0
    -77.83051096999998,40.86513880700005,0
    -77.83051548199995,40.86516167900004,0
    -77.83052813799998,40.86520696400004,0
    -77.83055303799995,40.86527300500006,0
    -77.83058410099994,40.86533739600003,0
    -77.83062308399997,40.86539921800005,0
    -77.83066833899994,40.86545839100006,0
    -77.83071974699999,40.86551445800006,0
    -77.83077704999994,40.86556697700007,0
    -77.83084030799995,40.86561520700008,0
    -77.83090661499995,40.86566081200004,0
    -77.83097722599996,40.86570252900003,0
    -77.83105323399997,40.86573830000003,0
    -77.83113270799998,40.86576916300004,0
    -77.83121508099998,40.86579495800004,0
    -77.83129931099995,40.86581674200005,0
    -77.83138581099996,40.86583237300005,0
    -77.83147340899995,40.86584355000008,0
    -77.83156186599996,40.86584960200003,0
    -77.83165067999994,40.86585007100007,0
    -77.83173939599999,40.86584604200004,0
    -77.83182788999994,40.86583809200005,0
    -77.83191641299999,40.86582709200007,0
    -77.83198191299994,40.86581637600005,0
    -77.83211176999998,40.86579081600007,0
    ];

% fcn_PlotTestTrack_geoPlotData((data_array),(color),(text),(fig_num))
% Fill in the data array. NOTE: above data is in BAD column order, so we
% have to manually rearrange it.
data_array = [data3(:,2), data3(:,1), data3(:,3)]; 
plot_color = []; % Make it empty to use default
plot_text = ''; % Make it empty to NOT put text on
fig_num = 333; % Give a figure number to make it plot it the figure
fcn_PlotTestTrack_geoPlotData(data_array,plot_color,plot_text,fig_num);

%% Basic example 4
% Plot data onto an existing figure

% call the function with empty inputs, but with a figure number,
% and it should create the plot with
% the focus on the test track, satellite view
% fcn_PlotTestTrack_geoPlotData((data_array),(color),(text),(fig_num))
empty_data = []; % Make it empty to NOT plot data
plot_color = []; % Make it empty to use default
plot_text = ''; % Make it empty to NOT put text on
fig_num = 444; % Give a figure number to make it plot it the figure
fcn_PlotTestTrack_geoPlotData(empty_data,plot_color,plot_text,fig_num);

% Now call the function again to plot data into an existing figure to check
% that this works
fcn_PlotTestTrack_geoPlotData(data_array,plot_color,plot_text,fig_num);

%% Basic example 5
% Plot data with user-given color

% fcn_PlotTestTrack_geoPlotData((data_array),(color),(text),(fig_num))
plot_data = data_array; % reuse data from before
plot_color = [0 0 1]; % Make it blue!
plot_text = ''; % Make it empty to NOT put text on
fig_num = 555; % Give a figure number to make it plot it the figure
fcn_PlotTestTrack_geoPlotData(plot_data,plot_color,plot_text,fig_num);

%% Basic example 6
% Plot data with text

% fcn_PlotTestTrack_geoPlotData((data_array),(color),(text),(fig_num))
plot_data = data_array; % reuse data from before
plot_color = []; % Make it empty to use default
plot_text = 'Test'; % Make it empty to NOT put text on
fig_num = 666; % Give a figure number to make it plot it the figure
fcn_PlotTestTrack_geoPlotData(plot_data,plot_color,plot_text,fig_num);
