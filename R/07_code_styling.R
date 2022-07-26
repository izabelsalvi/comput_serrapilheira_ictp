library(deSolve)
library(ggplot2)
library(tidyr)

# Creating a function for logistic growth
logGrowth <- function(t, y, p) {
  N <- y[1]
  with(as.list(p), {
    dN.dt <- r * N * (1 - a * N)
    return(list(dN.dt))
  })
}

# named vector with parameters
p <- c(r = 1, a = 0.001)
# initial condition
y0 <- c(N = 10)
# time steps
t <- seq(1,10, by = 0.1)

# give the function and the parameters to the ode function
out_log <- ode(y = y0, times = t, func = logGrowth, parms = p)

head(out_log)
dim(out_log)
class(out_log)
summary(out_log)

#we need a data frame before using ggplot
df_log <- as.data.frame(out_log) #as data frame we use when we already have an object and we need to convert it to data frama
class(df_log)

ggplot(df_log) +
  geom_line(aes(x = time, y = N)) +
  theme_classic()

#LOTKA-VOLTERRA COMPETITION MODEL
#creating a function that represents the ode

LVComp <-  function (t, y, p) {
  N <- y
  with(as.list(p), {
    dN1.dt <- r[1] * N[1] * (1 - a[1, 1] * N[1] - a[1, 2] * N[2])
    dN2.dt <- r[2] * N[2] * (1 - a[2, 1] * N[1] - a[2, 2] * N[2])
    return(list(c(dN1.dt, dN2.dt)))
  })
}

# LV parameters
a <- matrix(c(0.02, 0.01, 0.01, 0.03), nrow = 2)
r <- c(1, 1)
p2 <- list(r, a)
N0 <- c(10, 10)
t2 <- c(1:100)

source("function/lotka-volterra_function.R") #not working
out_lv <-ode (y= N0, times = t2, func = LVComp, parms = p2)
head(out_lv) #data not tidy

df_lv <- pivot_longer(as.data.frame(out_lv), cols = 2:3) #colapses the columns 2 and three

ggplot(df_lv) +
  geom_line(aes(x = time, y = value, color = name)) + #inside de aesthetics we separate x and y and the different species,
  #we separate them with color
  labs(x = "Time", y = "N", color = "Species") + #changes the label
  theme_classic()

