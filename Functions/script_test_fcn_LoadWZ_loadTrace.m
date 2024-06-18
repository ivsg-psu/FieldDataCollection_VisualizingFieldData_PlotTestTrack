% script_test_fcn_LoadWZ_loadTrace.m
% This is a script to exercise the function: fcn_LoadWZ_loadTrace.m
% This function was written on 2023_08_22 by S. Brennan, sbrennan@psu.edu
% and Vaishnavi Wagh, vbw5054@psu.edu

% Revision history:
% 2023_08_22
% -- first write of the code
% 2023_10_26
% -- fixed variable names to try to be consistent in use of "traces" rather
% than "lanes" or "markers"

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

%% BASIC example 1 - showing call by name
% Load the first trace cluster - call it by name
fig_num = 1;
plot_color = [];
line_width = [];

figure(fig_num);
clf;

trace_name = 'FieldMeasurements_OriginalTrackLane_OuterMarkerClusterSolidWhite_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);  

%% BASIC example 1.b - showing call by name
% Load the first trace cluster - call it by name
fig_num = 1;
plot_color = [];
line_width = [];

figure(fig_num);
clf;

trace_name = 'FieldMeasurements_OriginalTrackLane_OuterMarkerClusterSolidWhite';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);  
%% BASIC example 1 - showing call by name, with direct loading 
% Load the first trace cluster - call it by name
fig_num = 1;
plot_color = [];
line_width = [];

figure(fig_num);
clf;

trace_name = 'FieldMeasurements_OriginalTrackLane_OuterMarkerClusterSolidWhite_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, plot_color, line_width, fig_num);  

%% BASIC example 1.b - showing call by name
% Load the centerline
fig_num = 111;
plot_color = [];
line_width = [];

% lane_marker_name = 'AlignedDesign_OriginalLaneChangeArea_MiddleMarkerCluster_BrokenWhite';
trace_name = 'DesignDrawings_OriginalLaneChangeArea_MiddleMarkerCluster_BrokenWhite';

[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);   %#ok<*ASGLU>

%% BASIC example 1.c - showing call by name
% Load the centerline
fig_num = 112;
plot_color = [];
line_width = [];

trace_name = 'AlignedDesign_OriginalTrackLane_InnerMarkerClusterCenterline';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);   %#ok<*ASGLU>

%% BASIC example 1.d - showing call by name
% Load the centerline
fig_num = 113;
plot_color = [];
line_width = [];

trace_name = 'AlignedDesign_OuterTrackLane_StartLineSolidWhite';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);   %#ok<*ASGLU>


%% BASIC example 1.e - showing call by name
% Load the centerline
fig_num = 114;
plot_color = [];
line_width = [];

trace_name = 'AlignedDesign_OuterTrackLane_FinishLineSolidWhite';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);   %#ok<*ASGLU>

%% BASIC example 1.f - checking the stop line traces
fig_num = 1201;
plot_color = [];
line_width = [];

figure(fig_num);
clf;

trace_name = 'DesignDrawings_StopLine_DetourLines_SouthWestSolidWhite_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, plot_color, line_width, fig_num);  

trace_name = 'DesignDrawings_StopLine_DetourLines_SouthWestSolidWhite_StartOfStopLine_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, [0 1 0], 5, fig_num); 

trace_name = 'DesignDrawings_StopLine_DetourLines_SouthWestSolidWhite_FinishOfStopLine_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, [1 0 0], 5, fig_num); 

set(gca,'ZoomLevel',23.375,'MapCenter',[40.862203378848527 -77.834650716608408]);
title('LLA geometry for DesignDrawings_StopLine_DetourLines_SouthWestSolidWhite','Interpreter','none');

%% BASIC example 1.f - checking the stop line traces in Aligned Designs
fig_num = 12011;
plot_color = [];
line_width = [];

figure(fig_num);
clf;

trace_name = 'AlignedDesign_OriginalTrackLane_OuterMarkerClusterSolidWhite_6';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, plot_color, line_width, fig_num);

trace_name = 'AlignedDesign_OriginalTrackLane_InnerMarkerClusterOuterDoubleYellow_9';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, plot_color, line_width, fig_num);

trace_name = 'AlignedDesign_OriginalTrackLane_InnerMarkerClusterInnerDoubleYellow_9';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, plot_color, line_width, fig_num);

trace_name = 'AlignedDesign_StopLine_DetourLines_SouthWestSolidWhite_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, plot_color, line_width, fig_num);

trace_name = 'AlignedDesign_StopLine_DetourLines_SouthWestSolidWhite_StartOfStopLine_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, [0 1 0], 5, fig_num); 

trace_name = 'AlignedDesign_StopLine_DetourLines_SouthWestSolidWhite_FinishOfStopLine_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, [1 0 0], 5, fig_num); 

set(gca,'ZoomLevel',23.375,'MapCenter',[40.862203378848527 -77.834650716608408]);
title('LLA geometry for DesignDrawings_StopLine_DetourLines_SouthWestSolidWhite','Interpreter','none');

%% Adding 2.4 Start line

fig_num = 241;

trace_name = 'DesignDrawings_StopLine_BetweenNewLine2AndNewLine3SolidWhite';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, [1 0 0], 5, fig_num); 
hold on;

trace_name = 'AlignedDesign_StopLine_BetweenNewLine2AndNewLine3SolidWhite';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, [1 0 0], 5, fig_num); 

%% Adding 4.3 start line
fig_num = 43000;

trace_name = 'DesignDrawings_OuterTrackLane_EntryJunctionStartLineSolidClear';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 0, [1 0 0], 5, fig_num); 

%% Debugging
trace_name = 'AlignedDesign_EntryTransitions_ToNewLine1_FromOuterMarkerClusterSolidWhite_FarWest_DottedWhite';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, [1 0 0], 5, 23434); 

trace_name = 'AlignedDesign_EntryTransitions_ToNewLine2Center_FromOuterMarkerClusterSolidWhite_2_DottedWhite';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, [1 0 1], 5, 23434); 

