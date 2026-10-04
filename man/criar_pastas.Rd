\name{criar_pastas}
\alias{criar_pastas}
\title{Cria Infraestrutura Mínima de Pastas para um Projeto}
\description{Cria uma estrutura de diretórios padronizada dentro do diretório base do projeto R. Se `pasta_referencia` for `NULL`, a função usa o diretório de trabalho atual (`getwd()`). As pastas criadas organizam os dados brutos, auxiliares, tratados, intermediários e os resultados (descritivo, bivariada, multivariada e acurácia). Além disso, a função atribui cada caminho ao ambiente global com o prefixo `pasta_`, como `pasta_resultados` e `pasta_bancos_brutos`.}
\usage{criar_pastas(pasta_referencia = NULL)}
\arguments{
  \item{pasta_referencia}{Caminho base do projeto. Se `NULL`, usa o diretório atual de trabalho.}
}
\value{Um vetor nomeado em formato de string com os caminhos completos das pastas criadas. Os mesmos valores também ficam disponíveis no ambiente global com os nomes prefixados por `pasta_`.}
\examples{
\dontrun{
  pastas <- criar_pastas()
  print(pastas)
  print(pasta_resultados)
  pastas[["bancos_brutos"]]
}
}
