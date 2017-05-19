setwd("C:/Users/YQH8/Desktop/201607/PBP2/Data")

set.seed(1001)
f1="C:/Users/YQH8/Desktop/201607/PBP2/Submission/BMCgenomics/R1/Data/TableS1_Dataset1.csv"
m1=read.csv(f1, colClasses="character")
head(m1)

PEN=round(log2(as.numeric(m1$PEN)))
PEN_RAND=PEN[sample(1:length(PEN), length(PEN))]
cor.test(PEN, PEN_RAND)

library('ggplot2')

m4=data.frame(PEN_RAND, PEN)
fit <- lm(PEN ~ PEN_RAND, data = m4)
summary(fit)

ggplot(m4, aes(x = PEN_RAND, y = PEN)) + 
  geom_point() +
  stat_smooth(method = "lm", col = "red")+
  labs(title = paste("Adj R2 = ",signif(summary(fit)$adj.r.squared, 5),
                     "Intercept =",signif(fit$coef[[1]],5 ),
                     " Slope =",signif(fit$coef[[2]], 5),
                     " P =",signif(summary(fit)$coef[2,4], 5)))

#
f1="C:/Users/YQH8/Desktop/201607/PBP2/Submission/BMCgenomics/R1/Data/TableS1_Dataset1.csv"
m1=read.csv(f1, colClasses="character")
head(m1)

f2="C:/Users/YQH8/Desktop/201607/PBP2/Submission/BMCgenomics/R1/Data/Rand_test_PBPtype_MIC2_Prediction.csv"
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
m3a=m3a[!duplicated(m3a$PT), ]

m1c=m1[, c(2:3)]
m1c=m1c[!duplicated(m1c$PT), ]

m4=merge(m1c, m3a, by="PT")
dim(m4)
colnames(m4)[3]="PEN_RF_RAND"
m4$PEN_RF_RAND=round(log2(as.numeric(m4$PEN_RF_RAND)))
m4$PEN=round(log2(as.numeric(m4$PEN)))

plot(m4$PEN_RF_RAND, m4$PEN)


fit <- lm(PEN ~ PEN_RF_RAND, data = m4)
summary(fit)

ggplot(m4, aes(x = PEN_RF_RAND, y = PEN)) + 
  geom_point() +
  stat_smooth(method = "lm", col = "red")+
  labs(title = paste("Adj R2 = ",signif(summary(fit)$adj.r.squared, 5),
                     "Intercept =",signif(fit$coef[[1]],5 ),
                     " Slope =",signif(fit$coef[[2]], 5),
                     " P =",signif(summary(fit)$coef[2,4], 5)))


#
set.seed(1001)
f1="C:/Users/YQH8/Desktop/201607/PBP2/Submission/BMCgenomics/R1/Data/TableS1_Dataset1.csv"
m1=read.csv(f1, colClasses="character")
head(m1)

PEN=round(log2(as.numeric(m1$PEN)))
PEN_RF=round(log2(as.numeric(m1$PEN_MIC_RF)))
cor.test(PEN, PEN_RF)

library('ggplot2')

m4=data.frame(PEN_RF, PEN)
fit <- lm(PEN ~ PEN_RF, data = m4)
summary(fit)

ggplot(m4, aes(x = PEN_RF, y = PEN)) + 
  geom_point() +
  stat_smooth(method = "lm", col = "red")+
  labs(title = paste("Adj R2 = ",signif(summary(fit)$adj.r.squared, 5),
                     "Intercept =",signif(fit$coef[[1]],5 ),
                     " Slope =",signif(fit$coef[[2]], 5),
                     " P =",signif(summary(fit)$coef[2,4], 5)))








