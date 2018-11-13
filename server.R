
library(shiny)
library(shinydashboard)
library(colorspace)

# pal1 <- colorFactor("YlOrRd", NULL)
# pal2 <- colorFactor("Blues", NULL)
centroids <- getSpPPolygonsLabptSlots(map)

shinyServer(function(input, output) {
  
  dataOut <- reactive({
    leafmap
  })
  
  output$habitatMap = renderLeaflet({
    
    merged <- merged[,c(healthList), with=FALSE]
    
    pal1 <- colorQuantile("YlOrRd", NULL)
    pal2 <- colorQuantile("Blues", NULL)
    
    popup_dat <- paste0("<strong>County: </strong>", 
                        leafmap$NAME,
                        "<br><strong>",input$censusInfo,"</strong>: ", 
                        leafmap[[input$censusInfo]],
                        "<br><strong>",input$healthInfo,"</strong>: ", 
                        leafmap[[input$healthInfo]])
    
    leaflet(data = leafmap) %>% addTiles() %>%
      addPolygons(fillColor = ~pal1(leafmap[[input$censusInfo]]), 
                  fillOpacity = 0.8, 
                  color = "#BDBDC3", 
                  weight = 1,
                  popup = ~popup_dat) %>%
      addCircleMarkers(lng = ~centroids[,1],
                       lat = ~centroids[,2],
                       color = ~pal2(leafmap[[input$healthInfo]]),
                       fillOpacity = 0.3,
                       popup = ~popup_dat) %>%
      addLegend("bottomright", pal = pal1, values = ~leafmap[[input$censusInfo]],
                title = input$censusInfo,
                opacity = 1) %>%
      addLegend("bottomright", pal = pal2, values = ~leafmap[[input$healthInfo]],
                title = input$healthInfo,
                opacity = 1)
    #%>%
      #setView(lng, lat)
    
  })
  
  output$dataTable = renderDataTable({
    merged
  })
  
})
