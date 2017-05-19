## FDA631 evaluation Figures
## Figure 3
library(ggplot2)
library(scales) 
library(Rmisc)
library("GGally")

setwd("C:/Users/YQH8/Desktop/201607/PBP2/Data/")
BLAclass=c("PEN", "AMO", "MER", "TAX", "CFT", "CFX")
BKclass0=c(0.06, 	2, 0.25, 0.5, 1, 0.5)
BKclass1=c(1, 	4, 0.5,  1,   2,   1)
BKclass2=c(2, 	8, 1,    2,   4,   2)

m4=read.csv("C:/Users/YQH8/Desktop/201607/PBP2/Data/Eval_Dataset2All.csv", colClasses="character")
  #output file from the "Eva-MIC-Dataset2All.R" script

head(m4)
m4=m4[-(grep("_EN", m4$X)),]
dim(m4)

plots <- list()

x1=m4[, 4] # pEA
x2=unlist(strsplit(x1, split=" "))
AUC=as.numeric(x2[2*(1:12)-1])
x2.2=x2[2*(1:12)]
x2.3=gsub('(', "", x2.2, fixed=T)
x2.4=gsub(')', "", x2.3, fixed=T)
x2.5=unlist(strsplit(x2.4, split="-"))
LCL=as.numeric(x2.5[2*(1:12)-1])
UCL=as.numeric(x2.5[2*(1:12)])

df2=data.frame(DRUG=rep(BLAclass, each=2), 
	Method=rep(c("MM", "RF"),6),
 	AUC, LCL, UCL)
df2$Method=factor(df2$Method, levels=c("MM", "RF"))
df2$DRUG=factor(df2$DRUG, levels=BLAclass)

sp= ggplot(df2, aes(x=DRUG, y=AUC, fill = Method)) +   
  geom_bar(position = "dodge", stat="identity")+
  geom_errorbar(data=df2, aes(ymin=LCL, ymax=UCL), 
      width=0.2, size=1, color="black", position=position_dodge(.9)) 

sp=sp+scale_y_continuous(breaks=c(0, 25, 50, 75, 90, 100), expand = c(0, 0))
sp=sp+geom_hline(aes(yintercept=c(90)), linetype="dashed")

sp3=sp+xlab("Antibiotics")+ylab("% Essential Agreement")
sp3=sp3+theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(), 
    	panel.grid.minor = element_blank(), 
	axis.line.x = element_line(colour = "black"),
      axis.line.y = element_line(colour = "black"),
	axis.text.x=element_text(size=12,face="bold"),
	axis.text.y=element_text(size=12,face="bold"),
	axis.title.x=element_text(size=14,face="bold"),
	axis.title.y=element_text(size=14,face="bold"))


plots[[1]]=sp3
#
x1=m4[, 6] # pCA
x2=unlist(strsplit(x1, split=" "))
AUC=as.numeric(x2[2*(1:12)-1])
x2.2=x2[2*(1:12)]
x2.3=gsub('(', "", x2.2, fixed=T)
x2.4=gsub(')', "", x2.3, fixed=T)
x2.5=unlist(strsplit(x2.4, split="-"))
LCL=as.numeric(x2.5[2*(1:12)-1])
UCL=as.numeric(x2.5[2*(1:12)])

df2=data.frame(DRUG=rep(BLAclass, each=2), 
	Method=rep(c("MM", "RF"),6),
 	AUC, LCL, UCL)
df2$Method=factor(df2$Method, levels=c("MM", "RF"))
df2$DRUG=factor(df2$DRUG, levels=BLAclass)

sp= ggplot(df2, aes(x=DRUG, y=AUC, fill = Method)) +   
  geom_bar(position = "dodge", stat="identity")+
  geom_errorbar(data=df2, aes(ymin=LCL, ymax=UCL), 
      width=0.2, size=1, color="black", position=position_dodge(.9)) 

sp=sp+scale_y_continuous(breaks=c(0, 25, 50, 75, 90, 100), expand = c(0, 0))
sp=sp+geom_hline(aes(yintercept=c(90)), linetype="dashed")

sp3=sp+xlab("Antibiotics")+ylab("% Category Agreement")
sp3=sp3+theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(), 
    	panel.grid.minor = element_blank(), 
	axis.line.x = element_line(colour = "black"),
      axis.line.y = element_line(colour = "black"),
	axis.text.x=element_text(size=12,face="bold"),
	axis.text.y=element_text(size=12,face="bold"),
	axis.title.x=element_text(size=14,face="bold"),
	axis.title.y=element_text(size=14,face="bold"))

