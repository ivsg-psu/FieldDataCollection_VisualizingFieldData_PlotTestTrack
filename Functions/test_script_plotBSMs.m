
% Prep for GPS conversions
% The true location of the track base station is [40.86368573°, -77.83592832°, 344.189 m].
reference_latitude = 40.86368573;
reference_longitude = -77.83592832;
reference_altitude = 344.189;
gps_object = GPS(reference_latitude,reference_longitude,reference_altitude); % Load the GPS class

%% a test script to plot the LLApoints of the GPS coordinates of BSMs
% received using the Commsignia CV2X RSUs and OBUs

% steps
% 1. Read the csv file with LLA

filename = 'Sample_LLA1.csv';
BSMs_received_here = csvread(filename, 1, 1);

% 2.geoplot
fig_num = 108;
figure(fig_num);
clf;

for ith_BSM = 1:length(BSMs_received_here)
    fcn_PlotTestTrack_geoPlotData(BSMs_received_here(ith_BSM,:),'m',sprintf('%d',ith_BSM),fig_num);
end

%%
% 1. Read the csv file with LLA

filename = '1center_loading_OBU.csv';
BSMs_received_here = csvread(filename, 1);

% 2.geoplot
fig_num = 108;
figure(fig_num);
clf;

for ith_BSM = 1:length(BSMs_received_here)
    fcn_PlotTestTrack_geoPlotData(BSMs_received_here(ith_BSM,:),'m',[],fig_num);
    %geoplot(BSMs_received_here(:,1), BSMs_received_here(:,2),'r.');
    %title(filename,sprintf(ith_BSM));
end

%% faster plotting
% 1. Read the csv file with LLA

filename = '1center_loading_OBU.csv';
BSMs_received_here = csvread(filename, 1);

% 2.geoplot

% set up new plot, clear the figure, and initialize the
fig_num = 108;
figure(fig_num);
clf;

% Plot the base station with a green star. This sets up the figure for
% the first time, including the zoom into the test track area.

h_geoplot = geoplot(40.8637, -77.8359, '*','Color',[0 1 0],'Linewidth',3,'Markersize',10);
h_parent =  get(h_geoplot,'Parent');
set(h_parent,'ZoomLevel',16.375);
try
    geobasemap satellite
catch
    geobasemap openstreetmap
end
hold on;

% plot the location of the BSM message received in a red 
geoplot(BSMs_received_here(:,1), BSMs_received_here(:,2), '.','Color',[1 0 0],'Markersize',10);

%% faster plotting 05/29/2024 (1 RSU in middle pole, OBU driving inner and outer lanes of full track)
% 1. Read the csv file with LLA

filename = 'center_loading_RSU_05_29_2024.csv';
BSMs_received_here = csvread(filename, 1);

BSMs_received_here_corrected = [BSMs_received_here(:,1)/10000000 BSMs_received_here(:,2)/10000000 BSMs_received_here(:,3)]; 

% 2.geoplot

% set up new plot, clear the figure, and initialize the
fig_num = 109;
figure(fig_num);
clf;

% Plot the base station with a green star. This sets up the figure for
% the first time, including the zoom into the test track area.

h_geoplot = geoplot(40.8637, -77.8359, '*','Color',[0 1 0],'Linewidth',3,'Markersize',10);
h_parent =  get(h_geoplot,'Parent');
set(h_parent,'ZoomLevel',16.375);
try
    geobasemap satellite
catch
    geobasemap openstreetmap
end
hold on;

% plot the location of the BSM message received in a red 
geoplot(BSMs_received_here_corrected(:,1), BSMs_received_here_corrected(:,2), '.','Color',[1 0 0],'Markersize',10);

% convert to polyobject

% create polyobject
% pgon = polyshape()
% to bound the polygon area
% create a convex polytope to fit around the outside edges


%% center_loading_RSU_05_29_2024_2
% faster plotting 05/29/2024 2nd try (1 RSU in middle pole on top of ladder, OBU driving inner and outer lanes of full track)
% 1. Read the csv file with LLA

filename = 'center_loading_RSU_05_29_2024_2.csv';
BSMs_received_here = csvread(filename, 1);

BSMs_received_here_corrected = [BSMs_received_here(:,1)/10000000 BSMs_received_here(:,2)/10000000 BSMs_received_here(:,3)]; 

