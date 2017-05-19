setwd("C:/Users/YQH8/Desktop/201512/PBP")

BLAclass=c("PEN", "AMO", "MER", "TAX", "CFT", "CFX")

BKclass0=c(0.06, 	2, 0.25, 0.5, 1, 0.5)
BKclass1=c(1, 	4, 0.5,  1,   2,   1)
BKclass2=c(2, 	8, 1,    2,   4,   2)

source("C:\\Users\\YQH8\\Desktop\\201508\\PBP_MIC_R\\scripts\\evaluation-FDA631.R") 
f1="C:/Users/YQH8/Desktop/201607/PBP2/Submission/BMCgenomics/R1/Data/TableS2_Dataset2.csv"
m2=read.csv(f1)
m2=subset(m2, NewPT=="Y")

m2.3=m2
colnames(m2.3)[1]="sampleID"
head(m2.3)

m2=subset(m2.3, NDIST !="0")
m3=NULL
for (j1 in 1:length(BLAclass))
{
  k1=BLAclass[j1]
  i1=c(BKclass0[j1],BKclass1[j1], BKclass2[j1]) 
  MIC1=m2[k1]
  MIC2=m2[paste(k1, "_MIC_MM", sep="")]
  m4=cbind(MIC1,MIC2)
  x1=FDA631(data=m4, SIR=i1)
  m3=rbind(m3, x1[[2]])

  MIC2=m2[paste(k1, "_MIC_RF", sep="")]
  m4=cbind(MIC1,MIC2)
  x1=FDA631(data=m4, SIR=i1)
  m3=rbind(m3, x1[[2]])

  MIC2=m2[paste(k1, "_MIC_RF", sep="")]
  m4=cbind(MIC1,MIC2)
  x1=FDA631(data=m4, SIR=i1)
  m3=rbind(m3, x1[[2]])
}

x1=paste(rep(BLAclass, each=3), rep(c("MM", "RF", "EN"), 6), sep="_")
rownames(m3)=x1
f1="C:/Users/YQH8/Desktop/201607/PBP2/Data/Eval_Dataset2new.csv"
write.csv(m3, f1)

#