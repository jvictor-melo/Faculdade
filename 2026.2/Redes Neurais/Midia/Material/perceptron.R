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

# ============================================================
# CONFIGURANDO O DIRETORIO
# ============================================================

setwd('/home/user/Documentos/UNINASSAU/2026-2/Redes neurais artificiais/codigos/')

# ============================================================
# FUNCOES AUXILIARES
# ============================================================
source('psrule.R')          # regra do perceptron simples
source('psruleMC.R')        # regra do perceptron multiclasse
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

#dados=read.table('coluna_vertebral_2_classe.csv',header = TRUE,sep = ',')
#X <- as.matrix(dados[,c(1:6)])
#Y <- as.matrix(dados[,c(8)])

# COLUNA VERTEBRAL - 3 CLASSES

dados=read.table('coluna_vertebral_3_classe.csv',header = TRUE,sep = ';')
X <- as.matrix(dados[,c(1:6)])
Y <- as.matrix(dados[,c(9:11)])

# IONOSFERA
#X <- as.matrix(read.table("ionosfera-input.txt"))
#Y <- as.matrix(read.table("ionosfera-output.txt"))

# WINE (terroir)
# X <- as.matrix(read.table("wine-input.txt"))
# Y <- as.matrix(read.table("wine-output.txt"))

# YALE 1
# X <- as.matrix(read.table("yale1-input.txt"))
# Y <- as.matrix(read.table("yale1-output.txt"))


# ============================================================
# DIMENSÕES DOS DADOS
# ============================================================

din <- dim(X)
dout <- dim(Y)

d <- din[2]      # Número de atributos
n <- din[1]      # Número de exemplos

k <- dout[2] # Número de classes


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


# Normalização para [-1, 1]
# X <- (X - apply(X, 1, min)) /
#      (apply(X, 1, max) - apply(X, 1, min))

# X <- 2 * X - 1


# ============================================================
# CONVERSÃO DOS RÓTULOS
# ============================================================

# Troca 0 por -1
# Y[Y == 0] <- -1 só usar isso aqui no caso binario


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
Pclasseps=matrix(,Nr,k)

for (r in 1:Nr) {
  
  cat("Rodada:", r, "\n")
  
  I <- sample(1:n)
  
  # ----------------------------------------------------------
  # BINARIO OU MULTICLASSE?
  # ----------------------------------------------------------
  
  if(k==1)
  {
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
  }else{
    
    # ----------------------------------------------------------
    # EMBARALHAMENTO DOS DADOS
    # ----------------------------------------------------------
    
    X <- X[I, ]
    Y <- Y[I,]
    
    # ----------------------------------------------------------
    # SEPARAÇÃO TREINO / TESTE
    # ----------------------------------------------------------
    
    Xtrn <- X[1:Ntrn, ]
    Ytrn <- Y[1:Ntrn,]
    
    Xtst <- X[(Ntrn + 1):n, ]
    Ytst <- Y[(Ntrn + 1):n,]
    
  }
  
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
  
  W <- psruleMC(
    W0,
    Xtrn,
    Ytrn,
    Nep,
    lr
  )
  
  
  # ----------------------------------------------------------
  # PREDIÇÃO
  # ----------------------------------------------------------
  
  Ypred_tst <-sign(Xtst %*% W$pesos)# ifelse(Xtst %*% W$pesos >0,1,0) #
  
  # ----------------------------------------------------------
  # ACERTOS GLOBAIS
  # ----------------------------------------------------------
  
 # Nglobalps[r] <- evalclassifier1(
 #   Ytst,
 #   Ypred_tst,
  #  Ntst
 # )
  
 # Pglobalps[r] <- 100 * Nglobalps[r] / Ntst
  
  # ----------------------------------------------------------
  # ACERTOS POR CLASSE
  # ----------------------------------------------------------
  
  resultado <- evalclassifier2(
    Ytst,
    Ypred_tst
  )
  
  Nclasses <- resultado$Nacertos
  Ntotal <- resultado$Nexemplos
  
  
  Pclasseps[r,] <- 100 * Nclasses * (1 / Ntotal)
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
plot(W$Pglobal,type = 'l',main = 'Acerto global')

plot(W$Pclasse[,1],type = 'l',main = 'Acerto por classe',ylim=c(0,100))
lines(W$Pclasse[,2],type='l',col=2)
lines(W$Pclasse[,3],type='l',col=3)

legend("bottomright",
       legend = c("Classe 1", "Classe 2", "Classe 3"),
       col = c(1, 2, 3),
       lty = 1)

plot(W$erro,type = 'l',main = 'erro')
