-- Ejercicio 1:

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



-- Ejercicio 2:
-- Comprobar existencia de la tabla RIO
IF EXISTS (SELECT * FROM SYS.tables WHERE name='RIO')
BEGIN
	DROP TABLE RIO
END

-- Crear tabla RIO en el grupo principal
CREATE TABLE RIO(
-- Primero creamos todas las variables
	Codigo SMALLINT NOT NULL,
	Nombre VARCHAR(30) NOT NULL,
	Nacimiento VARCHAR(40) NULL,
	Vertiente VARCHAR(15) NULL
		CONSTRAINT DF_VertienteRio DEFAULT 'Mediterránea',
	Longitud FLOAT NOT NULL,
	CaudalAnual FLOAT NOT NULL,
	CaudalTrimestral FLOAT NOT NULL,
	Actividad VARCHAR(20) NOT NULL,
	
-- Creamos las constraints (reglas)	
	CONSTRAINT PK_Codigo PRIMARY KEY (Codigo),
	
	CONSTRAINT CK_CodigoRio CHECK (Codigo LIKE '[0-9][0-9][0-9]-[AR]'),
	CONSTRAINT U_NombreRio UNIQUE (Nombre),
	CONSTRAINT U_Nacimiento UNIQUE (Nacimiento),
	CONSTRAINT CK_VertienteRio CHECK (Vertiente IN('Mediterránea', 'Atlántica', 'Cántabra')),
	CONSTRAINT CK_LongitudRio CHECK (Longitud > 20.5),
	CONSTRAINT CK_CAUDALANUAL CHECK (caudalAnual BETWEEN 10 AND 1000),
	CONSTRAINT CK_CAUDALTRIMESTRAL CHECK (caudalTrimestral = caudalAnual / 3)	
)

-- Comprobamos la creación de la tabla y sus constraints 
exec sp_help RIO
exec sp_helpconstraint RIO


-- Comprobar existencia de la tabla TRAMO
IF EXISTS (SELECT * FROM SYS.tables WHERE name='TRAMO')
BEGIN
	DROP TABLE TRAMO
END


-- Crear tabla TRAMO en el grupo principal
CREATE TABLE TRAMO(
-- Primero creamos todas las variables
	CodRio SMALLINT NOT NULL,
	Numero INT NOT NULL,
	Kilometros FLOAT NOT NULL
		CONSTRAINT DF_KilometrosTramo DEFAULT 2.5,
	Curso VARCHAR(5) NOT NULL
		CONSTRAINT DF_CursoTramo DEFAULT 'Medio',
	LugarInicio VARCHAR(40) NOT NULL,
	LugarFin VARCHAR(40) NOT NULL, 
	
	CONSTRAINT PK_Tramo PRIMARY KEY (CodRio, Numero),
	CONSTRAINT FK_TramoRio FOREIGN KEY (CodRio) REFERENCES RIO(Codigo)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	
	CONSTRAINT CK_KilometrosTramo CHECK (Kilometros > 0.5 AND Kilometros < 10),
	CONSTRAINT CK_Curso CHECK (Kilometros IN ('Alto', 'Medio', 'Bajo')),
	CONSTRAINT CK_LugarFinTramo CHECK (LugarFin != LugarInicio)
)

-- Comprobar la creación de la tabla y sus constraints
exec sp_help TRAMO
exec sp_helpconstraint TRAMO


-- Comprobamos existencia de la tabla ESPECIETRAMO
IF EXISTS (SELECT * FROM SYS.tables WHERE name='ESPECIETRAMO')
BEGIN
	DROP TABLE ESPECIETRAMO
END

-- Creamos la tabla ESPECIETRAMO
CREATE TABLE ESPECIETRAMO (
	CodRio SMALLINT NOT NULL,
	Numero INT NOT NULL,
	
	CONSTRAINT PK_ESPECIETRAMO PRIMARY KEY (CodRio, Numero),
	CONSTRAINT FK_ESPECIETRAMO_TRAMO FOREIGN KEY (CodRio, Numero) REFERENCES TRAMO(CodRio, Numero)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
)

-- Comprobar la creación de la tabla y sus constrains
exec sp_help ESPECIETRAMO
exec sp_helpconstraint ESPECIETRAMO

-- Comprobamos la existencia de la tabla ESPECIE
IF EXISTS (SELECT * FROM SYS.tables WHERE name='ESPECIE')
BEGIN
	DROP table ESPECIE
END 

-- Creamos la tabla ESPECIE
CREATE TABLE ESPECIE (
	CodEspecie INT IDENTITY (5, 5) NOT NULL,
	Nombre VARCHAR(45) NOT NULL,
	Comestible BIT NULL
		CONSTRAINT DF_ComestibleEspecie DEFAULT 1,
	
	CONSTRAINT PK_ESPECIE PRIMARY KEY (CodEspecie)
	
)

-- Comprobamos la creación de la tabla ESPECIE
exec sp_help ESPECIE
exec sp_helpconstraint ESPECIE


-- Modificamos la tabla ESPECIETRAMO añadiendo el atributo que no podíamos añadir antes
-- Agregar codEspecie y establecer la clave foránea
ALTER TABLE ESPECIETRAMO 
	ADD codEspecie INT NOT NULL,
	CONSTRAINT FK_ESPECIE_ESPECIETRAMO FOREIGN KEY (CodEspecie) REFERENCES ESPECIE(CodEspecie)
		ON UPDATE CASCADE
		ON DELETE CASCADE
		
-- Eliminar la clave primaria existente
ALTER TABLE ESPECIETRAMO 
	DROP CONSTRAINT PK_ESPECIETRAMO
	
-- Crear la nueva clave primaria compuesta
ALTER TABLE ESPECIETRAMO 
	ADD CONSTRAINT PK_ESPECIETRAMO PRIMARY KEY (CodRio, Numero, CodEspecie)
	
-- Comprobamos la modificación de la tabla
exec sp_help ESPECIETRAMO
exec sp_helpconstraint ESPECIETRAMO