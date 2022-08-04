install.packages("vegan")
library(vegan)


Community.A <- c(10, 6, 4, 1)
Community.B <- c(7, rep(1, 7))


?renyi
ren_comA <- renyi(Community.A)
ren_comB <- renyi(Community.B)
#a - for different values of a
#0 richness, 1 - shannon, 2 - inverse simpson ##QUESTIONS ABOUT THISSS

ren_AB <- rbind(ren_comA, ren_comB)

?matplot #Plot the columns of one matrix against the columns of another

matplot(ren_AB)

#in this case we need to plot in the other axis (transpose)
matplot(t(ren_AB), type = "l", axes= FALSE, ylab = "Rényi diversity") #the x axis has the wrong scale
box()
axis(side = 2)
axis(side = 1, labels = c(0, 0.25, 0.5, 0.75, 1, 2, 4, 8, 32, 64, "Inf"), at = 1:11) #at is the amount of scales
legend("topright",
       legend = c("Community.A", "Community.B"),
       lty = c(1, 2), #line type
       col = c(1, 2)) #col

#we cannot compare the diversity between to communitis because the lines
#INTERCEPT!

#the hill numbers would be the indices, richness, shannon, simpson

?diversity