% 2.geoplot

% set up new plot, clear the figure, and initialize the
fig_num = 109;
figure(fig_num);
clf;

% Plot the base station with a green star. This sets up the figure for
% the first time, including the zoom into the test track area.

h_geoplot = geoplot(40.8637, -77.8359, '*','Color',[0 1 0],'Linewidth',3,'Markersize',10);
h_parent =  get(h_geoplot,'Parent');
set(h_parent,'ZoomLevel',16.375);
try
    geobasemap satellite
catch
    geobasemap openstreetmap
end
hold on;

% plot the location of the BSM message received in a red 
geoplot(BSMs_received_here_corrected(:,1), BSMs_received_here_corrected(:,2), '.','Color',[1 0 0],'Markersize',10);

%% center_loading_RSU_05_29_2024_20ft 
% faster plotting 05/29/2024 2nd try (1 RSU in middle pole on top of ladder, OBU driving inner and outer lanes of full track)
% 1. Read the csv file with LLA

filename = '20ft.csv';
BSMs_received_here = csvread(filename, 1);

BSMs_received_here_corrected = [BSMs_received_here(:,1)/10000000 BSMs_received_here(:,2)/10000000 BSMs_received_here(:,3)]; 

% 2.geoplot

% set up new plot, clear the figure, and initialize the
fig_num = 20;
figure(fig_num);
clf;

% Plot the base station with a green star. This sets up the figure for
% the first time, including the zoom into the test track area.

h_geoplot = geoplot(40.8637, -77.8359, '*','Color',[0 1 0],'Linewidth',3,'Markersize',10);
h_parent =  get(h_geoplot,'Parent');
set(h_parent,'ZoomLevel',16.375);
try
    geobasemap satellite
catch
    geobasemap openstreetmap
end
geotickformat -dd
hold on;

% % Power pole by the detour, Height ~ 9 meters
Trace_coordinates_ENU = [
    78.71383357714284 -60.13763178116716 -10.848769161102917
    ];
Trace_coordinates_LLA =  gps_object.ENU2WGSLLA(Trace_coordinates_ENU);
geoplot(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'b*',MarkerSize=10);
text(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'Loading Dock Tower','Color','b','FontWeight','bold');

% plot the location of the BSM message received in a red 
geoplot(BSMs_received_here_corrected(:,1), BSMs_received_here_corrected(:,2), '.','Color',[0 0 1],'Markersize',10);
title('High-Lift at 20ft');
zoom(0.5);

% 30ft
filename = '30ft.csv';
BSMs_received_here = csvread(filename, 1);

BSMs_received_here_corrected = [BSMs_received_here(:,1)/10000000 BSMs_received_here(:,2)/10000000 BSMs_received_here(:,3)]; 

% 2.geoplot

% set up new plot, clear the figure, and initialize the
fig_num = 30;
figure(fig_num);
clf;

% Plot the base station with a green star. This sets up the figure for
% the first time, including the zoom into the test track area.

h_geoplot = geoplot(40.8637, -77.8359, '*','Color',[0 1 0],'Linewidth',3,'Markersize',10);
h_parent =  get(h_geoplot,'Parent');
set(h_parent,'ZoomLevel',16.375);
try
    geobasemap satellite
catch
    geobasemap openstreetmap
end
geotickformat -dd
hold on;

% % Power pole by the detour, Height ~ 9 meters
Trace_coordinates_ENU = [
    78.71383357714284 -60.13763178116716 -10.848769161102917
    ];
Trace_coordinates_LLA =  gps_object.ENU2WGSLLA(Trace_coordinates_ENU);
geoplot(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'b*',MarkerSize=10);
text(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'Loading Dock Tower','Color','b','FontWeight','bold');

% plot the location of the BSM message received in a red 
geoplot(BSMs_received_here_corrected(:,1), BSMs_received_here_corrected(:,2), '.','Color',[0 0 1],'Markersize',10);
title('High-Lift at 30ft');
zoom(0.5);

% 40ft
filename = '40ft.csv';
BSMs_received_here = csvread(filename, 1);

BSMs_received_here_corrected = [BSMs_received_here(:,1)/10000000 BSMs_received_here(:,2)/10000000 BSMs_received_here(:,3)]; 

% 2.geoplot

% set up new plot, clear the figure, and initialize the
fig_num = 40;
figure(fig_num);
clf;