%% Checking handling area of detours - design drawings
fig_num = 1202;
plot_color = [];
line_width = [];

figure(fig_num);
clf;


trace_name = 'DesignDrawings_StopLine_DetourLines_HandlingAreaOutflowSolidWhite_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, plot_color, line_width, fig_num);  

trace_name = 'DesignDrawings_StopLine_DetourLines_HandlingAreaOutflowSolidWhite_StartOfStopLine_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, [0 1 0], 5, fig_num); 

trace_name = 'DesignDrawings_StopLine_DetourLines_HandlingAreaOutflowSolidWhite_FinishOfStopLine_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, [1 0 0], 5, fig_num); 

set(gca,'ZoomLevel',23.375,'MapCenter',[40.862300554635496 -77.834626285217581]);
title('LLA geometry for DesignDrawings_StopLine_DetourLines_HandlingAreaOutflowSolidWhite','Interpreter','none');

%% Checking handling area of detours - aligned designs

fig_num = 12021;
plot_color = [];
line_width = [];

figure(fig_num);
clf;

trace_name = 'AlignedDesign_StopLine_DetourLines_HandlingAreaOutflowSolidWhite_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, plot_color, line_width, fig_num);  

trace_name = 'AlignedDesign_StopLine_DetourLines_HandlingAreaOutflowSolidWhite_StartOfStopLine_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, [0 1 0], 5, fig_num); 

trace_name = 'AlignedDesign_StopLine_DetourLines_HandlingAreaOutflowSolidWhite_FinishOfStopLine_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, [1 0 0], 5, fig_num); 

set(gca,'ZoomLevel',23.375,'MapCenter',[40.862300554635496 -77.834626285217581]);
title('LLA geometry for AlignedDesign_StopLine_DetourLines_HandlingAreaOutflowSolidWhite','Interpreter','none');

%% Checking handling area of detours - design drawings

fig_num = 1203;
plot_color = [];
line_width = [];

figure(fig_num);
clf;

trace_name = 'DesignDrawings_StopLine_DetourLines_CurveAroundGarageSolidWhite_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, plot_color, line_width, fig_num);  

trace_name = 'DesignDrawings_StopLine_DetourLines_CurveAroundGarageSolidWhite_StartOfStopLine_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, [0 1 0], 5, fig_num); 

trace_name = 'DesignDrawings_StopLine_DetourLines_CurveAroundGarageSolidWhite_FinishOfStopLine_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, [1 0 0], 5, fig_num); 

set(gca,'ZoomLevel',23.375,'MapCenter',[40.863866568287008 -77.836342902661698]);
title('LLA geometry for DesignDrawings_StopLine_DetourLines_CurveAroundGarageSolidWhite','Interpreter','none');

%% Checking handling area of detours - aligned designs

fig_num = 12031;
plot_color = [];
line_width = [];

figure(fig_num);
clf;

trace_name = 'AlignedDesign_StopLine_DetourLines_CurveAroundGarageSolidWhite_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, plot_color, line_width, fig_num);  

trace_name = 'AlignedDesign_StopLine_DetourLines_CurveAroundGarageSolidWhite_StartOfStopLine_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, [0 1 0], 5, fig_num); 

trace_name = 'AlignedDesign_StopLine_DetourLines_CurveAroundGarageSolidWhite_FinishOfStopLine_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, [1 0 0], 5, fig_num); 

set(gca,'ZoomLevel',23.375,'MapCenter',[40.863866568287008 -77.836342902661698]);
title('LLA geometry for AlignedDesign_StopLine_DetourLines_CurveAroundGarageSolidWhite','Interpreter','none');

%% Checking crossroads area of detours - design drawings

fig_num = 1204;
plot_color = [];
line_width = [];

figure(fig_num);
clf;


trace_name = 'DesignDrawings_StopLine_DetourLines_CrossroadsSolidWhite_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, plot_color, line_width, fig_num);  

trace_name = 'DesignDrawings_StopLine_DetourLines_CrossroadsSolidWhite_StartOfStopLine_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, [0 1 0], 5, fig_num); 

trace_name = 'DesignDrawings_StopLine_DetourLines_CrossroadsSolidWhite_FinishOfStopLine_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, [1 0 0], 5, fig_num); 

set(gca,'ZoomLevel',23.375,'MapCenter',[40.863958267082765 -77.836665939940303]);
title('LLA geometry for DesignDrawings_StopLine_DetourLines_CrossroadsSolidWhite','Interpreter','none');

%% Checking crossroads area of detours - aligned designs

fig_num = 12041;
plot_color = [];
line_width = [];

figure(fig_num);
clf;


trace_name = 'AlignedDesign_StopLine_DetourLines_CrossroadsSolidWhite_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, plot_color, line_width, fig_num);  

trace_name = 'AlignedDesign_StopLine_DetourLines_CrossroadsSolidWhite_StartOfStopLine_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, [0 1 0], 5, fig_num); 

trace_name = 'AlignedDesign_StopLine_DetourLines_CrossroadsSolidWhite_FinishOfStopLine_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, [1 0 0], 5, fig_num); 

set(gca,'ZoomLevel',23.375,'MapCenter',[40.863958267082765 -77.836665939940303]);
title('LLA geometry for AlignedDesign_StopLine_DetourLines_CrossroadsSolidWhite','Interpreter','none');

%% Checking north exit area of detours - design drawings

fig_num = 1205;
plot_color = [];
line_width = [];

figure(fig_num);
clf;

trace_name = 'DesignDrawings_StopLine_DetourLines_NorthExitSolidWhite_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, plot_color, line_width, fig_num);  

trace_name = 'DesignDrawings_StopLine_DetourLines_NorthExitSolidWhite_StartOfStopLine_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, [0 1 0], 5, fig_num); 

trace_name = 'DesignDrawings_StopLine_DetourLines_NorthExitSolidWhite_FinishOfStopLine_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, [1 0 0], 5, fig_num); 

set(gca,'ZoomLevel',23.375,'MapCenter',[40.864902681571195 -77.835838199724364]);
title('LLA geometry for DesignDrawings_StopLine_DetourLines_NorthExitSolidWhite','Interpreter','none');

