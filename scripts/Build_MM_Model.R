
Build_MM_Model<- function(train_file, cwd)
{

  #train_file="/scicomp/home/yqh8/PBP_MIC/db/PBP_2528_14-MIC-AAtable.csv"
  #cwd="/scicomp/groups/OID/NCIRD/DBD/RDB/Strep_Lab/External/share/PBP_AA_to_MIC/newDB/"
  setwd(cwd)
  
  m3=read.csv(train_file, colClasses="character")
  t1=data.frame(PT=unique(m3$PT))
  BLAclass=c("PEN", "AMO", "MER", "TAX", "CFT", "CFX")
  #k1=BLAclass[1]

  for (k1 in BLAclass)
  {
    m1=m3
    m1=m1[!is.na(m1[k1]), ]
    t2=table(m1$PT, unlist(m1[k1]))
    x0=as.numeric(colnames(t2))
    t2=t2[, order(x0)]
    x1=colnames(t2)
    x2=rownames(t2)
    x3=1:length(x1)
    wPEN=NULL
    for (j1 in 1:dim(t2)[1])
    {
      x4=rev(t2[j1,])
      wPEN=c(wPEN, names(which(max(x4)==x4))[1])
    }
    t3=cbind(PT=x2, wPEN)
    t1=merge(t1, t3, all.x=T)
    colnames(t1)[dim(t1)[2]]=k1
  }

  colnames(t1)[1]="APT"
  write.csv(t1, "Ref_PBPtype_MIC.csv", row.names=F)

}

args <- commandArgs(TRUE)
train_file = args[1]
cwd = args[2]

#print (c(train_file, cwd))
Build_MM_Model(train_file, cwd)

