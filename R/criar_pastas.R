#' Cria Infraestrutura Mínima de Pastas para um Projeto
#'
#' Cria uma estrutura de diretórios padronizada dentro do diretório raiz do
#' projeto R. Se `pasta_referencia` for `NULL`, a função usa o diretório de
#' trabalho atual (`getwd()`). As pastas criadas organizam os dados brutos,
#' auxiliares, tratados, intermediários e os resultados (descritivo,
#' bivariada, multivariada e acurácia).
#'
#' @param pasta_referencia Caminho base do projeto. Se `NULL`, usa o diretório
#'   atual de trabalho.
#'
#' @return Um vetor nomeado com os caminhos em string das pastas criadas.
#' @export
#'
#' @examples
#' \dontrun{
#'   pastas <- criar_pastas()
#'   pastas[["bancos_brutos"]]
#' }

criar_pastas <- function(pasta_referencia = NULL) {
  base <- if (is.null(pasta_referencia)) {
    getwd()
  } else {
    pasta_referencia
  }

  base <- normalizePath(base, winslash = "/", mustWork = FALSE)

  criar_dir <- function(caminho) {
    if (!dir.exists(caminho)) {
      dir.create(caminho, recursive = TRUE, showWarnings = FALSE)
    }
    normalizePath(caminho, winslash = "/", mustWork = FALSE)
  }

  pastas <- c(
    bancos_brutos = criar_dir(file.path(base, "bancos_brutos")),
    dados_auxiliares = criar_dir(file.path(base, "dados auxiliares")),
    dados_tratados = criar_dir(file.path(base, "dados_tratados")),
    dados_inter = criar_dir(file.path(base, "dados_inter")),
    resultados = criar_dir(file.path(base, "resultados")),
    descritivo = criar_dir(file.path(base, "resultados", "descritivo")),
    bivariada = criar_dir(file.path(base, "resultados", "bivariada")),
    multivariada = criar_dir(file.path(base, "resultados", "multivariada")),
    acuracia = criar_dir(file.path(base, "resultados", "acuracia"))
  )

  for (nm in names(pastas)) {
    obj_name <- paste0("pasta_", nm)
    assign(obj_name, pastas[[nm]], envir = .GlobalEnv)
  }

  return(pastas)
}