%% Checking north exit area of detours - aligned designs

fig_num = 12051;
plot_color = [];
line_width = [];

figure(fig_num);
clf;

trace_name = 'AlignedDesign_StopLine_DetourLines_NorthExitSolidWhite_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, plot_color, line_width, fig_num);  

trace_name = 'AlignedDesign_StopLine_DetourLines_NorthExitSolidWhite_StartOfStopLine_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, [0 1 0], 5, fig_num); 

trace_name = 'AlignedDesign_StopLine_DetourLines_NorthExitSolidWhite_FinishOfStopLine_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, [1 0 0], 5, fig_num); 

set(gca,'ZoomLevel',23.375,'MapCenter',[40.864902681571195 -77.835838199724364]);
title('LLA geometry for AlignedDesign_StopLine_DetourLines_NorthExitSolidWhite','Interpreter','none');

%% Checking stopline for newline area - design drawings

fig_num = 1206;
plot_color = [];
line_width = [];

figure(fig_num);
clf;

trace_name = 'DesignDrawings_StopLine_BetweenNewLine1AndNewLine2SolidWhite_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, plot_color, line_width, fig_num);  

trace_name = 'DesignDrawings_StopLine_BetweenNewLine1AndNewLine2SolidWhite_StartOfStopLine_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, [0 1 0], 5, fig_num); 

trace_name = 'DesignDrawings_StopLine_BetweenNewLine1AndNewLine2SolidWhite_FinishOfStopLine_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, [1 0 0], 5, fig_num); 

set(gca,'ZoomLevel',23.375,'MapCenter',[40.863059937019720 -77.833283596403518]);
title('LLA geometry for DesignDrawings_StopLine_BetweenNewLine1AndNewLine2SolidWhite','Interpreter','none');

%% Checking stopline for newline area - aligned designs

fig_num = 12061;
plot_color = [];
line_width = [];

figure(fig_num);
clf;

trace_name = 'AlignedDesign_StopLine_BetweenNewLine1AndNewLine2SolidWhite_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, plot_color, line_width, fig_num);  

trace_name = 'AlignedDesign_StopLine_BetweenNewLine1AndNewLine2SolidWhite_StartOfStopLine_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, [0 1 0], 5, fig_num); 

trace_name = 'AlignedDesign_StopLine_BetweenNewLine1AndNewLine2SolidWhite_FinishOfStopLine_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, [1 0 0], 5, fig_num); 

set(gca,'ZoomLevel',23.375,'MapCenter',[40.863059937019720 -77.833283596403518]);
title('LLA geometry for AlignedDesign_StopLine_BetweenNewLine1AndNewLine2SolidWhite','Interpreter','none');

%% Checking start and stop lines for detour testing - design drawings

fig_num = 1207;
plot_color = [];
line_width = [];

figure(fig_num);
clf;

trace_name = 'DesignDrawings_OuterTrackLane_DetourStartLineSolidWhite';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, plot_color, line_width, fig_num);  

trace_name = 'DesignDrawings_OuterTrackLane_DetourFinishLineSolidWhite';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, plot_color, line_width, fig_num);  

trace_name = 'DesignDrawings_OuterTrackLane_DetourReentryLineSolidClear';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, plot_color, line_width, fig_num);  


trace_name = 'AlignedDesign_OuterTrackLane_DetourStartLineSolidWhite';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, [1 1 0], line_width, fig_num);  

trace_name = 'AlignedDesign_OuterTrackLane_DetourFinishLineSolidWhite';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, [1 1 0], line_width, fig_num);  

trace_name = 'AlignedDesign_OuterTrackLane_DetourReentryLineSolidClear';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 1, [1 1 0], line_width, fig_num);  


set(gca,'ZoomLevel',23.375,'MapCenter',[40.863294091284047 -77.837399592433925]);
title('LLA geometry for DesignDrawings_StopLine_BetweenNewLine1AndNewLine2SolidWhite','Interpreter','none');


%% BASIC example 2 - showing call by number
% Load the first trace cluster - call it by number
fig_num = 2;
figure(fig_num);
clf;

lane_marker_number = 1;
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(lane_marker_number, 0, plot_color, line_width, fig_num);  

%% BASIC example 3 - no figure
% Load the first trace cluster - call it by name
fig_num = [];
trace_name = 'FieldMeasurements_OriginalTrackLane_OuterMarkerClusterSolidWhite_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num); 

%% BASIC example 4 - different color
% Load the first trace cluster - call it by name
fig_num = [];
new_plot_color = [1 1 0];
new_line_width = 3;
trace_name = 'FieldMeasurements_OriginalTrackLane_OuterMarkerClusterSolidWhite_1';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 0, new_plot_color, new_line_width, fig_num); 


%% BASIC example 5 - showing call by name but entire cluster
% Load the first trace cluster - call it by name
fig_num = 4;
figure(fig_num);
clf;

trace_name = 'FieldMeasurements_OriginalTrackLane_OuterMarkerClusterSolidWhite';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num); 

%% BASIC example 6 - showing cover up trace
% Load the first trace cluster - call it by name
fig_num = 6;
figure(fig_num);
plot_color = [];
line_width = [];
clf;

trace_name = 'DesignDrawings_CoverUpLine_CoverEntryTransition';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num); 

%% BASIC example 7 - showing cover up trace
% Load the first trace cluster - call it by name
fig_num = 7;
figure(fig_num);
plot_color = [];
line_width = [];
clf;

trace_name = 'DesignDrawings_CoverUpLine_CoverEntryTransition2';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num); 

%% BASIC example 8 - showing start line
% Load the first trace cluster - call it by name
fig_num = 8;
figure(fig_num);
plot_color = [];
line_width = 3;
clf;

trace_name = 'DesignDrawings_OriginalTrackLane_StartLineSolidWhite';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 0, [0 1 0], line_width, fig_num); 

