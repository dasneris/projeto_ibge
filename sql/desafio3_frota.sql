-- =============================================================================
-- Frota acima da media nacional
-- Requisito tecnico: filtragem DINAMICA via SUBQUERY (consulta aninhada no WHERE).
--                    A linha de corte nao e' fixa: e' recalculada pelo proprio banco.
-- Automacao: coluna "categoria_frota" via CASE WHEN, comparando cada UF
--                         com MULTIPLOS da media nacional (tambem por subquery).
-- -----------------------------------------------------------------------------
-- REGRA DE NEGOCIO (relativa a media nacional de veiculos):
--   >= 2.0x a media ... 'Frota muito acima da media'
--   >= 1.5x a media ... 'Frota bem acima da media'
--   <  1.5x a media ... 'Frota acima da media'
-- =============================================================================

SELECT uf AS estado,
       total_veiculos,
       CASE
         WHEN total_veiculos >= 2.0 * (SELECT AVG(total_veiculos) FROM censo) THEN 'Frota muito acima da media'
         WHEN total_veiculos >= 1.5 * (SELECT AVG(total_veiculos) FROM censo) THEN 'Frota bem acima da media'
         ELSE 'Frota acima da media'
       END AS categoria_frota
FROM censo
WHERE total_veiculos > (SELECT AVG(total_veiculos) FROM censo)   -- subquery
ORDER BY total_veiculos DESC;
