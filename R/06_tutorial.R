# Loading needed packages
library(dplyr)
library(lme4)
library(merTools)
library(ggplot2)
install.packages("bbmle")
library(bbmle)

#Read my data
cuckoo <- read.csv("data/raw/valletta_cuckoo.csv")

#Create model for different hypotesis

h1 <- glm(Beg ~ Mass, data = cuckoo,
          family = poisson(link = log))

h2 <- glm(Beg ~ Mass + Species, data = cuckoo,
          family = poisson(link = log))

h3 <- glm(Beg ~ Mass * Species, data = cuckoo,
          family = poisson(link = log))

h0 <- glm(Beg ~ 0, data = cuckoo,
          family = poisson(link = log))

bbmle::AICtab(h0, h1, h2, h3, base = TRUE, weights = TRUE)
#weight - based on the delta aic <- which model explains our data the most

summary(h1)

newdata<- expand.grid (Mass=seq(min(cuckoo$Mass), max(cuckoo$Mass), length.out = 200), Species = unique (cuckoo$Species))
newdata$Beg <- predict (h3, newdata, type = "response")
