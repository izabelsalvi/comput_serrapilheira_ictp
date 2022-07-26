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

??recursive
?dir.create
#recursive is true because im saving a subfile, to create a double path

dir.create()
