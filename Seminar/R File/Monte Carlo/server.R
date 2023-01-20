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

server <- function(input, output) {
  output$tsplot<-renderPlot({
    data<-input$data
    if(is.null(data)){return()}
    file<-read.csv(data$datapath,header = T ,sep ='\t')
    x<-file[,1]
    ts.plot(x,main="Closing price",col="red",xlab="period",ylab="data")
  })
  output$descriptive<-renderPrint({
    data<-input$data
    if(is.null(data)){return()}
    file<-read.csv(data$datapath,header = T ,sep ='\t')
    x<-file[,1]
    cat("=======================\n")
    cat("descriptive statistics\n")
    cat("=======================\n")
    cat("mean =",mean(x),"\n")
    cat("variance =",var(x),"\n")
    cat("max =",max(x),"\n")
    cat("min =",min(x),"\n")
    cat("=======================\n")
  })
  output$data<-renderPrint({
    data<-input$data
    if(is.null(data)){return()}  
    file<-read.csv(data$datapath,header = T ,sep ='\t')
    x<-file[,1]
    stock=matrix(x,ncol=1)
    cat("=======================\n")
    cat("Closing price\n")
    cat("=======================\n")
    print(stock)
    cat("=======================\n")
    
  })
  output$ret<-renderPrint({
    data<-input$data
    if(is.null(data)){return()}
    file<-read.csv(data$datapath,header = T ,sep ='\t')
    x<-file[,1]
    n=length(x)
    return_stock=rep(0,n-1)
    for(i in 2:n)
    {
      return_stock[i]=log(x[i]/x[i-1])
    }
    returnstock=matrix(return_stock,ncol=1)
    cat("=======================\n")
    cat("Return of the stock\n")
    cat("=======================\n")
    print(returnstock)
    cat("=======================\n")
  })
  output$normality<-renderPrint({
    data<-input$data
    if(is.null(data)){return()}
    file<-read.csv(data$datapath,header = T ,sep ='\t')
    x<-file[,1]
    n=length(x)
    return_stock=rep(0,n-1)
    for(i in 2:n)
    {
      return_stock[i]=log(x[i]/x[i-1])
    }
    returnstock=matrix(return_stock,ncol=1)
    cat("=============================\n")
    cat("Normally test\n")
    cat("=============================\n")
    ks=ks.test(returnstock, "pnorm")
    print(ks)
    cat("=============================\n")
    cat("Hypothesis\n")
    cat("H0: returns are normally distributed\n")
    cat("H1: returns are not normally distributed\n")
    cat("critical area: reject H0 if p-value<0.05\n")
    cat("statistical test: p-value=",ks$p.value,"\n")
    if(ks$p.value<0.05){
      cat("Conclusion: returns are not normally distributed\n")}
    else{cat("Conclusion: returns are normally distributed\n")}
  })
  observeEvent(input$calculation,{
    data<-input$data
    if(is.null(data)){return()}
    file<-read.csv(data$datapath,header = T ,sep ='\t')
    x<-file[,1]
    n=length(x)
    return_stock=rep(0,n-1)
    for(i in 2:n)
    {
      return_stock[i]=log(x[i]/x[i-1])
    }
    Wo<-as.numeric(input$w)
    m<-as.numeric(input$N)
    output$VAR<-renderPrint({VaR_MC(return_stock,m,Wo)})
    output$interpretation<-renderPrint({
      cat("the average VaR value above according to the level of confidence and frequency that you input shows the maximum loss in one period ahead.\n")})
  })
}
