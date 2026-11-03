# Dados sintéticos

O CSV é uma referência dos seis registros a inserir no SQL Server. Ele não é a evidência de extração do Azure Data Factory. Os arquivos TXT finais deverão vir da execução real do pipeline e ficarão nos containers privados `raw` e `redundancia`.

Cada execução usa sua própria pasta `bronze/documentos/<RunId>/documentos.txt` para evitar sobrescrever a saída de outra execução. Reexecutar a mesma atividade na mesma execução pode regravar aquele caminho.
