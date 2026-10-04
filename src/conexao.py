"""Conexão com a Base dos Dados (BigQuery).

Lê o BILLING_PROJECT_ID do arquivo .env na raiz do repositório e executa
consultas SQL via basedosdados.read_sql.
"""

import os
from pathlib import Path

import basedosdados as bd
import pandas as pd
from dotenv import load_dotenv

RAIZ = Path(__file__).resolve().parent.parent
PASTA_SQL = RAIZ / "sql"

load_dotenv(RAIZ / ".env")


def obter_billing_project_id() -> str:
    """Retorna o ID do projeto de faturamento definido no .env."""
    billing_project_id = os.getenv("BILLING_PROJECT_ID")
    if not billing_project_id:
        raise RuntimeError(
            "BILLING_PROJECT_ID não encontrado. Copie o .env.example para .env "
            "e preencha com o ID do seu projeto no Google Cloud."
        )
    return billing_project_id


def executar_query(query: str) -> pd.DataFrame:
    """Executa uma query no BigQuery via Base dos Dados e retorna um DataFrame."""
    return bd.read_sql(query, billing_project_id=obter_billing_project_id())


def ler_sql(nome_arquivo: str) -> str:
    """Lê o conteúdo de um arquivo .sql da pasta sql/."""
    return (PASTA_SQL / nome_arquivo).read_text(encoding="utf-8")


if __name__ == "__main__":
    # Teste de conexão: não consulta nenhuma tabela, só confirma a autenticação.
    resultado = executar_query("SELECT 1 AS teste")
    print(resultado)
