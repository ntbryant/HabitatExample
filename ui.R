
library(shiny)
library(shinydashboard)
library(dtplyr)

ui <- dashboardPage(
  dashboardHeader(title = "NR Dashboard"),
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
                                   choices=sort(countyList),
                                   selected="Multnomah")),
                column(width = 3,
                       selectInput(inputId = "censusInfo",
                                   "Select Census Info to Display",
                                   choices=censusList,
                                   selected="Poverty Percent, All Ages")),
                column(width = 3,
                       selectInput(inputId = "healthInfo",
                                   "Select Health Info to Display",
                                   choices=healthList,
                                   selected="% Unemployed"))
              ),
              tags$style(type = "text/css", "#habitatMap {height: calc(100vh - 170px) !important;}"),
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