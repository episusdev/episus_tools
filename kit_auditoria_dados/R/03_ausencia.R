# R/03_ausencia.R — Análise de dados ausentes

tabela_ausencia <- function(dados) {
  tibble::tibble(
    Variavel     = names(dados),
    N_Ausente    = sapply(dados, function(x) sum(is.na(x))),
    Pct_Ausente  = round(sapply(dados, function(x) mean(is.na(x))) * 100, 1)
  ) |>
    dplyr::arrange(dplyr::desc(Pct_Ausente)) |>
    dplyr::filter(N_Ausente > 0)
}

grafico_ausencia_barra <- function(dados, top_n = 30) {
  df <- tabela_ausencia(dados) |> dplyr::slice_head(n = top_n)

  ggplot2::ggplot(df, ggplot2::aes(
    x = Pct_Ausente,
    y = reorder(Variavel, Pct_Ausente)
  )) +
    ggplot2::geom_col(fill = "#E05C3A", alpha = 0.85) +
    ggplot2::geom_text(ggplot2::aes(label = paste0(Pct_Ausente, "%")),
                       hjust = -0.1, size = 3) +
    ggplot2::scale_x_continuous(limits = c(0, 115), labels = function(x) paste0(x, "%")) +
    ggplot2::labs(
      title   = "Percentual de Dados Ausentes por Variável",
      x       = "% Ausente",
      y       = NULL
    ) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(panel.grid.major.y = ggplot2::element_blank())
}

grafico_ausencia_mapa <- function(dados, max_vars = 40, max_obs = 500) {
  # Seleciona variáveis com algum ausente
  vars_ausentes <- names(dados)[sapply(dados, function(x) any(is.na(x)))]
  if (length(vars_ausentes) == 0) {
    message("Nenhum dado ausente encontrado.")
    return(invisible(NULL))
  }
  vars_sel <- head(vars_ausentes, max_vars)
  obs_sel  <- sample(seq_len(nrow(dados)), min(max_obs, nrow(dados)))

  mat <- is.na(dados[obs_sel, vars_sel])
  df_long <- as.data.frame(mat) |>
    tibble::rownames_to_column("obs") |>
    tidyr::pivot_longer(-obs, names_to = "variavel", values_to = "ausente")

  ggplot2::ggplot(df_long, ggplot2::aes(
    x = variavel, y = obs, fill = ausente
  )) +
    ggplot2::geom_tile(color = NA) +
    ggplot2::scale_fill_manual(
      values = c("FALSE" = "#D6EAF8", "TRUE" = "#E05C3A"),
      labels = c("Presente", "Ausente"),
      name   = NULL
    ) +
    ggplot2::labs(
      title = "Mapa de Ausência (amostra de observações)",
      x = NULL, y = "Observação"
    ) +
    ggplot2::theme_minimal(base_size = 11) +
    ggplot2::theme(
      axis.text.x = ggplot2::element_text(angle = 45, hjust = 1),
      axis.text.y = ggplot2::element_blank(),
      axis.ticks.y = ggplot2::element_blank()
    )
}

ausencia_por_grupo <- function(dados, grupo_var) {
  if (!grupo_var %in% names(dados)) return(NULL)
  dados |>
    dplyr::group_by(.data[[grupo_var]]) |>
    dplyr::summarise(
      N = dplyr::n(),
      dplyr::across(everything(), ~ round(mean(is.na(.)) * 100, 1)),
      .groups = "drop"
    )
}
