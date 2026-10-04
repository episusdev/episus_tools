#' Avaliação de Completude de Variáveis de Data
#'
#' Avalia a completude de variáveis de data (aquelas cujo nome começa com
#' `"DT"`) em um data frame, convertendo as datas com `lubridate::dmy()` e
#' gerando um resumo.
#'
#' @param banco Data frame com os dados.
#' @param variavel Vetor de nomes das variáveis de data. Apenas variáveis cujo
#'   nome começa com `"DT"` são processadas.
#' @param nulo Valor considerado nulo (padrão: `NA`).
#' @param nivel_validos Percentual mínimo de observações válidas para ser
#'   considerado adequado (padrão: 90).
#'
#' @return Tibble com a avaliação da completude para cada variável de data.
#' @export
#'
#' @examples
#' \dontrun{
#'   resultados <- incomp_sist_multi_dt(banco, c("DT_DATA1", "DT_DATA2"))
#' }
incomp_sist_multi_dt <- function(banco, variavel, nulo = NA, nivel_validos = 90) {
  variaveis <- stringr::str_subset(variavel, "^DT")

  resultados <- purrr::map_dfr(variaveis, function(var) {
    var_sym <- rlang::ensym(var)
    x <- banco[[as.character(var_sym)]]

    x_dt <- suppressWarnings(lubridate::dmy(x))

    n_total <- length(x)
    validos <- sum(!is.na(x_dt))

    nulos_esperados <- if (length(nulo) == 1L && is.na(nulo)) {
      rep(FALSE, n_total)
    } else {
      as.character(x) %in% as.character(nulo)
    }

    nulos <- sum(is.na(x_dt) | is.na(x) | trimws(as.character(x)) == "" | nulos_esperados)
    pct_validos <- if (n_total == 0) 0 else round(validos / n_total * 100, 2)
    pct_nulos <- if (n_total == 0) 0 else round(nulos / n_total * 100, 1)

    tibble::tibble(
      "Variavel"     = as.character(var_sym),
      "N de obs."    = n_total,
      "Validos"      = validos,
      "% validos"    = pct_validos,
      "Nulos"        = nulos,
      "% nulos"      = pct_nulos,
      "Avaliacao"    = dplyr::if_else(pct_validos >= nivel_validos, "Adequado", "Inadequado"),
      "Data minima"  = if (sum(!is.na(x_dt)) == 0) NA else min(x_dt, na.rm = TRUE),
      "Data maxima"  = if (sum(!is.na(x_dt)) == 0) NA else max(x_dt, na.rm = TRUE)
    )
  })

  print(resultados)
  return(resultados)
}
