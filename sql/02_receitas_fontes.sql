-- 02_receitas_fontes.sql
-- Objetivo: listar as combinações de fonte, origem e natureza da receita,
-- com quantidade de lançamentos e soma de valor, para entender como o FEFC
-- aparece nos dados e o que mais compõe as receitas.
-- Recorte fixo de exploração: ano = 2022 e sigla_uf = 'SE'.
--
-- DECISÃO PENDENTE: qual combinação de fonte/origem identifica recurso do FEFC
--   (a ser definida depois de olhar o resultado desta query).
-- DECISÃO PENDENTE: tratar ou não receitas estimáveis em dinheiro
--   (natureza_receita) junto com receitas financeiras.

SELECT
  fonte_receita,
  origem_receita,
  natureza_receita,
  COUNT(*) AS n_lancamentos,
  SUM(valor_receita) AS valor_total
FROM `basedosdados.br_tse_eleicoes.receitas_candidato`
WHERE ano = 2022
  AND sigla_uf = 'SE'
GROUP BY fonte_receita, origem_receita, natureza_receita
ORDER BY valor_total DESC
