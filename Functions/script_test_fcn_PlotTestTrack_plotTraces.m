% script_test_fcn_PlotTestTrack_plotTraces.m
% This is a script to exercise the function: fcn_PlotTestTrack_plotTraces.m
% This function was written on 2023_08_15 by S. Brennan, sbrennan@psu.edu

% Revision history:
% 2023_08_15 
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

hard_coded_reference_unit_tangent_vector_outer_lanes   = [0.793033249943519   0.609178351949592];
hard_coded_reference_unit_tangent_vector_LC_south_lane = [0.794630317120972   0.607093616431785];

%% Basic example 1 - plot all traces in the lane change area
TraceNames = fcn_PlotTestTrack_nameTraces;

% FORMAT: [flags_whichIsSelected] = fcn_PlotTestTrack_findSelectedTraces(TraceNames,cell_string_array_to_select,cell_string_array_to_avoid)
isPlotted = fcn_PlotTestTrack_findSelectedTraces(TraceNames,{'FieldMeasurements_OriginalLaneChangeArea'},{});

% FORMAT: fcn_PlotTestTrack_plotTracesWithSmartCursor(...
%     TraceNames,isPlotted,plot_color,line_width,...
%     LLA_fig_num,ENU_fig_num,STH_fig_num,reference_unit_tangent_vector)
fcn_PlotTestTrack_plotTraces(TraceNames,isPlotted);


%% Basic example 2 - plot all traces in lane change area in LLA, ENU, and STH

% Show the lane change area, that it is also offset (LLA plot)
LLA_fig_num = 3000;
figure(LLA_fig_num);
clf;
set(gcf,'UserData',[]); % Clear the data

ENU_fig_num = 3001;
figure(ENU_fig_num);
clf;
grid on;
hold on;
set(gcf,'UserData',[]); % Clear the data


STH_fig_num = 3002;
STH_transverse_vector = hard_coded_reference_unit_tangent_vector_outer_lanes;
figure(STH_fig_num);
clf;
grid on;
hold on;
set(gcf,'UserData',[]); % Clear the data

TraceNames = fcn_PlotTestTrack_nameTraces;

% FORMAT: [flags_whichIsSelected] = fcn_PlotTestTrack_findSelectedTraces(TraceNames,cell_string_array_to_select,cell_string_array_to_avoid)
isPlotted = fcn_PlotTestTrack_findSelectedTraces(TraceNames,{'FieldMeasurements_OriginalLaneChangeArea'},{});

% FORMAT: fcn_PlotTestTrack_plotTracesWithSmartCursor(...
%     TraceNames,isPlotted,plot_color,line_width,...
%     LLA_fig_num,ENU_fig_num,STH_fig_num,reference_unit_tangent_vector)
fcn_PlotTestTrack_plotTraces(TraceNames,isPlotted,[1 0 0],2,LLA_fig_num,ENU_fig_num,STH_fig_num,STH_transverse_vector);

%% Basic example 3 - plot a trace with a direct call
trace_name = 'FieldMeasurements_OriginalTrackLane_OuterMarkerClusterSolidWhite_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_PlotTestTrack_loadTrace(trace_name);
tempTrace.Name = trace_name;
tempTrace.LLA_positions_cell_array = LLA_positions_cell_array;
tempTrace.ENU_positions_cell_array = ENU_positions_cell_array;

fcn_PlotTestTrack_plotTraces(tempTrace);

%% Basic example 4 - plot a trace with a direct call, with plots specified

trace_name = 'FieldMeasurements_OriginalTrackLane_OuterMarkerClusterSolidWhite';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_PlotTestTrack_loadTrace(trace_name);
tempTrace.Name = trace_name;
tempTrace.LLA_positions_cell_array = LLA_positions_cell_array;
tempTrace.ENU_positions_cell_array = ENU_positions_cell_array;

LLA_fig_num = 3300;
figure(LLA_fig_num);
clf;
set(gcf,'UserData',[]); % Clear the data

ENU_fig_num = 3301;
figure(ENU_fig_num);
clf;
grid on;
hold on;
axis equal;
set(gcf,'UserData',[]); % Clear the data


STH_fig_num = 3302;
STH_transverse_vector = hard_coded_reference_unit_tangent_vector_outer_lanes;
figure(STH_fig_num);
clf;
grid on;
hold on;
axis equal;
set(gcf,'UserData',[]); % Clear the data

fcn_PlotTestTrack_plotTraces(tempTrace,[],[1 0 0],2,LLA_fig_num,ENU_fig_num,STH_fig_num,STH_transverse_vector);

%% Basic example 5 - plot a trace with a direct call, with plots specified, no headers

trace_name = 'FieldMeasurements_OriginalTrackLane_OuterMarkerClusterSolidWhite';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_PlotTestTrack_loadTrace(trace_name);
tempTrace.Name = trace_name;
tempTrace.LLA_positions_cell_array = LLA_positions_cell_array;
tempTrace.ENU_positions_cell_array = ENU_positions_cell_array;

LLA_fig_num = 3300;
figure(LLA_fig_num);
clf;
set(gcf,'UserData',[]); % Clear the data

ENU_fig_num = 3301;
figure(ENU_fig_num);
clf;
grid on;
hold on;
axis equal;
set(gcf,'UserData',[]); % Clear the data


STH_fig_num = 3302;
STH_transverse_vector = hard_coded_reference_unit_tangent_vector_outer_lanes;
figure(STH_fig_num);
clf;
grid on;
hold on;
axis equal;
set(gcf,'UserData',[]); % Clear the data

flag_plot_headers_and_tailers = 0;
fcn_PlotTestTrack_plotTraces(tempTrace,[],[1 0 0],2,LLA_fig_num,ENU_fig_num,STH_fig_num,STH_transverse_vector, flag_plot_headers_and_tailers);

%% Basic example 6 - plot a trace with a direct call, with plots specified, no headers, no points

trace_name = 'FieldMeasurements_OriginalTrackLane_OuterMarkerClusterSolidWhite';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_PlotTestTrack_loadTrace(trace_name);
tempTrace.Name = trace_name;
tempTrace.LLA_positions_cell_array = LLA_positions_cell_array;
tempTrace.ENU_positions_cell_array = ENU_positions_cell_array;

LLA_fig_num = 3300;
figure(LLA_fig_num);
clf;
set(gcf,'UserData',[]); % Clear the data

ENU_fig_num = 3301;
figure(ENU_fig_num);
clf;
grid on;
hold on;
axis equal;
set(gcf,'UserData',[]); % Clear the data


STH_fig_num = 3302;
STH_transverse_vector = hard_coded_reference_unit_tangent_vector_outer_lanes;
figure(STH_fig_num);
clf;
grid on;
hold on;
axis equal;
set(gcf,'UserData',[]); % Clear the data

flag_plot_headers_and_tailers = 0;
flag_plot_points = 0;
fcn_PlotTestTrack_plotTraces(tempTrace,[],[1 0 0],2,LLA_fig_num,ENU_fig_num,STH_fig_num,STH_transverse_vector, flag_plot_headers_and_tailers, flag_plot_points);

