# ============================================================
# LIMPAR AMBIENTE
# ============================================================

rm(list=ls())# limpar a memoria do PC

# ============================================================
# PACOTES QUE SERAO UTILIZADOS
# ============================================================

#library('pracma')    # cálculos numéricos e métodos de matemática computacional
library('pROC')      # para calcular a curva ROC
library('DescTools')
library('caret')
library('readxl')
# ============================================================
# CONFIGURANDO O DIRETORIO
# ============================================================

setwd('/home/user/Documentos/UNINASSAU/2026-2/Redes neurais artificiais/codigos/')

# ============================================================
# FUNCOES AUXILIARES
# ============================================================
source('deltarule.R')          # regra do perceptron simples
# source('deltaruleMC.R')        # regra do perceptron multiclasse
source('evalclassifier1.R') # avaliar os classificadores (desempenho)
source('evalclassifier2.R') # avaliar o desempenho por classe

# ============================================================
# CONJUNTO DE DADOS
# ============================================================

# DERMATOLOGIA
# X <- as.matrix(read.table("dermato-input.txt"))
# Y <- as.matrix(read.table("dermato-output.txt"))

# GERMAN (crédito bancário)
# X <- as.matrix(read.table("german-input.txt"))
# Y <- as.matrix(read.table("german-output.txt"))

# COLUNA VERTEBRAL
# X <- as.matrix(read.table("/home/user/Downloads/coluna-input.txt"))
# Y <- as.matrix(read.table("/home/user/Downloads/coluna-output.txt"))

# COLUNA VERTEBRAL - 2 CLASSES

dados=read.table('coluna_vertebral_2_classe.csv',header = TRUE,sep = ',')
X <- as.matrix(dados[,c(1:6)])
Y <- as.matrix(dados[,c(8)])

# COLUNA VERTEBRAL - 3 CLASSES

#dados=read.table('coluna_vertebral_3_classe.csv',header = TRUE,sep = ';')
#X <- as.matrix(dados[,c(1:6)])
#Y <- as.matrix(dados[,c(9:11)])

# IONOSFERA
#X <- as.matrix(read.table("ionosfera-input.txt"))
#Y <- as.matrix(read.table("ionosfera-output.txt"))

# WINE (terroir)
# X <- as.matrix(read.table("wine-input.txt"))
# Y <- as.matrix(read.table("wine-output.txt"))

# YALE 1
# X <- as.matrix(read.table("yale1-input.txt"))
# Y <- as.matrix(read.table("yale1-output.txt"))

# COMPRESSAO DE CONCRETO
#dados=read_xls('Concrete_Data.xls',sheet=1,col_names=TRUE)
#X <-as.matrix(dados[,c(1:8)])
#Y <- as.matrix(dados[,c(9)])

# ============================================================
# DIMENSÕES DOS DADOS
# ============================================================

din <- dim(X)
dout <- dim(Y)

d <- din[2]      # Número de atributos
n <- din[1]      # Número de exemplos

k <- dout[2] # Número de classes

#k=1 # para regressao

# ============================================================
# CONFIGURAÇÃO TREINO/TESTE
# ============================================================

Ptrn <- 0.8                  # 80% para treinamento

Ntrn <- floor(Ptrn * n)     # Número de exemplos de treinamento

Ntst <- n - Ntrn            # Número de exemplos de teste

Nr <- 1                     # Número de rodadas independentes


# ============================================================
# PARÂMETROS DO TREINAMENTO
# ============================================================

lr <- 0.01                   # Taxa de aprendizagem

Nep <- 200                  # Número de épocas

# ============================================================
# NORMALIZAÇÃO (OPCIONAL)
# ============================================================

# Z-score
# X <- t(scale(t(X)))


# Normalização para [0, 1]
media <- apply(X, 2, mean)
desvio <- apply(X, 2, sd)

X <- sweep(X, 2, media, "-")
X <- sweep(X, 2, desvio, "/")

# X <- 2 * X - 1


# ============================================================
# CONVERSÃO DOS RÓTULOS
# ============================================================

# Troca 0 por -1
 Y[Y == 0] <- -1 # só usar isso aqui no caso binario


# ============================================================
# ADICIONAR BIAS Theta
# ============================================================

 X <- cbind(rep(1, n), X)
 d <- d + 1

# ============================================================
# SIMULAÇÃO MONTE CARLO
# ============================================================

Nglobalps=matrix(,nrow = Nr,ncol = 1)
Pglobalps=matrix(,nrow = Nr,ncol = 1)
#Pclasseps=matrix(,Nr,k)
#EQMglobalps=matrix(,nrow = Nr,ncol = 1)
 
