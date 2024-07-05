function fcn_PlotTestTrack_rangeRSU(csv_filenames, optional_parameters)
    reference_latitude = 40.86368573;
    reference_longitude = -77.83592832;
    reference_altitude = 344.189;
    gps_object = GPS(reference_latitude,reference_longitude,reference_altitude); 

    figure(1);

    %h_geoplot = geoplot(40.8637, -77.8359, '*','Color',[0 1 0],'Linewidth',3,'Markersize',10);
    %h_parent =  get(h_geoplot,'Parent');
    %set(h_parent,'ZoomLevel',16.375);
    
    try
        geobasemap satellite
    catch
        geobasemap openstreetmap
    end
    geotickformat -dd;
    hold on;

    for i = 1:length(csv_filenames)
        csv_file = csv_filenames{i};
        params = optional_parameters{i};

        color = params{1};
        markersize = params{2};
        location = params{3};
        flag_show_boundary = params{4};
        boundary_range = params{5};

        BSM_LLA = csvread(csv_file, 1);
        BSMs_LLA_corrected = [BSM_LLA(:,1)/10000000 BSM_LLA(:,2)/10000000 BSM_LLA(:,3)];

        LLA_BSM_coordinates = BSMs_LLA_corrected;

        geoplot(LLA_BSM_coordinates(:,1), LLA_BSM_coordinates(:,2), '.','Color',color,'Markersize',markersize);

        rsu_coordinates_enu = location;
        Trace_coordinates_LLA =  gps_object.ENU2WGSLLA(rsu_coordinates_enu);
        geoplot(Trace_coordinates_LLA(:,1),Trace_coordinates_LLA(:,2),'*', 'Color', color, 'MarkerSize',20);
    
        if flag_show_boundary == 1
            theta = 0:0.01:2*pi;
            circle_radius = boundary_range / 111000;  
            circle_lat = Trace_coordinates_LLA(1) + circle_radius * cos(theta);
            circle_lon = Trace_coordinates_LLA(2) + circle_radius * sin(theta) / cos(Trace_coordinates_LLA(1));
            geoplot(circle_lat, circle_lon, 'Color', color, 'LineWidth', 1.5);
        end
    end

    hold off;
end