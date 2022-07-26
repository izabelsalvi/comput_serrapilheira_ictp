--------------------------------------------------#
  # Scientific computing
  # ICTP/Serrapilheira 2022
  # Script to fit linear model in R
  # First version 2022-07-18
  # --------------------------------------------------#

  # loading packages
library(ggplot2)
install.packages("ggplot2")
# reading data
cat <- read.csv("data/raw/crawley_regression.csv")

# Do leaf chemical compounds affect the growth of caterpillars? ----------------

# the response variable
boxplot(cat$growth, col = "darkgreen")

# the predictor variable
unique(cat$tannin)

# creating the lm
mod_cat <- lm(growth ~ tannin, data = cat)

summary(mod_cat)
class(mod_cat)

## ----lm-plot------------------------------------------------------------------
plot(growth ~ tannin, data = cat, bty = 'l', pch = 19)
abline(mod_cat, col = "red", lwd = 2) #the function abline works with lm objects


## ----lm-ggplot----------------------------------------------------------------
ggplot(data = cat, mapping = aes(x = tannin, y = growth)) +
  geom_point() +
  geom_smooth(method = lm) + #it already plot the confidence level se = TRUE,
  theme_classic()


## AOV table
summary.aov(mod_cat)


## fitted values
predict(mod_cat)
cat$fitted <- predict(mod_cat)

# Comparing fitted vs. observed values
ggplot(data = cat) +
  geom_point(aes(x = growth, y = fitted)) +
  geom_abline(aes(slope = 1,  intercept = 0)) +
  theme_classic()


## Model diagnostics -----------------------------------------------------------
par(mfrow = c(2, 2))
plot(mod_cat)
par(mfrow = c(1, 1))
#residuals vs leverage - cooks distance - distance of the residuals - outliers

# Comparing statistical distributions ------------------------------------------
library(fitdistrplus)
install.packages("fitdistrplus")

data("groundbeef")
?groundbeef
str(groundbeef)


plotdist(groundbeef$serving, histo = TRUE, demp = TRUE)
dev.off()
descdist(groundbeef$serving, boot = 1000)

fw <- fitdist(groundbeef$serving, "weibull")
summary(fw)

fg <- fitdist(groundbeef$serving, "gamma")
fln <- fitdist(groundbeef$serving, "lnorm")

par(mfrow = c(2, 2))
plot_legend <- c("Weibull", "lognormal", "gamma")
denscomp(list(fw, fln, fg), legendtext = plot_legend) # how are the different distributions fitting to my data
qqcomp(list(fw, fln, fg), legendtext = plot_legend) #
cdfcomp(list(fw, fln, fg), legendtext = plot_legend)
ppcomp(list(fw, fln, fg), legendtext = plot_legend)


gofstat(list(fw, fln, fg)) #goodness of different fit statistics