% Plot the base station with a green star. This sets up the figure for
% the first time, including the zoom into the test track area.

h_geoplot = geoplot(40.8637, -77.8359, '*','Color',[0 1 0],'Linewidth',3,'Markersize',10);
h_parent =  get(h_geoplot,'Parent');
set(h_parent,'ZoomLevel',16.375);
try
    geobasemap satellite
catch
    geobasemap openstreetmap
end
geotickformat -dd
hold on;

% % Power pole by the detour, Height ~ 9 meters
Trace_coordinates_ENU = [
    78.71383357714284 -60.13763178116716 -10.848769161102917
    ];
Trace_coordinates_LLA =  gps_object.ENU2WGSLLA(Trace_coordinates_ENU);
geoplot(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'b*',MarkerSize=10);
text(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'Loading Dock Tower','Color','b','FontWeight','bold');

% plot the location of the BSM message received in a red 
geoplot(BSMs_received_here_corrected(:,1), BSMs_received_here_corrected(:,2), '.','Color',[0 0 1],'Markersize',10);
title('High-Lift at 40ft');
zoom(0.5);

%50 ft
filename = '50ft.csv';
BSMs_received_here = csvread(filename, 1);

BSMs_received_here_corrected = [BSMs_received_here(:,1)/10000000 BSMs_received_here(:,2)/10000000 BSMs_received_here(:,3)]; 

% 2.geoplot

% set up new plot, clear the figure, and initialize the
fig_num = 500;
figure(fig_num);
clf;

% Plot the base station with a green star. This sets up the figure for
% the first time, including the zoom into the test track area.

h_geoplot = geoplot(40.8637, -77.8359, '*','Color',[0 1 0],'Linewidth',3,'Markersize',10);
h_parent =  get(h_geoplot,'Parent');
set(h_parent,'ZoomLevel',16.375);
try
    geobasemap satellite
catch
    geobasemap openstreetmap
end
geotickformat -dd
hold on;

% plot the location of the BSM message received in a red 
geoplot(BSMs_received_here_corrected(:,1), BSMs_received_here_corrected(:,2), '.','Color',[0 0 1],'Markersize',10);
title('High-Lift at 50ft');
zoom(0.5);

% plotting poles

% % % Power Pole by the garage, Height ~ 8 meters
Trace_coordinates_ENU = [
    -41.54388324160499 -111.0086546354483 -12.592103434894112
    ];
Trace_coordinates_LLA =  gps_object.ENU2WGSLLA(Trace_coordinates_ENU);
geoplot(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'m*',MarkerSize=20);
text(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'1','Color','m','FontSize',20,'FontWeight','bold');

% % Pole with the time led, Height ~ 13 meters
Trace_coordinates_ENU = [
    29.746349250935626 124.74785860585521 -9.039292080071405
    ];
Trace_coordinates_LLA =  gps_object.ENU2WGSLLA(Trace_coordinates_ENU);
geoplot(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'m*',MarkerSize=20);
text(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'3','Color','m','FontSize',20,'FontWeight','bold');

% Power pole by the gas tank, Height ~ 10 meters
Trace_coordinates_ENU = [
    -21.40996058267557 -155.877934772639 -12.619945213934377
    ];
Trace_coordinates_LLA =  gps_object.ENU2WGSLLA(Trace_coordinates_ENU);
geoplot(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'m*',MarkerSize=20);
text(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'2','Color','m','FontSize',20,'FontWeight','bold');

% % Power pole by the detour, Height ~ 9 meters
Trace_coordinates_ENU = [
    78.71383357714284 -60.13763178116716 -10.848769161102917
    ];
Trace_coordinates_LLA =  gps_object.ENU2WGSLLA(Trace_coordinates_ENU);
geoplot(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'b*',MarkerSize=20);
text(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'4','Color','b','FontSize',20,'FontWeight','bold');

% % Pole by the lane test area,Height ~ 10.5 meters
Trace_coordinates_ENU = [
    261.5226068612395 0.9362222334994122 -10.041353704834773
    ];
Trace_coordinates_LLA =  gps_object.ENU2WGSLLA(Trace_coordinates_ENU);
geoplot(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'*',MarkerSize=20,Color=[0.9290 0.6940 0.1250]);
text(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'7','Color',[0.9290 0.6940 0.1250],'FontSize',20,'FontWeight','bold');

