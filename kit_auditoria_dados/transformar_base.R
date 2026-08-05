# =============================================================================
# transformar_base.R
# Transformação de variáveis categóricas da Base de Notificações — SINAN NET
# Dicionário de dados: SINAN NET Versão 5.0 | Agravo: Hanseníase
#
# Como usar:
#   source("transformar_base.R")
#   # A base transformada fica no objeto `dados_transformados`
#   # E salva o arquivo: Base_de_dados_transformada.xlsx
# =============================================================================

# ── 1. Pacotes ─────────────────────────────────────────────────────────────────
pacotes_necessarios <- c("readxl", "dplyr", "forcats", "writexl", "lubridate")

novos <- pacotes_necessarios[
  !sapply(pacotes_necessarios, requireNamespace, quietly = TRUE)
]
if (length(novos) > 0) {
  message("Instalando pacotes: ", paste(novos, collapse = ", "))
  install.packages(novos, repos = "https://cloud.r-project.org")
}

suppressPackageStartupMessages({
  library(readxl)
  library(dplyr)
  library(forcats)
  library(writexl)
  library(lubridate)
})

# ── 2. Carregar dados ──────────────────────────────────────────────────────────
message("📂 Carregando base de dados...")

arquivo <- "Base_de_dados.xlsx"
if (!file.exists(arquivo)) {
  stop("Arquivo não encontrado: ", arquivo,
       "\nColoque o script na mesma pasta da base de dados.")
}

dados_raw <- readxl::read_excel(arquivo)
message("   → ", nrow(dados_raw), " registros | ", ncol(dados_raw), " variáveis")

# ── 3. Funções auxiliares ──────────────────────────────────────────────────────

# Aplica rótulos a uma coluna numérica/character, preservando NA
rotular <- function(x, mapa) {
  resultado <- dplyr::recode(as.character(x), !!!mapa, .default = as.character(x))
  # Mantém NA original
  resultado[is.na(x)] <- NA_character_
  factor(resultado)
}

# ── 4. Transformações por variável ─────────────────────────────────────────────
message("🔄 Aplicando transformações...")

