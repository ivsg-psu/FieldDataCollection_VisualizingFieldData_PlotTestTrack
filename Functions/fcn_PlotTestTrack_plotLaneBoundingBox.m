function fcn_PlotTestTrack_plotLaneBoundingBox(csvFile, varargin)
%% fcn_PlotTestTrack_plotLaneBoundingBox
%
% create a plot of the lanes with a bounding box appearing under the lanes.
%
% FORMAT:
%
%       [LeftLaneX, LeftLaneY, RightLaneX, RightLaneY] = fcn_PlotTestTrack_laneBoundingBox(csvFile, (baseLat,baseLon, fig_num))
%
% INPUTS:
%
%      (MANDATORY INPUTS)
%       csvFile: The name of the .csv file that contains the latitude,
%                    longitude, altitude, and time of the location
%                    at which the OBU sent out the BSM message to the RSU
%                    that was in range. The code assumes latitude in first
%                    column, longitude in second, altitude in third, and 
%                    time in fourth. 
%
%       (OPTIONAL INPUTS)
%      baseLat: Latitude of the base location. Default is 40.8637.
%
%      baseLon: Longitude of the base location. Default is -77.8359.
%
%
%      fig_num: figure number
%
% OUTPUTS:
%
%      
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
%       script_test_fcn_PlotTestTrack_laneBoundingBox.m
%
% This function was written on 2024_07_18 by Joseph Baker
% --Start to write the function 
% Questions or comments? jmb9658@psu.edu


flag_do_debug = 0; % Flag to show the results for debugging
flag_do_plots = 0; % % Flag to plot the final results
flag_check_inputs = 1; % Flag to perform input checking

if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
    debug_fig_num = 34838;
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

if flag_check_inputs == 1
    % Are there the right number of inputs?
    narginchk(1,6);

end


% Default base location coordinates (PSU test track)
baseLat = 40.8637; % default
if 2 <= nargin
    temp = varargin{1};
    if ~isempty(temp)
        baseLat = temp;
    end
end

baseLon = -77.8359;% default
% Default base location coordinates (PSU test track)
if 3 <= nargin
    temp = varargin{2};
    if ~isempty(temp)
        baseLon = temp;
    end
end

% fig_num
fig_num = 100; % Default
if 4 <= nargin
    temp = varargin{3};
    if ~isempty(temp)
        fig_num = temp;
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

[ENU_LeftLaneX, ENU_LeftLaneY, ENU_RightLaneX, ENU_RightLaneY] = fcn_PlotTestTrack_animateAVLane(csvFile, baseLat,baseLon, fig_num);

ENU_RightLane = [ENU_RightLaneX ENU_RightLaneY (ENU_RightLaneX*0)];
ENU_LeftLane = [ENU_LeftLaneX ENU_LeftLaneY (ENU_LeftLaneX*0)];


baseAlt = 344.189; % TO DO: make this also an optional input
gps_object = GPS(baseLat,baseLon,baseAlt);

LLA_leftLane = gps_object.ENU2WGSLLA(ENU_LeftLane);
LLA_rightLane = gps_object.ENU2WGSLLA(ENU_RightLane);

plot_color = [0 1 1];



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


figure (fig_num); 
hold on;
prevIdx= 0;
for ith_data = 1:length(LLA_leftLane)
    if ~isnan(LLA_leftLane(ith_data,1))
        if prevIdx > 0
            if ~(all(LLA_rightLane(prevIdx,:) == LLA_rightLane(ith_data,:)) || all(LLA_rightLane(prevIdx,:)==LLA_leftLane(ith_data,:)) )
                fcn_INTERNAL_plotOneLane(LLA_rightLane(prevIdx,:),LLA_rightLane(ith_data,:), LLA_leftLane(prevIdx,:),LLA_leftLane(ith_data,:),plot_color,1)
            end
        end
        prevIdx = ith_data;
    end
    
end
hold off;

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end

end

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
%% fcn_INTERNAL_plotOneLane
function fcn_INTERNAL_plotOneLane(LLA_right1, LLA_right2, LLA_left1, LLA_left2, plot_color,line_width)

% Calculate the box to plot?
if ~isempty(LLA_right1) && ~isempty(LLA_left1)
   %boundaryLLA = [LLA_right1; flipud(LLA_left1); LLA_right1(1,:)];
    boundaryLLA = [LLA_right1; LLA_right2; LLA_left2; LLA_left1; LLA_right1;];

    LLA_data_to_plot = boundaryLLA;

    % Create the geoshape
    laneShape = geopolyshape(LLA_data_to_plot(:,1),LLA_data_to_plot(:,2));

    


    gp = geoplot(laneShape,'FaceColor',plot_color,'EdgeColor',plot_color,'Linewidth',line_width,'FaceAlpha',1);
    gp.EdgeAlpha = 0;
    gp.FaceAlpha = .35;
    % geoplot(LLA_data_to_plot(:,1)+offset_Lat,LLA_data_to_plot(:,2)+offset_Lon, '-','Color',plot_color,'Linewidth',line_width,'Markersize',sizeOfMarkers);
    % geoplot(LLA_data_to_plot(:,1)+offset_Lat,LLA_data_to_plot(:,2)+offset_Lon, '.','Color',plot_color,'Linewidth',line_width,'Markersize',round(sizeOfMarkers*2));
    % geoplot(LLA_data_to_plot(:,1)+offset_Lat,LLA_data_to_plot(:,2)+offset_Lon, '.','Color',[0 0 0],'Linewidth',line_width,'Markersize',round(sizeOfMarkers*0.5));
end
end