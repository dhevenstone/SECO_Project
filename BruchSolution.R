#changing on the main server to see my editor launch
# clear workspace
rm(list = ls(all = TRUE))

#  install.packages("ggplot2")
library(ggplot2) 

# name of the directory where you'll keep you graphics
gFolder<- "/Users/debrahevenstone/Documents/Teaching/Simulation/MethodsCourse2014/labs/U8_BruchMatlab/"

##########################################################
#Question 1, the continuous transition matrix           ##
##Redone to hold raw population numbers                 ##
##########################################################

#Create the allocation vector
X<-matrix(c(80,20,20,80),nrow=1) #this is the starting neighborhood distribution
beta=5; #this is the steepness of the curve
for(j in 1:10) {
  #Create entries in the transition matrix
  n1B <- exp(beta*(X[j,1]/(X[j,1]+X[j,3])))
  n2B <- exp(beta*(X[j,2]/(X[j,2]+X[j,4])))
  dB <- n1B+n2B
  n1W <- exp(beta*(X[j,3]/(X[j,1]+X[j,3])))
  n2W <- exp(beta*(X[j,4]/(X[j,2]+X[j,4])))
  dW <- n1W+n2W
  
  A1 <- n1B/dB
  A2 <- n2B/dB
  A3 <- n1W/dW
  A4 <- n2W/dW
  #Create the transition matrix
  A <- matrix(c(A1,A2,0,0,A1,A2,0,0,0,0,A3,A4,0,0,A3,A4), ncol=4)
  
  new=A%*%X[j,]
  X = rbind(X, t(new))
}
X

#######################################
##Question 2, automated experiments, ##
##data, and graphics.                ##
#######################################

# Markov Chain Function
Bruch <- function(beta, start, iterations){
  X<-start
  for(j in 1:iterations) {
    #Create entries in the transition matrix
    n1B <- exp(beta*(X[j,1]/(X[j,1]+X[j,3])))
    n2B <- exp(beta*(X[j,2]/(X[j,2]+X[j,4])))
    dB <- n1B+n2B
    n1W <- exp(beta*(X[j,3]/(X[j,1]+X[j,3])))
    n2W <- exp(beta*(X[j,4]/(X[j,2]+X[j,4])))
    dW <- n1W+n2W
    
    A1 <- n1B/dB
    A2 <- n2B/dB
    A3 <- n1W/dW
    A4 <- n2W/dW
    #Create the transition matrix
    A <- matrix(c(A1,A2,0,0,A1,A2,0,0,0,0,A3,A4,0,0,A3,A4), ncol=4)
    
    new=A%*%X[j,]
    X = rbind(X, t(new))
  }
  
  return(c(beta,start, t(new)))
}

#Initialize data frame
data <- numeric()

#Number of iterations to run the Markov chain
iterationsS = 10

#The list of starting conditions we want to test 
A <-matrix(c(100, 0, 0, 100),nrow=1) #full segregation start
B <-matrix(c(60, 40, 40, 60),nrow=1) # mixed symmetric start
C <-matrix(c(60, 40, 30, 70),nrow=1) #unequal neighborhoods
D <-matrix(c(50, 25, 25, 25),nrow=1) # unequal populations, unequal distributions

aList<-list(A, B, C, D)

#Run the experiments
for(item in aList){
  #Within each starting condition, vary beta from 1 to 10
  for(j in 0:10) {
    new <- Bruch(j, item, iterationsS)
    #bind on experimental data
    data<- rbind( data, new) 
  }
} 
#Adjust final data set
Z = dim(data)
rownames(data) <- rownames(1:Z[1])
data
data2<-data.frame(data)
colnames(data2)[1] <- 'beta'
colnames(data2)[2] <- 'SpopR1N1'
colnames(data2)[3] <- 'SpopR1N2'
colnames(data2)[4] <- 'SpopR2N1'
colnames(data2)[5] <- 'SpopR2N2'
colnames(data2)[6] <- 'EpopR1N1'
colnames(data2)[7] <- 'EpopR1N2'
colnames(data2)[8] <- 'EpopR2N1'
colnames(data2)[9] <- 'EpopR2N2'
#############