dados_transformados <- dados_raw |>

  # ── 4.1 TP_NOT — Tipo de Notificação ────────────────────────────────────────
  # 1=Negativa | 2=Individual | 3=Surto | 4=Investigação
  mutate(TP_NOT = rotular(TP_NOT, c(
    "1" = "Negativa",
    "2" = "Individual",
    "3" = "Surto",
    "4" = "Investigação"
  ))) |>

  # ── 4.2 CS_SEXO — Sexo do Paciente ──────────────────────────────────────────
  # M=Masculino | F=Feminino | I=Ignorado
  mutate(CS_SEXO = factor(CS_SEXO,
    levels = c("M", "F", "I"),
    labels = c("Masculino", "Feminino", "Ignorado")
  )) |>

  # ── 4.3 CS_GESTANT — Gestante ────────────────────────────────────────────────
  # 1=1º Trimestre | 2=2º Trimestre | 3=3º Trimestre
  # 4=Idade gestacional ignorada | 5=Não | 6=Não se aplica | 9=Ignorado
  mutate(CS_GESTANT = rotular(CS_GESTANT, c(
    "1" = "1º Trimestre",
    "2" = "2º Trimestre",
    "3" = "3º Trimestre",
    "4" = "Idade gestacional ignorada",
    "5" = "Não",
    "6" = "Não se aplica",
    "9" = "Ignorado"
  ))) |>

  # ── 4.4 CS_RACA — Raça/Cor ───────────────────────────────────────────────────
  # 1=Branca | 2=Preta | 3=Amarela | 4=Parda | 5=Indígena | 9=Ignorado
  mutate(CS_RACA = rotular(CS_RACA, c(
    "1" = "Branca",
    "2" = "Preta",
    "3" = "Amarela",
    "4" = "Parda",
    "5" = "Indígena",
    "9" = "Ignorado"
  ))) |>

  # ── 4.5 CS_ESCOL_N — Escolaridade ────────────────────────────────────────────
  # 0=Analfabeto | 1=1ª a 4ª série incompleta | 2=4ª série completa
  # 3=5ª a 8ª série incompleta | 4=Ensino fundamental completo
  # 5=Ensino médio incompleto | 6=Ensino médio completo
  # 7=Educação superior incompleta | 8=Educação superior completa
  # 9=Ignorado | 10=Não se aplica
  mutate(CS_ESCOL_N = rotular(CS_ESCOL_N, c(
    "0"  = "Analfabeto",
    "1"  = "1ª a 4ª série incompleta",
    "2"  = "4ª série completa (Ens. Fund. I)",
    "3"  = "5ª a 8ª série incompleta (Ens. Fund. II)",
    "4"  = "Ensino Fundamental completo",
    "5"  = "Ensino Médio incompleto",
    "6"  = "Ensino Médio completo",
    "7"  = "Educação Superior incompleta",
    "8"  = "Educação Superior completa",
    "9"  = "Ignorado",
    "10" = "Não se aplica"
  ))) |>

  # ── 4.6 FORMACLINI — Forma Clínica (classificação de Madrid) ────────────────
  # 1=Indeterminada | 2=Tuberculóide | 3=Dimorfa | 4=Virchowiana
  # 5=Não classificado | 6=Não informado | 9=Ignorado
  mutate(FORMACLINI = rotular(FORMACLINI, c(
    "1" = "Indeterminada",
    "2" = "Tuberculóide",
    "3" = "Dimorfa",
    "4" = "Virchowiana",
    "5" = "Não classificado",
    "6" = "Não informado",
    "9" = "Ignorado"
  ))) |>

  # ── 4.7 CLASSOPERA — Classificação Operacional no Diagnóstico ───────────────
  # 1=PB (Paucibacilar) | 2=MB (Multibacilar) | 9=Ignorado
  mutate(CLASSOPERA = rotular(CLASSOPERA, c(
    "1" = "Paucibacilar (PB)",
    "2" = "Multibacilar (MB)",
    "9" = "Ignorado"
  ))) |>

  # ── 4.8 AVALIA_N — Avaliação do Grau de Incapacidade no Diagnóstico ─────────
  # 0=Grau zero | 1=Grau I | 2=Grau II | 3=Não avaliado
  mutate(AVALIA_N = rotular(AVALIA_N, c(
    "0" = "Grau 0",
    "1" = "Grau I",
    "2" = "Grau II",
    "3" = "Não avaliado"
  ))) |>

  # ── 4.9 MODOENTR — Modo de Entrada ──────────────────────────────────────────
  # 1=Caso novo | 2=Transferência do mesmo município (outra unidade)
  # 3=Transferência de outro município | 4=Transferência de outro estado
  # 5=Transferência de outro país | 6=Recidiva | 7=Outros reingressos
  # 9=Ignorado
  mutate(MODOENTR = rotular(MODOENTR, c(
    "1" = "Caso novo",
    "2" = "Transferência do mesmo município",
    "3" = "Transferência de outro município",
    "4" = "Transferência de outro estado",
    "5" = "Transferência de outro país",
    "6" = "Recidiva",
    "7" = "Outros reingressos",
    "9" = "Ignorado"
  ))) |>

  # ── 4.10 MODODETECT — Modo de Detecção do Caso Novo ─────────────────────────
  # 1=Encaminhamento | 2=Demanda espontânea | 3=Exame de coletividade
  # 4=Exame de contatos | 5=Outros modos | 9=Ignorado
  mutate(MODODETECT = rotular(MODODETECT, c(
    "1" = "Encaminhamento",
    "2" = "Demanda espontânea",
    "3" = "Exame de coletividade",
    "4" = "Exame de contatos",
    "5" = "Outros modos",
    "9" = "Ignorado"
  ))) |>

  # ── 4.11 BACILOSCOP — Baciloscopia ───────────────────────────────────────────
  # 1=Positiva | 2=Negativa | 3=Não realizada | 9=Ignorado
  mutate(BACILOSCOP = rotular(BACILOSCOP, c(
    "1" = "Positiva",
    "2" = "Negativa",
    "3" = "Não realizada",
    "9" = "Ignorado"
  ))) |>

  # ── 4.12 ESQ_INI_N — Esquema Terapêutico Inicial ────────────────────────────
  # 1=PQT/PB/6 doses | 2=PQT/MB/12 doses | 3=Outros Esquemas Substitutivos
  mutate(ESQ_INI_N = rotular(ESQ_INI_N, c(
    "1" = "PQT/PB — 6 doses",
    "2" = "PQT/MB — 12 doses",
    "3" = "Outros Esquemas Substitutivos"
  ))) |>

  # ── 4.13 CLASSATUAL — Classificação Operacional Atual ───────────────────────
  # 1=PB (Paucibacilar) | 2=MB (Multibacilar) | 9=Ignorado
  mutate(CLASSATUAL = rotular(CLASSATUAL, c(
    "1" = "Paucibacilar (PB)",
    "2" = "Multibacilar (MB)",
    "9" = "Ignorado"
  ))) |>

  # ── 4.14 AVAL_ATU_N — Avaliação de Incapacidade Física na Alta ──────────────
  # 0=Grau zero | 1=Grau I | 2=Grau II | 3=Não avaliado / Ignorado
  mutate(AVAL_ATU_N = rotular(AVAL_ATU_N, c(
    "0" = "Grau 0",
    "1" = "Grau I",
    "2" = "Grau II",
    "3" = "Ignorado"
  ))) |>

  # ── 4.15 ESQ_ATU_N — Esquema Terapêutico em Uso ─────────────────────────────
  # 1=PQT/PB/6 doses | 2=PQT/MB/12 doses | 3=Outros Esquemas Substitutivos
  mutate(ESQ_ATU_N = rotular(ESQ_ATU_N, c(
    "1" = "PQT/PB — 6 doses",
    "2" = "PQT/MB — 12 doses",
    "3" = "Outros Esquemas Substitutivos"
  ))) |>

  # ── 4.16 EPIS_RACIO — Episódio Reacional Durante o Tratamento ───────────────
  # 1=Reação tipo 1 | 2=Reação tipo 2 | 3=Tipos 1 e 2 | 4=Sem reação
  mutate(EPIS_RACIO = rotular(EPIS_RACIO, c(
    "1" = "Reação tipo 1",
    "2" = "Reação tipo 2",
    "3" = "Reações tipo 1 e tipo 2",
    "4" = "Sem reação"
  ))) |>

  # ── 4.17 TPALTA_N — Tipo de Saída / Alta ────────────────────────────────────
  # 1=Cura | 2=Transferência p/ mesmo município
  # 3=Transferência p/ outro município | 4=Transferência p/ outro estado
  # 5=Transferência p/ outro país | 6=Óbito | 7=Abandono
  # 8=Erro diagnóstico | 9=Transferência não especificada
  mutate(TPALTA_N = rotular(TPALTA_N, c(
    "1" = "Cura",
    "2" = "Transferência p/ mesmo município",
    "3" = "Transferência p/ outro município",
    "4" = "Transferência p/ outro estado",
    "5" = "Transferência p/ outro país",
    "6" = "Óbito",
    "7" = "Abandono",
    "8" = "Erro diagnóstico",
    "9" = "Transferência não especificada"
  ))) |>

  # ── 4.18 IN_VINCULA — Vinculação de Notificações ────────────────────────────
  # 0=Não vinculada | 1=Vinculada
  mutate(IN_VINCULA = rotular(IN_VINCULA, c(
    "0" = "Não vinculada",
    "1" = "Vinculada"
  ))) |>

  # ── 4.19 NDUPLIC_N — Identificação de Duplicidade ───────────────────────────
  # 0=Não duplicado | 1=Duplicado | 2=Duplicado confirmado
  mutate(NDUPLIC_N = rotular(NDUPLIC_N, c(
    "0" = "Não duplicado",
    "1" = "Duplicado",
    "2" = "Duplicado confirmado"
  ))) |>

  # ── 4.20 CS_FLXRET / FLXRECEBI / MIGRADO_W ──────────────────────────────────
  # Variáveis administrativas internas (100% ausentes na base)
  # Mantidas como estão — sem transformação aplicável

  # ── 4.21 Datas: garantir classe Date ─────────────────────────────────────────
  mutate(across(
    c(DT_NOTIFIC, DT_DIAG, DT_DIGITA, DT_TRANSUS, DT_TRANSDM,
      DT_TRANSSM, DT_TRANSRM, DT_TRANSRS, DT_TRANSSE,
      DTINICTRAT, DT_NOTI_AT, DTULTCOMP, DTMUDESQ, DTALTA_N),
    ~ as.Date(.x)
  ))

