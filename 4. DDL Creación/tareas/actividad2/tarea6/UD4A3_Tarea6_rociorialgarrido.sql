-- 1. Si la base de datos ya existe, eliminarla
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'CONFLICTOSBELICOS')
BEGIN
    DROP DATABASE CONFLICTOSBELICOS;
END 
GO

-- 2. Crear la base de datos con sus respectivos archivos
CREATE DATABASE CONFLICTOSBELICOS
ON 
PRIMARY (
    NAME = conflictos_data, 
    FILENAME = 'C:\conflictosbelicos\conflictos_data.mdf', 
    SIZE = 5MB, 
    FILEGROWTH = 15%
),

FILEGROUP grupo_interviene (
    NAME = grupo_datos1, 
    FILENAME = 'C:\conflictosbelicos\grupo_datos1.ndf', 
    SIZE = 8MB, 
    FILEGROWTH = 5MB
),

(
    NAME = grupo_datos2, 
    FILENAME = 'C:\conflictosbelicos\grupo_datos2.ndf', 
    SIZE = 8MB, 
    FILEGROWTH = 5MB
),

FILEGROUP grupo_traficantes (
    NAME = traficante_datos1, 
    FILENAME = 'C:\conflictosbelicos\traficante_datos1.ndf', 
    SIZE = 5MB, 
    FILEGROWTH = 3MB, 
    MAXSIZE = 12MB    
),

FILEGROUP grupo_organizaciones (
    NAME = organizacion_data1, 
    FILENAME = 'C:\conflictosbelicos\organizacion_data1.ndf', 
    SIZE = 8MB, 
    FILEGROWTH = 3MB
),
(
    NAME = organizacion_data2, 
    FILENAME = 'C:\conflictosbelicos\organizacion_data2.ndf', 
    SIZE = 8MB, 
    FILEGROWTH = 3MB
)

LOG ON (
    NAME = conflicto1_log, 
    FILENAME = 'C:\conflictosbelicos\conflicto1_log.ldf', 
    SIZE = 5MB, 
    FILEGROWTH = 3MB
),
(
    NAME = conflicto2_log, 
    FILENAME = 'C:\conflictosbelicos\conflicto2_log.ldf', 
    SIZE = 5MB, 
    FILEGROWTH = 3MB
);
GO

-- 3. Usar la base de datos
USE CONFLICTOSBELICOS;
GO

-- 4. Crear esquemas
CREATE SCHEMA CONFLICTOS;
CREATE SCHEMA GRUPOS;
CREATE SCHEMA TRAFICANTES;
CREATE SCHEMA ORGANIZACIONES;
CREATE SCHEMA ARMAS;
GO

-- 5. Crear un tipo de datos personalizado para fechas
CREATE TYPE fecha_nula FROM DATETIME NULL;
GO

-- 6. Creación de tablas en sus respectivos esquemas

