
library(shiny)
library(shinydashboard)

pal1 <- colorFactor("YlOrRd", NULL)
pal2 <- colorFactor("Blues", NULL)
centroids <- getSpPPolygonsLabptSlots(map)

# # Format popup data for leaflet map.
# popup_dat <- paste0("<strong>County: </strong>", 
#                     leafmap$NAME,
#                     "<br><strong>Census Info: </strong>", 
#                     leafmap[[input$censusInfo]],"%",
#                     "<br><strong>Health Info: </strong>", 
#                     leafmap[[input$healthInfo]])

shinyServer(function(input, output) {
  
  dataOut <- reactive({
    merged
  })
  
  output$habitatMap = renderLeaflet({
    
    merged <- merged[.(healthList)]
    
    leaflet(data = leafmap) %>% addTiles() %>%
      addPolygons(fillColor = ~pal1(input$censusInfo), 
                  fillOpacity = 0.8, 
                  color = "#BDBDC3", 
                  weight = 1,
                  popup = ~leafmap[[input$censusInfo]]) %>%
      addCircleMarkers(lng = ~centroids[,1],
                       lat = ~centroids[,2],
                       color = ~pal2(input$healthInfo),
                       fillOpacity = 0.5,
                       popup = ~leafmap[[input$healthInfo]]) #%>%
      #setView(lng, lat)
    
  })
  
  output$table = renderDataTable({
    dataOut()
  })
  
})