trace_name = 'DesignDrawings_OriginalTrackLane_FinishLineSolidWhite';
[LLA_positions_cell_array, ENU_positions_cell_array] = ...
    fcn_LoadWZ_loadTrace(trace_name, 0, [1 0 0], line_width, fig_num); 

set(gca,'ZoomLevel',21.25,'MapCenter',[40.865495430146368 -77.830674192614197]);

%% Show all the name calls - put each on separate plots
% Commented out because it takes too many plots!
if 1==1
    TraceNames = fcn_LoadWZ_nameTraces;
    N_Traces = length(TraceNames);
    
    for ith_trace = 1:N_Traces
        %if ismember(ith_lane,[1 2 3 4])
        fig_num = 1000+ith_trace;
        figure(fig_num);
        clf;
        
        trace_name = TraceNames{ith_trace};
        [LLA_positions_cell_array, ENU_positions_cell_array] = ...
            fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
        title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
        %end
    end
end

%% Show all the field measured existing traces - put each on same plot
fig_num = 3000;
figure(fig_num);
clf;

TraceNames = fcn_LoadWZ_nameTraces;
FieldMeasurements_TraceNames = TraceNames(contains(TraceNames,'FieldMeasure'));

N_Traces = length(FieldMeasurements_TraceNames);
for ith_trace = 1:N_Traces
    trace_name = FieldMeasurements_TraceNames{ith_trace};
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
    title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
end

title('All field measured geometries');

%% Show all the DesignDrawings traces - put each on same plot
fig_num = 4000;
figure(fig_num);
clf;

TraceNames = fcn_LoadWZ_nameTraces;
DesignDrawings_TraceNames = TraceNames(contains(TraceNames,'DesignDrawings'));

N_Traces = length(DesignDrawings_TraceNames);
for ith_trace = 1:N_Traces
    trace_name = DesignDrawings_TraceNames{ith_trace};
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
    title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
    
    if ith_trace==1
        % Set of line fixes 1: set(gca,'ZoomLevel',24.125,'MapCenter',[40.862118894325583 -77.835012353758913]);
        % Set of line fixes 2: set(gca,'ZoomLevel',24.125,'MapCenter',[40.862299939965681 -77.834584272984856]);        
        % Set of line fixes 3: set(gca,'ZoomLevel',24.75,'MapCenter',[40.864562255558063 -77.830691163828973]);                
        set(gca,'ZoomLevel',24.625,'MapCenter',[40.864917442964391 -77.830467250315778]);                
        
    end
end



title('All design geometries');

%% Show all the DesignDrawings detour lines - put each on same plot
fig_num = 4000;
figure(fig_num);
clf;

TraceNames = fcn_LoadWZ_nameTraces;
DesignDrawings_TraceNames = TraceNames(contains(TraceNames,'DesignDrawings_DetourLines'));

N_Traces = length(DesignDrawings_TraceNames);
for ith_trace = 1:N_Traces
    trace_name = DesignDrawings_TraceNames{ith_trace};
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
    title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
    
    if ith_trace==1
        % Set of line fixes 1: set(gca,'ZoomLevel',24.125,'MapCenter',[40.862118894325583 -77.835012353758913]);
        % Set of line fixes 2: set(gca,'ZoomLevel',24.125,'MapCenter',[40.862299939965681 -77.834584272984856]);        
        % Set of line fixes 3: set(gca,'ZoomLevel',24.75,'MapCenter',[40.864562255558063 -77.830691163828973]);                
        set(gca,'ZoomLevel',24.625,'MapCenter',[40.864917442964391 -77.830467250315778]);                
        
    end
end



title('All design geometries');

%% Show all the Aligned Design Trace Markers - put each on same plot

fig_num = 5000;
figure(fig_num);
clf;

TraceNames = fcn_LoadWZ_nameTraces;
AlignedDesign_TraceNames = TraceNames(contains(TraceNames,'AlignedDesign'));

N_Traces = length(AlignedDesign_TraceNames);
for ith_trace = 1:N_Traces
    trace_name = AlignedDesign_TraceNames{ith_trace};
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
    title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
end

title('All Aligned Design measured geometries');

%% Show all the Aligned Design Trace Markers - put each on same plot

fig_num = 5001;
figure(fig_num);
clf;

TraceNames = fcn_LoadWZ_nameTraces;
AlignedDesign_TraceNames = TraceNames(contains(TraceNames,'AlignedDesign_LaneExtension'));

N_Traces = length(AlignedDesign_TraceNames);
for ith_trace = 1:N_Traces
    trace_name = AlignedDesign_TraceNames{ith_trace};
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
    title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
end

title('All Aligned Design Trace Extensions measured geometries');

%% Show all the Aligned Design Trace Markers - put each on same plot

fig_num = 5002;
figure(fig_num);
clf;

TraceNames = fcn_LoadWZ_nameTraces;
AlignedDesign_TraceNames = TraceNames(contains(TraceNames,'AlignedDesign_EntryTransitions'));

N_Traces = length(AlignedDesign_TraceNames);
for ith_trace = 1:N_Traces
    trace_name = AlignedDesign_TraceNames{ith_trace};
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
    title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
end

title('All Aligned Design Entry Transitions measured geometries');

%% Show all the Aligned Design Trace Markers - put each on same plot

fig_num = 5003;
figure(fig_num);
clf;

TraceNames = fcn_LoadWZ_nameTraces;
AlignedDesign_TraceNames = TraceNames(contains(TraceNames,'AlignedDesign_ExitTransitions'));

N_Traces = length(AlignedDesign_TraceNames);
for ith_trace = 1:N_Traces
    trace_name = AlignedDesign_TraceNames{ith_trace};
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
    title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
end

title('All Aligned Design Exit Transitions measured geometries');
%% Show all the Aligned Design Trace Markers - put each on same plot

fig_num = 5004;
figure(fig_num);
clf;

TraceNames = fcn_LoadWZ_nameTraces;
AlignedDesign_TraceNames = TraceNames(contains(TraceNames,'AlignedDesign_LaneToLaneTransition'));

N_Traces = length(AlignedDesign_TraceNames);
for ith_trace = 1:N_Traces
    trace_name = AlignedDesign_TraceNames{ith_trace};
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
    title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
