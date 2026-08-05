# R/05_distribuicoes.R — Distribuições numéricas e categóricas

# ── Numéricas ──────────────────────────────────────────────────────────────────

resumo_numericas <- function(dados) {
  vars_num <- names(dados)[sapply(dados, is.numeric)]
  if (length(vars_num) == 0) return(NULL)

  purrr::map_dfr(vars_num, function(v) {
    x <- dados[[v]]
    x_sem_na <- x[!is.na(x)]
    q <- quantile(x_sem_na, probs = c(.25, .75), na.rm = TRUE)
    iqr <- q[2] - q[1]
    outliers_low  <- sum(x_sem_na < (q[1] - 1.5 * iqr))
    outliers_high <- sum(x_sem_na > (q[2] + 1.5 * iqr))
    tibble::tibble(
      Variavel      = v,
      N             = length(x_sem_na),
      Media         = round(mean(x_sem_na), 2),
      Mediana       = round(median(x_sem_na), 2),
      DP            = round(sd(x_sem_na), 2),
      Min           = round(min(x_sem_na), 2),
      P25           = round(q[1], 2),
      P75           = round(q[2], 2),
      Max           = round(max(x_sem_na), 2),
      Outliers_Inf  = outliers_low,
      Outliers_Sup  = outliers_high
    )
  })
}

grafico_boxplot_numericas <- function(dados, max_vars = 12) {
  vars_num <- names(dados)[sapply(dados, is.numeric)]
  # excluir variáveis com todos iguais ou com poucas variações (códigos)
  vars_num <- vars_num[sapply(dados[vars_num], function(x) length(unique(na.omit(x))) > 5)]
  vars_num <- head(vars_num, max_vars)
  if (length(vars_num) == 0) return(NULL)

  df_long <- dados |>
    dplyr::select(dplyr::all_of(vars_num)) |>
    tidyr::pivot_longer(everything(), names_to = "variavel", values_to = "valor") |>
    dplyr::filter(!is.na(valor))

  ggplot2::ggplot(df_long, ggplot2::aes(x = valor, y = variavel, fill = variavel)) +
    ggplot2::geom_boxplot(outlier.colour = "#E05C3A", outlier.alpha = 0.5,
                          show.legend = FALSE) +
    ggplot2::scale_fill_viridis_d(option = "mako", alpha = 0.7) +
    ggplot2::labs(title = "Distribuição das Variáveis Numéricas", x = NULL, y = NULL) +
    ggplot2::theme_minimal(base_size = 12)
}

# ── Categóricas ───────────────────────────────────────────────────────────────

frequencia_categoricas <- function(dados, top_n = 10) {
  vars_cat <- names(dados)[sapply(dados, function(x) is.character(x) | is.factor(x))]
  if (length(vars_cat) == 0) return(NULL)

  purrr::map(vars_cat, function(v) {
    tab <- dados |>
      dplyr::count(.data[[v]], name = "N", sort = TRUE) |>
      dplyr::mutate(Pct = round(N / sum(N) * 100, 1))

    if (nrow(tab) > top_n) {
      outros <- tab[(top_n + 1):nrow(tab), ] |>
        dplyr::summarise(
          !!v := "(Outros)",
          N    = sum(N),
          Pct  = round(sum(N) / sum(tab$N) * 100, 1)
        )
      tab <- dplyr::bind_rows(tab[1:top_n, ], outros)
    }
    list(variavel = v, tabela = tab)
  }) |> purrr::set_names(vars_cat)
}