% % Pole at the crash test area - East, Height ~ 13 meters
Trace_coordinates_ENU = [
    236.28759539790076 183.8291816550618 -7.3790257131302175
];
Trace_coordinates_LLA =  gps_object.ENU2WGSLLA(Trace_coordinates_ENU);
geoplot(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'*',MarkerSize=20,Color=[0.9290 0.6940 0.1250]);
text(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'5','Color',[0.9290 0.6940 0.1250],'FontSize',20,'FontWeight','bold');
 
% % Pole at the crash test area - Middle, Height ~ 13 meters
Trace_coordinates_ENU = [
    128.68142817896114 169.2357589741786 -8.40854669915419
    ];
Trace_coordinates_LLA =  gps_object.ENU2WGSLLA(Trace_coordinates_ENU);
geoplot(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'*',MarkerSize=20,Color=[0.9290 0.6940 0.1250]);
text(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'6','Color',[0.9290 0.6940 0.1250],'FontSize',20,'FontWeight','bold');

% % Light Pole North Corner
% Trace_coordinates_ENU = [419.5481152890079 210.2952422867348 -9.173253201708432
% ]; % Height 12 meters
% Trace_coordinates_LLA =  gps_object.ENU2WGSLLA(Trace_coordinates_ENU);
% geoplot(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'*',MarkerSize=10,Color=[0.9290 0.6940 0.1250]);
% text(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'Spoke 6','Color',[0.9290 0.6940 0.1250],'FontWeight','bold');

% % Pole - white pipe
% Trace_coordinates_ENU = [241.20944407887026 -72.95601156337904 -9.364972520487274];
% Trace_coordinates_LLA =  gps_object.ENU2WGSLLA(Trace_coordinates_ENU);
% geoplot(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'y*',MarkerSize=10);
% text(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'Spoke 9','Color','y');
% 
% % Pole - opposite box
% Trace_coordinates_ENU = [
%     200.0578802380644 -46.661535005989734 -9.5033039405793
% ];
% Trace_coordinates_LLA =  gps_object.ENU2WGSLLA(Trace_coordinates_ENU);
% geoplot(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'y*',MarkerSize=10);
% text(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'Spoke 10','Color','y');

% % Pole on the grass by the storage bin
% Trace_coordinates_ENU = [382.36760523575947 109.15657120766576 -8.940380675262062
% ];
% Trace_coordinates_LLA =  gps_object.ENU2WGSLLA(Trace_coordinates_ENU);
% geoplot(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'y*',MarkerSize=10);
% text(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'Spoke 11','Color','y');
% 
% % Power box by the road
% Trace_coordinates_ENU = [ 393.94356305208527 95.94396223194781 -10.592871155655226
% ];
% Trace_coordinates_LLA =  gps_object.ENU2WGSLLA(Trace_coordinates_ENU);
% geoplot(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'y*',MarkerSize=10);
% text(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'Spoke 12','Color','y');
% 
% % Power box no lid
% Trace_coordinates_ENU = [382.1248461037517 90.26906282091701 -10.351070077201964
% ];
% Trace_coordinates_LLA =  gps_object.ENU2WGSLLA(Trace_coordinates_ENU);
% geoplot(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'y*',MarkerSize=10);
% text(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'Spoke 13','Color','y');

% Light Pole east corner
Trace_coordinates_ENU = [468.7771748930397 128.66683330454703 -8.282502229370525
];% Height 22 meters
Trace_coordinates_LLA =  gps_object.ENU2WGSLLA(Trace_coordinates_ENU);
geoplot(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'y*',MarkerSize=20);
text(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'Gateway 2','Color','y','FontSize',20,'FontWeight','bold');

% % Light pole by the bridge
% Trace_coordinates_ENU = [-111.36353729525754 21.531683473911414 -10.675007158762758
% ];% Height 12 meters
% Trace_coordinates_LLA =  gps_object.ENU2WGSLLA(Trace_coordinates_ENU);
% geoplot(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'c*',MarkerSize=10);
% text(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'Bridge Tower 30ft','Color','c','FontWeight','bold');