end

title('All Aligned Design LaneToLaneTransitions measured geometries');
%% Show all the name calls - put each on same plot
fig_num = 10000;
figure(fig_num);
clf;

TraceNames = fcn_LoadWZ_nameTraces;
N_Traces = length(TraceNames);

for ith_trace = 1:N_Traces
    trace_name = TraceNames{ith_trace};
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
    title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
end
title('All lane trace geometries')

%% Traces required for Scenario 1.1,3.1

plot_color = [];
line_width = [];

% looping through FieldMeasurent, designDrawing and AligneDesign data
d = dictionary(1,'FieldMeasurements_',2,'DesignDrawings_',3,'AlignedDesign_');

for data_type = 1:3

    fig_num = 6000 + data_type;
    figure(fig_num);
    clf;

    TraceNames = fcn_LoadWZ_nameTraces;
    AlignedDesign_TraceNames = TraceNames(contains(TraceNames,sprintf('%sOriginalTrackLane',d(data_type))));

    N_Traces = length(AlignedDesign_TraceNames);
    for ith_trace = 1:N_Traces
        trace_name = AlignedDesign_TraceNames{ith_trace};
        [LLA_positions_cell_array, ENU_positions_cell_array] = ...
            fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
        title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
    end

    title(sprintf('Scenario 1.1,3.1 using %s data',d(data_type)));
end

warning('Scenario 1.1,3.1 : FieldMeasurements is missing data in the north side of the track');
%% Traces required for Scenario 1.2,2.1

plot_color = [];
line_width = [];

% looping through FieldMeasurent, designDrawing and AligneDesign data
d = dictionary(1,'FieldMeasurements_',2,'DesignDrawings_',3,'AlignedDesign_');

for data_type = 1:3

    fig_num = 7000 + data_type;
    figure(fig_num);
    clf;

    TraceNames = fcn_LoadWZ_nameTraces;
    AlignedDesign_TraceNames = TraceNames(contains(TraceNames,sprintf('%sOriginalTrackLane',d(data_type))));

    N_Traces = length(AlignedDesign_TraceNames);
    for ith_trace = 1:N_Traces
        trace_name = AlignedDesign_TraceNames{ith_trace};
        [LLA_positions_cell_array, ENU_positions_cell_array] = ...
            fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
        title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
    end

    TraceNames = fcn_LoadWZ_nameTraces;
    AlignedDesign_TraceNames = TraceNames(contains(TraceNames,sprintf('%sDetourLines',d(data_type))));

    N_Traces = length(AlignedDesign_TraceNames);
    for ith_trace = 1:N_Traces
        trace_name = AlignedDesign_TraceNames{ith_trace};
        [LLA_positions_cell_array, ENU_positions_cell_array] = ...
            fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
        title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
    end

    title(sprintf('Scenario 1.2,2.1 using %s data',d(data_type)));
end

warning('Scenario 1.2,2.1 : FieldMeasurements data does not exist for detour traces or detour stop lines');

%% Traces required for Scenario 1.3

plot_color = [];
line_width = [];

% looping through FieldMeasurent, designDrawing and AligneDesign data
d = dictionary(1,'FieldMeasurements_',2,'DesignDrawings_',3,'AlignedDesign_');

for data_type = 2:3

    fig_num = 8000 + data_type;
    figure(fig_num);
    clf;

    TraceNames = fcn_LoadWZ_nameTraces;
    AlignedDesign_TraceNames = TraceNames(contains(TraceNames,sprintf('%sNewLine1_Center_SolidWhite',d(data_type))));

    N_Traces = length(AlignedDesign_TraceNames);
    for ith_trace = 1:N_Traces
        trace_name = AlignedDesign_TraceNames{ith_trace};
        [LLA_positions_cell_array, ENU_positions_cell_array] = ...
            fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
        title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
    end

    TraceNames = fcn_LoadWZ_nameTraces;
    AlignedDesign_TraceNames = TraceNames(contains(TraceNames,sprintf('%sNewLine2_Right_SolidYellow',d(data_type))));

    N_Traces = length(AlignedDesign_TraceNames);
    for ith_trace = 1:N_Traces
        trace_name = AlignedDesign_TraceNames{ith_trace};
        [LLA_positions_cell_array, ENU_positions_cell_array] = ...
            fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
        title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
    end

    TraceNames = fcn_LoadWZ_nameTraces;
    AlignedDesign_TraceNames = TraceNames(contains(TraceNames,sprintf('%sNewLine2_Left_DashedYellow',d(data_type))));

    N_Traces = length(AlignedDesign_TraceNames);
    for ith_trace = 1:N_Traces
        trace_name = AlignedDesign_TraceNames{ith_trace};
        [LLA_positions_cell_array, ENU_positions_cell_array] = ...
            fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
        title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
    end

    TraceNames = fcn_LoadWZ_nameTraces;
    AlignedDesign_TraceNames = TraceNames(contains(TraceNames,sprintf('%sNewLine3_Center_DashedWhite',d(data_type))));

    N_Traces = length(AlignedDesign_TraceNames);
    for ith_trace = 1:N_Traces
        trace_name = AlignedDesign_TraceNames{ith_trace};
        [LLA_positions_cell_array, ENU_positions_cell_array] = ...
            fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
        title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
    end

    TraceNames = fcn_LoadWZ_nameTraces;
    AlignedDesign_TraceNames = TraceNames(contains(TraceNames,sprintf('%sNewLine4_Center_SolidWhite',d(data_type))));

    N_Traces = length(AlignedDesign_TraceNames);
    for ith_trace = 1:N_Traces
        trace_name = AlignedDesign_TraceNames{ith_trace};
        [LLA_positions_cell_array, ENU_positions_cell_array] = ...
            fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
        title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
    end

    % transition curves
    trace_name = sprintf('%sEntryTransitions_ToNewLine1_FromOuterMarkerClusterSolidWhite_FarWest_DottedWhite',d(data_type));
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);

    trace_name = sprintf('%sEntryTransitions_ToNewLine2Right_FromInnerMarkerClusterOuterDoubleYellow_SolidYellow',d(data_type));
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);

    trace_name = sprintf('%sEntryTransitions_ToNewLine2Left_FromInnerMarkerClusterInnerDoubleYellow_SolidYellow',d(data_type));
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);

    trace_name = sprintf('%sExitTransitions_ToOuterMarkerClusterSolidWhite_FromNewLine1Center_DottedWhite',d(data_type));
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);

    trace_name = sprintf('%sExitTransitions_ToInnerMarkerClusterOuterDoubleYellow_FromNewLine2Right_SolidYellow',d(data_type));
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);


    trace_name = sprintf('%sExitTransitions_ToInnerMarkerClusterInnerDoubleYellow_FromNewLine2Left_SolidYellow',d(data_type));
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);

    title(sprintf('Scenario 1.3 using %s data',d(data_type)));
