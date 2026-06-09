-- =============================================================================
-- Vulnerabilidade social
-- Requisito tecnico: clausula de restricao COMPLEXA com MULTIPLOS operadores
--                    logicos -> AND, OR e NOT combinados na mesma condicao.
-- Automacao: coluna "nivel_vulnerabilidade" via CASE WHEN, graduando
--                         a severidade de cada UF selecionada.
-- -----------------------------------------------------------------------------
-- REGRA DE SELECAO (WHERE) — usa AND + OR + NOT:
--   (renda baixa  E  muitas matriculas no fundamental)
--   OU (IDH baixo  E  NAO pertence a regiao Sudeste)
--
-- REGRA DE CLASSIFICACAO (CASE) — limiares didaticos:
--   renda < 1200  E  idh < 0.700 ... 'Vulnerabilidade critica'
--   renda < 1500  OU idh < 0.720 ... 'Vulnerabilidade alta'
--   demais casos                 ... 'Vulnerabilidade moderada'
-- =============================================================================

SELECT uf AS estado,
       renda_per_capita,
       matriculas_ef,
       idh,
       CASE
         WHEN renda_per_capita < 1200 AND idh < 0.700 THEN 'Vulnerabilidade critica'
         WHEN renda_per_capita < 1500 OR  idh < 0.720 THEN 'Vulnerabilidade alta'
         ELSE 'Vulnerabilidade moderada'
       END AS nivel_vulnerabilidade
FROM censo
WHERE (renda_per_capita < 1500 AND matriculas_ef > 200000)
   OR (idh < 0.700 AND NOT regiao = 'Sudeste')
ORDER BY renda_per_capita ASC;
