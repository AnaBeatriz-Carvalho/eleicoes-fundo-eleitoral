# Registro de decisões

Cada escolha metodológica do projeto (filtros, regras, critérios) fica registrada aqui, da mais recente para a mais antiga.

## Modelo

```
### AAAA-MM-DD: título curto da decisão

- **Decisão:** o que foi decidido.
- **Motivo:** por que essa opção e não outra.
- **Impacto:** o que muda nos dados ou nos resultados (arquivos, contagens, valores afetados).
```

## Decisões pendentes

### Decidir antes de rodar

| Decisão | Query que informa |
|---------|-------------------|
| Quais situações de candidatura entram na análise (só aptas/deferidas, ou também indeferidas com recurso, renúncias etc.) | `01_candidatos_exploracao.sql` |
| Quais cargos entram na análise | `01_candidatos_exploracao.sql` e linha 6 da `04_checagem_chaves.sql` (não casamento por cargo) |
| Incluir ou não eleições suplementares (`tipo_eleicao`) | Nenhuma das queries atuais abre por `tipo_eleicao` |
| Quais eleições do período entram (gerais de 2018 e 2022, municipais de 2020, suplementares) | Nenhuma query; depende de `docs/base_legal.md` |

### Decidir depois dos resultados

| Decisão | Query que informa |
|---------|-------------------|
| Chave de junção entre as tabelas (o guia da Base dos Dados indica ano + tipo_eleicao + sequencial para a análise nacional) | `04_checagem_chaves.sql` |
| Quais valores de `resultado` contam como "eleito" (eleito por QP, por média, suplente) | `05_resultados_valores.sql` |
| Como tratar candidatos com linha no 1º e no 2º turno | `05_resultados_valores.sql` |
| Qual combinação de fonte e origem identifica recurso do FEFC | `02_receitas_fontes.sql` |
| Tratar ou não receitas estimáveis em dinheiro (`natureza_receita`) junto com as financeiras | `02_receitas_fontes.sql` |
| Qual critério define "repasse" (sequencial do doador, esfera partidária, texto de `origem_receita` ou combinação) | `03_receitas_repasses.sql` |
| Repasses entre candidatos entram ou saem do total de FEFC por candidato (dupla contagem) | `03_receitas_repasses.sql` |
| Como tratar repasses de diretórios de outra UF ou nacionais | `03_receitas_repasses.sql` |

## Decisões tomadas

