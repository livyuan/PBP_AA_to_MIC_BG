## Fitting a Power-law growth Model by maximum-likelihood estimator
## Figure S1 and S2
set.seed(1001)
setwd("C:/Users/YQH8/Desktop/201607/PBP2/Submission/BMCgenomics/R1/Data")
m1=read.csv("TableS1_Dataset1.csv", colClasses="character")
m2=read.csv("TableS2_Dataset2.csv", colClasses="character")

PTa=c(m1$PT, m2$PT)
n1=length(PTa)
x=1:n1

x1=sample(1:n1,n1)
x2=PTa[x1]

y=NULL
for (j1 in x) 
{
  y=c(y, length(unique(x2[1:j1])))
}

m3=cbind(nStrain=x, nPT=y)
write.csv(m3, "PTgrowth.csv", row.names=F)


#Figure S1
setwd("C:/Users/YQH8/Desktop/201607/PBP2/Submission/BMCgenomics/R1/Data")
m3=read.csv("PTgrowth.csv")

nStrain=m3[, 1]
nPT=m3[, 2]
library('ggplot2')

m4=data.frame(log10(nStrain), log10(nPT))
fit <- lm(log10(nPT) ~ log10(nStrain), data = m4)
summary(fit)

ggplot(m4, aes(x = log10(nStrain), y = log10(nPT))) + 
  geom_point() +
  stat_smooth(method = "lm", col = "red")+
  labs(title = paste("Adj R2 = ",signif(summary(fit)$adj.r.squared, 3)))


#Figure S2
setwd("C:/Users/YQH8/Desktop/201607/PBP2/Submission/BMCgenomics/R1/Data")
m3=read.csv("PTgrowth.csv")
library("poweRlaw")
nPT=as.numeric(m3[, 2])
m_sp = displ$new(nPT)
est_sp = estimate_xmin(m_sp)
m_sp$setXmin(est_sp)
bs_P = bootstrap_p(m_sp, no_of_sims=2000, threads=6)
bs_P$p
plot(bs_P)
save(bs_P, file="MLS_bs_P")
load("MLS_bs_P")

par(mar=c(3, 3, 2, 1), mgp=c(2, 0.4, 0), tck=-.01,
cex.axis=0.9, las=1)

plot(m_sp, pch=21, bg=2, panel.first=grid(col="grey80"),
xlab="Number of PPB type", ylab="CDF")
lines(m_sp, col=3, lwd=3)

