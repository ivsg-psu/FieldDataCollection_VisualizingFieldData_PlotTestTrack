%% script_test_fcn_PlotTestTrack_plotTraceENU.m
% This is a script to exercise the function: fcn_PlotTestTrack_plotTraceENU.m
% This function was written on 2023_07_20 by S. Brennan, sbrennan@psu.edu


% Revision history:
% 2023_07_20
% -- first write of the code


%% Fill in data for testing
% Load the first marker cluster - call it by name
ENU_positions_cell_array{1} = 1.0e+02 *[

-0.681049494040000  -1.444101004200000   0.225959982543000
-0.635840916402000  -1.480360972130000   0.225959615156000
-0.591458020164000  -1.513620272760000   0.225949259327000
-0.526826099435000  -1.557355626820000   0.226468769561000
-0.455230413850000  -1.601954836740000   0.226828212563000
-0.378844266810000  -1.644026018910000   0.227087638509000
-0.302039949257000  -1.680678797970000   0.227207090339000
-0.217481846757000  -1.715315663660000   0.227336509752000
-0.141767378277000  -1.742610853740000   0.227585981357000
-0.096035753167200  -1.756950994360000   0.227825672033000
];

ENU_positions_cell_array{2} = 1.0e+02 *[

-0.096035753167200  -1.756950994360000   0.227825672033000
-0.046217812938600  -1.771005260420000   0.227995337636000
0.025700956316500  -1.787638230440000   0.228144884542000
0.098357974826600  -1.800501473440000   0.228144450639000
0.177152561887000  -1.810690305340000   0.228123991965000
0.273236198681000  -1.817654871680000   0.228263454451000
0.364501910235000  -1.819114777210000   0.228492957384000
0.478769749755000  -1.813569236680000   0.228312361316000
0.578252405450000  -1.801635770890000   0.228621877252000
0.673410108325000  -1.783910295550000   0.228621444283000
0.781523906444000  -1.756930070190000   0.228470963597000
0.889917048000000  -1.721948466680000   0.228650501826000
0.992406509804000  -1.681063720990000   0.228310085456000
1.103055017650000  -1.628270864690000   0.228849643172000
1.239723948340000  -1.548705836180000   0.229439122979000
1.339251709010000  -1.483153008740000   0.230088675427000
];

ENU_positions_cell_array{3} = 1.0e+02 *[

   1.339251709010000  -1.483153008740000   0.230088675427000
   1.390220496380000  -1.447536755330000   0.230688406825000
   1.500649039670000  -1.366687645210000   0.231947695749000
   1.619936232260000  -1.276276969780000   0.232946659694000
   1.658497814730000  -1.246290733430000   0.232756264199000
   1.726179576070000  -1.194134129080000   0.233285471766000
   1.794279852100000  -1.141732303180000   0.233674556691000
   1.843697046830000  -1.103673506040000   0.233793821086000
   1.910881897570000  -1.051369238160000   0.233222732062000
   1.977969375100000  -1.000036991350000   0.234591516738000
   2.068718586050000  -0.930372260841000   0.234979699947000
   2.156970005120000  -0.862078062070000   0.235407742313000
   2.250276408100000  -0.790321941946000   0.235655454741000
   2.325942215980000  -0.732634183262000   0.235873435191000
   2.399021146270000  -0.676636598005000   0.236361352612000
   2.474931357600000  -0.618332934789000   0.236659049556000
   2.549576311420000  -0.561057731254000   0.236856644300000
   2.619865592130000  -0.506750602539000   0.237104255992000
   2.678747493610000  -0.461078483932000   0.237282161108000
   2.733351558350000  -0.418913036557000   0.237370139513000
   2.817368600250000  -0.354774607364000   0.237136878544000
   2.890132472030000  -0.298398935810000   0.238023917403000
   2.958342902630000  -0.245730396869000   0.238551020311000
   3.022800229050000  -0.195952921879000   0.238668175184000
   3.090309635410000  -0.143496389415000   0.239285083890000
   3.154853774550000  -0.093981341725300   0.239102022359000
   3.228508266550000  -0.037237819080300   0.239008399590000
   3.294531008890000   0.013364746657600   0.239325038737000
   3.347855324030000   0.054476705490200   0.239382243889000
   3.410794169220000   0.102364292519000   0.240278855067000
   3.489861812030000   0.162838824587000   0.240064458640000
   3.560042302360000   0.216146186620000   0.240130428855000
   3.638139977820000   0.275334615114000   0.240585802681000
   3.721450737040000   0.339180331666000   0.240930689915000
   3.809597399650000   0.406379169292000   0.241165100709000
   3.900050945570000   0.475638580737000   0.241129163056000
   3.982613892930000   0.538223979629000   0.241263570378000
   4.061187445720000   0.599298131740000   0.241768075210000
];

