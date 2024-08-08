
# FieldDataCollection_VisualizingFieldData_PlotTestTrack

<!--
The following template is based on:
Best-README-Template
Search for this, and you will find!
>
<!-- PROJECT LOGO -->
<br />
<p align="center">
  <!-- <a href="https://github.com/ivsg-psu/FeatureExtraction_Association_PointToPointAssociation">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a> -->

  <h2 align="center"> FieldDataCollection_VisualizingFieldData_PlotTestTrack
  </h2>

  <pre align="center">
    <img src=".\Images\plottrace.jpg" alt="Plot of a trace on the road of LTI Test Track" width="960" height="540">
</pre>

  <p align="center">
    The purpose of this code is to plot various types of geometric shapes and LLA and ENU data on geoplot or ENU plots. This library aims to visualize collected data (for example: BSM messages rom On-Board Units to Road Side Units) and also helps in analyzing the accuracy of the data being plotted.
    <br />
  </p>
</p>

***

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
        <a href="#getting-started">Getting Started</a>
        <ul>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#repo-structure">Repo Structure</a>
      <ul>
        <li><a href="#directories">Top-Level Directories</li>
        <li><a href="#dependencies">Dependencies</li>
      </ul>
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
        <li><a href="#fcn_plottesttrack_plotrectangle">fcn_plotTestTrack_plotRectangle</a></li>
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

A little about the ADS project for which this repository was created:

The USDOT ADS Demonstration Grants Program appropriated funding for a "highly automated vehicle research and development program" to fund planning, direct research, and demonstration grants for ADS and other driving automation systems and technologies. The demonstration grant included funds for testing the safe integration of ADS into our Nation's on-road transportation system. PennDOT plans to utilize these funds for research and development, planning, testing, demonstrating, and deploying the safe integration of AVs in the work zones through this grant. Through this demonstration, PennDOT and the project team aim to solve the challenge of safe integration of AVs into most work zones by examining if improved connectivity, enhanced visibility, and HD mapping will enable AVs to safely travel the work zones. The team will demonstrate how the operation of AVs in work zones can be tested, improved and standardized in three phases, this repository is built for phase 2.

The team has identified 17 common work zone scenarios/configurations in different urban, rural, and suburban settings on limited access facilities and urban arterials, typical to not only Pennsylvania, but other states too. Connected vehicle equipment will be added to the appropriate traffic control devices, construction workers and vehicles (collectively called work zone artifacts). Pavement markings and work zone artifacts will be enhanced with special coatings to improve visibility specifically for the AVs. For each of the work zone scenarios, the team will conduct simulation and closed track testing at the PSU test track.

You can find more information about the ADS project at :
<a href="https://www.penndot.pa.gov/ProjectAndPrograms/ResearchandTesting/Autonomous%20_Vehicles/Pages/ADS-Demonstration.aspx">PennDOT ADS Project</a>

This repository was created to better visualize and plot the location and time data collected by the CV2X communication system. The functions in this repo can also be used to plot geometric shapes that represenat range of coverage and Autonomous Vehicle (as a rectangle).

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_plottesttrack">Back to top</a>)</p>

***

## Getting Started

### Installation

1. Make sure to run MATLAB 2020b or higher. Why? The "digitspattern" command used in the DebugTools utilities was released late 2020 and this is used heavily in the Debug routines. If debugging is shut off, then earlier MATLAB versions will likely work, and this has been tested back to 2018 releases.

2. Clone the repo

   ```sh
   git clone https://github.com/ivsg-psu/FieldDataCollection_VisualizingFieldData_PlotTestTrack/commits/main/
   ```
3. Run the main code in the root of the folder (script_demo_plotTestTrack.m). This will download the required utilities for this code, unzip the zip files into a Utilities folder (.\Utilities), and update the MATLAB path to include the Utility locations. This install process will only occur the first time. Note: to force the install to occur again, delete the Utilities directory

