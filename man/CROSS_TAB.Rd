\name{CROSS_TAB}
\alias{CROSS_TAB}
\title{Tabulacao cruzada interativa com testes estatisticos}
\usage{
CROSS_TAB(
  data,
  var_exposicao,
  var_desfecho,
  exp_pos = NULL,
  exp_neg = NULL,
  desf_pos = NULL,
  desf_neg = NULL
)
}
\arguments{
\item{data}{Data frame contendo a base de dados.}

\item{var_exposicao}{Nome da variavel de exposicao, passada como string.}

\item{var_desfecho}{Nome da variavel de desfecho, passada como string.}

\item{exp_pos}{Valor que define o grupo Exposto. Se \code{NULL}, sera solicitado interativamente.}

\item{exp_neg}{Valor que define o grupo Nao Exposto. Se \code{NULL}, sera solicitado interativamente.}

\item{desf_pos}{Valor que define o grupo com o Desfecho (Caso). Se \code{NULL}, sera solicitado interativamente.}

\item{desf_neg}{Valor que define o grupo sem o Desfecho (Controle). Se \code{NULL}, sera solicitado interativamente.}
}
\value{
Uma lista contendo os seguintes resultados:
\itemize{
  \item \code{tabela_2x2}: Matriz de contingencia 2x2.
  \item \code{oddsratio}: Resultados de Odds Ratio calculados via pacote \code{epitools}.
  \item \code{riskratio}: Resultados de Risk Ratio calculados via pacote \code{epitools}.
  \item \code{chi_quadrado}: Teste de Qui-quadrado de Pearson com correcao de Yates.
  \item \code{exato_fisher}: Teste Exato de Fisher.
}
}
\description{
Gera uma tabela de contingencia 2x2 e calcula as razoes de chance (Odds Ratio) e risco (Risk Ratio), alem de aplicar testes de hipotese (Qui-quadrado e Exato de Fisher). Permite selecao interativa de pontos de corte para variaveis numericas e categorias para variaveis de texto.
}
\details{
Caso os parametros categoricos (\code{exp_pos}, \code{exp_neg}, \code{desf_pos}, \code{desf_neg}) nao sejam fornecidos, a funcao abrira menus interativos no console, exigindo que o usuario faca as escolhas durante a execucao. Por isso, a funcao so pode ser rodada em sessoes interativas (\code{interactive() == TRUE}).
}
\examples{
\dontrun{
# Exemplo 1: Uso interativo (ira gerar prompts no console)
CROSS_TAB(data = bd, var_exposicao = "SEXO", var_desfecho = "APGAR1")

# Exemplo 2: Uso direto, sem prompts
CROSS_TAB(
  data = bd, 
  var_exposicao = "FUMO", 
  var_desfecho = "CANCER", 
  exp_pos = "Sim", 
  exp_neg = "Nao", 
  desf_pos = "Positivo", 
  desf_neg = "Negativo"
)
}
}