ENU_positions_cell_array{4} = 1.0e+02 *[
   
   4.061187445720000   0.599298131740000   0.241768075210000
   4.151958465970000   0.672552042441000   0.241971507236000
   4.240694971640000   0.751542411688000   0.242794794590000
   4.312200354840000   0.825206523025000   0.242829094571000
   4.373338107310000   0.895670512718000   0.243033985961000
   4.437267496340000   0.980974659389000   0.243898317745000
   4.498262514620000   1.079682605530000   0.245192453662000
   4.548525556310000   1.193543635030000   0.246706860636000
   4.577024497810000   1.296471982690000   0.248232811363000
   4.592437993220000   1.394261623260000   0.249939637162000
   4.598790818700000   1.506113691290000   0.250706630741000 
];

ENU_positions_cell_array{5} =  1.0e+02 *[
   4.598790818700000   1.506113691290000   0.250706630741000
   4.596661110239999   1.568128878250000   0.251335285541000
   4.583246426620000   1.675270749070000   0.252583519421000
   4.561186217190000   1.769497222660000   0.253722548098000
   4.525806593920000   1.867642539130000   0.254812259350000
   4.485891020010000   1.948186043530000   0.255902659702000
   4.420143114050000   2.050532875340000   0.257284028077000];



% Save the matrix to a .mat file with the given filename
save('ExampleArray.mat','ENU_positions_cell_array');

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
% function only plots, has no outputs

%% BASIC example 1 - showing plot of entire cell array
% Load the first marker cluster - call it by name
fig_num = 1;
plot_color = [];
line_width = [];
flag_plot_headers_and_tailers = [];
flag_plot_points = [];
% load from data
Array = load("Data\ExampleArray.mat","ENU_positions_cell_array");
ENU_positions_cell_array = Array.ENU_positions_cell_array;
% Plot LLA cell array
fcn_PlotTestTrack_plotTraceENU(ENU_positions_cell_array, plot_color, line_width, flag_plot_headers_and_tailers,flag_plot_points, fig_num);

title(sprintf('Fig %.0d: showing plot of entire cell array in ENU',fig_num), 'Interpreter','none');


%% BASIC example 2 - showing plot of entire cell arra
% Load the first marker cluster - call it by name
fig_num = 2;
plot_color = [];
line_width = [];
flag_plot_headers_and_tailers = [];
flag_plot_points = [];
% Plot ENU results by each cell
Array = load("Data\ExampleArray.mat","ENU_positions_cell_array");
ENU_positions_cell_array = Array.ENU_positions_cell_array;
for ith_data = 1:length(ENU_positions_cell_array)
    ENU_data_to_plot = ENU_positions_cell_array{ith_data};
    fcn_PlotTestTrack_plotTraceENU(ENU_data_to_plot, plot_color, line_width, flag_plot_headers_and_tailers,flag_plot_points, fig_num);
end

title(sprintf('Fig %.0d: showing plot of entire cell array in ENU',fig_num),'Interpreter','none');

