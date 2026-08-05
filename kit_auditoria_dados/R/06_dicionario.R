# R/06_dicionario.R — Dicionário de dados automático

gerar_dicionario <- function(dados) {
  purrr::map_dfr(names(dados), function(v) {
    x        <- dados[[v]]
    tipo     <- class(x)[1]
    n_val    <- sum(!is.na(x))
    n_aus    <- sum(is.na(x))
    pct_aus  <- round(n_aus / length(x) * 100, 1)
    n_uniq   <- length(unique(na.omit(x)))

    exemplos <- if (is.numeric(x)) {
      paste0("min=", round(min(x, na.rm = TRUE), 2),
             ", max=", round(max(x, na.rm = TRUE), 2))
    } else if (lubridate::is.Date(x) || inherits(x, "POSIXct")) {
      paste0(min(x, na.rm = TRUE), " a ", max(x, na.rm = TRUE))
    } else {
      vals <- head(unique(na.omit(as.character(x))), 5)
      paste(vals, collapse = ", ")
    }

    tibble::tibble(
      Variavel     = v,
      Tipo         = tipo,
      N_Validos    = n_val,
      N_Ausentes   = n_aus,
      Pct_Ausente  = pct_aus,
      N_Unicos     = n_uniq,
      Exemplos     = exemplos
    )
  })
}
