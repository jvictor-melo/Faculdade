evalclassifier1 <- function(Ytst, Ypred, Ntst) {
  
  Nacertos <- 0
  
  Nclasse=dim(Ypred)
  
  if(Nclasse[2]==1)
  {
    for (k in 1:Ntst) {
      if (Ypred[k] == Ytst[k]) {
       Nacertos <- Nacertos + 1
      }
    }
  }else{
    for (k in 1:Ntst) {
      
      Imax_pred <- which.max(Ypred[k])
      Imax_real <- which.max(Ytst[k])
      
      if (Imax_pred == Imax_real) {
        Nacertos <- Nacertos + 1
      }
    }
  }
 
  
  return(Nacertos)
}