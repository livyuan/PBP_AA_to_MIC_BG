
#Function FDA631() required 2 inputs
# Input 1: data=matrix(nrow=n, ncol=2) containing the reference MIC (col 1) 
#	and the new MIC (col 2) for n isolates
# Input 2: SIR=c(m1, m2, m3) indicating the interpretive breakpoints:
#	S: MIC<=m1
#	I: m1<MIC<=m2
#	R: MIC>=m3   
#	If I is not an applicable interpretation  then set m2=NA  
#

#Function FDA631() returns a list containing two vectors
# The first one is a numeric vactor of 12 elements 
#corresponding to a row of TABLE 3 in FDA631
#	1 TT: Total tested
# 	2 nEA: number of essential agreement
# 	3 pEA: % essential agreement 
# 	4 TE: Total evaluable (excluding isolates with max or min reference MIC)
# 	5 nEAE: Number of essential agreement among TE
# 	6 pEAE: Number of essential agreement among TE
# 	7 nCA: number of category agreement 
# 	8 pCA: % category agreement 
# 	9 nR: number of resistant isolates
# 	10 nvmj: number of very major discrepancy
# 	11 nmaj: number of major discrepancy
# 	12 nmin: number of minor discrepancy
# The Second one is a character vector showing the point estimate and 95% CI for
#	pEA, pCA, pvmj, and pmaj.

FDA631<- function(data, SIR=c(0.06, NA, 0.12))
{
  x1=(as.numeric(data[, 1]))
  x2=(as.numeric(data[, 2]))
  df1=data.frame(refTMIC=round(log2(x1), 0),
	newTMIC=round(log2(x2), 0) )
  x1= (!is.na(df1[, 1])) & (!is.na(df1[, 2]))
  df1=df1[x1 , ]
  TT=dim(df1)[1]
  nEA= sum(abs(df1$refTMIC-df1$newTMIC)<=1, na.rm=T)
  pEA=round(100*nEA/TT, 1)
  LC=max(c(-5, min(df1$refTMIC, na.rm=T)))  
  UC=max(df1$refTMIC, na.rm=T)
  df2=subset(df1, refTMIC> LC & refTMIC<UC)
  TE=dim(df2)[1]
  nEAE= sum(abs(df2$refTMIC-df2$newTMIC)<=1, na.rm=T)
  pEAE=round(100*nEAE/TE, 1)   


  TSIR=round(log2(SIR))

  df1$refI=rep(NA, TT)
  df1$refI[df1$refTMIC<=TSIR[1]]="S"
  df1$refI[df1$refTMIC>=TSIR[3]]="R"
  if (!is.na(TSIR[2])) { df1$refI[df1$refTMIC>TSIR[1] & df1$refTMIC<=TSIR[2]]="I"} 

  df1$newI=rep(NA, TT)
  df1$newI[df1$newTMIC<=TSIR[1]]="S"
  if (is.na(TSIR[2])){df1$newI[df1$newTMIC>TSIR[1]]="R"} else {df1$newI[df1$newTMIC>TSIR[2]]="R"}
  if (!is.na(TSIR[2])) { df1$newI[df1$newTMIC>TSIR[1] & df1$newTMIC<=TSIR[2]]="I"} 
  
  nCA=sum(df1$refI == df1$newI, na.rm=T) 
  pCA=round(100*nCA/TT, 1)

  nR=sum(df1$refI=="R", na.rm=T) 
  nS=sum(df1$refI=="S", na.rm=T) 

  nvmj=sum( (df1$refI=="R") & (df1$newI=="S"), na.rm=T )
  nmaj=sum( (df1$refI=="S") & (df1$newI=="R"), na.rm=T)
  nmin=NA

  if (!is.na(TSIR[2])) 
  {
    nmin=sum( (df1$refI=="I") & (df1$newI !="I"), na.rm=T)
    nmin=nmin+sum( (df1$newI=="I") & (df1$refI !="I"), na.rm=T)
  }
  RT1=c(TT, nEA, pEA, TE, nEAE, pEAE, nCA, pCA, nR, nvmj, nmaj, nmin)
  
  names(RT1)=c("TT", "nEA", "pEA", "TE", "nEAE", "pEAE", 
			"nCA", "pCA", "nR", "nvmj", "nmaj", "nmin")

  RT2=c(as.character(TT), as.character(nEA))
  x1=binom.test(nEA, TT)
  x2=round(100*as.numeric(x1[[5]]),1)
  x3=round(100*as.numeric(x1[[4]]),1)
  RT2=c(RT2, paste(x2, " (", x3[1], "-", x3[2], ")", sep=""))

  RT2=c(RT2, as.character(nCA))
  x1=binom.test(nCA, TT)
  x2=round(100*as.numeric(x1[[5]]),1)
  x3=round(100*as.numeric(x1[[4]]),1)
  RT2=c(RT2, paste(x2, " (", x3[1], "-", x3[2], ")", sep=""))

  RT2=c(RT2, as.character(nR), as.character(nvmj))
  if (nR>0)
  {
    x1=binom.test(nvmj, nR)
    x2=round(100*as.numeric(x1[[5]]),1)
    x3=round(100*as.numeric(x1[[4]]),1)
    RT2=c(RT2, paste(x2, " (", x3[1], "-", x3[2], ")", sep=""))
  } else
  {
    RT2=c(RT2, "NA")
  }

  RT2=c(RT2, as.character(nS), as.character(nmaj))
  if ((nS) >0)
  {
    x1=binom.test(nmaj, (nS))
    x2=round(100*as.numeric(x1[[5]]),1)
    x3=round(100*as.numeric(x1[[4]]),1)
    RT2=c(RT2, paste(x2, " (", x3[1], "-", x3[2], ")", sep=""))
  } else
  {
    RT2=c(RT2, "NA")
  }

  names(RT2)=c("TT", "nEA", "pEA(95%CI)", "nCA", "pCA(95%CI)", "nR", 
			"nvmj", "pvmj(95%CI)", "nS", "nmaj", "pmaj(95%CI)")

  RL=list()
  RL[[1]]=RT1
  RL[[2]]=RT2
  
  return(RL)

}

