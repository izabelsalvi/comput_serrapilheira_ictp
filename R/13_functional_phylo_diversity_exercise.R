## 04/08/2022 - Comp  course ########
## PHYLOGENETIC AND FUNCTIONAL DIV ##

#Packages
install.packages("cluster")
install.packages("FD")
install.packages("SYNCSA")
install.packages("taxize")
install.packages("ape")
install.packages("phytools")
library(SYNCSA)
library(vegan)
library(cluster)
library(FD)
library(taxize)
library(dplyr)
library(ape)
library(phytools)

# Getting the cestes datasets for traits and comm
traits <- read.csv("data/raw/cestes/traits.csv")
comm <- read.csv("data/raw/cestes/comm.csv")

head(comm)[,1:6]
head(traits)[,1:6]

rownames(comm)[1:6]

rownames(comm) <- paste0("Site", comm[ , 1])
?paste0 # convert as chacter and concatenates them
comm <- comm[,-1] # erasing the first collumns
head(comm)[,1:6]


## Transforming the column traits$Sp into the
## rownames of the dataframe

head(traits[,1:6])
rownames(traits) <- paste0("", traits[,1])
traits <- traits[,-1]


## Species richness
richness <- vegan::specnumber(comm)

## Taxonomic diversity
shannon <- vegan::diversity(comm)
simpson <- vegan::diversity(comm, index = "simpson")


## Functional diversity

#Calculating the Goewer distance - a metric for checking trait diversity
gow <- cluster::daisy(traits, metric = "gower")
gow2 <- FD::gowdis(traits)

#obs:Gower's distance can be used to measure how different two records are.
#The records may contain combinations of logical, numerical, categorical or text data.
#The distance is always a number between 0 (identical) and 1 (maximally dis- similar).
#An easy to read specification of the measure is given in the original paper.

identical(gow, gow2) #same data, differnt packages, different results?

class(gow) #two classes
class(gow2)
#what is the difference between differences and dissimilarities

plot(gow, gow2, asp = 1)

gow
gow2


# Rao's quadratic entropy calculations in R

splist <- read.csv("data/raw/cestes/splist.csv")

#here we are using the distance matrix to calculate
#functional diversity
FuncDiv1 <- dbFD(x = gow, a = comm, messages = F)
?dbFD
names(FuncDiv1)

FuncDiv <- dbFD(x = traits, a = comm, messages = F)

# Finding the families
splist$TaxonName
classification_data <- classification(splist$TaxonName, db = "ncbi" )
str(classification)
length(classification_data)

#indexing a list
classification_data$'Arisarum vulgare'
classification_data[[1]]

# filter the family with every element and find the filter the family
tibble_ex <- classification_data [[1]] %>%
    filter(rank == "family")
select(name)

?classification


## FUNCTION THAT GIVES THE FAMILY
extract_family <- function(x) {
  if (!is.null(dim(x))) {
    y <- x %>%
      filter(rank == "family") %>%
      select(name)#returns a df
    return(y)
  }
}

extract_family(classification_data[[1]])

families <- list()
for(i in 1:length(classification_data)) {
  families [[i]]<- extract_family(classification_data[[i]])

}

families ##problem its a list

extract_family <- function(x) {
  if (!is.null(dim(x))) {
    y <- x %>%
      filter(rank == "family") %>%
      pull(name)#change for vector
    return(y)
  }
}


families <- vector()
for(i in 1:length(classification_data)) {
  f <- extract_family(classification_data[[i]])
  if(length(f) > 0) families[i] <- f
}
families

##Cutting the tree

?'ape-package'

APG <- read.tree("?")
plot(APG)

#prune the tree - find the phylogenetic calcules
