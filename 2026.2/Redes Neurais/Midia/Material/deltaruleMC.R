deltaruleMC <- function(W0, Xtrn, Ytrn, Nep, lr) {
  
  # Dimensões da matriz de treinamento
  n <- dim(Xtrn)
  K<- dim(Ytrn)[2] # numero de classe
  
  # Inicialização dos pesos
  W <- W0
  
  EQMglobal=matrix(,Nep,1)
  Pclasse=matrix(,Nep,K)
  condicao=matrix(,Nep,1)
  
  # Loop sobre as épocas
  for (k in 1:Nep) {
    
    # --------------------------------------------------------
    # Treinamento
    # --------------------------------------------------------
    cat("Epoca:", k, "\n")
    
    # --------------------------------------------------------
    # Caso queira apresentar aleatoriamente a ordem de apresentacao
    # --------------------------------------------------------
    
   # Iep <- sample(1:n[1]); Xtrn <- Xtrn[Iep, ]; Y <- Ytrn[Iep]
    
    Wold=W
    
    for (t in 1:n[1]) {
      
      # ativacao
      
      u<- t(W) %*% Xtrn[t,]
      
      # Predição para o exemplo t
      
      Ypred_trn <-u #sign(u) #ifelse(t(W) %*% Xtrn[t,]>0,1,0) # sign(t(W) %*% Xtrn[t,])
      
      # Erro
      erro <- Ytrn[t,] - Ypred_trn
      
      # Variação dos pesos
      DeltaW <- erro%*%t(Xtrn[t,])
      
      # Atualização dos pesos
      W <- W + lr * t(DeltaW)
    #  print(t)
    }
    
    # --------------------------------------------------------
    # Avaliação do modelo na época k
    # --------------------------------------------------------
    # ativacoes
    
    u_trn <- Xtrn%*%W
    
    # Predições para todo o conjunto de treinamento
    
   # Ypred_trn <- u_trn #sign(u_trn) #ifelse(Xtrn %*%W >0,1,0) # sign(W %*% Xtrn)
    
    # Predições para todo o conjunto de treinamento
    Ypred_trn <-ifelse(u_trn >0,1,0) # sign(Xtrn%*%W) #
    
    # Número de acertos
    Nglobal <- evalclassifier2(
      Ytrn,
      Ypred_trn
    )
    
    # Taxa de acerto
    Pglobal[k] <- 100 * sum(Nglobal$Nacertos) /sum(Nglobal$Nexemplos)
    
    Pclasse[k,]<-100 * Nglobal$Nacertos /Nglobal$Nexemplos
      
    # EQM para a epoca k
    
    erro_trn=(Ytrn-u_trn)
    
    EQMglobal[k] <- sum(erro_trn^2)/(2*n[1])
    
    if(EQMglobal[k]<=0.001)
    {
      break
    }
  }
  
  # Retorna a matriz de pesos
  return(list(pesos=W,Pglobal=Pglobal,EQMepoca=EQMglobal,Pclasse=Pclasse))
}