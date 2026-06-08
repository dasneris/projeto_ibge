# =============================================================================
# queries.R  —  Carrega as consultas SQL guardadas na pasta sql/
# Cada desafio fica em seu proprio arquivo .sql.
# =============================================================================

# Le um arquivo da pasta sql/ e devolve seu conteudo como texto
ler_sql <- function(nome_arquivo) {
  caminho <- file.path("sql", nome_arquivo)
  paste(readLines(caminho, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
}

SQL_DENSIDADE       <- ler_sql("desafio1_densidade.sql")
SQL_REGIOES         <- ler_sql("desafio2_regioes.sql")
SQL_FROTA           <- ler_sql("desafio3_frota.sql")
SQL_VULNERABILIDADE <- ler_sql("desafio4_vulnerabilidade.sql")
