
comm <- read.csv("data/raw/cestes/comm.csv")
##Exercise 1
#wich are the most abundant species
colSums(comm) #summing columns

#creating a row with sums
spabund <- colSums(comm)

#adding the new vector
comm2 <-  rbind(comm, new_row = spabund )
order(comm2[98,],)


##Exercise 2
##How many specie are in aeach plot
siteabund <- rowSums(comm2)
comm3 <- cbind(comm3, siteabund)
?cbind
View(siteabund)
comm_siteabund <- data.frame(comm3$Sites,comm3$siteabund)
comm_siteabund[order(comm_siteabund$comm3.siteabund),]
tail(comm_siteabund)


##Exercise 3
comm
#sort biggest number in eh plot
comm_sitesp <- subset(comm, select = -Sites)
for (i in 1:length(comm_sitesp)){
  max(comm_sitesp[i,])
  spmost <-  which (comm_sitesp[i,] == max (comm_sitesp[i,]))
  print(spmost)

}

##Exercise 4
#findind for one lne - we want at the end one value of diversity form the site
