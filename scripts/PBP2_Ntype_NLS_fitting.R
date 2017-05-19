## Fitting a Model by least-squares estimates 
set.seed(1001)
setwd("C:/Users/YQH8/Desktop/201607/PBP2/")
m1=read.csv("C:/Users/YQH8/Desktop/201512/PBP_2528_15.csv", colClasses="character")
head(m1)
n1=dim(m1)[1]
x=1:n1

n2=1000
m2=matrix(ncol=3, nrow=n2)
for (j2 in 1:n2) 
{
  x1=sample(1:n1,n1)
  x2=m1$PT[x1]
  y=NULL
  for (j1 in x) 
  {
    y=c(y, length(unique(x2[1:j1])))
  }
  m<-nls(y~(x^(b+1))*A/(b+1) + 1 - A/(b+1), start=c(A=2, b=-0.5))
  m2[j2, ]=c(j2, coef(m))
  print(j2)
}

f1="C:/Users/YQH8/Desktop/201607/PBP2/Data/Permutate_Ab.csv"
write.csv(m2, f1, row.names=F)

#
set.seed(1001)
setwd("C:/Users/YQH8/Desktop/201607/PBP2/")
m1=read.csv("C:/Users/YQH8/Desktop/201512/PBP_2528_15.csv", colClasses="character")
n1=dim(m1)[1]
x1=sample(1:n1,n1)
x2=m1$PT[x1]
x=1:n1
y=NULL
for (j1 in x) 
{
    y=c(y, length(unique(x2[1:j1])))
}
plot(x, y)

m3a=read.csv("C:/Users/YQH8/Desktop/201607/PBP2/Data/DataSet2_1781.csv", colClasses="character")
m3b=m3a[c("sampleID", "PT.y")]
head(m3b)
colnames(m3b)=c("LABID", "PT")
m3=m3b
sum(m3$LABID %in% m1$LABID)

n3=dim(m3)[1]
x3=sample(1:n3,n3)
x2=c(m1$PT[x1], m3$PT[x3])
y3=NULL
for (j1 in (length(x1)+1:length(x3))) 
{
  y3=c(y3, length(unique(x2[1:j1])))
}

x3=max(x)+(1:length(x3))
plot(x3, y3)

f1="C:/Users/YQH8/Desktop/201607/PBP2/Data/Permutate_Ab.csv"
m2=read.csv(f1, colClasses="numeric")
x2 <- 1:5000
EP<-LCI <- UCI <- MED <- MEAN <- numeric(length(x2))
A=m2[, 2]
b=m2[, 3]
for (i in 1:length(x2)) {
    pv=(i^(b+1))*A/(b+1) + 1 - A/(b+1)
    LCI[i] <- quantile(pv,0.025)
    UCI[i] <- quantile(pv,0.975)
    MED[i] <- quantile(pv, 0.5)
    MEAN[i] <- mean(pv)
    print(i)
}

plot(x, y, ylim=c(0, 500),xlim=c(0, 5000), col="grey", cex.axis=1.5, xlab="", ylab="")
points(x3, y3, col="blue")
lines(x2,MED,lty=2,col="black",lwd=3)
lines(x2,LCI,lty=1,col="black",lwd=1)
lines(x2,UCI,lty=1,col="black",lwd=1)

cor.test(MED[x3], y3) # 0.9997527 




#
library('ggplot2')
library(scales)
install.packages("vioplot")
library("vioplot")
 
f1="C:/Users/YQH8/Desktop/201607/PBP2/Data/Permutate_Ab.csv"
m2=read.csv(f1, colClasses="numeric")
A=m2[, 2]
b=m2[, 3]
hist(A, title="", cex.axis=1.5)
quantile(A,0.025)
quantile(A,0.975)
mean(A)
median(A)

hist(b, title="", cex.axis=1.5)
quantile(b,0.025)
quantile(b,0.975)
mean(b)

vioplot(A, names="", col="gold", horizontal=T, drawRect=T)
vioplot(b, names="", col="gold", horizontal=T, drawRect=T)

## End of Fitting a Model by least-squares estimates 

f1="C:/Users/YQH8/Desktop/201607/PBP2/Data/Permutate_Ab.csv"
m2=read.csv(f1, colClasses="numeric")
A=m2[, 2]
b=m2[, 3]
i=4326
EP=A*i^b
median(EP)
quantile(EP,0.975)
quantile(EP,0.025)
