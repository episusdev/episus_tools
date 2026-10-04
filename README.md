# episus_tools

`episus_tools` é um pacote em R pensado para facilitar a rotina de análise epidemiológica, principalmente no contexto de saúde pública, vigilância, estudos descritivos e tabulação de indicadores. O pacote reúne funções úteis para:

- descrever variáveis de um banco de dados;
- construir tabelas de frequência e medidas de associação;
- formatar resultados para relatórios e artigos;
- avaliar consistência e completude dos dados;
- preparar estruturas de projeto e documentação de dados;
- produzir gráficos e análises rápidas em epidemiologia.

Ele foi concebido para uso prático em rotinas de análise de dados em saúde, com foco em facilidade de uso e produtividade.

---

## Instalação

Se você estiver trabalhando com o pacote diretamente do repositório GitHub, pode instalar assim:

```r
# Instala o pacote remotes, se necessário
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes")
}

# Instala o pacote do GitHub
remotes::install_github("episusdev/episus_tools")

# Carrega o pacote
library(episus_tools)
```

Se você estiver no próprio diretório do pacote em desenvolvimento, também pode usar:

```r
devtools::load_all()
library(episus_tools)
```

Para uma rotina mais completa de análise em R, também é comum usar:

```r
pacotes_uteis()
```

Essa função instala e carrega diversas bibliotecas úteis para estudos em saúde pública e análise de dados.

---

## Estrutura geral do pacote

O pacote reúne diferentes grupos de funções:

- utilitários de manipulação e organização;
- funções de análise descritiva;
- funções de tabelas cruzadas e medidas de associação;
- funções de formatação para apresentação dos resultados;
- funções para auditoria e qualidade de dados;
- função de tema visual para gráficos;
- funções para organização de um projeto de pesquisa.

---

## Principais funções do pacote

A seguir, uma visão geral das funções publicadas e exemplos práticos de uso.

## 1) Funções de organização de projeto

### `criar_pastas()`
Cria uma estrutura de pastas padrão para um projeto de análise em saúde, como:

- `bancos_brutos/`
- `dados_auxiliares/`
- `dados_tratados/`
- `dados_inter/`
- `resultados/`
- `resultados/descritivo/`
- `resultados/bivariada/`
- `resultados/multivariada/`
- `resultados/acuracia/`

Exemplo:

```r
library(episus_tools)

criar_pastas()
```

Isso ajuda a manter um fluxo organizado para dados, análise e resultados.

### `criar_dicionario()`
Cria um resumo das variáveis do banco, mostrando os primeiros valores únicos e o número total de categorias/valores distintos.

```r
banco <- data.frame(
  sexo = c("Feminino", "Masculino", "Feminino", "Masculino"),
  idade = c(25, 30, 42, 35),
  diabetes = c("Sim", "Nao", "Sim", "Nao")
)

cadastro <- criar_dicionario(banco)
print(cadastro)
```

Essa função é muito útil para documentar a base antes da análise.

### `pacotes_uteis()`
Instala e carrega uma série de pacotes comuns em análise de dados, ciência de dados e epidemiologia.

```r
pacotes_uteis()
```

Ela usa `pacman::p_load()` para carregar pacotes como `tidyverse`, `epitools`, `ggplot2`, `readxl`, `rio`, `sjPlot`, `janitor`, `gt`, entre outros, além de instalar pacotes específicos do Ministério da Saúde via GitHub.

---

## 2) Funções de manipulação e utilitários básicos

### `ASSIGN(x)`
Retorna o valor informado. Parece simples, mas pode ser útil em fluxos de programação ou em testes rápidos.

```r
ASSIGN(10)
# [1] 10
```

### `AUTONUMBER(n)`
Gera uma sequência numérica automática de 1 até `n`.

```r
AUTONUMBER(5)
# [1] 1 2 3 4 5
```

### `CHECK_IF_THEN(value)`
Aplica lógica simples condicional: se o valor é maior que 10, retorna `"High"`; caso contrário retorna `"Low"`.

```r
CHECK_IF_THEN(12)
# [1] "High"

CHECK_IF_THEN(7)
# [1] "Low"
```

### `COMMENT_LEGAL(value, legal_values)`
Verifica se um valor pertence ao conjunto permitido.

```r
COMMENT_LEGAL("Sim", c("Sim", "Nao"))
# [1] TRUE

COMMENT_LEGAL("Talvez", c("Sim", "Nao"))
# [1] FALSE
```

### `CREATE_FORM()`
Cria um data frame com estrutura básica para formulário de coleta.

```r
form <- CREATE_FORM()
str(form)
```

A estrutura padrão inclui colunas como `ID`, `Name`, `Age`, `Gender` e `Date`.

