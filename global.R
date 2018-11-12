
library(data.table)
library(lubridate)
library(leaflet)
library(rgdal)
library(ggplot2)
library(ggmap)
library(raster)
library(sp)
library(rgeos)
library(colorspace)
library(dplyr)
library(rsconnect)
library(car)
library(readr)

# reading data
company <- fread("COMPANY_DATA.csv")
scores <- fread("COMPANY_SCORES.csv")
census <- setDT(read_csv("CENSUS_DATA.csv"))
health <- setDT(read_csv("HEALTH_DATA.csv"))

# formating GEOID
company$GEOID <- formatC(company$state_county_fips, width = 5, format = "d", flag = "0")
census[,GEOID:=paste0(`State FIPS Code`,`County FIPS Code`)]
health[,GEOID:=FIPS]

# merging data
company_scores <- merge(company[,.(GEOID,id,weight1)],scores,by="id")
tables <- list(company_scores, census, health)
lapply(tables, function(i) setkey(i, GEOID))
merged <- Reduce(function(...) merge(..., all = T), tables)

# reading map from https://www.census.gov/geo/maps-data/data/cbf/cbf_counties.html
map <- readOGR(dsn = ".", layer = "cb_2016_us_county_20m", stringsAsFactors = FALSE)

# Remove Alaska(2), Hawaii(15), Puerto Rico (72), Guam (66), Virgin Islands (78), American Samoa (60)
#  Mariana Islands (69), Micronesia (64), Marshall Islands (68), Palau (70), Minor Islands (74)
map <- map[!map$STATEFP %in% c("02", "15", "72", "66", "78", "60", "69",
                               "64", "68", "70", "74"),]
# Make sure other outling islands are removed.
map <- map[!map$STATEFP %in% c("81", "84", "86", "87", "89", "71", "76",
                               "95", "79"),]

centroids <- getSpPPolygonsLabptSlots(map)

strong_presence <- merged[log(weight1)>5]

companies_per_geoid <- merged[,.(number=.N,presence=sum(weight1,na.rm = T)),by=.(GEOID)]

merged_map <- merge(census,companies_per_geoid,by="GEOID")

leafmap <- sp::merge(map, merged_map, by=c("GEOID"))

# list of county names
countyList <- leafmap@data$NAME

# list of health attributes
healthList <- colnames(health)
index_n <- which(lapply(health, typeof)=="character")
healthList <- healthList[-index_n]
index <- which(grepl("95% CI|Quartile", healthList))
healthList <- healthList[-index]


# list of census attributes
censusList <- colnames(census)
index_n <- which(lapply(census, typeof)=="character")
censusList <- censusList[-index_n]
index <- which(grepl("90% CI", censusList))
censusList <- censusList[-index]


