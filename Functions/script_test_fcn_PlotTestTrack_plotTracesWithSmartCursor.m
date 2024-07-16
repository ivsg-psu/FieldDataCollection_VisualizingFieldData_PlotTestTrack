% script_test_fcn_PlotTestTrack_plotTracesWithSmartCursor.m
% This is a script to exercise the function: fcn_PlotTestTrack_plotTracesWithSmartCursor.m
% This function was written on 2023_08_14 by S. Brennan, sbrennan@psu.edu

% Revision history:
% 2023_08_14 
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

%% Basic example 1
TraceNames = fcn_PlotTestTrack_nameTraces;

% FORMAT: [flags_whichIsSelected] = fcn_PlotTestTrack_findSelectedTraces(TraceNames,cell_string_array_to_select,cell_string_array_to_avoid)
isPlotted = fcn_PlotTestTrack_findSelectedTraces(TraceNames,{'FieldMeasurements_OriginalLaneChangeArea'},{});


% FORMAT: fcn_PlotTestTrack_plotTracesWithSmartCursor(...
%     TraceNames,isPlotted,plot_color,line_width,...
%     LLA_fig_num,ENU_fig_num,STH_fig_num,reference_unit_tangent_vector)
fcn_PlotTestTrack_plotTracesWithSmartCursor(TraceNames,isPlotted);



%% Advanced example showing how this is used


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
STH_transverse_vector = [1/(2^0.5) 1/(2^0.5)];
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
fcn_PlotTestTrack_plotTracesWithSmartCursor(TraceNames,isPlotted,[1 0 0],2,LLA_fig_num,ENU_fig_num,STH_fig_num,STH_transverse_vector);