% % Light pole by the road
% Trace_coordinates_ENU = [-54.9088363936229 -218.70867368807137 -14.809994690085148
% ]; % Height 8 meters
% Trace_coordinates_LLA =  gps_object.ENU2WGSLLA(Trace_coordinates_ENU);
% geoplot(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'y*',MarkerSize=10);
% text(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'Spoke 17','Color','y');

% Bridge 30ft

filename = 'Bridge20ft.csv';
BSMs_received_here = csvread(filename, 1);

BSMs_received_here_corrected = [BSMs_received_here(:,1)/10000000 BSMs_received_here(:,2)/10000000 BSMs_received_here(:,3)]; 

% 2.geoplot

% set up new plot, clear the figure, and initialize the
fig_num = 500;
figure(fig_num);
% clf;

% Plot the base station with a green star. This sets up the figure for
% the first time, including the zoom into the test track area.

%h_geoplot = geoplot(40.8637, -77.8359, '*','Color',[0 1 0],'Linewidth',3,'Markersize',10);
h_parent =  get(h_geoplot,'Parent');
set(h_parent,'ZoomLevel',16.375);
try
    geobasemap satellite
catch
    geobasemap openstreetmap
end
hold on;

% plot the location of the BSM message received in a red 
geoplot(BSMs_received_here_corrected(:,1), BSMs_received_here_corrected(:,2), '.','Color',[0 1 1],'Markersize',10);
title('RSU at Bridge Area North Side of Track at 30ft above ground');

% RSU at Pendulum 50ft

filename = 'Pendulum50ft.csv';
BSMs_received_here = csvread(filename, 1);

BSMs_received_here_corrected = [BSMs_received_here(:,1)/10000000 BSMs_received_here(:,2)/10000000 BSMs_received_here(:,3)]; 

% 2.geoplot

% set up new plot, clear the figure, and initialize the
fig_num = 500;
figure(fig_num);
%clf;

% Plot the base station with a green star. This sets up the figure for
% the first time, including the zoom into the test track area.

%h_geoplot = geoplot(40.8637, -77.8359, '*','Color',[0 1 0],'Linewidth',3,'Markersize',10);
h_parent =  get(h_geoplot,'Parent');
set(h_parent,'ZoomLevel',16.375);
try
    geobasemap satellite
catch
    geobasemap openstreetmap
end
hold on;

% plot the location of the BSM message received in a red 
geoplot(BSMs_received_here_corrected(:,1), BSMs_received_here_corrected(:,2), '.','Color',[1 1 0],'Markersize',10);
legend(["Base Station", "Loading Dock Tower RSU Test","1-Spoke at Garage","2-Spoke at Gas Tank","3-Spoke at End of Crash Test Area","4-Spoke at Loading Dock","5-Spoke at Start of Crash Test Area","6-Spoke at Middle of Crash Test Area","7-Spoke at Middle of South Straight Rail","Gateway-2 for the East Side of Track (Controls Sopkes 5-7)","Pendulum RSU Test"],Location="northeast")
title('Placement of Towers for Gateways and Hubs');

%% RSU at Pendulum

filename = 'Penduluy*csv';
BSMs_received_here = csvread(filename, 1);

BSMs_received_here_corrected = [BSMs_received_here(:,1)/10000000 BSMs_received_here(:,2)/10000000 BSMs_received_here(:,3)]; 

% 2.geoplot

% set up new plot, clear the figure, and initialize the
fig_num = 500;
figure(fig_num);
%clf;

% Plot the base station with a green star. This sets up the figure for
% the first time, including the zoom into the test track area.

h_geoplot = geoplot(40.8637, -77.8359, '*','Color',[0 1 0],'Linewidth',3,'Markersize',10);
h_parent =  get(h_geoplot,'Parent');
set(h_parent,'ZoomLevel',16.375);
try
    geobasemap satellite
catch
    geobasemap openstreetmap
end
hold on;

% plot the location of the BSM message received in a red 
geoplot(BSMs_received_here_corrected(:,1), BSMs_received_here_corrected(:,2), '.','Color',[0 1 0],'Markersize',10);
title('RSU at Pendulum Area on Track');

%% RSU at Bridge

filename = 'end bridge.csv';
BSMs_received_here = csvread(filename, 1);

BSMs_received_here_corrected = [BSMs_received_here(:,1)/10000000 BSMs_received_here(:,2)/10000000 BSMs_received_here(:,3)]; 

% 2.geoplot