end

warning('Scenario 1.3 : FieldMeasurements data does not exist for any traces in this scenario');

%% Traces required for Scenario 1.3 on same plot for DesignDrwaings(pink) and AlignedDesign(blue)

plot_color = [];
line_width = 3;

% looping through FieldMeasurent, designDrawing and AligneDesign data
d = dictionary(1,'FieldMeasurements_',2,'DesignDrawings_',3,'AlignedDesign_');

for data_type = 2:3

    fig_num = 8000;
    figure(fig_num);

    TraceNames = fcn_LoadWZ_nameTraces;
    AlignedDesign_TraceNames = TraceNames(contains(TraceNames,sprintf('%sNewLine1_Center_SolidWhite',d(data_type))));

    N_Traces = length(AlignedDesign_TraceNames);
    for ith_trace = 1:N_Traces
        trace_name = AlignedDesign_TraceNames{ith_trace};
        if data_type == 2
            plot_color = [];
        else
            plot_color = [0 0 1];
        end
        [LLA_positions_cell_array, ENU_positions_cell_array] = ...
            fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
        title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
    end

    TraceNames = fcn_LoadWZ_nameTraces;
    AlignedDesign_TraceNames = TraceNames(contains(TraceNames,sprintf('%sNewLine2_Right_SolidYellow',d(data_type))));

    N_Traces = length(AlignedDesign_TraceNames);
    for ith_trace = 1:N_Traces
        trace_name = AlignedDesign_TraceNames{ith_trace};
        [LLA_positions_cell_array, ENU_positions_cell_array] = ...
            fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
        title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
    end

    TraceNames = fcn_LoadWZ_nameTraces;
    AlignedDesign_TraceNames = TraceNames(contains(TraceNames,sprintf('%sNewLine2_Left_DashedYellow',d(data_type))));

    N_Traces = length(AlignedDesign_TraceNames);
    for ith_trace = 1:N_Traces
        trace_name = AlignedDesign_TraceNames{ith_trace};
        [LLA_positions_cell_array, ENU_positions_cell_array] = ...
            fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
        title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
    end

    TraceNames = fcn_LoadWZ_nameTraces;
    AlignedDesign_TraceNames = TraceNames(contains(TraceNames,sprintf('%sNewLine3_Center_DashedWhite',d(data_type))));

    N_Traces = length(AlignedDesign_TraceNames);
    for ith_trace = 1:N_Traces
        trace_name = AlignedDesign_TraceNames{ith_trace};
        [LLA_positions_cell_array, ENU_positions_cell_array] = ...
            fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
        title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
    end

    TraceNames = fcn_LoadWZ_nameTraces;
    AlignedDesign_TraceNames = TraceNames(contains(TraceNames,sprintf('%sNewLine4_Center_SolidWhite',d(data_type))));

    N_Traces = length(AlignedDesign_TraceNames);
    for ith_trace = 1:N_Traces
        trace_name = AlignedDesign_TraceNames{ith_trace};
        [LLA_positions_cell_array, ENU_positions_cell_array] = ...
            fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
        title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
    end

    % transition curves
    trace_name = sprintf('%sEntryTransitions_ToNewLine1_FromOuterMarkerClusterSolidWhite_FarWest_DottedWhite',d(data_type));
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);

    trace_name = sprintf('%sEntryTransitions_ToNewLine2Right_FromInnerMarkerClusterOuterDoubleYellow_SolidYellow',d(data_type));
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);

    trace_name = sprintf('%sEntryTransitions_ToNewLine2Left_FromInnerMarkerClusterInnerDoubleYellow_SolidYellow',d(data_type));
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);

    trace_name = sprintf('%sExitTransitions_ToOuterMarkerClusterSolidWhite_FromNewLine1Center_DottedWhite',d(data_type));
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);

    trace_name = sprintf('%sExitTransitions_ToInnerMarkerClusterOuterDoubleYellow_FromNewLine2Right_SolidYellow',d(data_type));
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);


    trace_name = sprintf('%sExitTransitions_ToInnerMarkerClusterInnerDoubleYellow_FromNewLine2Left_SolidYellow',d(data_type));
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);

    title(sprintf('Scenario 1.3 using %s data',d(data_type)));
end

warning('Scenario 1.3 : FieldMeasurements data does not exist for any traces in this scenario');

%% Traces required for Scenario 1.4, 1.5

plot_color = [];
line_width = [];

% looping through FieldMeasurent, designDrawing and AligneDesign data
d = dictionary(1,'FieldMeasurements_',2,'DesignDrawings_',3,'AlignedDesign_');

