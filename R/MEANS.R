#' Estatísticas descritivas de uma variável numérica
#'
#' @param data Data frame.
#' @param variable Nome da coluna numérica (string).
#' @return Tibble com média, desvio padrão, mediana, mínimo e máximo.
#' @export
MEANS <- function(banco, coluna, na.rm = TRUE) {
  
  # Extrair a coluna
  x <- banco[[coluna]]
  
  # Remover NAs se solicitado
  if (na.rm) {
    x <- x[!is.na(x)]
  }
  
  n <- length(x)
  
  # Estatísticas básicas
  media <- mean(x)
  dp <- sd(x)
  mediana <- median(x)
  
  # Quartis
  p25 <- quantile(x, 0.25, names = FALSE)
  p75 <- quantile(x, 0.75, names = FALSE)
  
  # IIQ
  IIQ <- p75 - p25
  
  # Moda (pode haver mais de uma)
  freq <- table(x)
  moda <- as.numeric(names(freq[freq == max(freq)]))
  
  # Outliers (critério IQR)
  lim_inf <- p25 - 1.5 * IIQ
  lim_sup <- p75 + 1.5 * IIQ
  
  outliers <- x[x < lim_inf | x > lim_sup]
  prop_outliers <- length(outliers) / n
  
  # Retorno
  return(data.frame(
    n = n,
    media = media,
    dp = dp,
    mediana = mediana,
    p25 = p25,
    p75 = p75,
    IIQ = IIQ,
    moda = paste(moda, collapse = ", "),  # para caber no data.frame
    n_outliers = length(outliers),
    proporcao_outliers = prop_outliers
  ))
}

