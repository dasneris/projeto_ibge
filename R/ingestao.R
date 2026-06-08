# =============================================================================
# ingestao.R  —  Coleta, Limpeza e Preparacao
# Le o CSV do IBGE, limpa os dados e grava a tabela 'censo' no Postgres.
# -----------------------------------------------------------------------------
# COLETA:
#   Fonte : IBGE — Estatisticas dos Estados/UFs do Brasil
#   Portal: https://www.ibge.gov.br/  (secao "Estados" / "Cidades e Estados")
#   Arquivo: IBGE_Estatisicas_Brasil.csv  (em formato CSV)
#   Caracteristicas do arquivo bruto: encoding ISO-8859-1, separador ';',
#   numeros no padrao BR (decimal ',' e milhar '.') e nulos como '-' ou '...'.
#
# LIMPEZA aplicada abaixo:
#   1) leitura com o locale correto (encoding + decimal + milhar);
#   2) padronizacao dos nomes das colunas;
#   3) tratamento de valores nulos ('', 'NA', '-', '...');
#   4) conversao das colunas quantitativas para numerico;
#   5) derivacao da grande regiao a partir do codigo da UF (padrao IBGE).
# =============================================================================

library(readr)
library(dplyr)

CAMINHO_CSV <- "IBGE_Estatisicas_Brasil.csv"

# Colunas que precisam ser numericas
COLUNAS_NUMERICAS <- c(
  "area_km2", "populacao", "densidade_origem", "matriculas_ef",
  "idh", "receitas", "despesas", "renda_per_capita", "total_veiculos"
)

# Deriva a grande regiao a partir do 1o digito do codigo da UF
regiao_por_codigo <- function(cod) {
  digito <- substr(as.character(cod), 1, 1)
  dplyr::case_when(
    digito == "1" ~ "Norte",
    digito == "2" ~ "Nordeste",
    digito == "3" ~ "Sudeste",
    digito == "4" ~ "Sul",
    digito == "5" ~ "Centro-Oeste",
    TRUE          ~ "Indefinida"
  )
}

# Le o CSV e devolve um data.frame limpo e padronizado
# Charset ISO-8859-1; delimitador ';'; decimal ','
importar_csv <- function(caminho = CAMINHO_CSV) {
  dados <- read_delim(
    file    = caminho,
    delim   = ";",
    locale  = locale(encoding = "ISO-8859-1",
                     decimal_mark = ",", grouping_mark = "."),
    na      = c("", "NA", "-", "..."),
    trim_ws = TRUE,
    show_col_types = FALSE
  )

  names(dados) <- c(
    "uf", "codigo", "gentilico", "governador", "capital",
    "area_km2", "populacao", "densidade_origem", "matriculas_ef",
    "idh", "receitas", "despesas", "renda_per_capita", "total_veiculos"
  )

  dados$regiao <- regiao_por_codigo(dados$codigo)
  dados[COLUNAS_NUMERICAS] <- lapply(dados[COLUNAS_NUMERICAS], as.numeric)

  dados
}

# Grava o data.frame na tabela 'censo' (sobrescreve)
gravar_no_banco <- function(dados) {
  con <- conectar()
  on.exit(dbDisconnect(con))
  dbWriteTable(con, "censo", dados, overwrite = TRUE)
}
