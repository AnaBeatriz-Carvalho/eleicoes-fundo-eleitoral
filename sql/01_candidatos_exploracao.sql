-- 01_candidatos_exploracao.sql
-- Objetivo: conhecer a distribuição das candidaturas em Sergipe em 2022
-- por cargo, partido, gênero, raça e situação da candidatura.
-- Recorte fixo de exploração: ano = 2022 e sigla_uf = 'SE'.
--
-- Nenhum filtro de situação, cargo ou tipo de eleição é aplicado aqui.
-- DECISÃO PENDENTE: quais situações de candidatura entram na análise final
--   (ex.: só aptas/deferidas, ou também indeferidas com recurso, renúncias etc.).
-- DECISÃO PENDENTE: quais cargos entram na análise final.
-- DECISÃO PENDENTE: incluir ou não eleições suplementares (tipo_eleicao).

SELECT
  cargo,
  sigla_partido,
  genero,
  raca,
  situacao,
  COUNT(*) AS n_candidaturas
FROM `basedosdados.br_tse_eleicoes.candidatos`
WHERE ano = 2022
  AND sigla_uf = 'SE'
GROUP BY cargo, sigla_partido, genero, raca, situacao
ORDER BY cargo, sigla_partido, genero, raca, situacao