# ── 5. Relatório de transformações ────────────────────────────────────────────
message("\n📊 Resumo das transformações aplicadas:\n")

vars_transformadas <- c(
  "TP_NOT", "CS_SEXO", "CS_GESTANT", "CS_RACA", "CS_ESCOL_N",
  "FORMACLINI", "CLASSOPERA", "AVALIA_N", "MODOENTR", "MODODETECT",
  "BACILOSCOP", "ESQ_INI_N", "CLASSATUAL", "AVAL_ATU_N", "ESQ_ATU_N",
  "EPIS_RACIO", "TPALTA_N", "IN_VINCULA", "NDUPLIC_N"
)

for (v in vars_transformadas) {
  if (v %in% names(dados_transformados)) {
    niveis <- levels(dados_transformados[[v]])
    n_na   <- sum(is.na(dados_transformados[[v]]))
    message(sprintf("  ✅ %-15s → %d categorias | %d NA",
                    v, length(niveis), n_na))
  }
}

# ── 6. Salvar base transformada ────────────────────────────────────────────────
arquivo_saida <- "Base_de_dados_transformada.csv"
message("\n💾 Salvando: ", arquivo_saida)

# Converte fatores para character para compatibilidade com Excel
dados_para_salvar <- dados_transformados |>
  mutate(across(where(is.factor), as.character))

readr::write_csv(dados_para_salvar, arquivo_saida)

message("✅ Arquivo salvo com sucesso: ", arquivo_saida)
message("   → ", nrow(dados_para_salvar), " registros | ", ncol(dados_para_salvar), " variáveis")

# ── 7. Tabela de verificação rápida ───────────────────────────────────────────
message("\n🔍 Verificação — primeiros valores (CS_SEXO, CS_RACA, FORMACLINI, TPALTA_N):\n")

dados_transformados |>
  select(CS_SEXO, CS_RACA, FORMACLINI, TPALTA_N) |>
  head(10) |>
  print()

message("\n🎯 Transformação concluída!")
message("   Objeto disponível em R: dados_transformados")
message("   Arquivo salvo:          ", arquivo_saida)