### `IS_REQUIRED(value)`
Retorna `TRUE` se o valor não for `NA` e `FALSE` se for ausente.

```r
IS_REQUIRED(42)
# [1] TRUE

IS_REQUIRED(NA)
# [1] FALSE
```

### `LIST(data)`
Mostra as primeiras linhas do data frame.

```r
LIST(iris)
```

### `SELECT(data, condition)`
Filtra linhas de um data frame usando uma condição textual.

```r
base <- data.frame(
  idade = c(20, 40, 60, 18),
  sexo = c("F", "F", "M", "F")
)

SELECT(base, "idade > 25")
```

### `SORT(data, variable)`
Ordena o data frame por uma coluna.

```r
base <- data.frame(
  id = c(3, 1, 2),
  idade = c(30, 20, 40)
)

SORT(base, "idade")
```

---

## 3) Funções de análise descritiva

### `FREQ(data, variable)`
Calcula frequências absolutas e percentuais de uma variável.

```r
FREQ(iris, "Species")
```

Saída esperada em formato de tabela com `n` e `perc`.

### `MEANS(data, variable)`
Calcula estatísticas resumidas de uma variável numérica: média, desvio-padrão, mediana, quartis, intervalo interquartílico, moda, quantidade de outliers e proporção de outliers.

```r
MEANS(iris, "Petal.Length")
```

É útil para explorar distribuições antes de construir tabelas ou gráficos.

### `PLOT(data, variable)`
Cria um gráfico de barras para uma variável discreta ou categórica.

```r
PLOT(iris, "Species")
```

### `SUMMARY(data)`
Resumo rápido de todas as variáveis do data frame. A ideia é dar uma visão geral rica da estrutura da base.

```r
SUMMARY(iris)
```

---

## 4) Funções de análise epidemiológica e de associação

### `TABLE(a, b, c, d)`
Cria uma tabela 2x2 e retorna OR e RR com base em `epitools`.

```r
res <- TABLE(50, 20, 30, 100)
res$oddsratio
res$riskratio
```

### `STATCALC(a, b, c, d)`
Função equivalente para cálculo rápido de medidas de associação. Também produz tabela 2x2 e retorna OR e RR.

```r
res <- STATCALC(50, 20, 30, 100)
res$oddsratio
res$riskratio
```

### `MATCH(case, control)`
Utilizada para estudos de caso-controle. É um wrapper para o cálculo de odds ratio em tabela 2x2.

```r
or <- MATCH(case = c(35, 65), control = c(20, 80))
print(or)
```

### `SAMPLE_SIZE(p1, p2, power = 0.8, alpha = 0.05)`
Calcula o tamanho amostral para comparação de duas proporções em estudo binário.

```r
SAMPLE_SIZE(p1 = 0.30, p2 = 0.20)
```

### `p_valor_z(x, n, prop = 0.5)`
Calcula o p-valor de um teste Z para proporção comparada a uma hipótese nula.

```r
p_valor_z(x = 65, n = 100, prop = 0.5)
```

### `CROSS_TAB()`
Função interativa que permite montar tabela 2x2 a partir de variáveis de exposição e desfecho, com suporte a variáveis numéricas e categóricas. Ela pergunta ao usuário os pontos de corte ou valores de referência e devolve resultados de OR, RR, qui-quadrado e Fisher.

```r
# Requer sessão interativa
if (interactive()) {
  resultado <- CROSS_TAB(
    data = base,
    var_exposicao = "idade",
    var_desfecho = "diabetes",
    exp_pos = NULL,
    exp_neg = NULL,
    desf_pos = NULL,
    desf_neg = NULL
  )
}
```

Essa função é muito útil quando a análise necessita de seleção de recortes e categorização em tempo real.

### `tab_biv(banco, expos, desf, valores)`
Realiza análise bivariada para múltiplas exposições e múltiplos desfechos. A função calcula razão de prevalência (RP), intervalos de confiança e p-valores para cada combinações.

```r
banco <- data.frame(
  tabagismo = c("Sim", "Nao", "Sim", "Nao"),
  hipertensao = c("Sim", "Nao", "Nao", "Sim"),
  evento = c("Sim", "Nao", "Sim", "Nao")
)

resultado_biv <- tab_biv(
  banco,
  expos = c("tabagismo", "hipertensao"),
  desf = c("evento"),
  valores = c("Sim", "Nao")
)

resultado_biv
```

### `analisando_acuracia()`
Avalia acurácia diagnóstica para combinações de exposição e desfecho binários, calculando:

- sensibilidade;
- especificidade;
- valor preditivo positivo;
- valor preditivo negativo;
- acurácia;
- coeficiente de Youden;
- intervalos de confiança;
- p-valores.

