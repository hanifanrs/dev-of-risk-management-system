VaR.MC=function(x,Wo=1,n=1000,alpha=c(0.01,0.025,0.05,0.1),k=1) 
{
  x=as.matrix(x)
  n.data=dim(x)[1]
  
  Mean.Rt=mean(x)
  Sigma.Rt=sd(x)
  return.sim=rnorm(n,Mean.Rt,Sigma.Rt)  
  Rstar=quantile(return.sim,alpha) 
  VaR=Wo*Rstar*sqrt(k)
  view=as.matrix(t(VaR))
  colnames(view)=paste(((1-alpha)*100),"%",sep="")
  rownames(view)=""
  return(view)
  
}

VaR_MC=function(x,m,Wo)
{
  VaR.MC=matrix(NA,m,4)
  for(i in 1:m)
  {
    VaR.MC[i,1]=VaR.MC(x,Wo)[1]
    VaR.MC[i,2]=VaR.MC(x,Wo)[2]
    VaR.MC[i,3]=VaR.MC(x,Wo)[3]
    VaR.MC[i,4]=VaR.MC(x,Wo)[4]
  }
  VaR.MC
  y=colMeans(VaR.MC)
  mean=as.matrix(t(y))
  cat("=================================================================","\n") 
  cat("VaR values with Monte Carlo Simulation for confidence levels: \n")
  cat("=================================================================","\n")
  cat("     99%     97.5%     95%     90%     \n")
  cat("=================================================================","\n")
  print(VaR.MC)
  colnames(mean)=paste(((1-c(0.01,0.025,0.05,0.1))*100),"%",sep="")
  rownames(mean)=""
  cat("=================================================================","\n")
  cat("Average VaR value with ",m,"times for confidence level: \n")
  return(mean)
}