%% BASIC example 3 - showing plot_color
% Load the first marker cluster - call it by name
fig_num = 3;
plot_color = [0 0 1];
line_width = 5;
flag_plot_headers_and_tailers = 0;
flag_plot_points = [];
Array = load("Data\ExampleArray.mat","ENU_positions_cell_array");
ENU_positions_cell_array = Array.ENU_positions_cell_array;
% Plot ENU cell array
fcn_PlotTestTrack_plotTraceENU(ENU_positions_cell_array, plot_color, line_width, flag_plot_headers_and_tailers,flag_plot_points, fig_num);

title(sprintf('Fig %.0d: showing plot_color',fig_num), 'Interpreter','none');

%% BASIC example 4 - showing flag_plot_headers_and_tailers, otherwise same as Ex 3
% Load the first marker cluster - call it by name
fig_num = 4;
plot_color = [0 0 1];
line_width = 5;
flag_plot_headers_and_tailers = 0;
flag_plot_points = [];
Array = load("Data\ExampleArray.mat","ENU_positions_cell_array");
ENU_positions_cell_array = Array.ENU_positions_cell_array;
% Plot ENU cell array
fcn_PlotTestTrack_plotTraceENU(ENU_positions_cell_array, plot_color, line_width, flag_plot_headers_and_tailers,flag_plot_points, fig_num);

title(sprintf('Fig %.0d: showing flag_plot_headers_and_tailers',fig_num), 'Interpreter','none');


%% testing speed of function

% load inputs
plot_color = [];
line_width = [];
flag_plot_headers_and_tailers = [];
flag_plot_points = [];
% load from data
Array = load("Data\ExampleArray.mat","ENU_positions_cell_array");
ENU_positions_cell_array = Array.ENU_positions_cell_array;

% Speed Test Calculation
fig_num=[];
REPS=5; minTimeSlow=Inf;
tic;
%slow mode calculation - code copied from plotVehicleXYZ
for i=1:REPS
tstart=tic;
fcn_PlotTestTrack_plotTraceENU(ENU_positions_cell_array, plot_color, line_width, flag_plot_headers_and_tailers,flag_plot_points, fig_num);
telapsed=toc(tstart);
minTimeSlow=min(telapsed,minTimeSlow);
end
averageTimeSlow=toc/REPS;
%slow mode END
%Fast Mode Calculation
fig_num = -1;
minTimeFast = Inf;
tic;
for i=1:REPS
tstart = tic;
fcn_PlotTestTrack_plotTraceENU(ENU_positions_cell_array, plot_color, line_width, flag_plot_headers_and_tailers,flag_plot_points, fig_num);
telapsed = toc(tstart);
minTimeFast = min(telapsed,minTimeFast);
end
averageTimeFast = toc/REPS;
%Display Console Comparison
if 1==1
fprintf(1,'\n\nComparison of fcn_PlotTestTrack_plotTraceENU without speed setting (slow) and with speed setting (fast):\n');
fprintf(1,'N repetitions: %.0d\n',REPS);
fprintf(1,'Slow mode average speed per call (seconds): %.5f\n',averageTimeSlow);
fprintf(1,'Slow mode fastest speed over all calls (seconds): %.5f\n',minTimeSlow);
fprintf(1,'Fast mode average speed per call (seconds): %.5f\n',averageTimeFast);
fprintf(1,'Fast mode fastest speed over all calls (seconds): %.5f\n',minTimeFast);
fprintf(1,'Average ratio of fast mode to slow mode (unitless): %.3f\n',averageTimeSlow/averageTimeFast);
fprintf(1,'Fastest ratio of fast mode to slow mode (unitless): %.3f\n',minTimeSlow/minTimeFast);
end
%Assertion on averageTime NOTE: Due to the variance, there is a chance that
%the assertion will fail.
assert(averageTimeFast<averageTimeSlow);