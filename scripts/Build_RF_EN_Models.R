
Build_RF_EN_Models<- function(train_file, cwd)
{
  #train_file="/scicomp/home/yqh8/PBP_MIC/db/PBP_2528_14-MIC-AAtable.csv"
  #cwd="/scicomp/groups/OID/NCIRD/DBD/RDB/Strep_Lab/External/share/PBP_AA_to_MIC/newDB/"
  setwd(cwd)

  libpath="/scicomp/home/yqh8/R/Rlib/"
  library("methods")
  library("randomForest", lib.loc=libpath)
  library("iterators", lib.loc=libpath)
  library("foreach", lib.loc=libpath)
  library("Matrix")
  library("glmnet", lib.loc=libpath)
  
  BLAclass=c("PEN", "AMO", "MER", "TAX", "CFT", "CFX")
  BKclass1=c(0.06,  2, 0.25, 0.5,  0.5, 0.5)
  BKclass2=c(4,     4, 0.5,  1,    1,   1)

  m2=read.csv(train_file, colClasses="character")

  m3=m2[!duplicated(m2$PT), ]
  m3=m3[c("PT", colnames(m2)[9:925])]
  write.csv(m3, "train_PT_AA_table.csv", row.names=F)

  colAA=12:925
  m3=m2[, colAA]

  x1=NULL
  for (j1 in 1:dim(m3)[2])
  {
  if (length(unique(m3[,j1]))>1) {x1=c(x1, j1)}  
  }
  m3var=m3[, x1]
  write.csv(m3var, "Varsites_Randomforest.csv", row.names=F)
  m3var=read.csv("Varsites_Randomforest.csv", colClasses="factor")
  var2=m3var[!duplicated(m2$PT), ]
  write.csv(var2, file="NR_Varsites_Randomforest.csv", row.names=F)
    #save variable sites
  for (k1 in BLAclass)
  {
    print(paste("Building RF/EN models for", k1))
    m4=cbind(TMIC=round(log2(as.numeric(unlist(m2[k1])))), m3var)
    fit1 <- randomForest(TMIC~ . , data=m4, ntree=5*(dim(m4)[1]), na.action=na.omit)
    f1=paste(k1, "_RandomForestMIC", sep="")
    save(fit1, file=f1)
  
    xfactors <- model.matrix(TMIC ~ ., data=m4)[,-1]
    x1 <- as.matrix(data.frame(xfactors))
    y1=m4$TMIC[!is.na(m4$TMIC)]
    fit1 <- cv.glmnet(x1,y1, family="gaussian")
    f1=paste(k1, "_ElasticNetMIC", sep="")
    save(fit1, file=f1)

    m4$TMIC=factor(as.numeric(unlist(m2[k1]))>BKclass1[which(k1==BLAclass)])
    fit1 <- randomForest(TMIC~ . , data=m4, ntree=5*(dim(m4)[1]), na.action=na.omit)
    f1=paste(k1, "_RandomForestBK1", sep="")
    save(fit1, file=f1)

    xfactors <- model.matrix(TMIC ~ ., data=m4)[,-1]
    x1 <- as.matrix(data.frame(xfactors))
    y1=m4$TMIC[!is.na(m4$TMIC)]
    fit1 <- cv.glmnet(x1,y1, family="binomial", type.measure="auc")
    f1=paste(k1, "_ElasticNetBK1", sep="")
    save(fit1, file=f1)
  }
}

args <- commandArgs(TRUE)
train_file = args[1]
cwd = args[2]

print (c(train_file, cwd))
Build_RF_EN_Models(train_file, cwd)




