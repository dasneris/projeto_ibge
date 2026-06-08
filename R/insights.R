# =============================================================================
# insights.R  —  Gera o "Insight Final" AUTOMATICAMENTE a partir dos resultados
# Cada funcao recebe o data.frame devolvido pela query e monta um texto
# interpretativo, lendo as colunas de classificacao que o banco ja processou.
# Os numeros e contagens saem dos proprios dados.
# =============================================================================

# Densidade
insight_densidade <- function(df) {
  lider   <- df$estado[1]
  valor   <- df$densidade[1]
  n_alta  <- sum(df$classificacao == "Alta densidade")
  n_baixa <- sum(df$classificacao == "Baixa densidade")
  sprintf(
    paste0("INSIGHT: %s lidera com %.2f hab/km2. %d UF(s) em alta densidade ",
           "(pressao por transporte, habitacao e saneamento) e %d em baixa densidade ",
           "(vazios demograficos e maior custo logistico)."),
    lider, valor, n_alta, n_baixa
  )
}

# Regioes
insight_regioes <- function(df) {
  sprintf(
    paste0("INSIGHT: a regiao %s tem o maior IDH medio (%.3f) e a regiao %s o menor (%.3f). ",
           "A diferenca evidencia a desigualdade regional e ajuda a priorizar investimento publico."),
    df$regiao[1], df$media_idh[1],
    df$regiao[nrow(df)], df$media_idh[nrow(df)]
  )
}

# Frota
insight_frota <- function(df) {
  sprintf(
    paste0("INSIGHT: %d UF(s) com frota acima da media nacional, lideradas por %s ",
           "(%s veiculos). Concentracao de frota indica demanda por malha viaria, ",
           "combustivel e politicas de transito."),
    nrow(df), df$estado[1],
    format(df$total_veiculos[1], big.mark = ".", decimal.mark = ",")
  )
}

# Vulnerabilidade
insight_vulnerabilidade <- function(df) {
  if (nrow(df) == 0)
    return("INSIGHT: nenhuma UF atendeu aos criterios de vulnerabilidade definidos.")
  n_crit <- sum(df$nivel_vulnerabilidade == "Vulnerabilidade critica")
  n_alta <- sum(df$nivel_vulnerabilidade == "Vulnerabilidade alta")
  sprintf(
    paste0("INSIGHT: %d UF(s) sinalizadas, sendo %d criticas e %d em alta. ",
           "Sao candidatas prioritarias a programas de transferencia de renda ",
           "e reforco na educacao basica."),
    nrow(df), n_crit, n_alta
  )
}
