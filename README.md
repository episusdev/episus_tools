# episus_tools

`episus_tools` é um pacote de utilitários para análise epidemiológica, com funções desenvolvidas para treinandos do EpiSUS e analistas de dados em saúde.

## Instalação

Para instalar 

```r
# se usar devtools
remotes::install_github("episusdev/episus_tools")

# É interessante também instalar pacotes usualmente utilizados, inclusive o microdatasus e read.dbc
# Para isso, não esqueça de instalar o rtools correspondente a sua versão do R

library(episus_tools)
pacotes_uteis()

```

## Uso básico

```r
# Exemplo de função do pacote

## Criando dicionário de dados
dic <- criar_dicionario(banco)

## Funções similares ao EpiInfo (pgm)
FREQ(iris, "Species")
MEANS(iris, "Petal.Length")

## Formato de numero em texto para tabelas
iris = iris|>
  mutate(Petal.Width_string = format_n_int(Petal.Width))

```

## Estrutura do pacote

- `R/`: código-fonte das funções.
- `man/`: documentação de ajuda (`.Rd`).
- `DESCRIPTION`: metadados do pacote.
- `NAMESPACE`: exportações e imports.
- `LICENSE`: licença MIT.

## Kit de Auditoria de Dados

Além das funções do pacote, este repositório inclui o **`kit_auditoria_dados/`**:
um template Quarto parametrizado para auditoria reprodutível de qualidade de
dados em saúde pública (dados ausentes, duplicatas, distribuições, validação por
regras). Veja o [README do kit](kit_auditoria_dados/README.md) para instruções
de uso.
