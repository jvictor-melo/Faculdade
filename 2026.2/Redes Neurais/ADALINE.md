O Modelo ADALINE é bem parecido com [[5. Perceptron Simples (PS)|Percepton Simples]]. 
No geral, o Modelo ADALINE (**ADA**ptive **LIN**ear **E**lement) é um modelo mais sensível ao erro. Porque? Ao invés de comparar o alvo (d) com a saída já decidida (y), ele compara com o valor bruto (u). 
$$\Huge e = d - u$$
Ai ele continua ajustando e ajustando mesmo depois de já ter classificado corretamente, Isso acaba trazendo pra nós um resultado bem mais próximo do desejado. 
O lado ruim é que o erro nunca chega em zero de fato, vai so diminuindo de pouco a pouco.

A maior diferença entre eles fica no calculo do **erro**.
O erro no **Perceptron Simples** utilizados a função sinal, onde:
$$
\Huge\begin{aligned}
\mathbf{y(t)} = sign(u(t) = \begin{bmatrix} 1, \text{ se } u(t) \ge 0\\ -1, \text{ se } u(t) < 0 \\ \end{bmatrix}
\end{aligned}
$$
Agora no **ADALINE** é diferente, ao invés de usarmos **y** no erro, usamos o próprio **u**.
Fica assim:
$$\Huge\begin{gathered}
\text{Erro do Perceptron: \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Erro no Adaline:}
\\ e = d - y \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ e = d - u
\end{gathered}$$
Outra mudança, só que essa é apenas visual, na formula da aprendizagem, no Perceptron Simples usamos eta, mas no ADALINE usamos alpha:
$$\Large\begin{gathered}
\text{Formula do Aprendizado:}\\
w(t+1) = w(t) + \Delta w(t) \\ \\
\text{No Perceptron: \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ No ADALINE: }
\\ w(t+1) = w(t) + \eta\cdot e(t) \cdot x(t) \ \ \ \ \ \ \ \ \ \ \ \ \ \ w(t+1) = w(t) + \alpha\cdot e(t) \cdot x(t)
\end{gathered}$$
E basicamente essas são as grandes mudanças:

Vou deixar aqui um exemplo que eu fiz pra vcs entenderem melhor:

![[2026.2/Redes Neurais/Desenhos/ADALINE|ADALINE]]
