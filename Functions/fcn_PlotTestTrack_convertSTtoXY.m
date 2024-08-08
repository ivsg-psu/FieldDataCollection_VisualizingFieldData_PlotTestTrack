function ENU_points = fcn_PlotTestTrack_convertSTtoXY(ST_points,v_unit,varargin)
%% %% fcn_PlotTestTrack_convertSTtoXY
% Takes ST_points that are [station, transverse] in ENU coordinates and uses them as an
% input to give the  xEast and yNorth points 
%
% FORMAT:
%
%      ENU_points = fcn_PlotTestTrack_convertSTtoXY(ST_points,v_unit,varargin)
%
% INPUTS:
%
%      ST_points : [station, transverse] ENU coordinates in [Nx2] format
% 
%      v_unit: unit vector in direction of travel 
%
%      (OPTIONAL INPUTS)
%     
%      fig_num: a figure number to plot result
%
% OUTPUTS:
%
%      ENU_points : [xEast, yNorth] X and Y ENU coordinates in [Nx2] format
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
%       script_test_fcn_PlotTestTrack_convertSTtoXY.m for a full
%       test suite.
%
% This function was written on 2023_07_11 by V. Wagh
% Questions or comments? vbw5054@psu.ed


% Revision history:
% 2023_07_11 by V. Wagh
% -- start writing function

%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==3 && isequal(varargin{end},-1))
    flag_do_debug = 0; % % % % Flag to plot the results for debugging
    flag_check_inputs = 0; % Flag to perform input checking
    flag_max_speed = 1;
else
    % Check to see if we are externally setting debug mode to be "on"
    flag_do_debug = 0; % % % % Flag to plot the results for debugging
    flag_check_inputs = 1; % Flag to perform input checking
    MATLABFLAG_PlotTestTrack_FLAG_CHECK_INPUTS = getenv("MATLABFLAG_PlotTestTrack_FLAG_CHECK_INPUTS");
    MATLABFLAG_PlotTestTrack_FLAG_DO_DEBUG = getenv("MATLABFLAG_PlotTestTrack_FLAG_DO_DEBUG");
    if ~isempty(MATLABFLAG_PlotTestTrack_FLAG_CHECK_INPUTS) && ~isempty(MATLABFLAG_PlotTestTrack_FLAG_DO_DEBUG)
        flag_do_debug = str2double(MATLABFLAG_PlotTestTrack_FLAG_DO_DEBUG); 
        flag_check_inputs  = str2double(MATLABFLAG_PlotTestTrack_FLAG_CHECK_INPUTS);
    end
end

flag_do_debug = 1;

if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
    debug_fig_num = 999978;
else
    debug_fig_num = [];
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
if 0 == flag_max_speed
    if flag_check_inputs == 1
        % Are there the right number of inputs?
        narginchk(2,3);
    end
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

flag_do_plots = 0;
if (0==flag_max_speed) && (3<= nargin)
    temp = varargin{end};
    if ~isempty(temp)
        fig_num = temp;
        flag_do_plots = 1;
    end
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

% what is the vector to roate the points?
Transform_point = [1  0]; % 90 degree line segment
v_unit2 = fcn_PlotTestTrack_convertXYtoST(Transform_point,v_unit,fig_num);

station = ST_points(:,1);
transverse = ST_points(:,2);
% get the ENU_points
ENU_points = fcn_PlotTestTrack_convertXYtoST(ST_points,v_unit2,fig_num);


xEast = ENU_points(:,1);
yNorth = ENU_points(:,2); 

%% Any debugging?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____       _
%  |  __ \     | |
%  | |  | | ___| |__  _   _  __ _
%  | |  | |/ _ \ '_ \| | | |/ _` |
%  | |__| |  __/ |_) | |_| | (_| |
%  |_____/ \___|_.__/ \__,_|\__, |
%                            __/ |
%                           |___/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% plot result
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
    plot(X_recalc, Y_recalc,'y.','MarkerSize',20);
    quiver(0,0,X_recalc,Y_recalc,'Color','k','LineWidth',5);
    quiver(0,0,v_orthogonal(:,1),v_orthogonal(:,2),'Color','k','LineWidth',5);

    % Loop through each point, plotting their results
    for ith_point = 1:length(station)
        quiver(0,0,xEast(ith_point,1),yNorth(ith_point,1),'Color','g','LineWidth',3);
        quiver(0,0,station_vector(ith_point,1),station_vector(ith_point,2),'Color','b');
        quiver(station_vector(ith_point,1),station_vector(ith_point,2),transverse_vector(ith_point,1),transverse_vector(ith_point,2),'Color','r');
    end

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