# =============================================================================
# app.R  —  FRONT-END SHINY
# Le do PostgreSQL e exibe os 4 desafios em graficos + tabelas.
# Rodar:  shiny::runApp("app.R")
# Pre-requisito: rodar main.R uma vez antes (cria/popula a tabela 'censo').
# =============================================================================

library(shiny)
library(DT)

source("R/conexao.R")   # conexao + consultar()
source("R/queries.R")   # SQL_DENSIDADE, SQL_REGIOES, SQL_FROTA, SQL_VULNERABILIDADE
source("R/graficos.R")  # grafico_*()

# Interface
ui <- fluidPage(
  titlePanel("Analise Sociodemografica e Economica Nacional — IBGE"),
  tabsetPanel(
    tabPanel("Densidade",
             br(), plotOutput("plot1", height = "520px"), br(), DTOutput("tab1")),
    tabPanel("Regioes",
             br(), plotOutput("plot2", height = "420px"), br(), DTOutput("tab2")),
    tabPanel("Frota",
             br(), plotOutput("plot3", height = "420px"), br(), DTOutput("tab3")),
    tabPanel("Vulnerabilidade",
             br(), plotOutput("plot4", height = "420px"), br(), DTOutput("tab4"))
  )
)

# Servidor
server <- function(input, output, session) {
  # consulta o banco uma vez e reaproveita o resultado
  d1 <- reactive(consultar(SQL_DENSIDADE))
  d2 <- reactive(consultar(SQL_REGIOES))
  d3 <- reactive(consultar(SQL_FROTA))
  d4 <- reactive(consultar(SQL_VULNERABILIDADE))

  output$plot1 <- renderPlot(grafico_densidade(d1()))
  output$plot2 <- renderPlot(grafico_regioes(d2()))
  output$plot3 <- renderPlot(grafico_frota(d3()))
  output$plot4 <- renderPlot(grafico_vulnerabilidade(d4()))

  output$tab1 <- renderDT(datatable(d1(), options = list(pageLength = 10)))
  output$tab2 <- renderDT(datatable(d2()))
  output$tab3 <- renderDT(datatable(d3()))
  output$tab4 <- renderDT(datatable(d4()))
}

shinyApp(ui, server)
