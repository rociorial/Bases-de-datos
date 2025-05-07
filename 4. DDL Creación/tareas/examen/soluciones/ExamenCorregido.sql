IF EXISTS (SELECT * FROM SYS.databases WHERE name='RIOS')
BEGIN
	DROP DATABASE RIOS
END

-- Crear la base de datos
CREATE DATABASE RIOS

-- Archivo principal (.mdf)
ON PRIMARY(
	NAME = 'archivo_Data1',
	FILENAME = 'C:\EXRIOS\archivo_Data1.mdf',
	SIZE = 20MB,
	FILEGROWTH = 0),
	
-- Grupo de archivos de datos secundarios (.ndf)
FILEGROUP Grupo1_info(
	NAME = 'archivo_Sec1',
	FILENAME = 'C:\EXRIOS\archivo_Sec1.ndf',
	SIZE = 10MB,
	FILEGROWTH = 500KB),
	(NAME = 'archivo_Sec2',
	FILENAME = 'C:\EXRIOS\archivo_Sec2.ndf',
	SIZE = 10MB,
	FILEGROWTH = 500KB)

-- Grupo de archivos de registro (.ldf)
LOG ON(
	NAME = 'archivo_log1',
	FILENAME = 'C:\EXRIOS\archivo_log1.ldf',
	SIZE = 18MB,
	MAXSIZE = 30MB,
	FILEGROWTH = 3MB)
	
-- b) Información de la base de datos
USE RIOS
exec sp_helpdb RIOS 
-- Mostrar info de los grupos de archivos
SELECT 
    fg.name AS GrupoArchivo,
    df.name AS NombreArchivoLogico,
    df.physical_name AS RutaFisica,
    df.size * 8 / 1024 AS TamañoMB
FROM sys.filegroups fg
JOIN sys.database_files df 
    ON fg.data_space_id = df.data_space_id
ORDER BY fg.name;
-- Los grupos se han creado bien con los valores especificados

-- c) Borrar archivo archivo_sec2
ALTER DATABASE RIOS	
	REMOVE FILE archivo_Sec2
-- grupo1_info sea el grupo por defecto
ALTER DATABASE RIOS
	MODIFY FILEGROUP grupo1_info DEFAULT