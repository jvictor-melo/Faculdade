psrule <- function(W0, Xtrn, Ytrn, Nep, lr) {
  
  # Dimensões da matriz de treinamento
  n <- dim(Xtrn)
  
  # Inicialização dos pesos
  W <- W0
  
  Pglobal=matrix(,Nep,1)
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
      
      # Predição para o exemplo t
      Ypred_trn <- sign(t(W) %*% Xtrn[t,]) #ifelse(t(W) %*% Xtrn[t,]>0,1,0) # sign(t(W) %*% Xtrn[t,])
      
      # Erro
      erro <- Ytrn[t] - as.numeric(Ypred_trn)
      
      # Variação dos pesos
      DeltaW <- erro*Xtrn[t,]
      
      # Atualização dos pesos
      W <- W + lr * DeltaW
      print(t)
    }
    
    # --------------------------------------------------------
    # Avaliação do modelo na época k
    # --------------------------------------------------------
    
    # Predições para todo o conjunto de treinamento
    Ypred_trn <-sign(Xtrn%*%W) #ifelse(Xtrn %*%W >0,1,0) # sign(W %*% Xtrn)
    
    # Número de acertos
    Nglobal <- evalclassifier1(
      Ytrn,
      Ypred_trn,
      n[1]
    )
    
    # Taxa de acerto
    Pglobal[k] <- 100 * Nglobal / n[1]
    
    erro = W-Wold
    
    condicao[k] = sqrt(sum(diag(t(erro)%*%erro)))
    
    if(condicao[k]<=0.001)
    {
      break
    }
  }
  
  # Retorna a matriz de pesos
  return(list(pesos=W,ACepoca=Pglobal,erro=condicao))
}