for data_type = 2:3

    fig_num = 9000 + data_type;
    figure(fig_num);
    clf;

    TraceNames = fcn_LoadWZ_nameTraces;
    AlignedDesign_TraceNames = TraceNames(contains(TraceNames,sprintf('%sNewLine1_Center_SolidWhite',d(data_type))));

    N_Traces = length(AlignedDesign_TraceNames);
    for ith_trace = 1:N_Traces
        trace_name = AlignedDesign_TraceNames{ith_trace};
        [LLA_positions_cell_array, ENU_positions_cell_array] = ...
            fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
        title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
    end

    TraceNames = fcn_LoadWZ_nameTraces;
    AlignedDesign_TraceNames = TraceNames(contains(TraceNames,sprintf('%sNewLine2_Right_SolidYellow',d(data_type))));

    N_Traces = length(AlignedDesign_TraceNames);
    for ith_trace = 1:N_Traces
        trace_name = AlignedDesign_TraceNames{ith_trace};
        [LLA_positions_cell_array, ENU_positions_cell_array] = ...
            fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
        title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
    end

    TraceNames = fcn_LoadWZ_nameTraces;
    AlignedDesign_TraceNames = TraceNames(contains(TraceNames,sprintf('%sNewLine2_Left_DashedYellow',d(data_type))));

    N_Traces = length(AlignedDesign_TraceNames);
    for ith_trace = 1:N_Traces
        trace_name = AlignedDesign_TraceNames{ith_trace};
        [LLA_positions_cell_array, ENU_positions_cell_array] = ...
            fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
        title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
    end

    TraceNames = fcn_LoadWZ_nameTraces;
    AlignedDesign_TraceNames = TraceNames(contains(TraceNames,sprintf('%sNewLine3_Right',d(data_type))));

    N_Traces = length(AlignedDesign_TraceNames);
    for ith_trace = 1:N_Traces
        trace_name = AlignedDesign_TraceNames{ith_trace};
        [LLA_positions_cell_array, ENU_positions_cell_array] = ...
            fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
        title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
    end

    TraceNames = fcn_LoadWZ_nameTraces;
    AlignedDesign_TraceNames = TraceNames(contains(TraceNames,sprintf('%sNewLine3_Left',d(data_type))));

    N_Traces = length(AlignedDesign_TraceNames);
    for ith_trace = 1:N_Traces
        trace_name = AlignedDesign_TraceNames{ith_trace};
        [LLA_positions_cell_array, ENU_positions_cell_array] = ...
            fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
        title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
    end

    TraceNames = fcn_LoadWZ_nameTraces;
    AlignedDesign_TraceNames = TraceNames(contains(TraceNames,sprintf('%sNewLine4_Center_SolidWhite',d(data_type))));

    N_Traces = length(AlignedDesign_TraceNames);
    for ith_trace = 1:N_Traces
        trace_name = AlignedDesign_TraceNames{ith_trace};
        [LLA_positions_cell_array, ENU_positions_cell_array] = ...
            fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
        title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
    end

    % transition curves
    trace_name = sprintf('%sEntryTransitions_ToNewLine1_FromOuterMarkerClusterSolidWhite_FarWest_DottedWhite',d(data_type));
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);

    trace_name = sprintf('%sEntryTransitions_ToNewLine2Right_FromInnerMarkerClusterOuterDoubleYellow_SolidYellow',d(data_type));
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);

    trace_name = sprintf('%sEntryTransitions_ToNewLine2Left_FromInnerMarkerClusterInnerDoubleYellow_SolidYellow',d(data_type));
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);

    trace_name = sprintf('%sExitTransitions_ToOuterMarkerClusterSolidWhite_FromNewLine1Center_DottedWhite',d(data_type));
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);

    trace_name = sprintf('%sExitTransitions_ToInnerMarkerClusterOuterDoubleYellow_FromNewLine2Right_SolidYellow',d(data_type));
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);


    trace_name = sprintf('%sExitTransitions_ToInnerMarkerClusterInnerDoubleYellow_FromNewLine2Left_SolidYellow',d(data_type));
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);

    title(sprintf('Scenario 1.4,1,5 using %s data',d(data_type)));
end

warning('Scenario 1.4, 1.5 : FieldMeasurements data does not exist for any traces in this scenario');

%% Traces required for Scenario 1.6,5.2

plot_color = [];
line_width = [];

% looping through FieldMeasurent, designDrawing and AligneDesign data
d = dictionary(1,'FieldMeasurements_',2,'DesignDrawings_',3,'AlignedDesign_');

for data_type = 2:3

    fig_num = 10000 + data_type;
    figure(fig_num);
    clf;

    TraceNames = fcn_LoadWZ_nameTraces;
    AlignedDesign_TraceNames = TraceNames(contains(TraceNames,sprintf('%sNewLine1_Center_SolidWhite',d(data_type))));

    N_Traces = length(AlignedDesign_TraceNames);
    for ith_trace = 1:N_Traces
        trace_name = AlignedDesign_TraceNames{ith_trace};
        [LLA_positions_cell_array, ENU_positions_cell_array] = ...
            fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
        title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
    end

    TraceNames = fcn_LoadWZ_nameTraces;
    AlignedDesign_TraceNames = TraceNames(contains(TraceNames,sprintf('%sNewLine2_Center_DashedWhite',d(data_type))));

    N_Traces = length(AlignedDesign_TraceNames);
    for ith_trace = 1:N_Traces
        trace_name = AlignedDesign_TraceNames{ith_trace};
        [LLA_positions_cell_array, ENU_positions_cell_array] = ...
            fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
        title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
    end

    TraceNames = fcn_LoadWZ_nameTraces;
    AlignedDesign_TraceNames = TraceNames(contains(TraceNames,sprintf('%sNewLine3_Center_DashedWhite',d(data_type))));
    N_Traces = length(AlignedDesign_TraceNames);
    for ith_trace = 1:N_Traces
        trace_name = AlignedDesign_TraceNames{ith_trace};
        [LLA_positions_cell_array, ENU_positions_cell_array] = ...
            fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
        title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
    end

    TraceNames = fcn_LoadWZ_nameTraces;
    AlignedDesign_TraceNames = TraceNames(contains(TraceNames,sprintf('%sNewLine4_Right_SolidYellow',d(data_type))));
    N_Traces = length(AlignedDesign_TraceNames);
    for ith_trace = 1:N_Traces
        trace_name = AlignedDesign_TraceNames{ith_trace};
        [LLA_positions_cell_array, ENU_positions_cell_array] = ...
            fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
        title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
    end
    TraceNames = fcn_LoadWZ_nameTraces;
    AlignedDesign_TraceNames = TraceNames(contains(TraceNames,sprintf('%sNewLine4_Left_SolidYellow',d(data_type))));
    N_Traces = length(AlignedDesign_TraceNames);
    for ith_trace = 1:N_Traces
        trace_name = AlignedDesign_TraceNames{ith_trace};
        [LLA_positions_cell_array, ENU_positions_cell_array] = ...
            fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
        title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
    end

    % transition curves
    trace_name = sprintf('%sEntryTransitions_ToNewLine1_FromOuterMarkerClusterSolidWhite_FarWest_DottedWhite',d(data_type));
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);

    trace_name = sprintf('%sEntryTransitions_ToNewLine4Right_FromInnerMarkerClusterOuterDoubleYellow_SolidYellow',d(data_type));
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);

    trace_name = sprintf('%sEntryTransitions_ToNewLine4Left_FromInnerMarkerClusterInnerDoubleYellow_SolidYellow',d(data_type));
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);

    trace_name = sprintf('%sExitTransitions_ToOuterMarkerClusterSolidWhite_FromNewLine1Center_DottedWhite',d(data_type));
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);

    trace_name = sprintf('%sExitTransitions_ToInnerMarkerClusterOuterDoubleYellow_FromNewLine4Right_SolidYellow',d(data_type));
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);


    trace_name = sprintf('%sExitTransitions_ToInnerMarkerClusterInnerDoubleYellow_FromNewLine4Left_SolidYellow',d(data_type));
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);

    title(sprintf('Scenario 1.6,5.2 using %s data',d(data_type)));
