# .Rprofile — Configurações automáticas ao abrir o projeto
# Garante codificação UTF-8 em todas as sessões R nesta pasta

options(encoding = "UTF-8")

# Linux / macOS
if (.Platform$OS.type == "unix") {
  Sys.setlocale("LC_ALL", "pt_BR.UTF-8")
}

# Windows
if (.Platform$OS.type == "windows") {
  Sys.setlocale("LC_ALL", "Portuguese_Brazil.1252")
  # No Windows, salve os scripts como UTF-8 com BOM no RStudio:
  # Tools > Global Options > Code > Saving > Default text encoding: UTF-8
}
