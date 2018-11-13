
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
    
    pal1 <- colorQuantile("YlOrRd", NULL)
    pal2 <- colorQuantile("Blues", NULL)
    
    county_index <- which(map@data$NAME==input$County)
    county_index <- county_index[1]
    
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
                  popup = ~popup_dat,
                  label = ~NAME) %>%
      addCircleMarkers(lng = ~centroids[,1],
                       lat = ~centroids[,2],
                       color = ~pal2(leafmap[[input$healthInfo]]),
                       fillOpacity = 0.4,
                       popup = ~popup_dat,
                       label = ~NAME) %>%
      addLegend("bottomright", pal = pal1, values = ~leafmap[[input$censusInfo]],
                title = input$censusInfo,
                opacity = 1) %>%
      addLegend("bottomright", pal = pal2, values = ~leafmap[[input$healthInfo]],
                title = input$healthInfo,
                opacity = 1) %>%
      setView(centroids[county_index,1], centroids[county_index,2], zoom = 9)
  })
  
  output$dataTable = renderDataTable({
    merged <- merged[,c("Name", healthList, censusList), with=FALSE]
  })
  
})
