<a id="readme-top"></a>
<br />

<h3 align="center">FieldDataCollection_VisualizingFieldData_PlotTestTrack</h3>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
        <a href="#installation">Installation</a>
    </li>
    <li>
        <a href="#directories">Directories</a>
    </li>
    <li>
        <a href="#functions">Functions</a>
        <ul>
        <li><a href="#fcn_plottesttrack_animateavlane">fcn_PlotTestTrack_animateAVLane</a></li>
        <li><a href="#fcn_plottesttrack_breakarraybynans">fcn_PlotTestTrack_breakArrayByNans</a></li>
        <li><a href="#fcn_plottesttrack_calculatelanelines">fcn_PlotTestTrack_calculateLaneLines</a></li>
        <li><a href="#fcn_plottesttrack_circlecenterfromthreepoints">fcn_PlotTestTrack_circleCenterFromThreePoints</a></li>
        <li><a href="#fcn_plottesttrack_convertsttoxy">fcn_PlotTestTrack_convertSTtoXY</a></li>
        <li><a href="#fcn_plottesttrack_convertxytost">fcn_PlotTestTrack_convertXYtoST</a></li>
        <li><a href="#fcn_plottesttrack_geoplotdata">fcn_PlotTestTrack_geoPlotData</a></li>
        <li><a href="#fcn_plottesttrack_plotbsmfromobutorsu">fcn_PlotTestTrack_plotBSMfromOBUtoRSU</a></li>
        <li><a href="#fcn_plottesttrack_plotlaneboundingbox">fcn_PlotTestTrack_plotLaneBoundingBox</a></li>
        <li><a href="#fcn_plottesttrack_plotpointsanywhere">fcn_PlotTestTrack_plotPointsAnywhere</a></li>
        <li><a href="#fcn_plottesttrack_plotpointscolormap">fcn_PlotTestTrack_plotPointsColorMap</a></li>
        <li><a href="#fcn_plottesttrack_plotspeedofav">fcn_PlotTestTrack_plotSpeedofAV</a></li>
        <li><a href="#fcn_plottesttrack_plotspeedvsstation">fcn_PlotTestTrack_plotSpeedvsStation</a></li>
        <li><a href="#fcn_plottesttrack_plottraceenu">fcn_PlotTestTrack_plotTraceENU</a></li>
        <li><a href="#fcn_plottesttrack_plottracella">fcn_PlotTestTrack_plotTraceLLA</a></li>
        <li><a href="#fcn_plottesttrack_plottraces">fcn_PlotTestTrack_plotTraces</a></li>
        <li><a href="#fcn_plottesttrack_rangersu_circle">fcn_PlotTestTrack_rangeRSU_circle</a></li> 
        </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

Library of MATLAB functions related to visualizing data collected from various tests involving geographic coordinates, time, and more.


<p align="right">(<a href="#readme-top">back to top</a>)</p>


### Installation

1. Make sure to run MATLAB 2020b or higher. Why? The "digitspattern" command used in the DebugTools utilities was released late 2020 and this is used heavily in the Debug routines. If debugging is shut off, then earlier MATLAB versions will likely work, and this has been tested back to 2018 releases.

2. Clone the repo

   ```sh
   git clone https://github.com/ivsg-psu/FieldDataCollection_VisualizingFieldData_PlotTestTrack/commits/main/
   ```
3. Run the main code in the root of the folder (script_demo_plotTestTrack.m). This will download the required utilities for this code, unzip the zip files into a Utilities folder (.\Utilities), and update the MATLAB path to include the Utility locations. This install process will only occur the first time. Note: to force the install to occur again, delete the Utilities directory

4. Confirm it works! Run script_demo_plotTestTrack. If the code works, the script should run without errors. This script produces numerous example images such as those in this README file.

<a href="#pathplanning_geomtools_geomclasslibrary">Back to top</a>
   

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Directories

The following are the top level directories within the repository:
<ul>
 <li>Functions folder: Contains all functions and their test scripts.</li>
 <li>Utilities: Dependencies that are utilized but not implemented in this repository are placed in the Utilities directory. These can be single files but are most often other cloned repositories.</li>
</ul>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Functions


#### **fcn_plotTestTrack_animateAVLane**

 Creates animated plot of latitude, longitude coordinates with respect
 to time and a boundary line after displacement, also get the XY
 coordinates of the boundaries

 **FORMAT:**

    [ENU_LeftLaneX, ENU_LeftLaneY, ENU_RightLaneX, ENU_RightLaneY]
    = fcn_PlotTestTrack_animateAVLane(csvFile,car_length,car_width,
    (fig_num,baseLat,baseLon,left_color,right_color,AV_color))

**MANDATORY INPUTS**

    csvFile: The name of the .csv file that contains the latitude,
                longitude, altitude, and time of the location
                at which the OBU sent out the BSM message to the RSU
                that was in range. The code assumes latitude in first
                column, longitude in second, altitude in third, and
                time in fourth.
    car_length: The length of car (The unit have to be in Feet)

    car_width: Thewidth of car (The unit have to be in Feet)

