-- Somente dados sinteticos. Execute com uma conta administrativa no SQL Server local.
IF DB_ID(N'DioRedundanciaLab') IS NULL
    CREATE DATABASE DioRedundanciaLab;
GO
USE DioRedundanciaLab;
GO
IF OBJECT_ID(N'dbo.DocumentosFicticios', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.DocumentosFicticios (
        id_documento int NOT NULL PRIMARY KEY,
        data_recebimento date NOT NULL,
        tipo_documento nvarchar(40) NOT NULL,
        unidade_ficticia nvarchar(40) NOT NULL,
        quantidade int NOT NULL CHECK (quantidade >= 0),
        status_documento nvarchar(20) NOT NULL
    );
END;
GO
-- Insercao idempotente: nao apaga registros existentes.
INSERT INTO dbo.DocumentosFicticios
    (id_documento, data_recebimento, tipo_documento, unidade_ficticia, quantidade, status_documento)
SELECT v.* FROM (VALUES
 (1, CAST('2026-11-01' AS date), N'intimacao', N'Unidade Alfa', 51, N'recebido'),
 (2, CAST('2026-11-01' AS date), N'mandado', N'Unidade Beta', 45, N'validado'),
 (3, CAST('2026-11-01' AS date), N'processo', N'Unidade Alfa', 20, N'recebido'),
 (4, CAST('2026-11-01' AS date), N'inquerito', N'Unidade Gama', 34, N'validado'),
 (5, CAST('2026-11-02' AS date), N'relatorio', N'Unidade Beta', 16, N'recebido'),
 (6, CAST('2026-11-02' AS date), N'oficio', N'Unidade Gama', 28, N'validado')
) AS v(id_documento, data_recebimento, tipo_documento, unidade_ficticia, quantidade, status_documento)
WHERE NOT EXISTS (SELECT 1 FROM dbo.DocumentosFicticios d WHERE d.id_documento = v.id_documento);
GO
SELECT * FROM dbo.DocumentosFicticios ORDER BY id_documento;
SELECT COUNT(*) AS total_linhas, SUM(quantidade) AS total_documentos FROM dbo.DocumentosFicticios;
