# =============================================================================
# graficos.R  —  Funcoes que montam os graficos de cada desafio
# As cores seguem a COLUNA DE CLASSIFICACAO gerada pelo banco,
# para que o grafico mostre a interpretacao automatica de forma visual.
# =============================================================================


library(ggplot2)

# Desafio 1 — Densidade demografica por UF
grafico_densidade <- function(df) {
  ggplot(df, aes(x = reorder(estado, densidade), y = densidade, fill = classificacao)) +
    geom_col() +
    coord_flip() +
    scale_fill_manual(values = c(
      "Alta densidade"  = "#225ea8",
      "Media densidade" = "#41b6c4",
      "Baixa densidade" = "#c7e9b4"
    )) +
    labs(title = "Densidade demografica por UF (hab/km2)",
         x = NULL, y = "Habitantes por km2", fill = "Classificacao") +
    theme_minimal(base_size = 13)
}

# Desafio 2 — IDH medio por grande regiao
grafico_regioes <- function(df) {
  ggplot(df, aes(x = reorder(regiao, media_idh), y = media_idh, fill = classificacao)) +
    geom_col() +
    geom_text(aes(label = media_idh), hjust = -0.1, size = 4.5) +
    coord_flip() +
    ylim(0, 1) +
    scale_fill_manual(values = c(
      "Alto desenvolvimento"  = "#238b45",
      "Medio desenvolvimento" = "#74c476",
      "Baixo desenvolvimento" = "#bae4b3"
    )) +
    labs(title = "IDH medio por grande regiao",
         x = NULL, y = "IDH medio", fill = "Classificacao") +
    theme_minimal(base_size = 13)
}

# Desafio 3 — UFs com frota acima da media
grafico_frota <- function(df) {
  ggplot(df, aes(x = reorder(estado, total_veiculos), y = total_veiculos, fill = categoria_frota)) +
    geom_col() +
    coord_flip() +
    scale_fill_manual(values = c(
      "Frota muito acima da media" = "#993404",
      "Frota bem acima da media"   = "#d95f0e",
      "Frota acima da media"       = "#fe9929"
    )) +
    labs(title = "UFs com frota acima da media nacional",
         x = NULL, y = "Total de veiculos", fill = "Categoria") +
    theme_minimal(base_size = 13)
}

# Desafio 4 — Renda x matriculas
grafico_vulnerabilidade <- function(df) {
  ggplot(df, aes(x = renda_per_capita, y = matriculas_ef,
                 label = estado, color = nivel_vulnerabilidade)) +
    geom_point(size = 4) +
    geom_text(vjust = -0.8, size = 4, show.legend = FALSE) +
    scale_color_manual(values = c(
      "Vulnerabilidade critica"  = "#c51b8a",
      "Vulnerabilidade alta"     = "#f768a1",
      "Vulnerabilidade moderada" = "#fbb4b9"
    )) +
    labs(title = "Vulnerabilidade: renda per capita x matriculas no fundamental",
         x = "Renda mensal per capita (R$)",
         y = "Matriculas no ensino fundamental",
         color = "Nivel") +
    theme_minimal(base_size = 13)
}