**OPTIONAL INPUTS**
    baseLat: Latitude of the base location. Default is 40.8637.

    baseLon: Longitude of the base location. Default is -77.8359.

    baseAlt: Altitude of the base location. Default is [].

    left_color: color of the left lane boundary

    right_color: color of the right lane boundary

    AV_color: color of the AV

    name_of_movfile: string that will be the name of the output
    animation file. If a string is not supplied, the video will not 
    be saved

    path_to_save_video: the filepath that specifies where the 
    video  should be saved. Recommended to save in the Data Folder 
    of the repo.


    fig_num: figure number


 **OUTPUTS:**

    [LeftLaneX, LeftLaneY, RightLaneX, RightLaneY]: 
        XY coordinates of the left and right lane boundaries

 **DEPENDENCIES:**

    (none)

 **EXAMPLES:**

    csvFile = 'Test Track1.csv'; % Path to your CSV file

    baseLat = [];
    baseLon = [];
    baseAlt = []; 
    fig_num = [];
    car_width = 6; 
    car_length = 14;
    left_color = [];
    right_color = [];
    AV_color = [];
    name_of_movfile = 'TestTrack1';
    path_to_save_video = '.\Data';
    [ENU_LeftLaneX, ENU_LeftLaneY, ENU_RightLaneX, ENU_RightLaneY] ...'
        = fcn_PlotTestTrack_animateAVLane(csvFile,car_length,car_width, ...
        baseLat,baseLon,baseAlt,left_color,right_color,AV_color,name_of_movfile,path_to_save_video,fig_num);
<pre align="center">
  <img src=".\Images\animateav.jpg" alt="fcn_geometry_plotSphere picture" width="500" height="400">
  <figcaption></figcaption>
</pre>

    See the script:
    script_test_fcn_PlotTestTrack_animateAVLane.m

<p align="right">(<a href="#readme-top">back to top</a>)</p>



#### **fcn_plotTestTrack_breakArrayByNans**

Finds sections of nan, and breaks indicies into segments of non-nan data, returning indicies of each segment

 **FORMAT:**

    indicies_cell_array = fcn_PlotTestTrack_breakArrayByNans(input_array)


**MANDATORY INPUTS**

    input_array: a matrix where some rows contain NaN values

**OPTIONAL INPUTS**
    
    (none)

**OUTPUTS:**

    indicies_cell_array: a cell array of indicies, one array for 
    each section of the matrix that is separated by NaN values


**DEPENDENCIES:**

    (none)