#Subset data for plots
exp1 <- subset(data2, SpopR1N1==A[1] & SpopR1N2==A[2] & SpopR2N1==A[3] & SpopR2N2==A[4])
exp2 <- subset(data2, SpopR1N1==B[1] & SpopR1N2==B[2] & SpopR2N1==B[3] & SpopR2N2==B[4])
exp3 <- subset(data2, SpopR1N1==C[1] & SpopR1N2==C[2] & SpopR2N1==C[3] & SpopR2N2==C[4])
exp4 <- subset(data2, SpopR1N1==D[1] & SpopR1N2==D[2] & SpopR2N1==D[3] & SpopR2N2==D[4])

###################
###PLOT FUNCTION###
###################
plotExp<- function(experiment, name){    
  pdf(paste(gFolder,name,".pdf", sep = ""))
  .e <- environment()
  p<-  ggplot(experiment, aes(x=experiment[,1], y=experiment[,6], color = "Pop1, Neigh 1"), environment = .e) +
    geom_line() + 
    geom_line(data = experiment, 
              aes(x=experiment[,1], y=experiment[,7], color = "Pop1, Neigh 2")) + 
    geom_line(data = experiment, 
              aes(x=experiment[,1], y=experiment[,8], color = "Pop2, Neigh 1")) + 
    geom_line(data = experiment, 
              aes(x=experiment[,1], y=experiment[,9], color = "Pop2, Neigh 2")) +
    scale_x_continuous(breaks=c(1,2,3,4, 5, 6, 7, 8, 9, 10)) +                 
    #controls the ticks on the x-axis
    scale_color_manual(name = "", values = c("green", "blue", "red", "purple")) +  
    #controls the colors for the legend
    xlab("beta parameter") + ylab("population") +  
    #labels x and y-axis
    labs(title=paste("Population as beta varies, for ",name, sep=""),  
         legend.position = c(0.8,.2),                      
         legend.background = element_rect(fill = "white", colour = NA)) 
  print(p)
  dev.off()   
}
  
##Call the plot function
nexp1 <- deparse(substitute(exp1))
plotExp(exp1,nexp1)  
nexp2 <- deparse(substitute(exp2))
plotExp(exp2,nexp2)  
nexp3 <- deparse(substitute(exp3))
plotExp(exp3,nexp3)  
nexp4 <- deparse(substitute(exp4))
plotExp(exp4,nexp4)  




#################################################################
###Question 3: Analytic solution is the dominant eigen vector!###
#################################################################

# Markov Chain Function
EigMarkov <- function(beta, start){
  X<-start
    #Create entries in the transition matrix
    n1B <- exp(beta*(X[1]/(X[1]+X[3])))
    n2B <- exp(beta*(X[2]/(X[2]+X[4])))
    dB <- n1B+n2B
    n1W <- exp(beta*(X[3]/(X[1]+X[3])))
    n2W <- exp(beta*(X[4]/(X[2]+X[4])))
    dW <- n1W+n2W
    
    A1 <- n1B/dB
    A2 <- n2B/dB
    A3 <- n1W/dW
    A4 <- n2W/dW
    #Create the transition matrix
    A <- matrix(c(A1,A2,0,0,A1,A2,0,0,0,0,A3,A4,0,0,A3,A4), ncol=4)
  return(eigen(A))
}


A <-matrix(c(100, 0, 0, 100),nrow=1) #full segregation start
B <-matrix(c(60, 40, 40, 60),nrow=1) # mixed symmetric start
C <-matrix(c(60, 40, 30, 70),nrow=1) #unequal neighborhoods
D <-matrix(c(50, 25, 25, 25),nrow=1) # unequal populations, unequal distributions

aList<-list(A, B, C, D)
new <- EigMarkov(2.2, B)
new
new$vectors[,1]

#Run the experiments
for(item in aList){
  #Within each starting condition, vary beta from 1 to 10
  for(j in 0:10) {
    new <- EigMarkov(j, item)
    #bind on experimental data
    #data<- rbind( data, new) 
  }
}
