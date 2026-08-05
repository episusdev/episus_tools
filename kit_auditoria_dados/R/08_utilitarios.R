# R/08_utilitarios.R — Funções auxiliares

# Formatar tabela para exibição no Quarto
tabela_bonita <- function(df, caption = NULL, scroll = TRUE) {
  if (!is.data.frame(df) || nrow(df) == 0) {
    return(knitr::kable(data.frame(Mensagem = "Nenhum resultado encontrado.")))
  }
  opts <- list(pageLength = 15, scrollX = TRUE, language = list(
    url = "//cdn.datatables.net/plug-ins/1.10.11/i18n/Portuguese-Brasil.json"
  ))
  DT::datatable(df,
    caption    = caption,
    rownames   = FALSE,
    filter     = "top",
    extensions = "Buttons",
    options    = c(opts, list(
      dom     = "Bfrtip",
      buttons = list("copy", "csv", "excel")
    ))
  )
}

# Caixa de resumo colorida (HTML inline)
caixa_metrica <- function(rotulo, valor, cor = "#2E86AB") {
  glue::glue(
    '<div style="display:inline-block;background:{cor};color:white;',
    'border-radius:8px;padding:10px 18px;margin:6px;text-align:center;">',
    '<div style="font-size:1.6rem;font-weight:700;">{valor}</div>',
    '<div style="font-size:0.85rem;">{rotulo}</div>',
    '</div>'
  )
}

# Rodapé de reprodutibilidade
rodape_reproducibilidade <- function() {
  cat("\n---\n")
  cat("**Relatório gerado em:**", format(Sys.time(), "%d/%m/%Y %H:%M:%S"), "\n\n")
  cat("**Sessão R:**\n\n")
  info <- sessioninfo::session_info()
  cat("- R:", as.character(info$platform$version), "\n")
  cat("- SO:", info$platform$os, "\n")
  pkgs <- info$packages[info$packages$attached, c("package", "loadedversion")]
  if (nrow(pkgs) > 0) {
    cat("- Pacotes carregados:", paste0(pkgs$package, " ", pkgs$loadedversion, collapse = ", "), "\n")
  }
}

# Paleta de cores padrão do relatório
cores_relatorio <- list(
  primaria   = "#2E86AB",
  secundaria = "#A23B72",
  alerta     = "#E05C3A",
  ok         = "#3BB273",
  neutro     = "#6C757D"
)