for (r in 1:Nr) {
  
  cat("Rodada:", r, "\n")
  
  I <- sample(1:n)
  
  # ----------------------------------------------------------
  # BINARIO OU MULTICLASSE?
  # ----------------------------------------------------------
  
 # if(k==1)
 # {
    # ----------------------------------------------------------
    # EMBARALHAMENTO DOS DADOS
    # ----------------------------------------------------------
    
    X <- X[I, ]
    Y <- Y[I]
    
    # ----------------------------------------------------------
    # SEPARAÇÃO TREINO / TESTE
    # ----------------------------------------------------------
    
    Xtrn <- X[1:Ntrn, ]
    Ytrn <- Y[1:Ntrn]
    
    Xtst <- X[(Ntrn + 1):n, ]
    Ytst <- Y[(Ntrn + 1):n]
 # }else{
    
    # ----------------------------------------------------------
    # EMBARALHAMENTO DOS DADOS
    # ----------------------------------------------------------
    
  #  X <- X[I, ]
  #  Y <- Y[I,]
    
    # ----------------------------------------------------------
    # SEPARAÇÃO TREINO / TESTE
    # ----------------------------------------------------------
    
   # Xtrn <- X[1:Ntrn, ]
   # Ytrn <- Y[1:Ntrn,]
    
   # Xtst <- X[(Ntrn + 1):n, ]
   # Ytst <- Y[(Ntrn + 1):n,]
    
 # }
  
  # ----------------------------------------------------------
  # INICIALIZAÇÃO DOS PESOS
  # ----------------------------------------------------------
  
  W0 <- matrix(
    rnorm(k * d),
    nrow = d,
    ncol = k
  )
  
  
  # ----------------------------------------------------------
  # TREINAMENTO
  # ----------------------------------------------------------
  
  W <- deltarule(
    W0,
    Xtrn,
    Ytrn,
    Nep,
    lr
  )
  
  
  # ----------------------------------------------------------
  # ATIVACAO
  # ----------------------------------------------------------
    
    u_tst <- Xtst %*% W$peso
  
    
  # ----------------------------------------------------------
  # PREDIÇÃO
  # ----------------------------------------------------------
  
  #Ypred_tst <-u_tst #sign(u_tst)
  Ypred_tst<-sign(u_tst) #ifelse(Xtst %*% W$pesos >0,1,0) # classificacao
  
  # ----------------------------------------------------------
  # ACERTOS GLOBAIS
  # ----------------------------------------------------------
  
  Nglobalps[r] <- evalclassifier1(
    Ytst,
    Ypred_tst,
    Ntst
  )
  
  Pglobalps[r] <- 100 * Nglobalps[r] / Ntst
    
  EQMglobalps[r] <- sum((Ytst-Ypred_tst)^2)/(2*Ntst)
  
  # ----------------------------------------------------------
  # ACERTOS POR CLASSE
  # ----------------------------------------------------------
  
 # resultado <- evalclassifier2(
  #  Ytst,
  #  Ypred_tst
 # )
  
 # Nclasses <- resultado$Nacertos
 # Ntotal <- resultado$Nexemplos
  
  
 # Pclasseps[r,] <- 100 * Nclasses * (1 / Ntotal)
}


# ============================================================
# ESTATÍSTICAS DA TAXA DE ACERTO GLOBAL
# ============================================================

STATS <- c(
  mean(Pglobalps),
  sd(Pglobalps),
  median(Pglobalps),
  min(Pglobalps),
  max(Pglobalps)
)

names(STATS) <- c(
  "Média",
  "Desvio padrão",
  "Mediana",
  "Mínimo",
  "Máximo"
)

STATS
plot(W$EQMepoca,type = 'l',main = 'EQM')

# ============================================================
# REGRESSAO LINEAR MULTIPLA VS ADALINE
# ============================================================

dadosREGtrn=data.frame(Xtrn,Ytrn)
dadosREGtst=data.frame(Xtst,Ytst)

colnames(dadosREGtrn) <- c(paste0("X", 1:9),"Y")
colnames(dadosREGtst) <- c(paste0("X", 1:9),"Y")

modelo2=lm(Y~.,data = dadosREGtrn)

pred <- predict(modelo2, newdata = dadosREGtst)

erro <- dadosREGtst$Y - pred

mean(erro^2)

cbind(Ytst,Ypred_tst,pred) # comparando o observado com o previsto

# ============================================================
# RODAR ESSA PARTE DO CODIGO QUANDO FOR O MODELO MADALINE
# ============================================================

plot(W$Pglobal,type = 'l',main = 'Acerto global')

plot(W$Pclasse[,1],type = 'l',main = 'Acerto por classe',ylim=c(0,100))
lines(W$Pclasse[,2],type='l',col=2)
lines(W$Pclasse[,3],type='l',col=3)

legend("bottomright",
       legend = c("Classe 1", "Classe 2", "Classe 3"),
       col = c(1, 2, 3),
       lty = 1)

plot(W$EQMepoca,type = 'l',main = 'EQM')