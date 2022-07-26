###Time-series
install.packages("lubridate")
install.packages("zoo")

library(dplyr)
library(ggplot2)
library(lubridate)
library(zoo)

covid <- read.csv("data/raw/covid19-dd7bc8e57412439098d9b25129ae6f35.csv")

head(covid)

class(covid$date)
covid$date <- as_date(covid$date)
class(covid$date)
range(covid$date)
summary(covid$date)

ggplot(covid) +
  geom_line(aes(x = date, y = new_confirmed)) +
  theme_minimal()

#transform the negative values
covid$new_confirmed[covid$new_confirmed<0] <- 0
#finding the objects that are less than zero and changing into zero


ggplot(covid) +
  geom_line(aes(x = date, y = new_confirmed)) +
  theme_minimal() +
  scale_x_date(breaks = "4 months", date_labels = "%y-%m") #change the scale of the date,  "%y %m" format year month, Y full year
+ labs(x = "Date", y = "New cases")

#Rolling mean - make a mean for specific interval - better for visualization
covid$rolling <- zoo::rollmean(covid$new_confirmed, k = 14, fill = NA)
#k is the interval in days, fill what is missing so the object is the same size? so we can calculate

head(covid)

ggplot(covid) +
  geom_line(aes(x = date, y = new_confirmed)) +
  theme_minimal() +
  scale_x_date(breaks = "4 months", date_labels = "%y-%m") #change the scale of the date,  "%y %m" format year month, Y full year
+ labs(x = "Date", y = "New cases")
+ geom_line(aes(x = date, y = roll_mean), color= 'red', size = 1.2 )

