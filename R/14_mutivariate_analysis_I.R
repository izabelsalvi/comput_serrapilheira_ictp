#####05/08/2022## COMP COURSE ####
## MULTIVARIANCE ANALYSIS ########
install.packages("palmerpenguins")
install.packages("cluster")
library(vegan)
library(palmerpenguins)
library(cluster)

??cluster

data(dune)

data(dune.env)
head(dune.env)
class(dune.env)

dim(dune)
dim(dune.env)

names(dune.env)
names(dune)

?vegan::vegdist

?hclust

table(dune.env$Management)

#Chord distance - euclidean distance calculated into a normalized matrix
bray_distance <- vegdist(dune) #How close are entities in this phere
chord_distance <- dist(decostand(dune,"norm"))#euclidean distance
#mathematically you pu everything in a sphere


?vegdist

#bray curtis doesnt give you a mathematical result that you can you use
#after to do a pca

#the euclidean distance gives you some information??

b_cluster <- hclust(bray_distance, method = "average")
c_cluster <- hclust(chord_distance, method = "average")


par(mfrow = c(1,2))
plot(b_cluster)
plot(c_cluster)


par(mfrow = c(1,2))
plot(b_cluster, hang = -1, main = "", axes = F)
axis(2, at = seq(0, 1, 0.1), labels = seq(0, 1, 0.1), las = 2)
plot(c_cluster, hang = -1, main = "", axes = F)
axis(2, at = seq(0, 1, 0.1), labels = seq(0, 1, 0.1), las = 2)


##RDA

?decostand #stardardization methods for community ecology
chord_distance <-  dist(decostand(dune,"norm"))

is(chord_distance)

?rda

#pca doesnt accept distance, just t normalized data

norm <- decostand(dune, "norm")

pca <- rda(norm)

plot(pca) #principal components of the sites and the species

plot(pca, choices = c(2,3))

pca_envir <- rda(dune.env2)

dune.env2 <- dune.env[ , c("A1", "Manure")]

class(dune.env2$Manure)

numeric(dune.env2$Manure)

class(dune.env$A1)
dune.env2$Manure <- as.numeric(dune.env$Manure)
dune.env2$Moisture <- as.numeric(dune.env$Moisture)
?as.numeric

plot(pca_envir)
