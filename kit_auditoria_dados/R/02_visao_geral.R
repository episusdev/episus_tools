# R/02_visao_geral.R — Visão geral da base de dados

visao_geral <- function(dados) {
  n_linhas   <- nrow(dados)
  n_colunas  <- ncol(dados)
  n_numeric  <- sum(sapply(dados, is.numeric))
  n_char     <- sum(sapply(dados, is.character))
  n_date     <- sum(sapply(dados, lubridate::is.Date))
  n_logical  <- sum(sapply(dados, is.logical))
  n_factor   <- sum(sapply(dados, is.factor))
  n_missing  <- sum(is.na(dados))
  pct_missing <- round(n_missing / (n_linhas * n_colunas) * 100, 2)
  n_dup      <- sum(duplicated(dados))

  list(
    n_linhas    = n_linhas,
    n_colunas   = n_colunas,
    n_numeric   = n_numeric,
    n_char      = n_char,
    n_date      = n_date,
    n_logical   = n_logical,
    n_factor    = n_factor,
    n_missing   = n_missing,
    pct_missing = pct_missing,
    n_dup       = n_dup
  )
}

tabela_tipos <- function(dados) {
  tibble::tibble(
    Variavel = names(dados),
    Tipo     = sapply(dados, function(x) class(x)[1]),
    N_Validos = sapply(dados, function(x) sum(!is.na(x))),
    N_Faltantes = sapply(dados, function(x) sum(is.na(x))),
    Pct_Faltante = round(sapply(dados, function(x) mean(is.na(x))) * 100, 1)
  )
}
