
library(shiny)
library(shinydashboard)
library(dtplyr)

ui <- dashboardPage(
  dashboardHeader(title = "Neighborhood Revitalization Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Map", tabName = "map", icon = icon("map")),
      menuItem("Table", tabName = "table", icon = icon("th"))
    )
  ),
  
  dashboardBody(
    tabItems(
      
      # Map
      tabItem(tabName = "map",
              fluidRow(
                column(width = 3,
                       selectInput(inputId = "County",
                                   "Select County",
                                   choices=countyList,
                                   selected=countyList[1])),
                column(width = 3,
                       selectInput(inputId = "censusInfo",
                                   "Select Census Info to Display",
                                   choices=censusList,
                                   selected=censusList[1])),
                column(width = 3,
                       selectInput(inputId = "healthInfo",
                                   "Select Health Info to Display",
                                   choices=healthList,
                                   selected=healthList[1]))
              ),
              leafletOutput("habitatMap")
      ),
                
      # Spreadsheet
      tabItem(tabName = "table",
              fluidPage(
                dataTableOutput("dataTable")
              )
      )
      )
    )
)