function [xc,yc,radii] = fcn_PlotTestTrack_circleCenterFromThreePoints(x,y,varargin)
%% fcn_PlotTestTrack_circleCenterFromThreePoints calculates the center of a circle from
% three points given as vectors in x and y
% Format: 
% [xc,yc,radii] = fcn_circleCenterFromThreePoints(x,y,(fig_num))
%
% INPUTS:
%      x: a Nx1 vector where N is at least 3. If N = 1, a circle will be
%      fit between these threee points, if N = 4 or more, then one circle
%      will be fit to the first three points, another cicle to the next
%      three points, etc.
%
%      y: same dimension as x, but representing the y-coordinate of the
%      points
%
%      Optional input (3): a figure number if plot results are desired
%
% OUTPUTS:
%      xc: the x-coordinate of the centers of the circles, as an [(N-2)x1]
%      vector
%      yc: the y-coordinate of the centers of the circles, as an [(N-2)x1]
%      vector
%      radii: the radius of each the circles, as an [(N-2)x1]
%      vector
%
% Examples:
%      
%      % BASIC example
%      x = [0; 1; 0.5];
%      y = [0; 4; -1];
%      [xc,yc,radii] = fcn_circleCenterFromThreePoints(x,y,1)
% 
%      % ADVANCED example that uses vectors of x and y
%      x = [0; 1; 0.5; -1];
%      y = [0; 4; -1; 4];
%      [xc,yc,radii] = fcn_circleCenterFromThreePoints(x,y,1)
%
%      % ADVANCED example that lets user select N points 
%      figure(1); clf; grid on; axis equal;
%      [x,y] = ginput; % Get arbitrary N points until user hits return
%      [xc,yc,radii] = fcn_circleCenterFromThreePoints(x,y,1)     
%
%
% This function was written on 2020_03_20 by S. Brennan
% Questions or comments? sbrennan@psu.edu 

% Revision history:
% 2020_03_20 - wrote the code
% 2020_05_22 - added more comments, particularly to explain inputs more
% clearly
% 2024_06_12 - S. Brennan
% -- Added improved debugging and input checking section

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

if flag_max_speed == 1
    % Are there the right number of inputs?
    narginchk(2,3);
end
do_debug = 0;
% Does user want to show the plots?
if 0==flag_max_speed && 3 == nargin
    fig_num = varargin{1};
    figure(fig_num);
    do_debug = 1;
else
    if do_debug  
        fig = figure; % %% create new figure with next default index
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


% Are the input vectors the right shape?
if length(x(:,1))<3
    error('x vector must be at least a 3x1');
end
if length(y(:,1))<3
    error('y vector must be at least a 3x1');
end

%% Solve for the circle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _       
%  |  \/  |     (_)      
%  | \  / | __ _ _ _ __  
%  | |\/| |/ _` | | '_ \ 
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% The code below is set up to be vectorized if there are more than one
% solution. Since the code is quite different looking for each, they are
% separated out. However, it may be that the N-solution case works for N is
% equal to 1. This was not tested.

% Do some pre-calculations
num_solutions = length(x(:,1))-2; % This is the number of solutions to expect
r_squared = (x.^2 + y.^2); % These are the radii of points from origin
diff_x = diff(x);
diff_y = diff(y);
diff_rsquared = diff(r_squared);

if 1 == num_solutions % Expecting just one solution. No need for big A, b matrices    
    % solve for the center point    
    A = [diff_x diff_y];
    b = 1/2*diff_rsquared;
    
else % Simultaneous solutions to be calculated - create big A and b matrices    
    % Construct the A-matrix and b matrix that will create the regressor.
    % Start by filling A and b matrices up with zeros (see notes for
    % explanation of iputs)
    A = zeros(2*num_solutions,2*num_solutions);
    b = zeros(2*num_solutions,1);
    
    % Fill in the non-zero portions of the matrix, which will be 1 per each
    % of the N solutions
    for i_solution = 1:num_solutions
        A(1+2*(i_solution-1):2+2*(i_solution-1),1+2*(i_solution-1)) = ...
            diff_x(i_solution:i_solution+1);
        A(1+2*(i_solution-1):2+2*(i_solution-1),2+2*(i_solution-1)) = ...
            diff_y(i_solution:i_solution+1);        
        b(1+2*(i_solution-1):2+2*(i_solution-1),1) = ...
            1/2*diff_rsquared(i_solution:i_solution+1);
    end
end

% Solve the center points
centers = A\b;
centers = reshape(centers,2,length(centers(:,1))/2);
xc = centers(1,:)';
yc = centers(2,:)';


% NOTE: the following line is the slowest in the code. It can be sped
% up if we do not take the square root
radii = ((xc - x(1:num_solutions,1)).^2 + ...
    (yc - y(1:num_solutions,1)).^2).^0.5;

%% Plot the results (for debugging)?
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
if do_debug
    hold on % allow multiple plot calls
    plot(x,y,'ro');  % Plot all the input points
    plot(xc,yc,'g+'); % Plot all the circle centers

    axis equal;
    grid on; grid minor;

    % plot all the circle fits
    angles = 0:0.01:2*pi;
    for i_fit = 1:length(xc)       
      
        x_circle = xc(i_fit,1) + radii(i_fit) * cos(angles);
        y_circle = yc(i_fit,1) + radii(i_fit) * sin(angles);
        plot(x_circle,y_circle,'b-');
    end
end



