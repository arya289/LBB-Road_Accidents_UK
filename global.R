# Library Needed
# Dashboard
library(shiny)
library(shinydashboard)
library(shinythemes)
library(DT)
# Data Wrangling
library(dplyr)
library(tidyr)
library(lubridate)
# Data Visualization
library(ggplot2)
library(plotly)
library(ggthemes)
library(ggmosaic)
library(scales)
library(RColorBrewer)
# Map
library(leaflet)


# Read File
accident <- read.csv("Accidents_categorical.csv")

# Set Colours
cbPalette <- c("firebrick2", "goldenrod2")

# Remove some unused or irrelavnt columns
accident <- accident %>% 
                        select(-Age_of_Driver, -Driver_IMD_Decile, -Junction_Detail, -Junction_Location, -X1st_Road_Class, -X1st_Point_of_Impact,
                               -Vehicle_Manoeuvre, -Vehicle_Make)

# Create New Columns to extract some information from Datetime
accident <- accident %>%
                        mutate(Datetime = mdy_hm(Datetime, tz="Europe/London")) %>% 
                        mutate(Year = as.numeric(year(Datetime)),
                               Month = as.factor(strftime(Datetime, format="%b")),
                               Day = as.factor(strftime(Datetime, format="%a")),
                               Hour = as.numeric(strftime(Datetime, format="%H")))

# Remove na
accident <- accident %>% 
                        drop_na() 

# Check class
class(accident$Date) 

# Check levels
levels(accident$Month) 

# Sort the Month and Season levels
accident <- accident %>% 
                        mutate(Month = factor(Month, levels=c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")),
                               Season = factor(Season, levels=c("Spring", "Summer", "Autumn", "Winter")),
                               Day = factor(Day, levels=c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")))

# Filtering the Data to get more focused analysis
accsort <- accident %>% 
                        filter(Region %in% c("South East England","London","North West England","Yorkshire and the Humber","East England"),
                               Driver_Journey_Purpose != "Other/Not known",
                               Speed_limit == 30,
                               Age_of_Vehicle <= 10,
                               #Accident_Severity == "Fatal_Serious",
                               Weather != "Unknown") %>% 
                        droplevels()

# Create Function For Time Occured
event <- function(x){
  if(x < 6){
    x <- "12AM to 6AM"
  }else if(x >= 6 & x < 12){
    x <- "6AM to 12PM"
  }else if(x >= 12 & x < 18){
    x <- "12PM to 6PM"
  }else{
    x <- "6PM to 12AM"
  }
  
}

accsort2 <- accsort %>% 
                       mutate(Occured_Time = factor(sapply(Hour, event)),
                              Occured_Time = factor(Occured_Time, levels = c("12AM to 6AM", "6AM to 12PM", "12PM to 6PM", "6PM to 12AM")))


# acctable <- accsort2 %>% 
#   select(Accident_Index, Lights, Driver_Journey_Purpose, Propulsion_Code, Vehicle_Category, Accident_Severity)



# Create Function for Dropdown Button
dropdownButton <- function(label = "", 
                           status = c("default", "primary", "success", "info", "warning", "danger"), ..., 
                           width = NULL) {
  
  status <- match.arg(status)
  
  # dropdown button content
  html_ul <- list(
    class = "dropdown-menu",
    style = if (!is.null(width)) 
      paste0("width: ", validateCssUnit(width), ";"),
    lapply(X = list(...), FUN = tags$li, style = "margin-left: 10px; margin-right: 10px;")
  )
  
  # dropdown button apparence
  html_button <- list(
    class = paste0("btn btn-", status," dropdown-toggle"),
    type = "button", 
    `data-toggle` = "dropdown"
  )
  html_button <- c(html_button, list(label))
  html_button <- c(html_button, list(tags$span(class = "caret")))
  
  # final result
  tags$div(
    class = "dropdown",
    do.call(tags$button, html_button),
    do.call(tags$ul, html_ul),
    tags$script(
      "$('.dropdown-menu').click(function(e) {
      e.stopPropagation();
});")
  )
}





