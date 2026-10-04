-- 04_checagem_chaves.sql
-- Na análise nacional, a chave deve ser ano + tipo_eleicao + sequencial, conforme o guia da Base dos Dados.
-- Nesta exploração (só 2022 e SE), a junção usa apenas o sequencial.
--
-- Objetivo: verificar se a chave do candidato permite juntar as tabelas.
-- Atenção: em candidatos a chave se chama "sequencial"; nas outras tabelas,
-- "sequencial_candidato".
-- Recorte fixo de exploração: ano = 2022 e sigla_uf = 'SE'.
--
-- Linhas do resultado:
--   1. receitas_candidato: percentual de sequencial_candidato nulo.
--   2. resultados_candidato: percentual de sequencial_candidato nulo.
--   3. receitas_candidato: percentual de linhas que casam com candidatos,
--      sobre o total de linhas de receitas.
--   4. receitas_candidato: percentual de linhas que casam com candidatos,
--      só sobre as linhas com sequencial_candidato preenchido.
--   5. candidatos: quantidade de valores de sequencial que aparecem mais de
--      uma vez.
--   6. receitas_candidato: linhas com sequencial_candidato preenchido sem par
--      em candidatos, uma linha por cargo. Serve para ver se o não casamento
--      vem de cargos nacionais (ex.: presidente), cuja sigla_uf em candidatos
--      não é 'SE'. As linhas com sequencial nulo já aparecem no item 1.
--
-- Texto vazio ou só com espaços nas chaves é tratado como nulo, também na junção.
-- As colunas "cargo" e "percentual" ficam nulas nas linhas em que não se aplicam.

WITH receitas AS (
  SELECT
    NULLIF(TRIM(sequencial_candidato), '') AS sequencial_candidato,
    cargo
  FROM `basedosdados.br_tse_eleicoes.receitas_candidato`
  WHERE ano = 2022
    AND sigla_uf = 'SE'
),

resultados AS (
  SELECT
    NULLIF(TRIM(sequencial_candidato), '') AS sequencial_candidato
  FROM `basedosdados.br_tse_eleicoes.resultados_candidato`
  WHERE ano = 2022
    AND sigla_uf = 'SE'
),

candidatos_linhas AS (
  SELECT
    NULLIF(TRIM(sequencial), '') AS sequencial
  FROM `basedosdados.br_tse_eleicoes.candidatos`
  WHERE ano = 2022
    AND sigla_uf = 'SE'
),

candidatos AS (
  -- DISTINCT evita que sequenciais repetidos multipliquem linhas na junção
  SELECT DISTINCT sequencial
  FROM candidatos_linhas
  WHERE sequencial IS NOT NULL
),

receitas_casamento AS (
  SELECT
    r.sequencial_candidato,
    r.cargo,
    c.sequencial IS NOT NULL AS casou
  FROM receitas AS r
  LEFT JOIN candidatos AS c
    ON r.sequencial_candidato = c.sequencial
),

sequenciais_duplicados AS (
  SELECT sequencial
  FROM candidatos_linhas
  WHERE sequencial IS NOT NULL
  GROUP BY sequencial
  HAVING COUNT(*) > 1
)

SELECT
  1 AS ordem,
  'receitas_candidato' AS tabela,
  'sequencial_candidato nulo' AS checagem,
  CAST(NULL AS STRING) AS cargo,
  COUNT(*) AS n_linhas,
  ROUND(100 * SAFE_DIVIDE(COUNTIF(sequencial_candidato IS NULL), COUNT(*)), 2) AS percentual
FROM receitas

UNION ALL

SELECT
  2 AS ordem,
  'resultados_candidato' AS tabela,
  'sequencial_candidato nulo' AS checagem,
  CAST(NULL AS STRING) AS cargo,
  COUNT(*) AS n_linhas,
  ROUND(100 * SAFE_DIVIDE(COUNTIF(sequencial_candidato IS NULL), COUNT(*)), 2) AS percentual
FROM resultados

UNION ALL

SELECT
  3 AS ordem,
  'receitas_candidato' AS tabela,
  'casa com candidatos (sobre o total de linhas)' AS checagem,
  CAST(NULL AS STRING) AS cargo,
  COUNT(*) AS n_linhas,
  ROUND(100 * SAFE_DIVIDE(COUNTIF(casou), COUNT(*)), 2) AS percentual
FROM receitas_casamento

UNION ALL

SELECT
  4 AS ordem,
  'receitas_candidato' AS tabela,
  'casa com candidatos (sobre linhas com sequencial preenchido)' AS checagem,
  CAST(NULL AS STRING) AS cargo,
  COUNT(*) AS n_linhas,
  ROUND(100 * SAFE_DIVIDE(COUNTIF(casou), COUNT(*)), 2) AS percentual
FROM receitas_casamento
WHERE sequencial_candidato IS NOT NULL

UNION ALL

SELECT
  5 AS ordem,
  'candidatos' AS tabela,
  'valores de sequencial repetidos' AS checagem,
  CAST(NULL AS STRING) AS cargo,
  COUNT(*) AS n_linhas,
  CAST(NULL AS FLOAT64) AS percentual
FROM sequenciais_duplicados

UNION ALL

SELECT
  6 AS ordem,
  'receitas_candidato' AS tabela,
  'sem par em candidatos (sequencial preenchido)' AS checagem,
  cargo,
  COUNT(*) AS n_linhas,
  CAST(NULL AS FLOAT64) AS percentual
FROM receitas_casamento
WHERE sequencial_candidato IS NOT NULL
  AND NOT casou
GROUP BY cargo

ORDER BY ordem, n_linhas DESC
