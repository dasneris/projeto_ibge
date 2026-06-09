-- =============================================================================
-- Densidade demografica por UF
-- Operacao aritmetica entre colunas (populacao / area) + ORDENACAO
-- Automacao, o banco gera a coluna "classificacao" via CASE WHEN,
-- entregando o dado interpretado.
-- -----------------------------------------------------------------------------
-- REGRA DE NEGOCIO:
--   >= 100 hab/km2 ... 'Alta densidade'   (pressao urbana: transporte, habitacao)
--   >=  20 hab/km2 ... 'Media densidade'
--   <   20 hab/km2 ... 'Baixa densidade'  (vazios demograficos / custo logistico)
-- =============================================================================
SELECT uf AS estado,
       populacao,
       area_km2,
       ROUND((populacao / area_km2)::numeric, 2) AS densidade,
       CASE
         WHEN populacao / area_km2 >= 100 THEN 'Alta densidade'
         WHEN populacao / area_km2 >=  20 THEN 'Media densidade'
         ELSE 'Baixa densidade'
       END AS classificacao
FROM censo
ORDER BY densidade DESC;
