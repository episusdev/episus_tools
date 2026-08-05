# R/01_carregar.R — Carregamento e pré-processamento dos dados

carregar_dados <- function(caminho, id_var = NULL) {
  ext <- tolower(tools::file_ext(caminho))

  dados <- switch(ext,
    "csv"  = readr::read_csv(caminho, show_col_types = FALSE,
                             locale = readr::locale(encoding = "UTF-8",
                                                    decimal_mark = ".",
                                                    grouping_mark = ",")),
    "xlsx" = readxl::read_excel(caminho),
    "xls"  = readxl::read_excel(caminho),
    stop("Formato não suportado: ", ext)
  )

  # Converter colunas de datas automaticamente
  dados <- dplyr::mutate(dados, dplyr::across(
    where(~ inherits(.x, "POSIXct") | inherits(.x, "POSIXt")),
    as.Date
  ))

  # Aviso se id_var não existir
  if (!is.null(id_var) && !id_var %in% names(dados)) {
    warning("Variável de ID '", id_var, "' não encontrada na base.")
  }

  return(dados)
}