% set up new plot, clear the figure, and initialize the
fig_num = 500;
figure(fig_num);
% clf;

% Plot the base station with a green star. This sets up the figure for
% the first time, including the zoom into the test track area.

h_geoplot = geoplot(40.8637, -77.8359, '*','Color',[0 1 0],'Linewidth',3,'Markersize',10);
h_parent =  get(h_geoplot,'Parent');
set(h_parent,'ZoomLevel',16.375);
try
    geobasemap satellite
catch
    geobasemap openstreetmap
end
hold on;

% plot the location of the BSM message received in a red 
geoplot(BSMs_received_here_corrected(:,1), BSMs_received_here_corrected(:,2), '.','Color',[0 1 1],'Markersize',10);
title('RSU at Bridge Area North Side of Track');

%% Notes

% avoid plotting in red unless it is a problem
% use blue instead for plotting
% have a boundry to the regions
% plot the towers, make it the same color but different shade as the BSM points(dark green
% and light green)
% 
% if we are getting continuous data (10Hz), then from the tower, the slice
% from point 1 i.e tower to point 2 i.e OBU location is covered. So the
% whole slice has coverage
% so if we create a toll that checks if data is continuous, then we can
% define boundary edges to be placed for the wedge.
% so a wedge should have atleast 3 points that are continuous
% no wedges for dis-continuous points

% plot steps
% 1. find wedges
% 2. plot Wedge

% max range plot (for each angle, find the maximum radius that we can
% detect from the data collected in one test)

% steps
% 0. assign color to each tower
% 1. plot the towers
% 2. plot data for each tower in same color but diffrent shade (make it the same color but different shade as the BSM points(dark green
% and light green))
% 3. check if data is continuous for each region of tower (will need time
% for checking this)
% 4. plot wedges for continuous data and only dots for discontinuous data

% change x and y axis from deg-min to decimals
%% Bridge 30ft

filename = 'Bridge20ft.csv';
BSMs_received_here = csvread(filename, 1); %#ok<*CSVRD> 

BSMs_received_here_corrected = [BSMs_received_here(:,1)/10000000 BSMs_received_here(:,2)/10000000 BSMs_received_here(:,3)]; 

% 2.geoplot

% set up new plot, clear the figure, and initialize the
fig_num = 500;
figure(fig_num);
% clf;

% Plot the base station with a green star. This sets up the figure for
% the first time, including the zoom into the test track area.

%h_geoplot = geoplot(40.8637, -77.8359, '*','Color',[0 1 0],'Linewidth',3,'Markersize',10);
h_parent =  get(h_geoplot,'Parent');
set(h_parent,'ZoomLevel',16.375);
try
    geobasemap satellite
catch
    geobasemap openstreetmap
end
hold on;

% plot the location of the BSM message received in a red 
geoplot(BSMs_received_here_corrected(:,1), BSMs_received_here_corrected(:,2), '.','Color',[0 1 1],'Markersize',10);
title('RSU at Bridge Area North Side of Track at 30ft above ground');

%% RSU at Pendulum 50ft

filename = 'Pendulum50ft.csv';
BSMs_received_here = csvread(filename, 1);

BSMs_received_here_corrected = [BSMs_received_here(:,1)/10000000 BSMs_received_here(:,2)/10000000 BSMs_received_here(:,3)]; 

% 2.geoplot

% set up new plot, clear the figure, and initialize the
fig_num = 500;
figure(fig_num);
%clf;

% Plot the base station with a green star. This sets up the figure for
% the first time, including the zoom into the test track area.

%h_geoplot = geoplot(40.8637, -77.8359, '*','Color',[0 1 0],'Linewidth',3,'Markersize',10);
h_parent =  get(h_geoplot,'Parent');
set(h_parent,'ZoomLevel',16.375);
try
    geobasemap satellite
catch
    geobasemap openstreetmap
end
hold on;

% plot the location of the BSM message received in a red 
geoplot(BSMs_received_here_corrected(:,1), BSMs_received_here_corrected(:,2), '.','Color',[1 1 0],'Markersize',10);
legend(["Base Station", "Loading Dock Tower RSU Test","Loading Dock Tower","Pendulum Tower","Bridge Tower 30ft","Bridge Tower RSU Test","Pendulum Tower RSU Test"],Location="northeast")
title('RSU at Pendulum Area on Track 50ft above ground');
