# Execução verificada

Laboratório concluído em 3 de novembro de 2026, com dados exclusivamente fictícios.

## Ambiente

- SQL Server 2025 Express, instância dedicada DIOLAB, instalado com resultado Passed/código 0.
- Self-hosted Integration Runtime 5.71.9776.1 confirmado em execução no Azure.
- SQL acessível por TCP somente em 127.0.0.1:14333. Nenhuma regra de entrada de firewall criada.
- Identidade local do runtime com SELECT somente na tabela fictícia.
- Data Factory existente reutilizado; pipeline do projeto anterior preservado.
- ADLS Gen2 Standard LRS, namespace hierárquico habilitado, contêineres raw e redundancia privados.
- Identidade gerenciada do Data Factory autorizada somente na conta de armazenamento deste laboratório.
- Assinatura mantida sem migração para pagamento conforme o uso; limite autorizado de US$ 5 em créditos. Não há gatilhos recorrentes. O custo final deve ser consultado após a atualização da cobrança no portal.

## Resultado

Pipeline: `pl_redundancia_sql_txt`.

Execução: `ae6ff787-d557-49c6-bea5-4c31d7b93624`.

Status geral: Bem-sucedido. Duração: 1 minuto e 27 segundos.

| Atividade | Resultado | Duração observada |
| --- | --- | --- |
| SQL_para_Raw | Bem-sucedido; 6 linhas lidas e 6 gravadas | 25 s |
| Raw_para_Copia | Bem-sucedido; replicação binária | 31 s |
| Metadados_Raw | Bem-sucedido | 8 s |
| Metadados_Copia | Bem-sucedido | 9 s |
| Validar_Copias | Bem-sucedido; condição verdadeira | 3 s |

As saídas foram baixadas separadamente dos contêineres raw e redundancia. O validador comparou bytes e registros com o CSV de referência: 6 registros, soma 194, 423 bytes em cada cópia, SHA-256 idêntico `21fd4338617fd051d1ffc06cd398173e6bb2a919e8a953f50994df9b355bcd5d`.

## Diagnóstico e aprendizado

A primeira implantação do modelo falhou porque o linked service do Data Lake ainda era um rascunho no Studio. Após publicá-lo, o mesmo modelo implantou os datasets e o pipeline. Essa falha demonstra a diferença entre testar uma configuração no editor e publicar suas dependências no serviço ativo.

A autenticação integrada foi validada pelo próprio ADF. A conexão utiliza a identidade do serviço Windows e uma porta estritamente local, sem usar a senha pessoal do usuário. A chave de registro do runtime não está neste repositório.

A segunda cópia compartilha a mesma conta e região: é redundância lógica didática, não um backup independente contra perda da conta ou falha regional.