plots[[2]]=sp3

#
x1=m4[, 12] # maj
x2=unlist(strsplit(x1, split=" "))
AUC=as.numeric(x2[2*(1:12)-1])
x2.2=x2[2*(1:12)]
x2.3=gsub('(', "", x2.2, fixed=T)
x2.4=gsub(')', "", x2.3, fixed=T)
x2.5=unlist(strsplit(x2.4, split="-"))
LCL=as.numeric(x2.5[2*(1:12)-1])
UCL=as.numeric(x2.5[2*(1:12)])

df2=data.frame(DRUG=rep(BLAclass, each=2), 
	Method=rep(c("MM", "RF"),6),
 	AUC, LCL, UCL)
df2$Method=factor(df2$Method, levels=c("MM", "RF"))
df2$DRUG=factor(df2$DRUG, levels=BLAclass)

df2$AUC=df2$AUC+0.01

sp= ggplot(df2, aes(x=DRUG, y=AUC, fill = Method)) +   
  geom_bar(position = "dodge", stat="identity")+
  geom_errorbar(data=df2, aes(ymin=LCL, ymax=UCL), 
      width=0.2, size=1, color="black", position=position_dodge(.9)) 
#sp=sp+scale_y_continuous(breaks=c(0, 3, 5, 10), limit=c(0, 30))
sp=sp+scale_y_continuous(breaks=c(0, 1:10), limit=c(0, 10), expand = c(0, 0))
sp=sp+geom_hline(aes(yintercept=c(3)), linetype="dashed")


sp3=sp+xlab("Antibiotics")+ylab("% major discrepancy")
sp3=sp3+theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(), 
    	panel.grid.minor = element_blank(), 
	axis.line.x = element_line(colour = "black"),
      axis.line.y = element_line(colour = "black"),
	axis.text.x=element_text(size=12,face="bold"),
	axis.text.y=element_text(size=12,face="bold"),
	axis.title.x=element_text(size=14,face="bold"),
	axis.title.y=element_text(size=14,face="bold"))+
	annotate("text", x = 1:6, y = 8, label = m4[2*(1:6),10], size=5)

plots[[3]]=sp3
#
x1=m4[, 9] # vmj
x2=unlist(strsplit(x1, split=" "))
AUC=as.numeric(x2[2*(1:12)-1])
x2.2=x2[2*(1:12)]
x2.3=gsub('(', "", x2.2, fixed=T)
x2.4=gsub(')', "", x2.3, fixed=T)
x2.5=unlist(strsplit(x2.4, split="-"))
LCL=as.numeric(x2.5[2*(1:12)-1])
UCL=as.numeric(x2.5[2*(1:12)])

df2=data.frame(DRUG=rep(BLAclass, each=2), 
	Method=rep(c("MM", "RF"),6),
 	AUC, LCL, UCL)
df2$Method=factor(df2$Method, levels=c("MM", "RF"))
df2$DRUG=factor(df2$DRUG, levels=BLAclass)

df2$AUC=df2$AUC+0.01

sp= ggplot(df2, aes(x=DRUG, y=AUC, fill = Method)) +   
  geom_bar(position = "dodge", stat="identity")+ 	
  geom_errorbar(data=df2, aes(ymin=LCL, ymax=UCL), 
      width=0.2, size=1, color="black", position=position_dodge(.9)) 

sp=sp+geom_hline(aes(yintercept=c(1.5)), linetype="dashed")
sp=sp+geom_hline(aes(yintercept=c(7.5)), linetype="dashed")
sp=sp+scale_y_continuous(breaks=c(1.5, 7.5, 15, 20, 40, 60, 80, 100), limit=c(0, 100), expand = c(0, 0))

sp3=sp+xlab("Antibiotics")+ylab("% very major discrepancy")
sp3=sp3+theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(), 
    	panel.grid.minor = element_blank(), 
	axis.line.x = element_line(colour = "black"),
      axis.line.y = element_line(colour = "black"),
	axis.text.x=element_text(size=12,face="bold"),
	axis.text.y=element_text(size=12,face="bold"),
	axis.title.x=element_text(size=14,face="bold"),
	axis.title.y=element_text(size=14,face="bold"))+
	annotate("text", x = 1:6, y = 50, label = m4[2*(1:6),7], size=5)

plots[[4]]=sp3
multiplot(plotlist = plots[1:4], layout=matrix(1:4, nrow=2, byrow=T))

## End of FDA631 evaluation Figures

