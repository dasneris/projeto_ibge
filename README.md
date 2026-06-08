# Projeto IBGE — Análise Sociodemográfica e Econômica Nacional

Disciplina: Big Data e Analytics · Linguagem: R · SGBD: PostgreSQL

Uma **linha do tempo do dado**: do CSV bruto e bagunçado → limpeza → banco
relacional → consultas SQL que **classificam** os resultados automaticamente →
**insight** gerado pelo próprio sistema abaixo de cada consulta.

## Estrutura

```
projeto_ibge/
├── main.R                       # Ponto de entrada: pipeline completo
├── app.R                        # Front-end Shiny: gráficos + tabelas
├── IBGE_Estatisicas_Brasil.csv  # Base de dados (dado bruto)
│
├── R/
│   ├── conexao.R                # Conexão com o banco (credenciais + consultar())
│   ├── ingestao.R               # coleta, limpeza e gravação da tabela
│   ├── queries.R                # Carrega as consultas SQL da pasta sql/
│   ├── insights.R               # Gera o "Insight Final" automático por desafio
│   └── graficos.R               # Gráficos coloridos pela classificação do banco
│
└── sql/
    ├── desafio1_densidade.sql       # Aritmética entre colunas + ordenação
    ├── desafio2_regioes.sql         # Agregação (COUNT/AVG) + GROUP BY
    ├── desafio3_frota.sql           # Filtragem dinâmica com subquery
    └── desafio4_vulnerabilidade.sql # Restrição complexa (AND + OR + NOT)
```

## Etapa 1 — Coleta, Limpeza e Preparação

- **Coleta:** o arquivo `IBGE_Estatisicas_Brasil.csv` foi baixado do portal do
  IBGE (https://www.ibge.gov.br/ — seção *Cidades e Estados*), com as
  estatísticas por UF. O arquivo bruto vem em `ISO-8859-1`, separador `;`,
  números no padrão brasileiro (decimal `,` e milhar `.`) e nulos como `-`/`...`.
- **Limpeza** (em `R/ingestao.R`): leitura com o *locale* correto, padronização
  dos nomes das colunas, tratamento de nulos, conversão para numérico e
  derivação da **grande região** a partir do código da UF (padrão IBGE).

### Dicionário de dados

| Atributo | Descrição |
|---|---|
| `uf` | Unidade da Federação (estado) |
| `codigo` | Código IBGE da UF (1º dígito = grande região) |
| `regiao` | Grande região derivada do código (Norte, Nordeste, …) |
| `area_km2` | Área territorial em km² |
| `populacao` | População estimada |
| `idh` | Índice de Desenvolvimento Humano |
| `renda_per_capita` | Renda mensal per capita (R$) |
| `matriculas_ef` | Matrículas no ensino fundamental |
| `total_veiculos` | Frota total de veículos |
| `receitas` / `despesas` | Receitas e despesas públicas |

## Etapa 2 — Análise e Automação

Cada desafio é uma consulta em `sql/`. Além de resolver a análise, **o banco
classifica o resultado** numa coluna de status (via `CASE WHEN`), entregando o
dado já interpretado:

| Desafio | Técnica exigida | Coluna automática |
|---|---|---|
| 1 — Densidade | aritmética entre colunas + ordenação | `classificacao` (Alta/Média/Baixa densidade) |
| 2 — Regiões | agregação + agrupamento | `classificacao` (nível de desenvolvimento por IDH) |
| 3 — Frota | subquery  | `categoria_frota` (acima / bem acima / muito acima) |
| 4 — Vulnerabilidade | `AND` + `OR` + `NOT` | `nivel_vulnerabilidade` (crítica/alta/moderada) |

> Os **limiares** de cada regra de negócio estão comentados no topo de cada
> arquivo `.sql`

## Etapa 3 — Insight Final

O `main.R` imprime, **logo abaixo de cada consulta**, um insight gerado
automaticamente a partir dos próprios resultados (`R/insights.R`).
 No `app.R`, os gráficos pintam cada categoria com uma cor, reforçando a leitura visual.

## Como rodar

1. Instale os pacotes (uma vez):
   ```r
   install.packages(c("DBI", "RPostgres", "readr", "dplyr", "shiny", "ggplot2", "DT"))
   ```
2. Ajuste a senha do banco em **`R/conexao.R`** (único lugar com credenciais).
   ```r
    
   ```
3. Rode o pipeline e veja resultados + insights no console:
   ```r
   source("main.R")
   ```
4. Abra a interface visual:
   ```r
   shiny::runApp("app.R")
   ```

## Onde mexer

- **Trocar a senha / banco** → `R/conexao.R`
- **Editar uma consulta ou um limiar de regra** → arquivo em `sql/`
- **Mudar um texto de insight** → `R/insights.R`
- **Mudar um gráfico / cores** → `R/graficos.R`
- **Mudar a limpeza dos dados** → `R/ingestao.R`
