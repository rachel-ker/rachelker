## Personal Project on Mapping Singapore
## Interactive Map of Cycleways in Singapore, divided by administrative regions

######## Set up #########

# Clear working memory
rm(list=ls())     

# Load libraries
library(magrittr)
library(osmdata)
library(sf)
library(sp)
library(leaflet)
library(raster)
library(rgdal)

######## Ploting OSM #########

## Check for available features and tags

#available_features()
#available_tags("highway")
#opq(bbox = "singapore") %>% 
#add_osm_feature(key = 'boundary', value = "administrative") %>%
#  osmdata_sp()

## Create the query and plot maps
sgmaps_cycleway_sp <- opq(bbox = "singapore") %>% 
  add_osm_feature(key = 'highway', value = "cycleway") %>%
  osmdata_sp()

sgmaps_boundary_sp <- opq(bbox = "singapore") %>% 
  add_osm_feature(key = 'boundary', value = "administrative") %>%
  osmdata_sp()

plot(sgmaps_cycleway_sp$osm_lines)
plot(sgmaps_boundary_sp$osm_lines, add = T, col = "red")


# Plotting over base map in leaflet

writeOGR(sgmaps_boundary_sp$osm_lines, getwd(), "sg_boundary", driver="ESRI Shapefile")
writeOGR(sgmaps_cycleway_sp$osm_lines, getwd(), "sg_cycleway", driver="ESRI Shapefile")

boundary <- shapefile("sg_boundary.shp")
cycleway <- shapefile("sg_cycleway.shp")

sgmaps_base <- leaflet() %>%
  addTiles(group = "Base") %>% 
  addProviderTiles(providers$Stamen.Toner, group = "Toner") %>%
  addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite") %>%
  addPolylines(data = boundary, color = 'blue', weight = 1,
               opacity = 1, group = "Boundary") %>%
  addPolylines(data = cycleway, color = "green",weight = 1,
               opacity = 1, group = "Cycleway") %>%
  setView(103.808, 1.351, zoom = 11) %>%
  addLayersControl(baseGroups = c("Base", "Toner", "Toner Lite"), 
                   overlayGroups = c("Boundary", "Cycleway"),
                   options = layersControlOptions(collapsed = F))

sgmaps_base


