# =============================================================================
# conexao.R  —  Conexao com o banco PostgreSQL
# Unico lugar onde ficam as credenciais e as funcoes de acesso ao banco.
# =============================================================================

library(DBI)
library(RPostgres)

# ---- Credenciais (ajuste aqui) 

config_bd <- list(
  host    = "localhost",
  porta   = 5432,
  usuario = "postgres",
  senha   = "postgres",
  banco   = "censo_ibge"
)

# ---- Abre uma conexao com o banco

conectar <- function() {
  dbConnect(
    RPostgres::Postgres(),
    host     = config_bd$host,
    port     = config_bd$porta,
    user     = config_bd$usuario,
    password = config_bd$senha,
    dbname   = config_bd$banco
  )
}

# Executa um SELECT e devolve um data.frame
# Abre e fecha a conexao sozinha

consultar <- function(sql) {
  con <- conectar()
  on.exit(dbDisconnect(con))
  dbGetQuery(con, sql)
}
