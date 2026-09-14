evalclassifier2 <- function(Ytst, Ypred) {
  
  n=dim(Ytst)
  Nexemplos=array(NA,c(n[2]))
  
  
  for (i in 1:n[2]) # contando o numero de exemplos de cada classe no conjunto de dados de teste
  {
    Nexemplos[i]=sum(Ytst[,i])
  }
  Nacertos=array(0,c(n[2])) # um vetor para contar o acerto por classe
  
  for(j in 1:n[1])
  {
    if(which.max(Ypred[j,])==which.max(Ytst[j,]))
    {
      ident=which.max(Ytst[j,])
      Nacertos[ident]=Nacertos[ident]+1
    }
  }
  
  return(list(Nacertos=Nacertos,Nexemplos=Nexemplos))
}