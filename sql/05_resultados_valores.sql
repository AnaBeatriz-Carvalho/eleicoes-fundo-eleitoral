-- 05_resultados_valores.sql
-- Objetivo: listar as combinações de turno e resultado existentes em
-- resultados_candidato, com contagem, para entender como a eleição do
-- candidato está codificada.
-- Recorte fixo de exploração: ano = 2022 e sigla_uf = 'SE'.
--
-- DECISÃO PENDENTE: quais valores de resultado contam como "eleito"
--   (ex.: eleito por QP, eleito por média, suplente).
-- DECISÃO PENDENTE: como tratar candidatos com linha no 1º e no 2º turno.

SELECT
  turno,
  resultado,
  COUNT(*) AS n_linhas
FROM `basedosdados.br_tse_eleicoes.resultados_candidato`
WHERE ano = 2022
  AND sigla_uf = 'SE'
GROUP BY turno, resultado
ORDER BY turno, n_linhas DESC
