#### setup, install packages

#https://scientific-computing.netlify.app/10_spatial_tools/10_tutorial.html

#install.packages("sf")
#install.packages("tmap")
#install.packages("raster")
#install.packages("ggplot2")
#install.packages("dplyr")

library(dplyr)
library(sf)
library(raster)
library(tmap)
library(ggplot2)
library(raster)

dir.create(path = "data/raster/", recursive = TRUE)
tmax_data <- getData(name = "worldclim", var = "tmax", res = 10, path = "data/raster/")

data("World")
World

#package tmap has sintax simital to ggploot. the functions start all with _tm
tm_shape(World) +
  tm_borders() #you habe to define after the elements (wich is the shape that you want to add)

#checking the information of of the World object
head(World)
names(World)
class(World)
dplyr::glimpse(World)

plot(World[,1])
plot(World[1]) #everything

#if you plot the line will only appear the first country only
plot(World[1,])
plot(World["pop_est"])

#the geometry column and geometry as objects

head(World[,1:4])
World$geometry

head(sf::st_coordinates(World))

no_geom <-  sf::st_drop_geometry(World)
head(no_geom)
class(no_geom)
class(World)

#bounding boxes
st_bbox(World)


##Manipulating objects

unique(World$continent)


World %>%
  filter(continent == "South America") %>%
  tm_shape() +
  tm_borders()

?mutate

World %>%
  mutate(our_countries = if_else(iso_a3 %in% c("COL","BRA", "MEX", "ARG"), "red", "grey")) %>%
#mutate is to create a new column, creating a column with an if else so that the column we have the
#information about the country related to the color
  tm_shape() + #adding shape
  tm_borders() +
  tm_fill(col = "our_countries") + #here im filling the map with colors difined by our new column
  tm_add_legend("fill",
                "Countries",
                col = "red")


##Loading, plotting, and saving a shapefile from the disk

install.packages("rnaturalearth")
install.packages("remotes")
remotes::install_github("ropensci/rnaturalearthhires")
library(rnaturalearth)
library(rnaturalearthhires)
bra <- ne_states(country = "brazil", returnclass = "sf")
plot(bra)


??recursive
?dir.create
#recursive is true because im saving a subfile, to create a double path

dir.create("data/shapefiles", recursive = TRUE)
st_write(obj = bra,
         dsn = "data/shapefiles/bra.shp",
         delete_layes = TRUE ) #if i want to overwrite i have to delete the previous |delete_dsn = T

?st_write #write simple features object to file or database

bra2 <-  read_sf("data/shapefiles/bra.shp")
plot(bra2)


##Loading plotting and saving a raster from disk

library(raster)
dir.create(path = "data/raster/", recursive = TRUE)
tmax_data <- getData(name = "worldclim", var = "tmax", res = 10, path = "data/raster/")
plot(tmax_data)

is(tmax_data) #the data are a raster stack, several rasters piled

dim(tmax_data)
extent(tmax_data)
res(tmax_data)

??rspatialdata

#| eval: false
library(RColorBrewer)
display.brewer.all()
display.brewer.all(type = "div")