```r
res_acuracia <- analisando_acuracia(
  banco = banco,
  exposicoes = c("tabagismo", "hipertensao"),
  desfechos = c("evento"),
  valores = c("Sim", "Nao")
)

res_acuracia
```

Também aceita `pasta_results` e `nome_analise` para salvar o resultado em CSV.

---

## 5) Funções de qualidade de dados e completude

### `incomp_sist_multi_char()`
Avalia a completude de variáveis categóricas, ignorando colunas de data e marcando valores nulos e ignorados.

```r
banco <- data.frame(
  sexo = c("F", "M", "F", NA),
  escolaridade = c("Medio", "Fundamental", "9", "Superior"),
  peso = c(60, 70, 75, 80)
)

incomp_sist_multi_char(
  banco,
  variavel = c("sexo", "escolaridade"),
  ignorado = c("9", "99"),
  nulo = NA,
  nivel_validos = 90,
  nivel_ign = 5
)
```

### `incomp_sist_multi_dt()`
Avalia a completude de colunas de data (por convenção, variáveis cujo nome começa com `DT`). Converte valores em data e calcula validade percentual.

```r
banco <- data.frame(
  DT_NASCIMENTO = c("01/01/2000", "15/07/1999", "99/99/9999"),
  DT_CADASTRO = c("05/03/2020", "12/12/2021", "20/08/2019")
)

incomp_sist_multi_dt(
  banco,
  variavel = c("DT_NASCIMENTO", "DT_CADASTRO")
)
```

### `calcula_periodo_anos()`
Retorna um intervalo de anos em formato textual, útil para relatórios e metadados de bases temporais.

```r
banco <- data.frame(
  ano = c(2015, 2016, 2017, 2018)
)

calcula_periodo_anos(banco, ano_col = ano)
# [1] "2015-2018"
```

---

## 6) Funções de formatação para tabelas e relatórios

Essas funções ajudam a formatar números e resultados para apresentação em relatórios, tabelas e documentos de análise.

### `format_n_int(n)`
Formata inteiros com separador de milhar.

```r
format_n_int(1234567)
# [1] "1.234.567"
```

### `format_perc(n)`
Formata percentuais com 1 casa decimal.

```r
format_perc(42.5)
# [1] "42,5"
```

### `format_n_perc(n, perc)`
Formata número com percentual em parênteses.

```r
format_n_perc(42, 80.5)
# [1] "42 (80,5%)"
```

### `format_estimate(n)`
Formata estimativas com 2 casas decimais.

```r
format_estimate(1.2345)
# [1] "1,23"
```

### `format_est(n)`
Similar a `format_estimate()`, mas pensado como função auxiliar e com uso específico em outros formatos do pacote.

```r
format_est(2.678)
# [1] "2,68"
```

### `format_est_ic95(est, ici, ics)`
Formata estimativa com intervalo de confiança em um único texto.

```r
format_est_ic95(2.5, 1.9, 3.2)
# [1] "2,50 (1,90 - 3,20)"
```

### `format_pvalor(n)`
Formata p-valores com 3 casas decimais.

```r
format_pvalor(0.0045)
# [1] "0,005"
```

---

## 7) Visualização e estilo

### `tema_episus()`
Retorna um tema base para `ggplot2` com visual limpo e inspirador em epidemiologia.

```r
library(ggplot2)

ggplot(iris, aes(x = Species, y = Sepal.Length)) +
  geom_boxplot(width = 0.5, fill = "steelblue") +
  tema_episus() +
  labs(title = "Comprimento da sépala por espécie")
```

---

## Case completo: fluxo de análise em epidemiologia

A seguir está um exemplo mais completo, simulando a rotina típica de um estudo em saúde pública.