-- Tabla PAIS
CREATE TABLE CONFLICTOS.PAIS (
    codigoPais INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Tabla CONFLICTO
CREATE TABLE CONFLICTOS.CONFLICTO (
    idConflicto INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    causa VARCHAR(20),
    fechaInicio fecha_nula DEFAULT GETDATE(),
    fechaFin DATETIME NULL DEFAULT NULL,
    codigoPais INT NULL,

    CONSTRAINT FK_ConflictoPais FOREIGN KEY (codigoPais) REFERENCES CONFLICTOS.PAIS(codigoPais) 
        ON DELETE SET NULL,
    CONSTRAINT ck_causaConflicto CHECK (causa IN ('Racial', 'Territorial', 'Religioso', 'Economico'))
);

-- Tabla GRUPO
CREATE TABLE GRUPOS.GRUPO (
    codigoGrupo INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Tabla INTERVIENE
CREATE TABLE GRUPOS.INTERVIENE (
    idConflicto INT,
    codigoGrupo INT,
    PRIMARY KEY (idConflicto, codigoGrupo),
    FOREIGN KEY (idConflicto) REFERENCES CONFLICTOS.CONFLICTO(idConflicto) ON DELETE CASCADE,
    FOREIGN KEY (codigoGrupo) REFERENCES GRUPOS.GRUPO(codigoGrupo) ON DELETE CASCADE
);

-- Tabla LIDER
CREATE TABLE GRUPOS.LIDER (
    codigoLider CHAR(5) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    codigoGrupo INT NULL,
    FOREIGN KEY (codigoGrupo) REFERENCES GRUPOS.GRUPO(codigoGrupo) ON DELETE SET NULL,
    CONSTRAINT CK_CodigoLider CHECK (codigoLider LIKE 'LD[0-9][0-9][0-9]' OR codigoLider LIKE 'LR[0-9][0-9][0-9]')
);

-- Tabla JEFE
CREATE TABLE GRUPOS.JEFE (
    codigoJefe INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    codigoGrupo INT NULL,
    FOREIGN KEY (codigoGrupo) REFERENCES GRUPOS.GRUPO(codigoGrupo) ON DELETE SET NULL
);

-- Tabla ORGANIZACIONES
CREATE TABLE ORGANIZACIONES.ORGANIZACIONES (
    idOrganizacion INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    tipo VARCHAR(20),
    CONSTRAINT CK_ORGANIZACIONES CHECK (tipo IN ('Gubernamental', 'No Gubernamental', 'Internacional'))
);

-- Tabla DIALOGA
CREATE TABLE ORGANIZACIONES.DIALOGA (
    idOrganizacion INT,
    idConflicto INT,
    PRIMARY KEY (idOrganizacion, idConflicto),
    FOREIGN KEY (idOrganizacion) REFERENCES ORGANIZACIONES.ORGANIZACIONES(idOrganizacion) ON DELETE CASCADE,
    FOREIGN KEY (idConflicto) REFERENCES CONFLICTOS.CONFLICTO(idConflicto) ON DELETE CASCADE
);

-- Tabla MEDIA
CREATE TABLE ORGANIZACIONES.MEDIA (
    idMedia INT PRIMARY KEY,
    tipoAyuda VARCHAR(20),
    CONSTRAINT CK_TIPOAYUDA CHECK (tipoAyuda IN ('Médica', 'Diplomática', 'Presencial'))
);

-- Tabla ARMA
CREATE TABLE ARMAS.ARMA (
    codigoArma INT PRIMARY KEY,
    tipo VARCHAR(100) UNIQUE NOT NULL,
    alcance INT NOT NULL,
    unidadAlcance VARCHAR(10) DEFAULT 'km',
    CONSTRAINT CK_alcanceArmas CHECK (unidadAlcance IN ('m', 'km'))
);

-- Tabla CATEGORIA
CREATE TABLE ARMAS.CATEGORIA (
    nombre VARCHAR(50) PRIMARY KEY,
    descripcion TEXT NOT NULL
);

-- Relación ARMA-CATEGORIA
CREATE TABLE ARMAS.ARMA_CATEGORIA (
    codigoArma INT,
    nombreCategoria VARCHAR(50),
    PRIMARY KEY (codigoArma, nombreCategoria),
    FOREIGN KEY (codigoArma) REFERENCES ARMAS.ARMA(codigoArma) ON DELETE CASCADE,
    FOREIGN KEY (nombreCategoria) REFERENCES ARMAS.CATEGORIA(nombre) ON DELETE CASCADE
);

-- Tabla STOCK
CREATE TABLE TRAFICANTES.STOCK (
    codigoArma INT PRIMARY KEY,
    cantidad INT NOT NULL,
    FOREIGN KEY (codigoArma) REFERENCES ARMAS.ARMA(codigoArma) ON DELETE CASCADE
);

-- Tabla TRAFICANTE
CREATE TABLE TRAFICANTES.TRAFICANTE (
    idTraficante INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    nacionalidad VARCHAR(50) NOT NULL
);

-- Tabla SUMINISTRA
CREATE TABLE TRAFICANTES.SUMINISTRA (
    idTraficante INT,
    codigoArma INT,
    cantidad INT NOT NULL,
    PRIMARY KEY (idTraficante, codigoArma),
    FOREIGN KEY (idTraficante) REFERENCES TRAFICANTES.TRAFICANTE(idTraficante) ON DELETE CASCADE,
    FOREIGN KEY (codigoArma) REFERENCES ARMAS.ARMA(codigoArma) ON DELETE CASCADE
);

-- Verificación de metadatos
SELECT name, type_desc, physical_name FROM sys.master_files WHERE database_id = DB_ID('CONFLICTOSBELICOS');
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG = 'CONFLICTOSBELICOS';
SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_CATALOG = 'CONFLICTOSBELICOS';
SELECT * FROM INFORMATION_SCHEMA.SCHEMATA;