end

warning('Scenario 1.6,5.2 : FieldMeasurements data does not exist for any traces in this scenario');

%% Traces required for Scenario 4.1a, 4.1b, 4.3, 5.1a, 5.1b

plot_color = [];
line_width = [];

% looping through FieldMeasurent, designDrawing and AligneDesign data
d = dictionary(1,'FieldMeasurements_',2,'DesignDrawings_',3,'AlignedDesign_');

for data_type = 2:3

    fig_num = 11000 + data_type;
    figure(fig_num);
    clf;

    TraceNames = fcn_LoadWZ_nameTraces;
    AlignedDesign_TraceNames = TraceNames(contains(TraceNames,sprintf('%sNewLine2_Center_DashedWhite',d(data_type))));

    N_Traces = length(AlignedDesign_TraceNames);
    for ith_trace = 1:N_Traces
        trace_name = AlignedDesign_TraceNames{ith_trace};
        [LLA_positions_cell_array, ENU_positions_cell_array] = ...
            fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
        title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
    end

    TraceNames = fcn_LoadWZ_nameTraces;
    AlignedDesign_TraceNames = TraceNames(contains(TraceNames,sprintf('%sNewLine3_Center_DashedWhite',d(data_type))));
    N_Traces = length(AlignedDesign_TraceNames);
    for ith_trace = 1:N_Traces
        trace_name = AlignedDesign_TraceNames{ith_trace};
        [LLA_positions_cell_array, ENU_positions_cell_array] = ...
            fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
        title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
    end

    TraceNames = fcn_LoadWZ_nameTraces;
    AlignedDesign_TraceNames = TraceNames(contains(TraceNames,sprintf('%sNewLine4_Right_SolidYellow',d(data_type))));
    N_Traces = length(AlignedDesign_TraceNames);
    for ith_trace = 1:N_Traces
        trace_name = AlignedDesign_TraceNames{ith_trace};
        [LLA_positions_cell_array, ENU_positions_cell_array] = ...
            fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
        title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
    end
    TraceNames = fcn_LoadWZ_nameTraces;
    AlignedDesign_TraceNames = TraceNames(contains(TraceNames,sprintf('%sNewLine4_Left_SolidYellow',d(data_type))));
    N_Traces = length(AlignedDesign_TraceNames);
    for ith_trace = 1:N_Traces
        trace_name = AlignedDesign_TraceNames{ith_trace};
        [LLA_positions_cell_array, ENU_positions_cell_array] = ...
            fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
        title(sprintf('Trace geometry for trace number %.0d with name %s',ith_trace,trace_name),'Interpreter','none');
    end

    % transition curves
    trace_name = sprintf('%sEntryTransitions_ToNewLine2Center_FromOuterMarkerClusterSolidWhite_2_DottedWhite',d(data_type));
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);

    trace_name = sprintf('%sEntryTransitions_ToNewLine4Right_FromInnerMarkerClusterOuterDoubleYellow_SolidYellow',d(data_type));
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);

    trace_name = sprintf('%sEntryTransitions_ToNewLine4Left_FromInnerMarkerClusterInnerDoubleYellow_SolidYellow',d(data_type));
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);

    trace_name = sprintf('%sExitTransitions_ToOuterMarkerClusterSolidWhite_FromNewLine2Right_SmallDottedWhite',d(data_type));
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);
    trace_name = sprintf('%sExitTransitions_ToOuterMarkerClusterSolidWhite_FromNewLine2Right_SolidWhite',d(data_type));
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);

    trace_name = sprintf('%sExitTransitions_ToInnerMarkerClusterOuterDoubleYellow_FromNewLine4Right_SolidYellow',d(data_type));
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);

    trace_name = sprintf('%sExitTransitions_ToInnerMarkerClusterInnerDoubleYellow_FromNewLine4Left_SolidYellow',d(data_type));
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(trace_name, 0, plot_color, line_width, fig_num);

    title(sprintf('Scenario 4.1a,4.1b,4.3,5.1a,5.1b using %s data',d(data_type)));
end

warning('Scenario 4.1a,4.1b,4.3,5.1a,5.1b: FieldMeasurements data does not exist for any traces in this scenario');

% scenarios left to teat : 2.3,2.4,4.2,6.1
%% Test the centerline cases


%% Failure cases follow
if 1==0
    %% Bad input name
    bad_lane_marker_name = 'this is bad';
    [LLA_positions_cell_array, ENU_positions_cell_array] = ...
        fcn_LoadWZ_loadTrace(bad_lane_marker_name);

    %%
end