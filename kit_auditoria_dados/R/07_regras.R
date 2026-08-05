# R/07_regras.R — Motor de regras de validação

# Formato do CSV de regras (rules.csv):
# variavel, tipo, valor, severidade, descricao
# Tipos: range, allowed_values, regex, not_null

aplicar_regras <- function(dados, caminho_regras) {
  if (!file.exists(caminho_regras)) {
    message("Arquivo de regras não encontrado: ", caminho_regras)
    return(NULL)
  }

  regras <- readr::read_csv(caminho_regras, show_col_types = FALSE)
  resultados <- purrr::pmap_dfr(regras, function(variavel, tipo, valor, severidade, descricao) {
    if (!variavel %in% names(dados)) {
      return(tibble::tibble(
        Variavel   = variavel,
        Regra      = tipo,
        Descricao  = descricao,
        Severidade = severidade,
        N_Falhas   = NA_integer_,
        Pct_Falhas = NA_real_,
        Status     = "VARIÁVEL NÃO ENCONTRADA"
      ))
    }

    x <- dados[[variavel]]
    falhas <- switch(tipo,
      "range" = {
        partes <- as.numeric(strsplit(valor, ",")[[1]])
        sum(!is.na(x) & (x < partes[1] | x > partes[2]))
      },
      "allowed_values" = {
        permitidos <- strsplit(valor, ",")[[1]]
        sum(!is.na(x) & !as.character(x) %in% trimws(permitidos))
      },
      "regex" = {
        sum(!is.na(x) & !grepl(valor, as.character(x)))
      },
      "not_null" = {
        sum(is.na(x))
      },
      NA_integer_
    )

    status <- dplyr::case_when(
      is.na(falhas)  ~ "TIPO DESCONHECIDO",
      falhas == 0    ~ "✅ OK",
      severidade == "erro"   ~ "❌ ERRO",
      severidade == "aviso"  ~ "⚠️ AVISO",
      TRUE           ~ "ℹ️ INFO"
    )

    tibble::tibble(
      Variavel   = variavel,
      Regra      = tipo,
      Descricao  = descricao,
      Severidade = severidade,
      N_Falhas   = as.integer(falhas),
      Pct_Falhas = round(falhas / nrow(dados) * 100, 1),
      Status     = status
    )
  })

  resultados
}
