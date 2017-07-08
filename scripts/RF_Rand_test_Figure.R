set.seed(1001)
library(ggplot2)
#
f1="../data/TableS1_Dataset1.csv"
m1=read.csv(f1, colClasses="character")
head(m1)

f2="../data/Rand_test_PBPtype_MIC2_Prediction.csv"
m2=read.csv(f2, colClasses="character")
head(m2)
colnames(m2)
m2a=m2[, c(1, 14)]
head(m2a)
colnames(m2a)[1]="LABID"
m1b=m1[, c(1:2)]
head(m1b)
m3=merge(m2a, m1b, by="LABID")
dim(m3)

head(m3)
m3a=m3[, c(2:3)]
head(m3a)

m1c=m1[, c(2:3)]
#m1c=m1c[!duplicated(m1c$PT), ]

m4=merge(m1c, m3a, by="PT")
dim(m4)
colnames(m4)[3]="PEN_RF_RAND"
m4$Log2_PEN_RF_RANDtest=round(log2(as.numeric(m4$PEN_RF_RAND)))
m4$Log2_PEN=round(log2(as.numeric(m4$PEN)))


fit <- lm(Log2_PEN ~ Log2_PEN_RF_RANDtest, data = m4)
summary(fit)

ggplot(m4, aes(x = Log2_PEN_RF_RANDtest, y = Log2_PEN)) + 
  geom_jitter(width = 0.25, height = 0.25) +
  labs(title = paste("Adj R2 = ",signif(summary(fit)$adj.r.squared, 2)))

#
f1="../data/TableS1_Dataset1.csv"
m1=read.csv(f1, colClasses="character")
head(m1)

Log2_PEN=round(log2(as.numeric(m1$PEN)))
Log2_PEN_RF=round(log2(as.numeric(m1$PEN_MIC_RF)))

m4=data.frame(Log2_PEN_RF, Log2_PEN)
fit <- lm(Log2_PEN ~ Log2_PEN_RF, data = m4)
summary(fit)

ggplot(m4, aes(x = Log2_PEN_RF, y = Log2_PEN)) + 
  geom_jitter(width = 0.25, height = 0.25) +
  labs(title = paste("Adj R2 = ",signif(summary(fit)$adj.r.squared, 2)))





