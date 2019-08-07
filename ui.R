ui <- fluidPage(
    #useShinyjs(),
    navbarPage(title = "Dashboard Analysis of Road Accident in UK (2010 - 2014)", 
               
               # Pick a bootstrap theme from https://rstudio.github.io/shinythemes/
               theme = shinytheme("united"),
               
               # Interactive Map panel -------------------------------------------------- 
               tabPanel("Geographical & Time Analysis",  
                        tags$style(type = "text/css", "#map {height: calc(120vh - 100px) !important;}"),
                        tags$style(HTML(".js-irs-1 .irs-single, .js-irs-1 .irs-bar-edge, .js-irs-1 .irs-bar {background: orange}")),
                        fluidRow(
                                 column(12, 
                                   fluidRow(
                                       h4("Location of Road Accidents", align="left")),
                                   fluidRow(
                                       box(
                                           width = 9,
                                           leafletOutput("map")),
                                       sidebarPanel(
                                                    width = 3,
                                                        sliderInput("YearID",
                                                                    "Year of Observations:",
                                                                    min = 2010,
                                                                    max = 2014,
                                                                    value = c(2010,2014)),
                                                        checkboxGroupInput(
                                                                           "RegionID", 
                                                                           "Select Region:",
                                                                           choices = levels(accsort2$Region),
                                                                           selected = c("East England", "London", "North West England", "South East England", "Yorkshire and the Humber")),
                                                        checkboxGroupInput(
                                                                           "WeatherID", 
                                                                           "Select Weather:",
                                                                           choices = levels(accsort2$Weather),
                                                                           selected = c("Fine","Fog or mist","Other","Raining","Snowing")),
                                                        checkboxGroupInput(
                                                                           "WindID",
                                                                           "Select High Wind Condition:",
                                                                           choices = levels(accsort2$High_Wind),
                                                                           selected = c("No","Yes")),
                                                        checkboxGroupInput(
                                                                           "AreaID",
                                                                           "Select Area Type:",
                                                                           choices = levels(accsort2$Urban_or_Rural_Area),
                                                                           selected = c("Rural","Urban")),
                                                        h4("Notes:"),
                                                        p("Data filtered into the following conditions:", style = "font-si12pt"),
                                                        p("- Only Top 5 Regions with Most Accidents", style = "font-si12pt"),
                                                        p("- Speed Limited only in 30 mph", style = "font-si12pt"),
                                                        p("- Age of Vehicle Limited to 10 Years", style = "font-si12pt")#,
                                                        #p("- Severity Only Limited to Fatal/Serious", style = "font-si12pt")
                                                        
                                                                        )
                                                     
                                           
                                       )
                                       
                                   ),
                                
                                   fluidRow(
                                       column(12,
                                              fluidRow(
                                                  column(6,                                         
                                                         h4("Monthly Accident by Severity Type", align="left"),
                                                         tabBox(
                                                                width = 12,
                                                                id = "tabset1", height = "100px",
                                                                tabPanel("Splitted", plotOutput('counts')),
                                                                tabPanel("In Total", plotOutput('intotal'))
                                                         )     
                                                  ),
                                                  column(6, 
                                                         h4("Accidents on Time Occured", align="left"),
                                                         tabBox(
                                                             width = 12, 
                                                             id = "tabset2", height = "100px", 
                                                             tabPanel("By Day of Week", plotOutput('dayvtime')),
                                                             tabPanel("By Season", plotOutput('seavtime'))
                                                             
                                                         )
                                                  )
                                              )
                                       )
                                   )
                                   
                                   
                                   
                            )
                        
               
               ),
               
               #Tab Data Explorer------------------------
               tabPanel("Road & Vehicle Analysis",
                        fluidRow(
                            column(12,
                                   fluidRow(
                                       column(6,
                                              h4("Road Components", align="left")
                                              ),
                                       column(6,
                                              h4("Vehicle Components", align="left")
                                       )
                                   ),
                                   fluidRow(
                                       column(3,
                                              br(),
                                              dropdownButton(
                                                  label = "Select Road Types:", status = "default", width = 100,
                                                  checkboxGroupInput(inputId = "RoadTypeID", 
                                                                     label = NULL, 
                                                                     choices = levels(accsort2$Road_Type), 
                                                                     selected = c("Dual carriageway","One way street","Roundabout","Single carriageway","Slip road"))
                                                             )
                                              
                                                ),
                                       column(3,
                                              br(),
                                              dropdownButton(
                                                  label = "Road Surface Conditions:", status = "default", width = 100,
                                                  checkboxGroupInput(inputId = "RoadSurfaceID", 
                                                                     label = NULL, 
                                                                     choices = levels(accsort2$Road_Surface_Conditions), 
                                                                     selected = c("Dry","Flood over 3cm. deep","Frost or ice","Snow","Wet or damp"))
                                                              )
                                              
                                              ),
                                       column(3,
                                              numericInput("Vehicle", "Vehicle Numbers:", 1, min = 1, max = 5)
                                              ),
                                       column(3,
                                              sliderInput("EngineCC",
                                                          "Engine CC:",
                                                          min = 38,
                                                          max = 3500,
                                                          value = c(38,3500))
                                       )
                                            ),
                                        
                                    br(),
                                    fluidRow(
                                             DT::dataTableOutput("data")  
                                                )
                                    
                        
                        )
                    )
               )
                              
    ) # closing navbar parantheses
    
    
) # closing ui parantheses