**EXAMPLES:**

    %% Basic test case - no Nans
    test_data = rand(10,2);
    indicies_cell_array = fcn_PlotTestTrack_breakArrayByNans(test_data);
    assert(isequal(indicies_cell_array{1},(1:10)'));

    %% Basic test case - all Nans
    test_data = nan(10,2);
    indicies_cell_array = fcn_PlotTestTrack_breakArrayByNans(test_data);
    assert(isequal(indicies_cell_array{1},[]));

    See the script:
    script_test_fcn_PlotTestTrack_breakArrayByNans.m

<p align="right">(<a href="#readme-top">back to top</a>)</p>



#### **fcn_plotTestTrack_calculateLaneLines**

Returns the left lane, right lane, and center of lane coordinates in ENU format

 **FORMAT:**

    [ENU_LeftLaneX, ENU_LeftLaneY, ENU_RightLaneX, 
    ENU_RightLaneY, ENU_LaneCenterX, ENU_LaneCenterY] = 
    fcn_PlotTestTrack_calculateLaneLines(csvFile,(baseLat,baseLon,
    baseAlt, laneWidth))



**MANDATORY INPUTS**

    csvFile: The name of the .csv file that contains the latitude, 
    longitude, altitude, and time of the location at which the OBU 
    sent out the BSM message to the RSU that was in range. The 
    code assumes latitude in first column, longitude in second, 
    altitude in third, and time in fourth. 


**OPTIONAL INPUTS**
    
    baseLat: Latitude of the base location. Default is 40.8637.

    baseLon: Longitude of the base location. Default is -77.8359.

    baseAlt: Altitude of the base location. Default is []. 

    laneWidth: Width of lane in meters. Default is 3.6.

**OUTPUTS:**

    [LeftLaneX, LeftLaneY, RightLaneX, RightLaneY, CenterLaneX, 
    CenterLaneY]: XY coordinates of the left and right lane 
    boundaries


**DEPENDENCIES:**

    (none)

**EXAMPLES:**

    csvFile = 'Pittsburgh_2_11_07_2024.csv'; % Path to your CSV file

    % base station in pittsburg
    reference_latitude_pitts = 40.44181017;
    reference_longitude_pitts = -79.76090840;
    reference_altitude_pitts = 327.428;

    baseLat = reference_latitude_pitts;
    baseLon = reference_longitude_pitts;
    baseAlt = reference_altitude_pitts;
    laneWidth = [];
        [ENU_LeftLaneX, ENU_LeftLaneY, ENU_RightLaneX, ENU_RightLaneY, ENU_LaneCenterX, ENU_LaneCenterY]...
        = fcn_PlotTestTrack_calculateLaneLines(csvFile,baseLat,baseLon,baseAlt, laneWidth);

    assert(length(ENU_LeftLaneX) == 5988)
    assert(length(ENU_LeftLaneY) == 5988)
    assert(length(ENU_RightLaneX) == 5988)
    assert(length(ENU_RightLaneY) == 5988)
    assert(length(ENU_LaneCenterX) == 5988)
    assert(length(ENU_LaneCenterY) == 5988)

    See the script:
    script_test_fcn_PlotTestTrack_calculateLaneLines.m
    for a full test suite.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


#### **fcn_plotTestTrack_circleCenterFromThreePoints**

 Calculates the center of a circle from three points given as vectors in x and y

 **FORMAT:**

    [xc,yc,radii] = fcn_circleCenterFromThreePoints(x,y,(fig_num))



**MANDATORY INPUTS**

    x: a Nx1 vector where N is at least 3. If N = 1, a circle will 
    be fit between these threee points, if N = 4 or more, then one 
    circle will be fit to the first three points, another cicle to 
    the next three points, etc.

    y: same dimension as x, but representing the y-coordinate of 
    the points 


**OPTIONAL INPUTS**
    
    fig_num: a figure number if plot results are desired

**OUTPUTS:**

    xc: the x-coordinate of the centers of the circles, as an 
    [(N-2)x1] vector
    
    yc: the y-coordinate of the centers of the circles, as an 
    [(N-2)x1] vector
      
    radii: the radius of each the circles, as an 
    [(N-2)x1]  vector


**DEPENDENCIES:**

    (none)

**EXAMPLES:**

    %% Example 1
    x = [0; 0.5; 1; 4; 6; 7; 9; 11; 15];
    y = [0; 4;  -1;-3; 2; -1;3;  3; -0.5];
    fcn_circleCenterFromThreePoints(x,y,1);
    plot(x,y,'r-');
    hold on
    figure(1); clf;
    for i=1:length(x)-2
        fcn_circleCenterFromThreePoints(x(i:i+2),y(i:i+2),1);
        plot(x,y,'g-');
        %pause;
    end

<pre align="center">
  <img src=".\Images\circlecenter.jpg" alt="fcn_geometry_plotSphere picture" width="500" height="400">
  <figcaption></figcaption>
</pre>

    See the script:
    script_test_fcn_PlotTestTrack_calculateLaneLines.m

<p align="right">(<a href="#readme-top">back to top</a>)</p>

#### **fcn_plotTestTrack_convertSTtoXY**

Takes ST_points that are [station, transverse] in ENU coordinates and uses them as an input to give the  xEast and yNorth points 

 **FORMAT:**

    ENU_points = 
    fcn_PlotTestTrack_convertSTtoXY(ST_points,v_unit,fig_num)



**MANDATORY INPUTS**

    ST_points : [station, transverse] ENU coordinates in 
    [Nx2] format

    v_unit: unit vector in direction of travel 


**OPTIONAL INPUTS**
    
    fig_num: a figure number to plot result

**OUTPUTS:**

    ENU_points : [xEast, yNorth] X and Y ENU coordinates in 
    [Nx2] format


**DEPENDENCIES:**

    (none)

**EXAMPLES:**

    % very simple points : [2,2]

    v_bar = [1 1]; % 45 degree line segment
    v_bar_magnitude = sum((v_bar).^2,2).^0.5;
    v_unit = v_bar/v_bar_magnitude;

    ENU_points = [2,2];
    fig_num = 1001;
    ST_points = fcn_PlotTestTrack_convertXYtoST(ENU_points,v_unit,fig_num);
    assert(length(ST_points)==2)

    See the script:
    script_test_fcn_PlotTestTrack_convertSTtoXY.m

<p align="right">(<a href="#readme-top">back to top</a>)</p>



#### **fcn_plotTestTrack_convertXYtoST**

Takes xEast and yNorth points in the ENU coordinates and used them as an input to give the station (distance from origin in the direction of travel) and transverse (distance from origin in the orthogonal direction) 


 **FORMAT:**

    ST_points = 
    fcn_PlotTestTrack_convertSTtoXY(ENU_points,v_unit,fig_num)



**MANDATORY INPUTS**

    ENU_points : [xEast, yNorth] X and Y ENU coordinates in 
    [Nx2] format

    v_unit: unit vector in direction of travel 


**OPTIONAL INPUTS**
    
    fig_num: a figure number to plot result

**OUTPUTS:**

    ST_points : [station, transverse] ENU coordinates in 
    [Nx2] format

**DEPENDENCIES:**

    (none)

**EXAMPLES:**

    % very simple points : [2,2]

    v_bar = [1 1]; % 45 degree line segment
    v_bar_magnitude = sum((v_bar).^2,2).^0.5;
    v_unit = v_bar/v_bar_magnitude;


    ENU_points = [2,2];
    fig_num = 1001;
    ST_points = fcn_PlotTestTrack_convertXYtoST(ENU_points,v_unit,fig_num);
    assert(abs(ST_points(:,1)- 2*2^0.5)<1E-10);
    assert(isequal(ST_points(:,2),0));

    See the script:
    script_test_fcn_PlotTestTrack_convertXYtoST.m

<p align="right">(<a href="#readme-top">back to top</a>)</p>




#### **fcn_plotTestTrack_geoPlotData**

Plots data from an array one by one, created to plot data arrays for scenarios, using the "geoplot" command. If the user gives no data to plot, then the function initializes the figure.

 **FORMAT:**

    fcn_PlotTestTrack_geoPlotData((data_array),(color),(text),(fig_num))

**MANDATORY INPUTS**

    data_array: an optional data array to plot. Data is assumed to 
            be of the form: Nx3 array with each row containing:
            [Latitude Longitude Altitude]

**OPTIONAL INPUTS**

    color: an optional color to plot. Default is yellow ([1 1 0]).

    text: an optional text to add to the plot. 

    fig_num: a figure number to plot result

**OUTPUTS:**

    (none)

**DEPENDENCIES:**

    (none)

**EXAMPLES:**

    % call the function with empty inputs, but with a figure number,
    % and it should create the plot with
    % the focus on the test track, satellite view
    % fcn_PlotTestTrack_geoPlotData((data_array),(color),(text),(fig_num))
    data_array = []; % Make it empty to NOT plot data
    plot_color = []; % Make it empty to use default
    plot_text = ''; % Make it empty to NOT put text on
    fig_num = 222; % Give a figure number to make it plot it the figure
    fcn_PlotTestTrack_geoPlotData(data_array,plot_color,plot_text,fig_num);
<pre align="center">
  <img src=".\Images\geoplot.jpg" alt="fcn_geometry_plotSphere picture" width="500" height="400">
  <figcaption></figcaption>
</pre>
    See the script:
    script_test_fcn_PlotTestTrack_geoPlotData.m

<p align="right">(<a href="#readme-top">back to top</a>)</p>



#### **fcn_plotTestTrack_plotBSMfromOBUtoRSU**

Creates a plot of entered traces in either LLA, ENU, or STH-linear formats.

 **FORMAT:**

    [LLA_BSM_coordinates, ENU_BSM_coordinates,... 
    STH_BSM_coordinates] = 
    fcn_PlotTestTrack_plotBSMfromOBUtoRSU(csv_filenames,...
    (flag_plot_spokes,flag_plot_hubs,flag_plot_LLA,...
    flag_plot_ENU,flag_plot_STH,plot_color,fig_num))

**MANDATORY INPUTS**

    csvFile: The name of the .csv file that contains the latitude, 
            longitude, altitude, and time of the location at which 
            the OBU sent out the BSM message to the RSU that was 
            in range. The code assumes latitude in first column, 
            longitude in second, altitude in third, and time in 
            fourth. 

**OPTIONAL INPUTS**

    flag_plot_spokes: true of false for plotting the Spokes 
                    (towers on the test track that will hold one 
                    RSU, one Wave-Long Range and one computer box 
                    along with the Camera and LIDAR sensor. Values 
                    of 1 or 0 for true and false respectively.
                    Default is 1.

    flag_plot_hubs: true of false for plotting the Gateways 
                    (towers on the test track that will hold one 
                    RSU, 4 Wave Micros and one computer box, may 
                    or may not have the Camera and LIDAR sensor.
                    Values of 1 or 0 for true and false respectively.
                    Default is 1.

    flag_plot_LLA: true (1) or false (0) to plot in LLA. 
                   Default is 1.

    flag_plot_ENU: true (1) or false (0) to plot in ENU. 
                   Default is 1

    flag_plot_STH: true (1) or false (0) to plot in STH. 
                   Default is 1.

    plot_color: a color specifier such as [1 0 0] or 'r' indicating
                what color the traces should be plotted

    fig_num: figure numer for the plot, in case of ENU or STH being
             plotted in addition to the LLA plot, the figue number 
             will just be LLA figure number +1 or LLA figure 
             number + 2. 
             Default figure number is 100.

**OUTPUTS:**

    LLA_BSM_coordinates: Array of LLA coordinates of BSM locations

    ENU_BSM_coordinates: Array of ENU coordinates of BSM locations

    STH_BSM_coordinates: Array of STH coordinates of BSM locations


**DEPENDENCIES:**

    (none)

**EXAMPLES:**

    %% Basic example 1 - RSU range test at the pendulum for 50ft

    csv_filename = 'Pendulum50ft.csv';

    [LLA_BSM_coordinates, ENU_BSM_coordinates, STH_BSM_coordinates]  = ...
        fcn_PlotTestTrack_plotBSMfromOBUtoRSU(...
        csv_filename);

    assert(length(LLA_BSM_coordinates) == 2211)
    assert(length(ENU_BSM_coordinates) == 2211)
    assert(length(STH_BSM_coordinates) == 2211)

<pre align="center">
  <img src=".\Images\plotbsm.jpg" alt="fcn_geometry_plotSphere picture" width="500" height="400">
  <figcaption></figcaption>
</pre>
    See the script:
    script_test_fcn_PlotTestTrack_plotBSMfromOBUtoRSU.m

<p align="right">(<a href="#readme-top">back to top</a>)</p>



#### **fcn_plotTestTrack_plotLaneBoundingBox**

Creates a plot of the lanes with a bounding box appearing under the lanes.


 **FORMAT:**

    [LLA_leftLane, LLA_rightLane, LLA_centerLane] = 
    fcn_PlotTestTrack_laneBoundingBox(csvFile, ...
                      (baseLat,baseLon,baseAlt,laneWidth, 
                      left_color, right_color, center_color, 
                      lane_color, fig_num))


**MANDATORY INPUTS**

    csvFile: The name of the .csv file that contains the latitude, 
            longitude, altitude, and time of the location at which 
            the OBU sent out the BSM message to the RSU that was 
            in range. The code assumes latitude in first column, 
            longitude in second, altitude in third, and time in 
            fourth. 

**OPTIONAL INPUTS**
    
    baseLat: Latitude of the base location. Default is 40.8637.

    baseLon: Longitude of the base location. Default is -77.8359.

    baseAlt: Altitude of the base location. Default is 344.189.

    laneWidth: Width of the lane in meters. Default is 3.6

    left_color: Color of the left lane lines in the plot. Default is [0 0 1]

    right_color: Color of the left lane lines in the plot. Default is [0 1 1]

    center_color: Color of the left lane lines in the plot. Default is [1 0 0]

    lane_color: Color of the left lane lines in the plot. Default is [1 0 1]

    fig_num: Figure number of the LLA plot. Default is 100.

**OUTPUTS:**

    LLA_leftLane: Latitude and Longitude of the left side lane lines.

    LLA_rightLane: Latitude and longitude of the right side lane lines.

    LLA_centerLane: Latitude and longitude of the center of the lane.

**DEPENDENCIES:**

    (none)

**EXAMPLES:**

    csvFile = 'Pittsburgh_2_11_07_2024.csv'; % Path to your CSV file

    % base station in pittsburg
    reference_latitude_pitts = 40.44181017;
    reference_longitude_pitts = -79.76090840;
    reference_altitude_pitts = 327.428;

    baseLat = reference_latitude_pitts;
    baseLon = reference_longitude_pitts;
    baseAlt = reference_altitude_pitts;
    laneWidth = [];
    left_color = [];
    right_color= [];
    center_color = [];
    lane_color = [];
    fig_num = 177;
    [LLA_leftLane,LLA_rightLane, LLA_centerOfLane] = fcn_PlotTestTrack_plotLaneBoundingBox(csvFile, ...
        baseLat,baseLon, baseAlt,laneWidth, left_color,...
        right_color,center_color,lane_color,fig_num);

<pre align="center">
  <img src=".\Images\plotlane.jpg" alt="plotLaneBoundingBox picture" width="500" height="400">
  <figcaption></figcaption>
</pre>

    See the script:
    script_test_fcn_PlotTestTrack_plotLaneBoundingBox.m

<p align="right">(<a href="#readme-top">back to top</a>)</p>



#### **fcn_plotTestTrack_plotPointsAnywhere**

Takes the input points in any format, LLA/ENU and plots them as points in all LLA and ENU coordinates if specified

 **FORMAT:**

    [LLA_coordinates, ENU_coordinates]  = 
    fcn_PlotTestTrack_plotPointsAnywhere(...
       initial_points, input_coordinates_type, 
       (base_station_coordinates, plot_color, MarkerSize, 
       LLA_fig_num, ENU_fig_num))

**MANDATORY INPUTS**

    initial_points: a matrix of NX2 for LLA or ENU coordinates

    input_coordinates_type = A string stating the type of
    initial_points that have been the input. String can be "LLA" or 
    "ENU"

**OPTIONAL INPUTS**
    
    base_station_coordinates: the reference latitude, reference
    longitude and reference altitude for the base station that we 
    can use to convert ENU2LLA and vice-versa

    plot_color: a color specifier such as [1 0 0] or 'r' indicating
    what color the traces should be plotted

    MarkerSize: the line width to plot the traces

    LLA_fig_num: a figure number for the LLA plot

    ENU_fig_num: a figure number for the ENU plot

**OUTPUTS:**

    (none)

**DEPENDENCIES:**

    (none)

**EXAMPLES:**
    initial_points = 1.0e+02 * [

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

    input_coordinates_type = "ENU";
    base_station_coordinates = [];
    plot_color = [];
    MarkerSize = [];
    LLA_fig_num = [];
    ENU_fig_num = [];

    [LLA_coordinates, ENU_coordinates]  = fcn_PlotTestTrack_plotPointsAnywhere(...
        initial_points, input_coordinates_type, base_station_coordinates,...
        plot_color, MarkerSize, LLA_fig_num, ENU_fig_num);
    
<pre align="center">
  <img src=".\Images\plotpointslla.jpg" alt="plotLaneBoundingBox picture" width="500" height="400">
  <figcaption></figcaption>
</pre>
<pre align="center">
  <img src=".\Images\plotpointsenu.jpg" alt="plotLaneBoundingBox picture" width="500" height="400">
  <figcaption></figcaption>
</pre>
    See the script:
    script_test_fcn_PlotTestTrack_plotPointsAnywhere.m

<p align="right">(<a href="#readme-top">back to top</a>)</p>



#### **fcn_plotTestTrack_plotPointsColorMap**

Takes input coordinates in ENU, as well as a third value at each point, and plots the points in specific colors based on the proportion of that value to the max value provided.

 **FORMAT:**

    fcn_PlotTestTrack_plotPointsColorMap(...
        ENU_coordinates, values (base_station_coordinates, maxValue, 
        minValue, plot_color, LLA_fig_num, ENU_fig_num))


**MANDATORY INPUTS**

    ENU_coordinates: coordinates of points to plot in ENU.

    values: The raw values you want to plot as a color on the map.


**OPTIONAL INPUTS**
    
    base_station_coordinates: the reference latitude, reference
       longitude and reference altitude for the base station that 
       we can use to convert ENU2LLA and vice-versa
       
    maxValue: maximum value of the list of values to allow. For
    example, a 70mph speed limit

    minValue: minimum value to plot.

    plot_color: a colormap color string such as 'jet' or 'summer'

    LLA_fig_num: a figure number for the LLA plot

    ENU_fig_num: a figure number for the ENU plot

**OUTPUTS:**

    (none)

**DEPENDENCIES:**

    (none)

**EXAMPLES:**

    %Plots a circle around the test track facility in different colors

    reference_latitude = 40.8637;
    reference_longitude = -77.8359;
    reference_altitude= 344.189;
    base_station_coordinates = [reference_latitude, reference_longitude, reference_altitude];

    t = 2*pi*(0:.01:1);
    x = 50.*cos(t);
    y = 50.*sin(t);


    ENU_coordinates = [x; y; ones(1,length(x))]';
    values = 0:.5:50;
    maxValue = 40;
    minValue = 10;
    plot_color = 'jet';
    LLA_fig_num = 301;
    ENU_fig_num = 302;

    fcn_PlotTestTrack_plotPointsColorMap(...
            ENU_coordinates, values , base_station_coordinates, maxValue, minValue, plot_color, LLA_fig_num, ENU_fig_num);

<pre align="center">
  <img src=".\Images\plotcolormaplla.jpg" alt="plotLaneBoundingBox picture" width="500" height="400">
  <figcaption></figcaption>
</pre>
<pre align="center">
  <img src=".\Images\plotcolormapenu.jpg" alt="plotLaneBoundingBox picture" width="500" height="400">
  <figcaption></figcaption>
</pre>

    See the script:
    script_test_fcn_PlotTestTrack_plotPointsColorMap.m

<p align="right">(<a href="#readme-top">back to top</a>)</p>



#### **fcn_plotTestTrack_plotSpeedofAV**

Takes the input csv file, reads the LLA and time data from those 
files and calculates the speed of the Av at every point. Also plots 
the speed of the AV in different colours

**FORMAT:**

    SpeedofAV  = fcn_PlotTestTrack_plotSpeedofAV(...
        csvFile, (base_station_coordinates, maxVelocity, 
        minVelocity, plot_color, LLA_fig_num, ENU_fig_num))



**MANDATORY INPUTS**

    csvFile: The name of the .csv file that contains the latitude, 
            longitude, altitude, and time of the location at which 
            the OBU sent out the BSM message to the RSU that was 
            in range. The code assumes latitude in first column, 
            longitude in second, altitude in third, and time in 
            fourth. 

**OPTIONAL INPUTS**
    
    base_station_coordinates: the reference latitude, reference
    longitude and reference altitude for the base station that we 
    can use to convert ENU2LLA and vice-versa

    maxVelocity: maximum velocity allowed in mph

    minVelocity: minimum velocity allowed in mph

    plot_color: a colormap color string such as 'jet' or 'summer'

    LLA_fig_num: a figure number for the LLA plot

    ENU_fig_num: a figure number for the ENU plot

**OUTPUTS:**

    csvFilename = 'Test Track1.csv'; % Path to your CSV file

    reference_latitude = 40.8637;
    reference_longitude = -77.8359;
    reference_altitude= 344.189;
    base_station_coordinates = [reference_latitude, reference_longitude, reference_altitude];

    maxVelocity = 30;
    minVelocity = 5;
    plot_color = 'jet';
    LLA_fig_num = 201;
    ENU_fig_num = 202;

    SpeedofAV  = fcn_PlotTestTrack_plotSpeedofAV(...
        csvFilename, base_station_coordinates, maxVelocity, minVelocity, plot_color, LLA_fig_num, ENU_fig_num);

    assert(length(SpeedofAV)==742);

<pre align="center">
  <img src=".\Images\speedofav.jpg" alt="plotLaneBoundingBox picture" width="500" height="400">
  <figcaption></figcaption>
</pre>
<pre align="center">
  <img src=".\Images\speedofavenu.jpg" alt="plotLaneBoundingBox picture" width="500" height="400">
  <figcaption></figcaption>
</pre>

    SpeedofAV: a 1XN matirx with the speed of the AV in mph that 
    correspondes to every LLA location of the AV from the BSMs sent 
    by OBU 


**DEPENDENCIES:**

    (none)

**EXAMPLES:**

    See the script:
    script_test_fcn_PlotTestTrack_plotSpeedofAV.m

<p align="right">(<a href="#readme-top">back to top</a>)</p>



#### **fcn_plotTestTrack_plotSpeedvsStation**

Creates a plot of speed vs Station coordinates by taking the LLA and time from the csv file as an input

**FORMAT:**

    [AVSpeed, StationCoordinates] = 
    fcn_PlotTestTrack_plotSpeedvsStation(csvFile, (baseLat,baseLon, 
            baseAlt, plot_color, fig_num))


**MANDATORY INPUTS**

    csvFile: The name of the .csv file that contains the latitude, 
            longitude, altitude, and time of the location at which 
            the OBU sent out the BSM message to the RSU that was 
            in range. The code assumes latitude in first column, 
            longitude in second, altitude in third, and time in 
            fourth. 

**OPTIONAL INPUTS**
    
    baseLat: Latitude of the base location. Default is 40.8637.

    baseLon: Longitude of the base location. Default is -77.8359.

    baseAlt: Altitude of the base location. Default is 344.189.

    plot_color: color of the plot. Ex. [1 0 1] is magenta

    fig_num: figure number

**OUTPUTS:**

    AVSpeed: An NX1 matrix of the speed of the AV at every location

    StationCoordinates: An NX1 matrix of the Station Coordinates 
    that correspond to the AV speed

**DEPENDENCIES:**

    (none)

**EXAMPLES:**

    csvFile = 'Pittsburgh_3.csv';

    baseLat = 40.44181017;
    baseLon = -79.76090840;
    baseAlt = 327.428;
    plot_color = [];
    fig_num = [];

    [AVSpeed_mph, NoExtremes_SC] = fcn_PlotTestTrack_plotSpeedvsStation(csvFile, baseLat,baseLon, baseAlt, plot_color, fig_num);

    assert(length(AVSpeed_mph) == 780)
    assert(length(NoExtremes_SC) == 780)

<pre align="center">
  <img src=".\Images\speedvsstation1.jpg" alt="plotLaneBoundingBox picture" width="500" height="400">
  <figcaption></figcaption>
</pre>
<pre align="center">
  <img src=".\Images\speedvsstation2.jpg" alt="plotLaneBoundingBox picture" width="500" height="400">
  <figcaption></figcaption>
</pre>

    See the script:
    script_test_fcn_plotTestTrack_plotSpeedvsStation.m

<p align="right">(<a href="#readme-top">back to top</a>)</p>



#### **fcn_plotTestTrack_plotTraceENU**

Plots trace of ENU data via plot.

**FORMAT:**

    fcn_PlotTestTrack_plotTraceENU(ENU_data,(plot_color),(fig_num))


**MANDATORY INPUTS**

    ENU_data: a NX2 vector of [X Y] data for the lane marker positions

**OPTIONAL INPUTS**
    
    plot_color: a 3 x 1 array to indicate the color to use

    line_width: the width of the line to use (default is 2)

    flag_plot_headers_and_tailers: set to 1 to plot a green bar at 
    the "head" of the plot, red bar at the "tail of the plot. For 
    plots with 4 points or less, the head and tail is created via 
    vector projections. For plots with more than 4, the segments at 
    start and end define the head and tail (default is 1)

    flag_plot_points: set to 1 to plot points encircled by the plot
    color, or 0 to not plot the points (default is 1)

    fig_num: a figure number to plot result

**OUTPUTS:**

    (none)

**DEPENDENCIES:**

    (none)

**EXAMPLES:**

    % Load the first marker cluster - call it by name
    fig_num = 3;
    plot_color = [0 0 1];
    line_width = 5;
    Array = load("Data\ExampleArray.mat","ENU_positions_cell_array");
    ENU_positions_cell_array = Array.ENU_positions_cell_array;
    % Plot ENU cell array
    fcn_PlotTestTrack_plotTraceENU(ENU_positions_cell_array, plot_color, line_width, flag_plot_headers_and_tailers, fig_num);

    title(sprintf('Fig %.0d: showing plot_color',fig_num), 'Interpreter','none');

<pre align="center">
  <img src=".\Images\plottraceenu.jpg" alt="plotLaneBoundingBox picture" width="500" height="400">
  <figcaption></figcaption>
</pre>

    See the script:
    script_test_fcn_PlotTestTrack_plotTraceENU.m

<p align="right">(<a href="#readme-top">back to top</a>)</p>



#### **fcn_plotTestTrack_plotTraceLLA**

Plots trace of LLA data via geoplot.

**FORMAT:**

    fcn_PlotTestTrack_plotTraceLLA(LLA_data,(plot_color),(fig_num))


**MANDATORY INPUTS**

    LLA_data: a NX2 vector of [X Y] data for the lane marker positions

**OPTIONAL INPUTS**
    
    plot_color: a 3 x 1 array to indicate the color to use

    line_width: the width of the line to use (default is 2)

    flag_plot_headers_and_tailers: set to 1 to plot a green bar at 
    the "head" of the plot, red bar at the "tail of the plot. For 
    plots with 4 points or less, the head and tail is created via 
    vector projections. For plots with more than 4, the segments at 
    start and end define the head and tail (default is 1)

    flag_plot_points: set to 1 to plot points encircled by the plot
    color, or 0 to not plot the points (default is 1)

    fig_num: a figure number to plot result
**OUTPUTS:**

    (none)

**DEPENDENCIES:**

    (ENVIRONMENT VARIABLES)
    uses setenv("MATLABFLAG_PLOTTESTTRACK_ALIGNMATLABLLAPLOTTINGIMAGES","1");
    to add offset during plotting, in images, to match to true LLA
    coordinates.

**EXAMPLES:**

    % Load the first marker cluster - call it by name
    fig_num = 1;
    plot_color = [];
    line_width = [];
    flag_plot_headers_and_tailers = [];
    flag_plot_points = [];

    Array = load("Data\ExampleArray.mat","LLA_positions_cell_array");
    LLA_positions_cell_array = Array.LLA_positions_cell_array;

    % Plot LLA cell array
    fcn_PlotTestTrack_plotTraceLLA(LLA_positions_cell_array, plot_color, line_width, flag_plot_headers_and_tailers, flag_plot_points, fig_num);

    title(sprintf('Fig %.0d: showing plot of entire cell array in LLA',fig_num),'Interpreter','none');

<pre align="center">
  <img src=".\Images\plottracella.jpg" alt="plotLaneBoundingBox picture" width="500" height="400">
  <figcaption></figcaption>
</pre>
    See the script:
    script_test_fcn_PlotTestTrack_plotTraceLLA.m

<p align="right">(<a href="#readme-top">back to top</a>)</p>



#### **fcn_plotTestTrack_plotTraces**

Creates a plot of entered traces in either LLA, ENU, or STH-linear
Creates a plot of selected traces in either LLA, ENU, or STH-linear formats.

 **FORMAT:**

    fcn_PlotTestTrack_plotTraces(...
        Trace_coordinates, input_coordinates_type,...
        (plot_color,line_width,...
        LLA_fig_num,ENU_fig_num,STH_fig_num,
        reference_unit_tangent_vector,...
        flag_plot_headers_and_tailers, flag_plot_points));


**MANDATORY INPUTS**

    Trace_coordinates: a matrix of Nx2 or Nx3 containing the LLA or ENU
        or STH coordinates of the trace that is to be plotted
    TraceNames: a cell array of strings

    input_coordinates_type = A string stating the type of
        Trace_coordinates that have been the input. String can be "LLA" or
    "ENU" or "STH".


**OPTIONAL INPUTS**
    
    plot_color: a color specifier such as [1 0 0] or 'r' indicating
        what color the traces should be plotted

    line_width: the line width to plot the traces

    LLA_fig_num: a figure number for the LLA plot

    ENU_fig_num: a figure number for the ENU plot

    STH_fig_num: a figure number for the STH plot
 
    reference_unit_tangent_vector: the reference vector for the STH
        coordinate frame to use for STH plotting

    flag_plot_headers_and_tailers: set to 1 to plot the head/tail of
        the trace (default), and 0 to just plot the entire trace alone

    flag_plot_points: set to 1 to plot the points as color-enclosed
        circles (default), and 0 to plot just the line portion 
        without points.

**OUTPUTS:**

    (none)

**DEPENDENCIES:**

    (none)

**EXAMPLES:**

    Trace_coordinates = 1.0e+02 * [

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

    input_coordinates_type = "ENU";
    fcn_PlotTestTrack_plotTraces(Trace_coordinates, input_coordinates_type);

<pre align="center">
  <img src=".\Images\plottrace.jpg" alt="plotLaneBoundingBox picture" width="500" height="400">
  <figcaption></figcaption>
</pre>
    See the script:
    script_test_fcn_PlotTestTrack_plotTraces.m

<p align="right">(<a href="#readme-top">back to top</a>)</p>



#### **fcn_plotTestTrack_rangeRSU_circle**

Takes the input points from the RSU, LLA/ENU and plots a circle in all LLA and ENU coordinates if specified

 **FORMAT:**

    fcn_PlotTestTrack_rangeRSU_circle(...
        reference_latitude, reference_longitude, reference_altitude, 
        rsu_coordinates_enu, radius, varargin)


**MANDATORY INPUTS**

    reference_latitude: Latitude of the base location. Default is 40.8637.

    reference_longitude: Longitude of the base location. Default is -77.8359.

    reference_altitude: Altitude of the base location. Default is 344.189.

**OPTIONAL INPUTS**
    
    plot_color: a color specifier such as [1 0 0] or 'r' indicating
        what color the RSU point and circle should be plotted

    MarkerSize: the size of the marker to plot the RSU position

    fig_num: figure number

**OUTPUTS:**

    (none)

**DEPENDENCIES:**

    (none)

**EXAMPLES:**

    reference_latitute = 40.79347940;
    reference_longitude = -77.86444659;
    reference_altitude = 357;

    rsu_coordinates_lla = [40.79382193, -77.91282763, 0];

    gps_object = GPS(reference_latitute,reference_longitude,reference_altitude);
    rsu_coordinates_enu = gps_object.WGSLLA2ENU(rsu_coordinates_lla(:,1), rsu_coordinates_lla(:,2), rsu_coordinates_lla(:,3));

    radius = 500;

    plot_color = [0 1 0];
    MarkerSize = 18;
    fcn_PlotTestTrack_rangeRSU_circle(reference_latitute, reference_longitude, reference_altitude, rsu_coordinates_enu, radius, plot_color, MarkerSize);

<pre align="center">
  <img src=".\Images\plotrangecirclella.jpg" alt="plotLaneBoundingBox picture" width="500" height="400">
  <figcaption></figcaption>
</pre>
<pre align="center">
  <img src=".\Images\plotrangecircleenu.jpg" alt="plotLaneBoundingBox picture" width="500" height="400">
  <figcaption></figcaption>
</pre>

    See the script:
    script_test_fcn_PlotTestTrack_rangeRSU_circle.m

<p align="right">(<a href="#readme-top">back to top</a>)</p>





<!-- USAGE EXAMPLES -->
### Usage

Each of the functions has an associated test script, using the convention

```sh
script_test_fcn_fcnname
```

where fcnname is the function name as listed above.

As well, each of the functions includes a well-documented header that explains inputs and outputs. These are supported by MATLAB's help style so that one can type:

```sh
help fcn_fcnname
```

for any function to view function details.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Sean Brennan - sbrennan@psu.edu

Project Link: https://github.com/ivsg-psu/FieldDataCollection_VisualizingFieldData_PlotTestTrack

<p align="right">(<a href="#readme-top">back to top</a>)</p>
