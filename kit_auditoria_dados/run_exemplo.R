## run_exemplo.R — Instala dependências e renderiza o relatório
## Execute: source("run_exemplo.R")

# ── 1. Instalar pacotes necessários ───────────────────────────────────────────
pacotes <- c(
  "tidyverse", "lubridate", "skimr", "DT", "knitr", "kableExtra",
  "glue", "patchwork", "scales", "sessioninfo", "readxl", "readr",
  "purrr", "viridis", "naniar", "quarto"
)

novos <- pacotes[!sapply(pacotes, requireNamespace, quietly = TRUE)]
if (length(novos) > 0) {
  message("Instalando: ", paste(novos, collapse = ", "))
  install.packages(novos, repos = "https://cloud.r-project.org")
}

# ── 2. Verificar Quarto ───────────────────────────────────────────────────────
if (!nzchar(Sys.which("quarto"))) {
  stop(
    "Quarto não encontrado.\n",
    "Instale em: https://quarto.org/docs/get-started/\n"
  )
}

# ── 3. Renderizar o relatório ─────────────────────────────────────────────────
dados_arquivo <- "Base_de_dados_transformada.csv"
if (!file.exists(dados_arquivo)) {
  stop(
    "Arquivo de dados não encontrado: ", dados_arquivo, "\n",
    "Os dados de exemplo não são versionados neste repositório.\n",
    "Coloque sua base (ou a base de exemplo) nesta pasta e renomeie para: ",
    dados_arquivo
  )
}

quarto::quarto_render(
  input  = "template.qmd",
  execute_params = list(
    data_path   = dados_arquivo,
    id_var      = "ID_MUNICIP",
    group_var   = "SG_UF_NOT",
    rules_path  = "regras_exemplo.csv",
    top_n_cat   = 10,
    titulo_base = "Base de Notificações Individuais — SINAN"
  ),
  output_file = "relatorio_auditoria.html"
)

# ── 4. Abrir relatório no navegador ──────────────────────────────────────────
if (file.exists("relatorio_auditoria.html")) {
  message("\n✅ Relatório gerado: relatorio_auditoria.html\n")
  utils::browseURL("relatorio_auditoria.html")
} else {
  message("⚠️ Relatório não encontrado. Verifique os erros acima.")
}
