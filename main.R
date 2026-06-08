# =============================================================================
# main.R  —  PONTO DE ENTRADA (console)
# CSV bruto -> limpeza -> banco -> SQL com classificacao
# automatica -> INSIGHT gerado pelo sistema abaixo de cada consulta.
# Rodar: source("main.R")
# =============================================================================

source("R/conexao.R")    # conexao + consultar()
source("R/ingestao.R")   # importar_csv() + gravar_no_banco()
source("R/queries.R")    # SQL_* (carregadas da pasta sql/)
source("R/insights.R")   # insight_*() — interpretacao automatica

# Imprime um desafio: titulo + SQL + resultado + INSIGHT
mostrar <- function(titulo, sql, fn_insight) {
  cat("\n=====================================================================\n")
  cat(titulo, "\n")
  cat("---------------------------------------------------------------------\n")
  cat(sql, "\n")
  cat("---------------------------------------------------------------------\n")
  resultado <- consultar(sql)
  print(resultado, row.names = FALSE)
  cat("\n", fn_insight(resultado), "\n", sep = "")   # <- Insight Automático
}

# Coleta, Limpeza e Preparacao 
dados <- importar_csv()
cat("Linhas carregadas do CSV:", nrow(dados), "\n")

gravar_no_banco(dados)
cat("Tabela 'censo' criada/atualizada no PostgreSQL.\n")

# Analise e Automacao (SQL puro + classificacao via CASE WHEN) ---
mostrar("DESAFIO 1: Densidade demografica",         SQL_DENSIDADE,       insight_densidade)
mostrar("DESAFIO 2: Agregacao por grande regiao",   SQL_REGIOES,         insight_regioes)
mostrar("DESAFIO 3: Frota acima da media nacional", SQL_FROTA,           insight_frota)
mostrar("DESAFIO 4: Vulnerabilidade social",        SQL_VULNERABILIDADE, insight_vulnerabilidade)

cat("\n\nPipeline concluido (dado bruto -> inteligencia automatizada).\n")
