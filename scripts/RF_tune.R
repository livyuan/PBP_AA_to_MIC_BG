cwd="/scicomp/groups/OID/NCIRD/DBD/RDB/Strep_Lab/External/share/PBP_AA_to_MIC/data/"
setwd(cwd)

libpath="/scicomp/home/yqh8/R/Rlib/"

library("randomForest",lib.loc=libpath)
library("mlbench", lib.loc=libpath)
library("caret", lib.loc=libpath)


set.seed(1001)

m1=read.csv("TableS1_Dataset1.csv", colClasses="character")
m1a=m1[, c(1, 3)]
head(m1a)
PEN=round(log2(as.numeric(m1$PEN)))
m1a$PEN=PEN

m2=read.csv("TableS3_Dataset1_PBP_AAtable.csv", colClasses="character")

m3=merge(m1a, m2, by="LABID")
dim(m3)
m3=m3[!is.na(m3$PEN),]

m3[1, 1:4]
m3a=m3[, -1]
m3a[1, 1:4]
x=m3a[, -1]
y=as.numeric(m3a[,1])

x2=NULL
for (j1 in 1:dim(x)[2]) {
  if(length(unique(x[, j1]))>1) {x2=c(x2, j1)} 
}
xa=x[, x2]

m4=cbind(PEN=y, xa)

 # 10-fold CV
control <- trainControl(method="repeatedcv", number=10, repeats=3)
metric <- "Rsquared"
mtry <- (ncol(xa)/3)
tunegrid <- expand.grid(.mtry=mtry)
rf_default <- train(PEN~., data=m4, method="rf", metric="Rsquared", tuneGrid=tunegrid, trControl=control)
print(rf_default)
save(rf_default, file="RF_tune_rf_default")

 # Random Search mtry
control <- trainControl(method="repeatedcv", number=10, repeats=3, search="random")
set.seed(1001)
metric <- "Rsquared"
rf_random <- train(PEN~., data=m4, method="rf", metric=metric, tuneLength=15, trControl=control)
save(rf_random, file="RF_tune_rf_random")

load("RF_tune_rf_random")
print(rf_random)
plot(rf_random)

 # Random Search ntree
set.seed(1001)
metric <- "Rsquared"
ntree=5*dim(m4)[1]
tunegrid <- expand.grid(.ntree=ntree)

control <- trainControl(method="repeatedcv", number=5, repeats=1, search="random")
rf_random <- train(PEN~., data=m4, method="rf", metric=metric, tuneGrid=tunegrid, tuneLength=5, trControl=control)
save(rf_random, file="RF_tune_rf_random_ntree")

load("RF_tune_rf_random_ntree")
print(rf_random)
plot(rf_random)


 




























m1=read.csv("TableS3_Dataset1_PBP_AAtable.csv", colClasses="character")
m1$DS=1

m2=read.csv("TableS4_Dataset2_PBP_AAtable.csv", colClasses="character")
m2$DS=2

m3=rbind(m1, m2)
head(m3)
colnames(m3)
m3a=m3[, -c(1, 916)]
dim(m3a)
m3b=as.matrix(m3a)
m3c=as.data.frame(m3b, stringsAsFactors=T)

library("cluster", lib.loc=libpath)
dis1=daisy(m3c, metric ="gower")
save(dis1, file="tsne_dis1")

library("tsne", lib.loc=libpath)
t1=tsne(dis1)
save(t1, file="tsne_t1")

load("tsne_t1")

m4=data.frame(tSNE1=t1[, 1], tSNE2=t1[, 2], DS=factor(m3$DS))

library("ggplot2", lib.loc=libpath)
p1=ggplot(m4, aes(x=tSNE1, y=tSNE2, color=DS)) + geom_point()

ggsave(filename="tsne_plot.pdf", plot=p1)
