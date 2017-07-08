setwd("C:/Users/YQH8/Desktop/201607/PBP2/Data")

f1="../data/TableS3_Dataset1_PBP_AAtable.csv"
m1=read.csv(f1, colClasses="character")
m1$DS=1


f2="../data/TableS4_Dataset2_PBP_AAtable.csv"
m2=read.csv(f2, colClasses="character")
m2$DS=2

m3=rbind(m1, m2)
head(m3)
colnames(m3)
m3a=m3[, -c(1, 916)]
dim(m3a)
m3b=as.matrix(m3a)
m3c=as.data.frame(m3b, stringsAsFactors=T)

library(cluster)
dis1=daisy(m3c, metric ="gower")
save(dis1, file="tsne_dis1")

library("tsne")
t1=tsne(dis1)
save(t1, file="tsne_t1")

load("tsne_t1")
m4=data.frame(tSNE1=t1[, 1], tSNE2=t1[, 2], DS=factor(m3$DS))
library("ggplot2", lib.loc=libpath)
p1=ggplot(m4, aes(x=tSNE1, y=tSNE2, color=DS)) + geom_point()
ggsave(filename="tsne_plot.pdf", plot=p1)