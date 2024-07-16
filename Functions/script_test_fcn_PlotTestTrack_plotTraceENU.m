% script_test_fcn_PlotTestTrack_plotTraceENU.m
% This is a script to exercise the function: fcn_PlotTestTrack_plotTraceENU.m
% This function was written on 2023_07_20 by S. Brennan, sbrennan@psu.edu


% Revision history:
% 2023_07_20
% -- first write of the code

close all;

%% Fill in data for testing
% Load the first marker cluster - call it by name
lane_marker_name = 'FieldMeasurements_OriginalTrackLane_OuterMarkerClusterSolidWhite';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_PlotTestTrack_loadTrace(lane_marker_name); 



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

fig_num = 0; % Initialize the figure number count

%% BASIC example 1 - showing plot of entire cell arra
% Load the first marker cluster - call it by name
fig_num = fig_num + 1;
plot_color = [];
line_width = [];
flag_plot_headers_and_tailers = [];

% Plot LLA cell array
fcn_PlotTestTrack_plotTraceENU(ENU_positions_cell_array, plot_color, line_width, flag_plot_headers_and_tailers, fig_num);

title(sprintf('Fig %.0d: showing plot of entire cell array in ENU',fig_num), 'Interpreter','none');


%% BASIC example 2 - showing plot of entire cell arra
% Load the first marker cluster - call it by name
fig_num = fig_num + 1;
plot_color = [];

% Plot ENU results by each cell
for ith_data = 1:length(ENU_positions_cell_array)
    ENU_data_to_plot = ENU_positions_cell_array{ith_data};
    fcn_PlotTestTrack_plotTraceENU(ENU_data_to_plot, plot_color, line_width, flag_plot_headers_and_tailers, fig_num);
end

title(sprintf('Fig %.0d: showing plot of entire cell array in ENU',fig_num),'Interpreter','none');

%% BASIC example 3 - showing plot_color
% Load the first marker cluster - call it by name
fig_num = fig_num + 1;
plot_color = [0 0 1];
line_width = 5;

% Plot ENU cell array
fcn_PlotTestTrack_plotTraceENU(ENU_positions_cell_array, plot_color, line_width, flag_plot_headers_and_tailers, fig_num);

title(sprintf('Fig %.0d: showing plot_color',fig_num), 'Interpreter','none');

%% BASIC example 4 - showing flag_plot_headers_and_tailers, otherwise same as Ex 3
% Load the first marker cluster - call it by name
fig_num = fig_num + 1;
plot_color = [0 0 1];
line_width = 5;
flag_plot_headers_and_tailers = 0;

% Plot ENU cell array
fcn_PlotTestTrack_plotTraceENU(ENU_positions_cell_array, plot_color, line_width, flag_plot_headers_and_tailers, fig_num);

title(sprintf('Fig %.0d: showing flag_plot_headers_and_tailers',fig_num), 'Interpreter','none');




%% Failure cases follow
if 1==0
    %% Bad input name
    bad_lane_marker_name = 'this is bad';
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_PlotTestTrack_loadTrace(bad_lane_marker_name);

    %%
end