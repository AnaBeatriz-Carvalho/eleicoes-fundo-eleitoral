-- 03_receitas_repasses.sql
-- Objetivo: medir quanto das receitas vem de outro candidato ou de órgão
-- partidário. Esses repasses podem gerar dupla contagem: o mesmo recurso do
-- FEFC pode aparecer como receita do diretório e de novo como receita do
-- candidato, ou passar de um candidato para outro.
-- Recorte fixo de exploração: ano = 2022 e sigla_uf = 'SE'.
--
-- A query separa as receitas com sequencial_candidato_doador preenchido e nulo
-- e, dentro de cada grupo, abre por esfera_partidaria_doador.
-- Texto vazio ou só com espaços é tratado como nulo.
--
-- DECISÃO PENDENTE: qual critério define "repasse" (sequencial do doador,
--   esfera partidária, texto de origem_receita, ou combinação).
-- DECISÃO PENDENTE: repasses entre candidatos entram ou saem do total de FEFC
--   recebido por candidato (evitar dupla contagem).
-- DECISÃO PENDENTE: como tratar repasses de diretórios de outra UF ou nacionais.

SELECT
  IF(NULLIF(TRIM(sequencial_candidato_doador), '') IS NULL, 'nulo', 'preenchido') AS sequencial_doador,
  esfera_partidaria_doador,
  COUNT(*) AS n_lancamentos,
  SUM(valor_receita) AS valor_total
FROM `basedosdados.br_tse_eleicoes.receitas_candidato`
WHERE ano = 2022
  AND sigla_uf = 'SE'
GROUP BY sequencial_doador, esfera_partidaria_doador
ORDER BY sequencial_doador, valor_total DESC
