#' Tabulação cruzada com teste qui-quadrado
#'
#' @param data Data frame.
#' @param var1 Nome da primeira variável (string).
#' @param var2 Nome da segunda variável (string).
#' @return Lista com `table` (tabulação cruzada) e `chi_square` (resultado do
#'   teste qui-quadrado).
#' @export
TABLE <- function(data, 
                       var_exposicao, 
                       var_desfecho, 
                       exp_pos = NULL, 
                       exp_neg = NULL, 
                       desf_pos = NULL, 
                       desf_neg = NULL) {
  
  if (!interactive()) {
    stop("Esta função requer uma sessão interativa para exibir os prompts de escolha.")
  }
  
  vec_exp <- data[[var_exposicao]]
  vec_desf <- data[[var_desfecho]]
  
  # --- Função interna para lidar com interações numéricas ---
  processar_numerico <- function(vetor, nome_var, tipo) {
    cat("\n[!] A variável de", tipo, "('", nome_var, "') é NUMÉRICA.\n", sep="")
    
    # Pede o valor do corte
    corte_str <- readline(prompt = "Digite o ponto de corte (ex: 6): ")
    corte <- as.numeric(gsub(",", ".", corte_str)) # Aceita vírgula ou ponto
    
    # Pede a regra para o grupo Positivo (Exposto ou Caso)
    nome_grupo <- ifelse(tipo == "EXPOSIÇÃO", "EXPOSTO", "DESFECHO POSITIVO (Caso)")
    cat("\nPara o grupo", nome_grupo, ", os valores devem ser em relação ao corte (", corte, "):\n", sep="")
    
    opcoes <- c(
      paste0("Maior que o corte (> ", corte, ") - Aberto"),
      paste0("Maior ou igual ao corte (>= ", corte, ") - Fechado"),
      paste0("Menor que o corte (< ", corte, ") - Aberto"),
      paste0("Menor ou igual ao corte (<= ", corte, ") - Fechado")
    )
    
    escolha <- menu(opcoes)
    if (escolha == 0) stop("Operação cancelada pelo usuário.")
    
    # Aplica a regra escolhida e define automaticamente o complemento
    if (escolha == 1) {
      pos <- paste0(">", corte); neg <- paste0("<=", corte)
      vetor_cat <- ifelse(vetor > corte, pos, neg)
    } else if (escolha == 2) {
      pos <- paste0(">=", corte); neg <- paste0("<", corte)
      vetor_cat <- ifelse(vetor >= corte, pos, neg)
    } else if (escolha == 3) {
      pos <- paste0("<", corte); neg <- paste0(">=", corte)
      vetor_cat <- ifelse(vetor < corte, pos, neg)
    } else if (escolha == 4) {
      pos <- paste0("<=", corte); neg <- paste0(">", corte)
      vetor_cat <- ifelse(vetor <= corte, pos, neg)
    }
    
    return(list(vetor_cat = vetor_cat, pos = pos, neg = neg))
  }
  
  # ==========================================
  # 1. TRATAMENTO DA VARIÁVEL DE EXPOSIÇÃO
  # ==========================================
  if (is.numeric(vec_exp) && (is.null(exp_pos) || is.null(exp_neg))) {
    resultado_num <- processar_numerico(vec_exp, var_exposicao, "EXPOSIÇÃO")
    vec_exp <- resultado_num$vetor_cat
    exp_pos <- resultado_num$pos
    exp_neg <- resultado_num$neg
    
  } else if (is.null(exp_pos) || is.null(exp_neg)) {
    vec_exp <- as.character(vec_exp)
    niveis_exp <- unique(na.omit(vec_exp))
    
    cat("\n--- Selecione as categorias para EXPOSIÇÃO ('", var_exposicao, "') ---\n", sep="")
    cat("Escolha o valor para EXPOSTO (exp_pos):\n")
    escolha1 <- menu(niveis_exp)
    exp_pos <- niveis_exp[escolha1]
    
    cat("\nEscolha o valor para NÃO EXPOSTO (exp_neg):\n")
    niveis_restantes <- niveis_exp[niveis_exp != exp_pos]
    escolha2 <- menu(niveis_restantes)
    exp_neg <- niveis_restantes[escolha2]
  }
  
  # ==========================================
  # 2. TRATAMENTO DA VARIÁVEL DE DESFECHO
  # ==========================================
  if (is.numeric(vec_desf) && (is.null(desf_pos) || is.null(desf_neg))) {
    resultado_num <- processar_numerico(vec_desf, var_desfecho, "DESFECHO")
    vec_desf <- resultado_num$vetor_cat
    desf_pos <- resultado_num$pos
    desf_neg <- resultado_num$neg
    
  } else if (is.null(desf_pos) || is.null(desf_neg)) {
    vec_desf <- as.character(vec_desf)
    niveis_desf <- unique(na.omit(vec_desf))
    
    cat("\n--- Selecione as categorias para DESFECHO ('", var_desfecho, "') ---\n", sep="")
    cat("Escolha o valor para DESFECHO POSITIVO / CASO (desf_pos):\n")
    escolha1 <- menu(niveis_desf)
    desf_pos <- niveis_desf[escolha1]
    
    cat("\nEscolha o valor para DESFECHO NEGATIVO / CONTROLE (desf_neg):\n")
    niveis_restantes <- niveis_desf[niveis_desf != desf_pos]
    escolha2 <- menu(niveis_restantes)
    desf_neg <- niveis_restantes[escolha2]
  }
  
  # ==========================================
  # 3. CONSTRUÇÃO DA TABELA E TESTES
  # ==========================================
  
  dados_temp <- data
  dados_temp[[var_exposicao]] <- vec_exp
  dados_temp[[var_desfecho]] <- vec_desf
  
  sub_data <- dados_temp[
    dados_temp[[var_exposicao]] %in% c(exp_pos, exp_neg) & 
      dados_temp[[var_desfecho]] %in% c(desf_pos, desf_neg), 
  ]
  
  fator_exp <- factor(sub_data[[var_exposicao]], levels = c(exp_pos, exp_neg))
  fator_desf <- factor(sub_data[[var_desfecho]], levels = c(desf_pos, desf_neg))
  
  tab <- table(fator_exp, fator_desf)
  
  if (nrow(tab) < 2 || ncol(tab) < 2) {
    stop("Erro: As categorias escolhidas não formaram uma tabela 2x2 válida. Verifique os dados.")
  }
  
  cat("\n============================================\n")
  cat("RESUMO DA ANÁLISE:\n")
  cat("Exposição:", exp_pos, "(Exposto) vs", exp_neg, "(Não Exposto)\n")
  cat("Desfecho:", desf_pos, "(Caso) vs", desf_neg, "(Controle)\n")
  cat("============================================\n\n")
  
  list(
    tabela_2x2 = tab,
    oddsratio = epitools::oddsratio(tab, method = "wald"),
    riskratio = epitools::riskratio(tab, method = "wald"),
    chi_quadrado = chisq.test(tab, correct = TRUE),
    exato_fisher = fisher.test(tab)
  )
}

