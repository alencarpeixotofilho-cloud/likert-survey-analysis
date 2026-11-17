# Avaliação Institucional com Escalas Likert

![R](https://img.shields.io/badge/R-276DC3?style=flat-square&logo=r&logoColor=white) ![Python](https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white) ![Licença MIT](https://img.shields.io/badge/licen%C3%A7a-MIT-green?style=flat-square) ![Status](https://img.shields.io/badge/status-em%20constru%C3%A7%C3%A3o-orange?style=flat-square)

> Análise reprodutível de questionários de avaliação institucional e de avaliação docente.

## 📌 Visão geral

Processa respostas de questionários em escala Likert, calcula índices por dimensão, compara segmentos (cursos, períodos, ciclos) e gera gráficos e relatório. Segue as boas práticas de anonimato: resultados só são exibidos para grupos com número mínimo de respondentes.

## ✨ Funcionalidades

- Índices de satisfação por questão e por dimensão
- Gráficos de barras divergentes para escalas Likert
- Comparação entre segmentos e ciclos avaliativos
- Confiabilidade das dimensões (alfa de Cronbach)
- Supressão automática de grupos pequenos (proteção de anonimato)
- Relatório automatizado

## 🗂️ Estrutura do repositório

```text
avaliacao-institucional-likert/
├── R/              # indicadores, gráficos e relatório
├── questionarios/  # modelo de questionário (fictício)
├── exemplos/       # respostas sintéticas
├── LICENSE
└── README.md
```

## 🚀 Como usar

```r
source("exemplos/gerar_dados_exemplo.R")
source("R/relatorio.R")
```

## 🔒 Dados e privacidade

Este repositório **não contém dados reais** de estudantes, docentes ou instituições.
Todos os exemplos usam **dados sintéticos** gerados pelo próprio projeto
(`exemplos/gerar_dados_exemplo`), com identificadores fictícios (`Estudante 001`, `Item 001`…).
Os itens de prova usados nos exemplos são inventados para fins de demonstração.

## 🛣️ Roadmap

- [ ] Respostas sintéticas
- [ ] Índices por dimensão
- [ ] Gráficos Likert
- [ ] Regra de supressão de grupos
- [ ] Relatório final

## 📄 Licença

Distribuído sob a licença MIT. Veja [`LICENSE`](LICENSE).
