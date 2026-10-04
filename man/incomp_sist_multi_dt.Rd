\name{incomp_sist_multi_dt}
\alias{incomp_sist_multi_dt}
\title{Avaliação de Completude de Variáveis de Data}
\description{Avalia a completude de variáveis de data (aquelas cujo nome começa com `"DT"`) em um data frame. A função converte os valores para data com `lubridate::dmy()`, identifica registros vazios, nulos e inválidos, e retorna um resumo com indicadores de validade e qualidade da variável.}
\usage{incomp_sist_multi_dt(banco, variavel, nulo = NA, nivel_validos = 90)}
\arguments{
  \item{banco}{Data frame com os dados.}
  \item{variavel}{Vetor de nomes das variáveis de data. Apenas variáveis cujo nome começa com `"DT"` são processadas.}
  \item{nulo}{Valor ou vetor de valores considerados nulos, como `NA` ou uma sequência de códigos de ausência.}
  \item{nivel_validos}{Percentual mínimo de observações válidas para que a variável seja classificada como adequada (padrão: 90).}
}
\details{A função aplica `lubridate::dmy()` aos valores da variável e considera inválidas as entradas vazias, `NA`, strings em branco e valores listados em `nulo`. O resultado é um `tibble` contendo o número total de observações, número e percentual de registros válidos, número e percentual de nulos, avaliação final (`Adequado` ou `Inadequado`) e a data mínima e máxima observadas.}
\value{Um `tibble` com a avaliação da completude para cada variável de data.}
\examples{
\dontrun{
  banco <- data.frame(
    DT_NASCIMENTO = c("01/01/2000", "", "15/07/1999", "99/99/9999"),
    DT_CADASTRO = c("10/02/2020", "12/03/2021", "", "20/11/2022")
  )

  resultados <- incomp_sist_multi_dt(banco, c("DT_NASCIMENTO", "DT_CADASTRO"))
  print(resultados)
}
}