```r
library(dplyr)
library(ggplot2)
library(episus_tools)

# 1) Cria estrutura de projeto
criar_pastas()

# 2) Simula banco de dados
set.seed(123)

banco <- tibble::tibble(
  id = 1:500,
  sexo = sample(c("Feminino", "Masculino"), 500, replace = TRUE),
  idade = round(rnorm(500, mean = 48, sd = 15)),
  tabagismo = sample(c("Sim", "Nao"), 500, replace = TRUE, prob = c(0.30, 0.70)),
  hipertensao = sample(c("Sim", "Nao"), 500, replace = TRUE, prob = c(0.25, 0.75)),
  diabetes = sample(c("Sim", "Nao"), 500, replace = TRUE, prob = c(0.18, 0.82)),
  evento = sample(c("Sim", "Nao"), 500, replace = TRUE, prob = c(0.20, 0.80))
)

# 3) Documenta a base
banco_dic <- criar_dicionario(banco)
print(banco_dic)

# 4) Explora frequência de variáveis
FREQ(banco, "sexo")
FREQ(banco, "tabagismo")

# 5) Resumo estatístico de idade
MEANS(banco, "idade")

# 6) Gráfico simples
PLOT(banco, "sexo") + tema_episus()

# 7) Qualidade dos dados
incomp_sist_multi_char(
  banco,
  variavel = c("sexo", "tabagismo", "hipertensao", "diabetes", "evento"),
  ignorado = c("9", "99"),
  nulo = NA,
  nivel_validos = 90,
  nivel_ign = 5
)

# 8) Pressuposto de associação bivariada
resultado_biv <- tab_biv(
  banco,
  expos = c("tabagismo", "hipertensao"),
  desf = c("evento"),
  valores = c("Sim", "Nao")
)

print(resultado_biv)

# 9) Análise de acurácia diagnóstica
resultado_acuracia <- analisando_acuracia(
  banco = banco,
  exposicoes = c("tabagismo", "hipertensao"),
  desfechos = c("evento"),
  valores = c("Sim", "Nao")
)

print(resultado_acuracia)

# 10) Variável de data/tempo
banco_ano <- tibble::tibble(
  ano = c(2019, 2020, 2021, 2022)
)

calcula_periodo_anos(banco_ano, ano_col = ano)

# 11) Tabela 2x2 manual
res_tab <- TABLE(45, 30, 20, 80)
print(res_tab$oddsratio)
print(res_tab$riskratio)
```

Este fluxo ilustra como combinar as funções do pacote para:

1. organizar a base;
2. documentar e validar dados;
3. explorar distribuições;
4. analisar associação;
5. reportar indicadores e acurácia;
6. preparar resultados para apresentação.

---

## Observações finais

`episus_tools` foi pensado para ser um pacote prático e de uso ágil, especialmente para quem trabalha com epidemiologia, vigilância em saúde, dados de saúde pública e análise de indicadores epidemiológicos.

Ele não busca substituir ferramentas mais robustas de análise estatística, mas oferece uma camada útil de funções rápidas, amigáveis e com foco em rotina de trabalho.

Para uso em produção, o ideal é combinar esse pacote com:

- `dplyr` para manipulação;
- `ggplot2` para gráficos;
- `epitools` para medidas de associação;
- `readr` e `readxl` para importação;
- `tidyr` e `lubridate` para dados temporais.

---

## Dica de uso

Em projetos reais, uma boa prática é:

```r
library(episus_tools)
library(dplyr)
library(ggplot2)

# 1. organizar caminhos
criar_pastas()

# 2. criar dicionário
criar_dicionario(banco)

# 3. validar dados
incomp_sist_multi_char(banco, c("sexo", "tabagismo"), ignorado = c("9", "99"))

# 4. analisar descritivas
FREQ(banco, "sexo")
MEANS(banco, "idade")

# 5. analisar associação
resultado <- tab_biv(banco, expos = c("tabagismo"), desf = c("evento"), valores = c("Sim", "Nao"))
```

Dessa forma, o fluxo de análise permanece avaliável, reproducível e organizado.

---

## Resumo rápido de funções públicas

- `ASSIGN()`
- `AUTONUMBER()`
- `CHECK_IF_THEN()`
- `COMMENT_LEGAL()`
- `CREATE_FORM()`
- `CROSS_TAB()`
- `FREQ()`
- `IS_REQUIRED()`
- `LIST()`
- `MATCH()`
- `MEANS()`
- `PLOT()`
- `SAMPLE_SIZE()`
- `SELECT()`
- `SORT()`
- `STATCALC()`
- `SUMMARY()`
- `TABLE()`
- `analisando_acuracia()`
- `calcula_periodo_anos()`
- `criar_dicionario()`
- `criar_pastas()`
- `format_est()`
- `format_est_ic95()`
- `format_estimate()`
- `format_n_int()`
- `format_n_perc()`
- `format_perc()`
- `format_pvalor()`
- `incomp_sist_multi_char()`
- `incomp_sist_multi_dt()`
- `p_valor_z()`
- `pacotes_uteis()`
- `tab_biv()`
- `tema_episus()`

---

## Conclusão

O pacote `episus_tools` combina utilidades práticas, funções de tabulação, análise descritiva e indicadores de saúde pública em um único conjunto de ferramentas. Ele é especialmente útil para rotinas de análise com pouca necessidade de programação complexa, mas ainda com capacidade de produzir resultados relevantes e organizados.

Se o objetivo for velocidade de trabalho, organização de um projeto e análise exploratória em saúde, esse pacote é um excelente ponto de partida.
