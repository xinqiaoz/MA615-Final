library(shiny)
library(tidyverse)
library(shiny)
library(ggmap)
library(ggplot2)
library(maptools)
library(maps)
library(leaflet)
library(janitor)

data_raw<- read.csv("~/Desktop/BU/MA615/FinalProj/alt_fuel_stations.csv")
data_0<- remove_empty(data_raw, c("cols"))
data_0<- data_0[-c(1, 9, 12, 13, 15, 16, 18, 26, 27, 31, 32, 33, 35, 36, 39, 40)]



icons <- awesomeIcons(
    icon = 'disc',
    iconColor = 'black',
    library = 'ion',
    markerColor = 'blue',
    squareMarker = FALSE
)

ui<- fluidPage(
    titlePanel("Electric Car Charging Station in your State"), 
    sidebarLayout(
        sidebarPanel(
            selectInput("State", "Select the State you live in", unique(data_0$State))
        ),
        mainPanel(
            leafletOutput(outputId = "mapping")
        )
    )
)

server<- function(input, output, session){
    output$mapping<- renderLeaflet({
        CS<- data_0 %>% filter(State== input$State)
        leaflet(CS) %>% addTiles() %>%
            fitBounds(~min(Longitude), ~min(Latitude), ~max(Longitude), ~max(Latitude)) %>% 
            addProviderTiles("OpenStreetMap", group = "Mapnik")%>%
            addAwesomeMarkers(lng = ~Longitude, lat = ~Latitude, label = ~Station.Name, icon=icons)
    })
}

shinyApp(ui, server)



