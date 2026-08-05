# R/04_duplicatas.R — Detecção de duplicatas

duplicatas_exatas <- function(dados) {
  dup_idx <- which(duplicated(dados) | duplicated(dados, fromLast = TRUE))
  list(
    n_duplicatas = sum(duplicated(dados)),
    linhas       = if (length(dup_idx) > 0) dados[dup_idx, ] else NULL
  )
}

duplicatas_por_id <- function(dados, id_var) {
  if (is.null(id_var) || !id_var %in% names(dados)) return(NULL)

  contagem <- dados |>
    dplyr::count(.data[[id_var]], name = "N") |>
    dplyr::filter(N > 1) |>
    dplyr::arrange(dplyr::desc(N))

  list(
    n_ids_dup = nrow(contagem),
    tabela    = contagem
  )
}

resumo_duplicatas <- function(dados, id_var = NULL) {
  ex  <- duplicatas_exatas(dados)
  por_id <- duplicatas_por_id(dados, id_var)

  list(exatas = ex, por_id = por_id)
}
