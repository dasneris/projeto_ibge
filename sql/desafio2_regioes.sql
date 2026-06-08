# =============================================================================
-- Agregacao por grande regiao
-- Requisito tecnico: funcoes de AGREGACAO (COUNT, AVG) + AGRUPAMENTO por categoria
-- Automacao: coluna "classificacao" calculada sobre o AVG(idh) do grupo,
--                         classificando cada regiao por nivel de desenvolvimento.
-- -----------------------------------------------------------------------------
-- REGRA DE NEGOCIO (faixas de IDH — limiares didaticos)
--   media_idh >= 0.750 ... 'Alto desenvolvimento'
--   media_idh >= 0.700 ... 'Medio desenvolvimento'
--   media_idh <  0.700 ... 'Baixo desenvolvimento'
# =============================================================================

SELECT regiao,
       COUNT(*)                                 AS qtd_estados,
       ROUND(AVG(idh)::numeric, 3)              AS media_idh,
       ROUND(AVG(renda_per_capita)::numeric, 2) AS media_renda,
       CASE
         WHEN AVG(idh) >= 0.750 THEN 'Alto desenvolvimento'
         WHEN AVG(idh) >= 0.700 THEN 'Medio desenvolvimento'
         ELSE 'Baixo desenvolvimento'
       END AS classificacao
FROM censo
GROUP BY regiao
ORDER BY media_idh DESC;
