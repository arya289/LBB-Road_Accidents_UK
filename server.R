server <- function(input, output, session) {
    
    
    # Set Reactive Values
    filteredData <- reactive({ 
        
        if (is.null(input$RegionID)) {
            return(NULL)
        }  else if (is.null(input$WeatherID)) {
            return(NULL)
        }  else if (is.null(input$AreaID)) {
            return(NULL)
        }  else if (is.null(input$WindID)) {
            return(NULL)
    }

    accsort2 %>%
            filter(Year >= input$YearID[1],
                   Year <= input$YearID[2],
                   Region %in% input$RegionID,
                   Weather %in% input$WeatherID,
                   High_Wind %in% input$WindID
                   )
    })
    

    filteredData2 <- reactive({ 
        
        if (is.null(input$RoadTypeID)) {
            return(NULL)
        }  else if (is.null(input$RoadSurfaceID)) {
            return(NULL)
        }  
        
        accsort2 %>%
            filter(Engine_CC >= input$EngineCC[1],
                   Engine_CC <= input$EngineCC[2],
                   Number_of_Vehicles == input$Vehicle,
                   Road_Type %in% input$RoadTypeID,
                   Road_Surface_Conditions %in% input$RoadSurfaceID
            )
    })
    
    
    
    
    #Plot Map
    output$map <- renderLeaflet({
        
        leaflet(accsort2) %>%
                            addTiles() %>%
                            addMarkers(lng = ~Longitude,
                                       lat = ~Latitude,        
                                clusterOptions = markerClusterOptions(),
                                label=~as.character(filteredData()$Accident_Index))
        
    })
    
    
    observe({
            leafletProxy("map", data = filteredData()) %>%
            clearMarkers() %>% 
            clearMarkerClusters() %>% 
            addMarkers(lng = ~Longitude,
                       lat = ~Latitude,
                       clusterOptions = markerClusterOptions(),
                       label=~as.character(Accident_Index))
    })
    
    
    #Plot Chart
    
    #Count Chart
    output$counts <- renderPlot({
                        
                     plot1 <- ggplot(filteredData(), aes(x = Month, fill = Accident_Severity)) +
                                     geom_bar(position = "dodge") + 
                                     labs(x = NULL, y = NULL) +
                                     theme_igray() +
                                     geom_text(aes(label=comma(..count..)),stat="count", position=position_dodge(0.9),vjust=-0.2) +
                                     scale_y_continuous(labels=comma) + 
                                     scale_fill_manual("Severity Type", values=cbPalette[1:2])       
                         
                     plot1
                     
    })
    
    
    #Total Chart
    output$intotal <- renderPlot({
        
        plot2 <- ggplot(filteredData(), aes(x = Month)) +
            geom_bar(fill = "orange3", col = "darkorange3") +
            theme_igray() +
            labs(x = NULL, y = NULL) +
            geom_text(aes(label=comma(..count..)),stat="count", position=position_dodge(0.9),vjust=-0.5) +
            scale_y_continuous(labels=comma)        
        
        plot2
    })
    
    
    # Day vs Time Chart
    
    output$dayvtime <- renderPlot({
        
        plot3 <- ggplot(filteredData()) +
                                geom_mosaic(aes(x = product(Day), fill=Occured_Time)) +
                                theme_igray() +
                                labs(x = NULL, y = NULL) +
                                theme(legend.position = "none") +
                                scale_fill_brewer(palette = "Set1")
        
        plot3
        
    })
    
    # Season vs Time Chart
    
    output$seavtime <- renderPlot({

        plot4 <- ggplot(filteredData()) +
                        geom_mosaic(aes(x = product(Season), fill=Occured_Time)) +
                        theme_igray() +
                        labs(x = NULL, y = NULL) +
                        theme(legend.position = "none") +
                        scale_fill_brewer(palette = "Dark2")

        plot4

    })
    
    #Data Table Explorer
    output$data = DT::renderDataTable({
        subset_table <- filteredData2() %>% 
                        select(Accident_Index, Lights, Driver_Journey_Purpose, Propulsion_Code, Vehicle_Category, Accident_Severity)
        datatable(subset_table, 
                  options = list(
                      searching = FALSE,
                      pageLength = 10,
                      lengthMenu = c(10, 20, 30),
                      initComplete = JS(
                          "function(settings, json) {",
                          "$(this.api().table().header()).css({'background-color': '#468dd4', 'color': '#ffffff'});",
                          "}")
                  )
                  
                
                )
        })
    
    
    #closing server parantheses
}