--	Rocío Rial Garrido	77481582X


-- EJERCICIO 1
-- Crear base de datos
CREATE DATABASE RIOS
ON
PRIMARY (
	NAME = archivo_Data1,
	FILENAME = 'C:\EXRIOS\archivo_Data1.mdf', 
	SIZE = 20MB,
	MAXSIZE = UNLIMITED,
	FILEGROWTH = 500KB
),
FILEGROUP Grupo1_info (
	NAME = archivo_Sec1,
	FILENAME = 'C:\EXRIOS\archivo_Sec1.ndf', 
	SIZE = 10MB,
	MAXSIZE = UNLIMITED,
	FILEGROWTH = 3MB
),
FILEGROUP Registro (
	NAME = archivo_Sec2,
	FILENAME = 'C:\EXRIOS\archivo_Sec2.ndf', 
	SIZE = 18MB,
	MAXSIZE = 30MB,
	FILEGROWTH = 3MB
)
LOG ON (
	NAME = archivo_Log,
	FILENAME = 'C:\EXRIOS\archivo_Log.ldf',
	SIZE = 10MB, 
	MAXSIZE = UNLIMITED,
	FILEGROWTH = 1MB
);

-- Mostrar información de la base de datos
EXEC sp_helpdb RIOS;

-- Borrar el archivo aarchivo_Sec2
ALTER DATABASE RIOS 
REMOVE FILE archivo_Sec2;

-- Hacer que el grupo1_info sea el grupo por defecto
ALTER DATABASE RIOS
MODIFY FILEGROUP Grupo1_info DEFAULT;


-- EJERCICIO 2
-- Crear tabla RIO
CREATE TABLE RIO(
	Codigo VARCHAR(7) NOT NULL,
	Nombre VARCHAR(30) NOT NULL,
	Nacimiento VARCHAR(40) NOT NULL,
	Vertiente VARCHAR(15) NOT NULL CHECK (Vertiente IN('Mediterránea','Atlántica','Cántabra'))DEFAULT 'Mediterránea',
	Longitud DECIMAL(5,1) NOT NULL CHECK (Longitud >= 20.5),
	CaudalAnual DECIMAL(6,1) NOT NULL CHECK (CaudalAnual >=  10 AND CaudalAnual <= 1000),
	CaudalTrimestral DECIMAL(6,1) NULL,
	Actividad VARCHAR(20) NULL,
	CONSTRAINT PK_RIO PRIMARY KEY (Codigo)
);
-- Mostrar información y restricciones de la tabla RIO
EXEC sp_help RIO;

-- Crear tabla TRAMO
CREATE TABLE TRAMO(
	CodRio VARCHAR(7) NOT NULL,
	Numero INT NOT NULL,
	Kilometros DECIMAL(4,1) NOT NULL CHECK (Kilometros > 0.5  AND Kilometros <= 10) DEFAULT 2.5,
	Curso VARCHAR(10) NOT NULL CHECK (Curso IN ('Alto','Medio','Bajo')) DEFAULT 'Medio',
	LugarInicio VARCHAR(40) NOT NULL,
	LugarFin VARCHAR(40) NOT NULL CHECK (LugarInicio <> LugarFin)
	CONSTRAINT PK_TRAMO PRIMARY KEY (CodRio, Numero),
	CONSTRAINT PK_TRAMO_RIO FOREIGN KEY (CodRio) REFERENCES RIO(Codigo) ON DELETE CASCADE
);
-- Mostrar información y restricciones de la tabla TRAMO
EXEC sp_help TRAMO;

-- Crear tabla ESPECIE
CREATE TABLE ESPECIE(
	CodEspecie VARCHAR(5) NOT NULL,  
	Nombre VARCHAR(45) NOT NULL,
	Comestible  CHAR(1) NOT NULL CHECK (Comestible IN ('S', 'N')),
	CONSTRAINT PK_ESPECIE PRIMARY KEY (CodEspecie)
);
-- Mostrar información y restricciones de la tabla ESPECIE
EXEC sp_help ESPECIE;


-- Crear tabla ESPECIETRAMO
CREATE TABLE ESPECIETRAMO(
	CodRio VARCHAR(7) NOT NULL,
	Numero INT NOT NULL,
	codEspecie VARCHAR(5) NOT NULL,
	CONSTRAINT PK_ESPECIE_TRAMO PRIMARY KEY (CodRio, Numero, CodEspecie),
	CONSTRAINT PK_ET_TRAMO FOREIGN KEY (CodRio, Numero) REFERENCES TRAMO(CodRio, Numero) 
	ON DELETE CASCADE,
	CONSTRAINT PK_ET_ESPECIE FOREIGN KEY (CodEspecie) REFERENCES ESPECIE(CodEspecie) 
	ON DELETE CASCADE
);
-- Mostrar información y restricciones de la tabla ESPECIETRAMO
EXEC sp_help ESPECIETRAMO;


-- EJERCICIO 3
-- Borrar el campo curso del tramo
ALTER TABLE TRAMO
DROP COLUMN Curso;
EXEC sp_help TRAMO;

-- Creación de río afluente
ALTER TABLE RIO
ADD CONSTRAINT FK_RIO_AFLUENTE
FOREIGN KEY (CodRioPadre) REFERENCES RIO(CodRio)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

EXEC sp_help RIO;

-- Cumplición de restricciones
ALTER TABLE RIO
ADD CONSTRAINT CHK_Actividad_Valida
CHECK (Actividad IN ('Perenne','Estacional','Transitorio'));

ALTER TABLE RIO
ADD CONSTRAINT DF_Actividad_Default
DEFAULT 'Estacional' FOR Actividad;
  
EXEC sp_help RIO;


-- EJERCICIO 4
-- Crear tabla PLAYA
CREATE TABLE PLAYA(
	CodPlaya INT IDENTITY(1,1) PRIMARY KEY,
	CodRio VARCHAR(7) NOT NULL,
	Numero INT NOT NULL,
	Nombre VARCHAR(120) NOT NULL,
	PH DECIMAL(3,1) NOT NULL CHECK (PH BETWEEN 4 AND 9) DEFAULT 7.5,
	FechaInspeccion DATE NOT NULL DEFAULT GETDATE() - 365,
	Servicios NVARCHAR(255) NOT NULL,
	FOREIGN KEY (CodRio, Numero) REFERENCES TRAMO(CodRio, Numero)
	ON DELETE CASCADE
	ON UPDATE CASCADE	
);

EXEC sp_help PLAYA;	