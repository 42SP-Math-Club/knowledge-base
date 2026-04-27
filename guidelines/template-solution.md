# [Nome do Problema]

> **Plataforma / Fonte:** Project Euler #1 / CSES / Sessão do clube / ...
> **Área:** Lógica · Matemática Discreta · Álgebra · Probabilidade · Algoritmos
> **Dificuldade:** Fácil · Médio · Difícil
> **Data:** AAAA-MM-DD
> **Autor:** login42

---

## Problema

Descreva o problema com suas próprias palavras. O que é dado? O que se pede?

> **Exemplo**
> Dado um inteiro $n$, encontre a soma de todos os múltiplos de 3 ou 5 menores que $n$.

---

## Análise

Que padrões você identificou antes de resolver? Que abordagens foram tentadas e descartadas?

---

## Solução

Explique o raciocínio central passo a passo.

$$
\text{soma} = \frac{k(k+1)}{2}
$$

```c
int	sum_multiples(int n)
{
    int sum = 0;
    for (int i = 1; i < n; i++)
        if (i % 3 == 0 || i % 5 == 0)
            sum += i;
    return (sum);
}
```

---

## Conceitos Utilizados

- Aritmética modular
- Progressão aritmética
- ...

---

## Aprendizados

O que esse problema ensinou? Que erro atrasou a solução?

---

## Referências

- [Nome do recurso](https://...)
