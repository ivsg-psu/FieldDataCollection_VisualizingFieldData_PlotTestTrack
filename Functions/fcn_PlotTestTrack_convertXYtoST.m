function ST_points = fcn_PlotTestTrack_convertXYtoST(ENU_points,v_unit,varargin)
%% fcn_PlotTestTrack_convertXYtoST
% Takes xEast and yNorth points in the ENU coordinates and used them as an
% input to give the station ( distance from origin in the direction of
% travel) and transvers (distance from origin in the orthogonal direction) 
%
% FORMAT:
%
%       fcn_PlotTestTrack_convertXYtoST(ENU_points, v_unit,fig_num)
%
% INPUTS:
%      
%      ENU_points : [xEast, yNorth] X and Y ENU coordinates in [Nx2] format
% 
%      v_unit: unit vector in direction of travel 
%
%      (OPTIONAL INPUTS)
%     
%      fig_num: a figure number to plot result
%
% OUTPUTS:
%
%      ST_points : [station, transverse] ENU coordinates in [Nx2] format
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
%       script_test_fcn_PlotTestTrack_convertXYtoST.m for a full
%       test suite.
%
% This function was written on 2023_07_10 by V. Wagh
% Questions or comments? vbw5054@psu.ed


% Revision history:
% 2023_07_11 by V. Wagh
% -- start writing function
% 2024_07_18 - A. Kim
% -- Added improved debugging and input checking section

%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==3 && isequal(varargin{end},-1))
    flag_do_debug = 0; % Flag to plot the results for debugging
    flag_check_inputs = 0; % Flag to perform input checking
    flag_max_speed = 1;
else
    % Check to see if we are externally setting debug mode to be "on"
    flag_do_debug = 0; % Flag to plot the results for debugging
    flag_check_inputs = 1; % Flag to perform input checking
    MATLABFLAG_PLOTTESTTRACK_FLAG_CHECK_INPUTS = getenv("MATLABFLAG_PLOTTESTTRACK_FLAG_CHECK_INPUTS");
    MATLABFLAG_PLOTTESTTRACK_FLAG_DO_DEBUG = getenv("MATLABFLAG_PLOTTESTTRACK_FLAG_DO_DEBUG");
    if ~isempty(MATLABFLAG_PLOTTESTTRACK_FLAG_CHECK_INPUTS) && ~isempty(MATLABFLAG_PLOTTESTTRACK_FLAG_DO_DEBUG)
        flag_do_debug = str2double(MATLABFLAG_PLOTTESTTRACK_FLAG_DO_DEBUG);
        flag_check_inputs  = str2double(MATLABFLAG_PLOTTESTTRACK_FLAG_CHECK_INPUTS);
    end
end

if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
    debug_fig_num = 23434; %#ok<NASGU>
else
    debug_fig_num = []; %#ok<NASGU>
end
%% check input arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____                   _
%  |_   _|                 | |
%    | |  _ __  _ __  _   _| |_ ___
%    | | | '_ \| '_ \| | | | __/ __|
%   _| |_| | | | |_) | |_| | |_\__ \
%  |_____|_| |_| .__/ \__,_|\__|___/
%              | |
%              |_|
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if flag_check_inputs == 1
    % Are there the right number of inputs?
    narginchk(2,3);

end

% Tell user where we are
if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
end


flag_do_plots = 0; % Default to not plot
fig_num = []; % Initialize the figure number to be empty
if 3 == nargin
    temp = varargin{end};
    if ~isempty(temp)
        fig_num = temp;
        flag_do_plots = 1;
    else 
        % An empty figure number is given by user, so do not plot anything
    end
end

% Setup figures if there is debugging
if flag_do_debug
    fig_debug = 9999; 
else
    fig_debug = []; %#ok<*NASGU>
end

%% Write main code for plotting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _
%  |  \/  |     (_)
%  | \  / | __ _ _ _ __
%  | |\/| |/ _` | | '_ \
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rotation_matrix = [0 -1; 1 0];
v_orthogonal = (rotation_matrix *v_unit')';

% define the origin : origin of ENU coordinates
xEast = ENU_points(:,1);
yNorth = ENU_points(:,2);

% if flag_make_new_plot == 1
%     % plot xEast and yNorth
%     figure(fig_num);
%     hold on;
%     grid on;
%     xlabel('xEast [m]')
%     ylabel('yNorth [m]');
%     axis equal
%     plot(xEast,yNorth,'r.','MarkerSize',20);
%     text(xEast,yNorth,'old points', 'Color','r');
% end

ones_vector = ones(length(ENU_points(:,1)),1);  
transverse = sum(ENU_points.*(ones_vector*v_orthogonal),2);
station = sum(ENU_points.*(ones_vector*v_unit),2);

% Push to the output
ST_points = [station, transverse];

% plot results?
if flag_do_plots == 1
    station_vector = station * v_unit;
    transverse_vector = transverse* v_orthogonal;
    new_points_transverse = ENU_points + transverse_vector;
    new_points_station = ENU_points + station_vector;

    figure(fig_num);
    hold on;
    grid on;
    xlabel('xEast [m]');
    ylabel('yNorth [m]');
    axis equal;
    plot(xEast, yNorth,'g.','MarkerSize',20);
    quiver(0,0,v_unit(:,1),v_unit(:,2),'Color','k','LineWidth',5);
    quiver(0,0,v_orthogonal(:,1),v_orthogonal(:,2),'Color','k','LineWidth',5);

    % Loop through each point, plotting their results
    for ith_point = 1:length(station)
        quiver(0,0,xEast(ith_point,1),yNorth(ith_point,1),'Color','g','LineWidth',3);
        quiver(0,0,station_vector(ith_point,1),station_vector(ith_point,2),'Color','b');
        quiver(station_vector(ith_point,1),station_vector(ith_point,2),transverse_vector(ith_point,1),transverse_vector(ith_point,2),'Color','r');
    end
    
    %plot(xEast,yNorth, v_unit(:,1),v_unit(:,2),'color','g','LineWidth',3);
   % plot([0; new_points_station(:,1)],[0;new_points_station(:,2)],'color','b','LineWidth',3);
   % plot(new_points_transverse(:,1),new_points_transverse(:,1),'b.','MarkerSize',20);
    %plot(new_points_station(:,1),new_points_station(:,1),'b.','MarkerSize',20);

end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end
end % Ends main function

%% Functions follow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   ______                _   _
%  |  ____|              | | (_)
%  | |__ _   _ _ __   ___| |_ _  ___  _ __  ___
%  |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
%  | |  | |_| | | | | (__| |_| | (_) | | | \__ \
%  |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
%
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%§