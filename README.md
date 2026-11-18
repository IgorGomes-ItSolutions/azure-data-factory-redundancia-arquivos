# Redundância de arquivos com Azure Data Factory

Laboratório DIO de extração de dados fictícios do SQL Server para TXT no Azure Data Lake Storage Gen2, seguida de cópia e verificação de integridade.

## Visão geral

| Item | Resumo |
|---|---|
| Objetivo | Demonstrar ingestão e validar uma segunda cópia do arquivo |
| Situação | Execução em nuvem documentada; saídas disponíveis para validação local |
| Resultado | 6 registros, soma das quantidades de 194 e duas cópias de 423 bytes |
| Limite | Cópia lógica na mesma conta não equivale a backup isolado ou regional |

## Organização

- [adf/](adf/): linked services, datasets, runtime e pipeline.
- [sql/01_criar_base.sql](sql/01_criar_base.sql): preparação da tabela fictícia.
- [data/](data/): referência e saídas do laboratório.
- [validar_copias.py](validar_copias.py): comparação dos bytes e dos registros.
- [Registro de execução](docs/estado-execucao.md) e [resultado da validação](docs/validacao-arquivos.json).

## Como reproduzir

1. Prepare SQL Server e Self-hosted Integration Runtime em ambiente de laboratório.
2. Revise e execute o script SQL em uma instância dedicada.
3. Configure uma conta ADLS Gen2 com contêineres privados para origem e cópia.
4. Configure os linked services com as identidades e permissões do seu ambiente. Mantenha chaves e credenciais fora do Git.
5. Adapte os JSONs, valide e publique o pipeline.
6. Execute manualmente após revisar custos e permissões.
7. Baixe as duas saídas e compare-as com o validador.

A segunda cópia usa formato binário para preservar os bytes; as pastas por execução evitam misturar resultados. O runtime local depende do computador ligado.

## Validação local

Com Python 3, na raiz do repositório:

```bash
python validar_copias.py data/saida-validada/raw/documentos.txt data/saida-validada/redundancia/documentos.txt
```

A comparação foi novamente aprovada em 18/11/2026: conteúdo idêntico nas cópias e compatível com a referência. Não foi executado um novo pipeline em nuvem nessa revisão.

## Decisões e limites

Os dados são fictícios. Uma cópia na mesma conta compartilha riscos de acesso e de região. Uma solução real precisa definir retenção, isolamento, RPO/RTO e testes de restauração. Resultados deste pequeno conjunto não estimam desempenho em grandes volumes.

Em produção, a conexão SQL deve usar configuração adequada de certificado e autenticação; exceções estritamente locais do laboratório não devem ser reproduzidas automaticamente.

## Próximos passos

Evoluir o estudo para políticas de retenção e restauração em ambiente isolado, com validação documentada antes de qualquer alegação de resultado.

## Autoria e referências

Projeto de estudo de Igor Gomes para o desafio DIO **Criando Processos de Redundância de Arquivos na Azure**.

- [Conector SQL Server](https://learn.microsoft.com/en-us/azure/data-factory/connector-sql-server)
- [Self-hosted Integration Runtime](https://learn.microsoft.com/en-us/azure/data-factory/create-self-hosted-integration-runtime)
- [Conector ADLS Gen2](https://learn.microsoft.com/en-us/azure/data-factory/connector-azure-data-lake-storage)

[Voltar ao portfólio](https://github.com/IgorGomes-ItSolutions)
