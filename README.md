# 📚 Repositório de Estudos — 2026.2

> ## ⚠️ AVISO IMPORTANTE ANTES DE COMMITAR
> **NÃO dê `git add .` nem `git add -A`!**
> Isso sobe TUDO que foi modificado no repositório, inclusive arquivo de matéria que não é seu e coisa que você nem quis mexer (e ainda gera conflito pra galera).
>
> Adicione **só a pasta da matéria que você alterou**. Exemplo:
> ```bash
> git status                              # confere o que mudou antes de tudo
> git add "2026.2/Redes Neurais"          # adiciona só a pasta que você mexeu
> git commit -m "Redes Neurais: add aula sobre backpropagation"
> git push
> ```

---

## Sobre o repositório

Repositório de anotações e materiais de estudo do período **2026.2**, organizado por matéria em pastas dentro de `2026.2/`.

## ✅ Matérias já estudadas

## 🧠 Redes Neurais

- [x] 1. Funcionalidades do neurônio biológico
- [x] 2. Neurônio artificial de McCulloch-Pitts (MP)
- [x] 3. Análise geométrica do neurônio MP
- [x] 4. Portas lógicas AND, OR e NOT
- [x] 5. Rede Perceptron Simples (PS) e aplicações
- [x] 6. Problemas não-linearmente separáveis e a porta lógica XOR
- [x] 7. Implementação da porta lógica XOR via redes multicamadas
- [ ] 8. Rede Perceptron Multicamadas (MLP)
- [ ] 9. Algoritmo de retropropagação do erro (error backpropagation)
- [ ] 10. Dicas de treinamento, teste e validação da rede MLP

## Boas práticas de commit

- Só mexa/comite a pasta da sua matéria.
- Sempre rode `git status` antes de dar `add`, pra ver exatamente o que vai subir.
- Se aparecer arquivo de outra matéria que você não mexeu, NÃO dê add nele.
- Mensagens de commit objetivas: `"Matéria: o que foi adicionado/alterado"`.
