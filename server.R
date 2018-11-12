
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
    
    # ifelse(class(leafmap[,input$censusInfo)=="numeric",
    #        pal1 <- colorQuantile("YlOrRd", NULL),
    #        pal1 <- colorFactor("YlOrRd", NULL))
    # 
    # ifelse(class(input$healthInfo)=="numeric",
    #        pal2 <- colorQuantile("YlOrRd", NULL),
    #        pal2 <- colorFactor("YlOrRd", NULL))
    
    leaflet(data = leafmap) %>% addTiles() %>%
      addPolygons(data = leafmap,
                  fillColor = ~rainbow_hcl(10), 
                  fillOpacity = 0.8, 
                  color = "#BDBDC3", 
                  weight = 1,
                  popup = ~leafmap[[input$censusInfo]]) %>%
      addCircleMarkers(lng = ~centroids[,1],
                       lat = ~centroids[,2],
                       color = ~diverge_hcl(10),
                       fillOpacity = 0.5,
                       popup = ~leafmap[[input$healthInfo]]) 
    #%>%
      #setView(lng, lat)
    
  })
  
  output$table = renderDataTable({
    merged
  })
  
})

dt <- data.table(V1="GEOID")

leafmap[,dt$V1]
leafmap$`dt$v1`
