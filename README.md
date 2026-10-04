# Fundo Eleitoral, gênero e raça (2018 a 2022)

## Pergunta

Entre 2018 e 2022, os partidos destinaram a mulheres e pessoas negras a parcela mínima do Fundo Especial de Financiamento de Campanha (FEFC) exigida por lei?

E, controlando pelo dinheiro recebido, a chance de eleição desses grupos muda?

## Principais achados

_Em construção._

## Dados

Fonte: [Base dos Dados](https://basedosdados.org/), conjunto `basedosdados.br_tse_eleicoes`, que organiza os dados abertos do Tribunal Superior Eleitoral (TSE) no BigQuery.

Tabelas usadas até agora:

| Tabela | Conteúdo | Uso no projeto |
|--------|----------|----------------|
| `candidatos` | Uma linha por candidatura, com cargo, partido, gênero, raça e situação | Perfil das candidaturas |
| `receitas_candidato` | Uma linha por receita declarada na prestação de contas | Identificação dos recursos do FEFC e de repasses |
| `resultados_candidato` | Resultado e votos de cada candidato por turno | Identificação de quem foi eleito |

Chave do candidato: `sequencial` em `candidatos` e `sequencial_candidato` nas demais tabelas.

A etapa atual é exploratória e usa apenas Sergipe em 2022 para conhecer a estrutura das tabelas antes de ampliar o recorte.

As regras legais de distribuição do FEFC por gênero e raça estão em [`docs/base_legal.md`](docs/base_legal.md).

## Metodologia

_Em construção._ As escolhas metodológicas são registradas em [`docs/decisoes.md`](docs/decisoes.md).

## Limitações

_Em construção._

## Como reproduzir

Pré-requisitos: Python 3.11 e um projeto no Google Cloud com a API do BigQuery ativada (o projeto é usado para faturar as consultas).

1. Clone o repositório e entre na pasta.
2. Crie e ative o ambiente virtual:

   ```bash
   python -m venv .venv
   # Windows
   .venv\Scripts\activate
   # Linux ou macOS
   source .venv/bin/activate
   ```

3. Instale as dependências:

   ```bash
   pip install -r requirements.txt
   ```

4. Copie `.env.example` para `.env` e preencha `BILLING_PROJECT_ID` com o ID do seu projeto no Google Cloud.
5. Teste a conexão (na primeira execução, o navegador abre para autenticação na conta Google):

   ```bash
   python -m src.conexao
   ```

   O resultado esperado é uma tabela com uma linha e a coluna `teste` igual a 1.

6. Abra os notebooks:

   ```bash
   jupyter notebook notebooks/
   ```

> **Nota sobre custo no BigQuery**
>
> - Nas tabelas da Base dos Dados, só a coluna `ano` é partição. Filtrar por `ano` reduz o volume lido e o custo.
> - O filtro por `sigla_uf` não reduz o volume lido: a consulta varre o ano inteiro e só depois descarta as outras UFs.
> - Nunca use `SELECT *`. O BigQuery cobra por coluna lida, então selecione apenas as colunas necessárias.

## Estrutura do repositório

```
.
├── app/            # Aplicativo Streamlit (em construção)
├── data/           # Dados locais baixados ou gerados (fora do Git)
├── docs/
│   ├── base_legal.md   # Regras de cota do FEFC por ano
│   └── decisoes.md     # Registro das decisões metodológicas
├── notebooks/
│   └── 01_exploracao_se_2022.ipynb   # Exploração das tabelas com recorte SE 2022
├── sql/
│   ├── 01_candidatos_exploracao.sql  # Candidaturas por cargo, partido, gênero, raça e situação
│   ├── 02_receitas_fontes.sql        # Fonte, origem e natureza das receitas
│   ├── 03_receitas_repasses.sql      # Repasses de candidatos e partidos (dupla contagem)
│   ├── 04_checagem_chaves.sql        # Nulos no sequencial e casamento entre tabelas
│   └── 05_resultados_valores.sql     # Valores de resultado e turno
├── src/
│   └── conexao.py      # Conexão com a Base dos Dados via BigQuery
├── .env.example        # Modelo do arquivo de variáveis de ambiente
└── requirements.txt
```
