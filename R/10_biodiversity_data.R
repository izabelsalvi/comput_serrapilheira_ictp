##### Biodiversity data ##
##### 27/07/2022 #########

install.packages("rgbif")
install.packages("Taxonstand")
install.packages("CoordinateCleaner")
install.packages("maps")

library(dplyr)
library(rgbif)
library(Taxonstand)
library(CoordinateCleaner)
library(maps)

## GETTING THE DATA

?occ_search #search for GBIF occurrences
#you can check all the parameters - its a very helpful help!

myrsine_data <- occ_search (
  scientificName = "Myrsine coriacea",
  limit = 100000  #thedefault limit is 500, you need to increase it
)

#check how many names have changed for one species


head(myrsine_data)
names(myrsine_data)

#creating a new object from this table with the occurences
myrsine.data <- myrsine_data$data


##Exporting the raw data
write.csv (myrsine.data,
           "data/raw/myssine_data.csv",
           row.names = FALSE)


View(myrsine.data)
?write.csv

#checking the species taxonomy
sort(unique(myrsine.data$scientificName))
names(myrsine.data)

#currently accepted taxonomy
table(myrsine.data$taxonomicStatus)

#names that are accepted or not
table(myrsine.data$scientificName, myrsine.data$taxonomicStatus)

##using the package taxostand to check if the taxonomic
#updates in the gbif are correct

#(1) generating a list a list with unique species names
#and combine it to data

species.names <-  unique (myrsine.data$scientificName)

species.names
class(species.names)

tax.check <-  TPL(species.names)

class(tax.check)
names(tax.check)

View(tax.check)


#creating a new data.frame with a new taxonomy
new.tax <- data.frame(scientificName = species.names,
                      genus.new.TPL = tax.check$New.Species,
                      status.new.TPL = tax.check$New.species,
                      status.TPL = tax.check$taxonomic.status,
                      scientidicName.new.TPL = paste(tax.check$New.Genus,
                                                     tax.check$New.Species))
new.tax <- data.frame(scientificName = species.names,
                      genus.new.TPL = tax.check$New.Genus,
                      species.new.TPL = tax.check$New.Species,
                      status.TPL = tax.check$Taxonomic.status,
                      scientificName.new.TPL = paste(tax.check$New.Genus,
                                                     tax.check$New.Species))

myrsine.new.tax <- merge(myrsine.data, new.tax, by = "scientificName")

write.csv(myrsine.new.tax,
          "data/processed/data_taxonomy_check.csv",
          row.names = FALSE)

##checking species coordinates
plot(decimalLatitude ~decimalLongitude, data = myrsine.data, asp = 1)
map(,,,, add= TRUE)


## using the function clean_coordinates() from the coordinateCleaner package
## to clean the species records

#the raw data provides an id in the column gbifID

myrsine.coord <-  myrsine.data[!is.na(myrsine.data$decimalLatitude) & !is.na(myrsine.data$decimalLongitude)]
myrsine.coord <- myrsine.data[!is.na(myrsine.data$decimalLatitude)
                              & !is.na(myrsine.data$decimalLongitude),]
#now we dont have NA

#coordinate cleaning
geo.clean <-  clean_coordinates(x = myrsine.coord,
                                lon = "decimalLongitude",
                                lat = "decimalLatitude",
                                species = "species",
                                value = "clean")

##plotting the clean data
par(mfrow = c (1,2))
plot(decimalLatitude ~ decimalLongitude, data = myrsine.data, asp = 1)
map(, , , add = TRUE)
plot(decimalLatitude ~decimalLongitude, data = geo.clean, asp = 1)
map(, , , add = TRUE)


##saving in the clean coordinates
myrsine.new.geo <-  clean_coordinates(x = myrsine.coord,
                                      lon = "decimalLongitude",
                                      lat = "decimalLatitude", )

table(myrsine.new.geo$.summary)

tail(names(myrsine.new.geo))

#merge the raw data with the cleaned data
# merging w/ original data
myrsine.new.geo2 <- merge(myrsine.data, myrsine.new.geo,
                          all.x = TRUE)
dim(myrsine.new.geo2)

plot(decimalLatitude ~ decimalLongitude, data = myrsine.new.geo, asp = 1)
map(, , , add = TRUE)

#Exporting the data after coordinate check
plot(decimalLatitude ~ decimalLongitude, data = myrsine.new.geo2, asp = 1,
     col = if_else(myrsine.new.geo2$.summary, "green", "red"))
map(, , , add = TRUE)

#save the dataset as a shapefile
library(tmap)
library(sf)
myrsine.final <- left_join(myrsine.coord, myrsine.new.geo2)
nrow(myrsine.final)

myrsine_sf <- st_as_sf(myrsine.final, coords = c("decimalLongitude", "decimalLatitude"))
st_crs(myrsine_sf)

myrsine_sf <- st_set_crs(myrsine_sf, 4326)
st_crs(myrsine_sf)

##TMAP MODE
RColorBrewer::brewer.pal(7, "RdBu")
library(tmap)
data(World)
?tmap
tm_shape(World) +
  tm_polygons("HPI", palette ="-YlGn")

tmaptools::palette_explorer()