4. Confirm it works! Run script_demo_plotTestTrack. If the code works, the script should run without errors. This script produces numerous example images such as those in this README file.

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_plottesttrack">Back to top</a>)</p>

***

## Repo Structure

### Top-Level Directories

The following are the top level directories within the repository:
<ul>
<li>/Data folder: The data folder contains any .mat or csv files that are used as inputs for the plotting functions</li>
 <li>/Functions folder: Contains all functions and their test scripts.</li>
 <li>/Images folder: Images that are pertinant to the functions or any   documentations are stored in this folder.</li>
 <li>/Utilities: Dependencies that are utilized but not implemented in this repository are placed in the Utilities directory. These can be single files but are most often other cloned repositories.</li>
</ul>

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_plottesttrack">Back to top</a>)</p> 

***

### Dependencies

* [Errata_Tutorials_DebugTools](https://github.com/ivsg-psu/Errata_Tutorials_DebugTools) - The DebugTools repo is used for the initial automated folder setup, and for input checking and general debugging calls within subfunctions. The repo can be found at: <https://github.com/ivsg-psu/Errata_Tutorials_DebugTools>

* [PathPlanning_PathTools_PathClassLibrary](https://github.com/ivsg-psu/PathPlanning_PathTools_PathClassLibrary) - the PathClassLibrary contains tools used to find intersections of the data with particular line segments, which is used to find start/end/excursion locations in the functions. The repo can be found at: <https://github.com/ivsg-psu/PathPlanning_PathTools_PathClassLibrary>

* [FieldDataCollection_GPSRelatedCodes_GPSClass](https://github.com/ivsg-psu/FieldDataCollection_GPSRelatedCodes_GPSClass) - This library contains code to support conversions among coordinate systems commonly used for GPS data. These include: East-North-Up (ENU), Latitude-Longitude-Altitude (LLA), and Earth-Centered-Earth-Fixed (ECEF) systems. Note that UTM coordinates are not yet supported. The repo can be found at: <https://github.com/ivsg-psu/FieldDataCollection_GPSRelatedCodes_GPSClass>

* [FeatureExtraction_Association_LineFitting](https://github.com/ivsg-psu/FeatureExtraction_Association_LineFitting) - The purpose of this code is Basic line fitting code, including vertical line fitting and regression fitting. The repo can be found at: <https://github.com/ivsg-psu/FeatureExtraction_Association_LineFitting>

* [PathPlanning_GeomTools_FindCircleRadius](https://github.com/ivsg-psu/PathPlanning_GeomTools_FindCircleRadius) - This code calculates the center of a circle from three points given as vectors in x and y. The repo can be found at: <https://github.com/ivsg-psu/PathPlanning_GeomTools_FindCircleRadius>

* [FeatureExtraction_DataClean_BreakDataIntoLaps](https://github.com/ivsg-psu/FeatureExtraction_DataClean_BreakDataIntoLaps) - The purpose of this code is to break data into "laps", e.g. segments of data that are defined by a clear start condition and end condition. The code finds when a given path meets the "start" condition, then meets the "end" condition, and returns every portion of the path that is inside both conditions. The repo can be found at: <https://github.com/ivsg-psu/FeatureExtraction_DataClean_BreakDataIntoLaps>

* [PathPlanning_MapTools_ParseXODR](https://github.com/ivsg-psu/PathPlanning_MapTools_ParseXODR) - Cannot find this library. The repo can be found at: <https://github.com/ivsg-psu/PathPlanning_MapTools_ParseXODR>

* [PathPlanning_GeomTools_GeomClassLibrary](https://github.com/ivsg-psu/PathPlanning_GeomTools_GeomClassLibrary) - This is a library of MATLAB functions related to geometric calculations for paths. The repo can be found at: <https://github.com/ivsg-psu/PathPlanning_GeomTools_GeomClassLibrary>

<a href="#fielddatacollection_visualizingfielddata_loadworkzone">Back to top</a>

***

## Functions

#### **fcn_plotTestTrack_animateAVLane**

 Creates animated plot of latitude, longitude coordinates with respect
 to time and a boundary line after displacement, also get the XY
 coordinates of the boundaries

 **FORMAT:**

    [ENU_LeftLaneX, ENU_LeftLaneY, ENU_RightLaneX, ENU_RightLaneY]
    = fcn_PlotTestTrack_animateAVLane(csvFile,car_length,car_width,
    (fig_num,baseLat,baseLon,left_color,right_color,AV_color))
<pre align="center">
  <img src=".\Images\animateav.jpg" alt="fcn_geometry_plotSphere picture" width="500" height="400">
  <figcaption></figcaption>
</pre>

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_plottesttrack">Back to top</a>)</p>

***

#### **fcn_plotTestTrack_breakArrayByNans**

Finds sections of nan, and breaks indicies into segments of non-nan data, returning indicies of each segment

 **FORMAT:**

    indicies_cell_array = fcn_PlotTestTrack_breakArrayByNans(input_array)

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_plottesttrack">Back to top</a>)</p>

***

#### **fcn_plotTestTrack_calculateLaneLines**

Returns the left lane, right lane, and center of lane coordinates in ENU format

 **FORMAT:**

    [ENU_LeftLaneX, ENU_LeftLaneY, ENU_RightLaneX, 
    ENU_RightLaneY, ENU_LaneCenterX, ENU_LaneCenterY] = 
    fcn_PlotTestTrack_calculateLaneLines(csvFile,(baseLat,baseLon,
    baseAlt, laneWidth))

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_plottesttrack">Back to top</a>)</p>

***

#### **fcn_plotTestTrack_circleCenterFromThreePoints**

 Calculates the center of a circle from three points given as vectors in x and y

 **FORMAT:**

    [xc,yc,radii] = fcn_circleCenterFromThreePoints(x,y,(fig_num))

<pre align="center">
  <img src=".\Images\circlecenter.jpg" alt="fcn_geometry_plotSphere picture" width="500" height="400">
  <figcaption></figcaption>
</pre>

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_plottesttrack">Back to top</a>)</p>

***

#### **fcn_plotTestTrack_convertSTtoXY**

Takes ST_points that are [station, transverse] in ENU coordinates and uses them as an input to give the  xEast and yNorth points 

 **FORMAT:**

    ENU_points = 
    fcn_PlotTestTrack_convertSTtoXY(ST_points,v_unit,fig_num)

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_plottesttrack">Back to top</a>)</p>

***

#### **fcn_plotTestTrack_convertXYtoST**

Takes xEast and yNorth points in the ENU coordinates and used them as an input to give the station (distance from origin in the direction of travel) and transverse (distance from origin in the orthogonal direction) 


 **FORMAT:**

    ST_points = 
    fcn_PlotTestTrack_convertSTtoXY(ENU_points,v_unit,fig_num)

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_plottesttrack">Back to top</a>)</p>

***

#### **fcn_plotTestTrack_geoPlotData**

Plots data from an array one by one, created to plot data arrays for scenarios, using the "geoplot" command. If the user gives no data to plot, then the function initializes the figure.

 **FORMAT:**

    fcn_PlotTestTrack_geoPlotData((data_array),(color),(text),(fig_num))

<pre align="center">
  <img src=".\Images\geoplot.jpg" alt="fcn_geometry_plotSphere picture" width="500" height="400">
  <figcaption></figcaption>
</pre>
    See the script:
    script_test_fcn_PlotTestTrack_geoPlotData.m

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_plottesttrack">Back to top</a>)</p>

***

#### **fcn_plotTestTrack_plotBSMfromOBUtoRSU**

Creates a plot of entered traces in either LLA, ENU, or STH-linear formats.

 **FORMAT:**

    [LLA_BSM_coordinates, ENU_BSM_coordinates,... 
    STH_BSM_coordinates] = 
    fcn_PlotTestTrack_plotBSMfromOBUtoRSU(csv_filenames,...
    (flag_plot_spokes,flag_plot_hubs,flag_plot_LLA,...
    flag_plot_ENU,flag_plot_STH,plot_color,fig_num))

<pre align="center">
  <img src=".\Images\plotbsm.jpg" alt="fcn_geometry_plotSphere picture" width="500" height="400">
  <figcaption></figcaption>
</pre>


<p align="right">(<a href="#fielddatacollection_visualizingfielddata_plottesttrack">Back to top</a>)</p>

***

#### **fcn_plotTestTrack_plotLaneBoundingBox**

Creates a plot of the lanes with a bounding box appearing under the lanes.


 **FORMAT:**

    [LLA_leftLane, LLA_rightLane, LLA_centerLane] = 
    fcn_PlotTestTrack_laneBoundingBox(csvFile, ...
                      (baseLat,baseLon,baseAlt,laneWidth, 
                      left_color, right_color, center_color, 
                      lane_color, fig_num))

<pre align="center">
  <img src=".\Images\plotlane.jpg" alt="plotLaneBoundingBox picture" width="500" height="400">
  <figcaption></figcaption>
</pre>

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_plottesttrack">Back to top</a>)</p>

***

#### **fcn_plotTestTrack_plotPointsAnywhere**

Takes the input points in any format, LLA/ENU and plots them as points in all LLA and ENU coordinates if specified

 **FORMAT:**

    [LLA_coordinates, ENU_coordinates]  = 
    fcn_PlotTestTrack_plotPointsAnywhere(...
       initial_points, input_coordinates_type, 
       (base_station_coordinates, plot_color, MarkerSize, 
       LLA_fig_num, ENU_fig_num))

  
<pre align="center">
  <img src=".\Images\plotpointslla.jpg" alt="plotLaneBoundingBox picture" width="500" height="400">
  <figcaption></figcaption>
</pre>
<pre align="center">
  <img src=".\Images\plotpointsenu.jpg" alt="plotLaneBoundingBox picture" width="500" height="400">
  <figcaption></figcaption>
</pre>

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_plottesttrack">Back to top</a>)</p>

***

#### **fcn_plotTestTrack_plotPointsColorMap**

Takes input coordinates in ENU, as well as a third value at each point, and plots the points in specific colors based on the proportion of that value to the max value provided.

 **FORMAT:**

    fcn_PlotTestTrack_plotPointsColorMap(...
        ENU_coordinates, values (base_station_coordinates, maxValue, 
        minValue, plot_color, LLA_fig_num, ENU_fig_num))


<pre align="center">
  <img src=".\Images\plotcolormaplla.jpg" alt="plotLaneBoundingBox picture" width="500" height="400">
  <figcaption></figcaption>
</pre>
<pre align="center">
  <img src=".\Images\plotcolormapenu.jpg" alt="plotLaneBoundingBox picture" width="500" height="400">
  <figcaption></figcaption>
</pre>

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_plottesttrack">Back to top</a>)</p>

#### **fcn_plotTestTrack_plotRectangle**

Takes the LLA coordinates of the center of rectangle as inpt along with the reference_latitude, reference_longitude, reference_altitude and plots a rectangle of the input length and width in LLA and ENU

**FORMAT:**

    [ENU_X, ENU_Y] = fcn_PlotTestTrack_plotRectangle(...
       reference_latitude, reference_longitude, reference_altitude, LLA_centerPoint,...
       LLA_second_point, (car_length,car_width,AV_color,flag_LLA,flag_ENU,fig_num)

<pre align="center">
  <img src=".\Images\plotrectanglella.jpg" alt="fcn_plotTestTrack_plotRectangle picture" width="500" height="400">
  <figcaption></figcaption>
</pre>
<pre align="center">
  <img src=".\Images\plotrectangleenu.jpg" alt="fcn_plotTestTrack_plotRectangle picture" width="500" height="400">
  <figcaption></figcaption>
</pre>

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_plottesttrack">Back to top</a>)</p>

***

#### **fcn_plotTestTrack_plotSpeedofAV**

Takes the input csv file, reads the LLA and time data from those 
files and calculates the speed of the Av at every point. Also plots 
the speed of the AV in different colours

**FORMAT:**

    SpeedofAV  = fcn_PlotTestTrack_plotSpeedofAV(...
        csvFile, (base_station_coordinates, maxVelocity, 
        minVelocity, plot_color, LLA_fig_num, ENU_fig_num))

<pre align="center">
  <img src=".\Images\speedofav.jpg" alt="plotLaneBoundingBox picture" width="500" height="400">
  <figcaption></figcaption>
</pre>
<pre align="center">
  <img src=".\Images\speedofavenu.jpg" alt="plotLaneBoundingBox picture" width="500" height="400">
  <figcaption></figcaption>
</pre>

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_plottesttrack">Back to top</a>)</p>

***

#### **fcn_plotTestTrack_plotSpeedvsStation**

Creates a plot of speed vs Station coordinates by taking the LLA and time from the csv file as an input

**FORMAT:**

    [AVSpeed, StationCoordinates] = 
    fcn_PlotTestTrack_plotSpeedvsStation(csvFile, (baseLat,baseLon, 
            baseAlt, plot_color, fig_num))

<pre align="center">
  <img src=".\Images\speedvsstation1.jpg" alt="plotLaneBoundingBox picture" width="500" height="400">
  <figcaption></figcaption>
</pre>
<pre align="center">
  <img src=".\Images\speedvsstation2.jpg" alt="plotLaneBoundingBox picture" width="500" height="400">
  <figcaption></figcaption>
</pre>

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_plottesttrack">Back to top</a>)</p>

***

#### **fcn_plotTestTrack_plotTraceENU**

Plots trace of ENU data via plot.

**FORMAT:**

    fcn_PlotTestTrack_plotTraceENU(ENU_data,(plot_color),(fig_num))

<pre align="center">
  <img src=".\Images\plottraceenu.jpg" alt="plotLaneBoundingBox picture" width="500" height="400">
  <figcaption></figcaption>
</pre>

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_plottesttrack">Back to top</a>)</p>

***

#### **fcn_plotTestTrack_plotTraceLLA**

Plots trace of LLA data via geoplot.

**FORMAT:**

    fcn_PlotTestTrack_plotTraceLLA(LLA_data,(plot_color),(fig_num))

<pre align="center">
  <img src=".\Images\plottracella.jpg" alt="plotLaneBoundingBox picture" width="500" height="400">
  <figcaption></figcaption>
</pre>

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_plottesttrack">Back to top</a>)</p>

***

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

<pre align="center">
  <img src=".\Images\plottrace.jpg" alt="plotLaneBoundingBox picture" width="500" height="400">
  <figcaption></figcaption>
</pre>

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_plottesttrack">Back to top</a>)</p>

***

#### **fcn_plotTestTrack_rangeRSU_circle**

Takes the input points from the RSU, LLA/ENU and plots a circle in all LLA and ENU coordinates if specified

 **FORMAT:**

    fcn_PlotTestTrack_rangeRSU_circle(...
        reference_latitude, reference_longitude, reference_altitude, 
        rsu_coordinates_enu, radius, varargin)

<pre align="center">
  <img src=".\Images\plotrangecirclella.jpg" alt="plotLaneBoundingBox picture" width="500" height="400">
  <figcaption></figcaption>
</pre>
<pre align="center">
  <img src=".\Images\plotrangecircleenu.jpg" alt="plotLaneBoundingBox picture" width="500" height="400">
  <figcaption></figcaption>
</pre>

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_plottesttrack">Back to top</a>)</p>


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

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_plottesttrack">Back to top</a>)</p>

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_plottesttrack">Back to top</a>)</p>



<!-- CONTACT -->
## Contact

Sean Brennan - sbrennan@psu.edu

Project Link: https://github.com/ivsg-psu/FieldDataCollection_VisualizingFieldData_PlotTestTrack

<p align="right">(<a href="#fielddatacollection_visualizingfielddata_plottesttrack">Back to top</a>)</p>
