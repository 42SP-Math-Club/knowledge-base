# Regras da Base de Conhecimento

Estas convenções garantem que o repositório seja navegável e útil para todos os membros, agora e no futuro.

---

## Onde Cada Coisa Vai

| Pasta | O que pertence aqui |
|---|---|
| `solutions/` | Solução completa e explicada de um problema |
| `problems/` | Problemas propostos, ainda sem solução |
| `techniques/` | Estratégias reutilizáveis (ex.: indução, substituição, contradição) |
| `explanations/` | Textos conceituais — o *porquê* de teoremas e ideias |
| `core-knowledge/` | Definições, axiomas e teoremas fundamentais |
| `resources/cheat-sheets/` | Resumos de fórmulas e regras para consulta rápida |
| `resources/study-materials/` | Leituras externas, links e referências curadas |

Cada pasta de conteúdo (`solutions/`, `problems/`) é organizada por área:
`logic/` · `discrete-math/` · `algebra/` · `probability/` · `algorithms/`

---

## Nomenclatura de Arquivos

- Use letras minúsculas, sem acentos, com hífens no lugar de espaços
- Inclua o número do problema quando houver (ex: `project-euler-001`)
- Seja descritivo: prefira `sieve-of-eratosthenes` a `primes`

```
solutions/
└── algorithms/
    ├── project-euler-001-multiples-3-5.md
    ├── cses-binary-search.md
    └── session-2026-04-21-strong-induction.md

problems/
└── algorithms/
    └── project-euler-001-multiples-3-5.md
```

---

## Estrutura de uma Entrada

Toda solução deve seguir o `template-solution.md`. Os campos obrigatórios são:

| Campo | Obrigatório |
|---|---|
| Nome do problema | ✅ |
| Plataforma / Fonte | ✅ |
| Área | ✅ |
| Dificuldade | ✅ |
| Data | ✅ |
| Autor (login42) | ✅ |
| Problema | ✅ |
| Solução | ✅ |
| Conceitos Utilizados | ✅ |
| Análise | ⬜ recomendado |
| Aprendizados | ⬜ recomendado |
| Referências | ⬜ opcional |

---

## Qualidade do Conteúdo

- **Explique, não apenas mostre.** Código sem raciocínio não ensina nada.
- **Escreva para quem não resolveu o problema.** A solução deve fazer sentido sem contexto externo.
- **Prefira clareza à elegância.** Um código legível vale mais que um one-liner obscuro.
- **Use LaTeX para fórmulas** quando o arquivo for referenciado no charter ou em materiais de sessão.

---

## O Que Não Pertence à Base

- Soluções copiadas sem explicação própria
- Rascunhos incompletos (salve localmente até estar pronto)
- Conteúdo não relacionado às áreas do clube

---

## Atualizações e Correções

Qualquer membro pode corrigir ou complementar uma entrada existente. Ao fazer isso:

1. Mantenha o autor original no campo **Autor**
2. Adicione uma linha ao final: `> Revisado por: login42 — AAAA-MM-DD`
