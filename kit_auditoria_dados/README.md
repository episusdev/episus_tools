# 📋 Kit de Relatório de Auditoria de Qualidade de Dados

Template Quarto parametrizado para auditoria reprodutível de bases de dados em saúde pública.

---

## Conteúdo do Kit

```
audit_kit/
├── template.qmd          # Template Quarto principal (parametrizado)
├── estilo.css            # Estilos visuais do relatório HTML
├── run_exemplo.R         # Script de instalação + renderização com um comando
├── regras_exemplo.csv    # Regras de validação configuráveis
└── R/
    ├── 01_carregar.R     # Carregamento e detecção automática de formato
    ├── 02_visao_geral.R  # Dimensões, tipos, completude global
    ├── 03_ausencia.R     # Análise de missingness (tabelas + gráficos)
    ├── 04_duplicatas.R   # Duplicatas exatas e por ID
    ├── 05_distribuicoes.R# Estatísticas numéricas e frequências categóricas
    ├── 06_dicionario.R   # Dicionário de dados automático
    ├── 07_regras.R       # Motor de validação por regras (CSV)
    └── 08_utilitarios.R  # Funções auxiliares de formatação
```

> **Nota:** os dados de exemplo (SINAN) não são versionados neste repositório por
> tamanho e confidencialidade. Coloque sua própria base nesta pasta e rode o kit
> normalmente — o `run_exemplo.R` espera o arquivo `Base_de_dados_transformada.csv`.

---

## Pré-requisitos

- **R** ≥ 4.2 → [https://cran.r-project.org](https://cran.r-project.org)
- **Quarto** ≥ 1.3 → [https://quarto.org/docs/get-started/](https://quarto.org/docs/get-started/)

---

## Início Rápido

### Opção 1 — Um comando (recomendado)

```r
source("run_exemplo.R")
```

Isso instala os pacotes necessários, renderiza o relatório com os dados de exemplo e o abre no navegador.

### Opção 2 — Linha de comando

```bash
quarto render template.qmd \
  -P data_path:Base_de_dados.csv \
  -P id_var:ID_MUNICIP \
  -P group_var:SG_UF_NOT
```

### Opção 3 — Com seus próprios dados

```bash
quarto render template.qmd \
  -P data_path:minha_base.csv \
  -P id_var:meu_id \
  -P group_var:minha_uf \
  -P rules_path:minhas_regras.csv
```

---

## Parâmetros

| Parâmetro     | Padrão                  | Descrição                                             |
|---------------|-------------------------|-------------------------------------------------------|
| `data_path`   | `Base_de_dados.csv`     | Caminho para o arquivo de dados (CSV ou XLSX)         |
| `id_var`      | `ID_MUNICIP`            | Nome da variável identificadora (para checar dup.)    |
| `group_var`   | `SG_UF_NOT`             | Variável de agrupamento para análise de ausência      |
| `rules_path`  | `regras_exemplo.csv`    | Caminho para o CSV de regras de validação             |
| `top_n_cat`   | `10`                    | Nível máximo exibido nas tabelas categóricas          |
| `titulo_base` | (nome genérico)         | Título descritivo da base para o relatório            |

---

## O Relatório Cobre

| Seção | Conteúdo |
|---|---|
| **Visão Geral** | Dimensões, tipos de variáveis, resumo skimr, completude |
| **Dados Ausentes** | Tabela com %, gráfico de barras, mapa vis_miss, ausência por grupo |
| **Duplicatas** | Exatas e baseadas em ID |
| **Distribuições Numéricas** | Estatísticas + detecção de outliers (IQR) + boxplots |
| **Frequências Categóricas** | Top-N níveis + bucket "Outros" |
| **Validação por Regras** | Range, valores permitidos, regex, not_null — com severidade |
| **Dicionário de Dados** | Gerado automaticamente com tipo, completude e exemplos |
| **Reprodutibilidade** | Timestamp + versão R + pacotes carregados |

---

## Configurando Regras de Validação

Crie um arquivo CSV com as colunas:

```
variavel,tipo,valor,severidade,descricao
```

### Tipos de Regras

| `tipo`           | `valor` (exemplo)         | Descrição                                 |
|------------------|---------------------------|-------------------------------------------|
| `range`          | `0,120`                   | Valor deve estar no intervalo [min, max]  |
| `allowed_values` | `M,F,I`                   | Valor deve estar na lista (separada por vírgula) |
| `regex`          | `^\d{6}$`                 | Valor deve corresponder à expressão regular |
| `not_null`       | *(vazio)*                 | Variável não pode ter valores ausentes    |

### Severidades

- `erro` → ❌ Falha crítica de qualidade
- `aviso` → ⚠️ Problema a revisar
- `info` → ℹ️ Observação informativa

---

## Saída

O relatório é gerado como **HTML autocontido** (`relatorio_auditoria.html`) — sem dependências externas, pronto para compartilhar por e-mail ou publicar na web.

---

## Referência de Variáveis (SINAN)

Consulte os arquivos:
- `Dicionário_de_variáveis.pdf`
- `DIC_DADOS_NETNotificaoIndividual_rev.pdf`

---

*Desenvolvido para epidemiologistas, analistas de saúde pública e equipes de dados que precisam de auditoria rápida e reprodutível.*
