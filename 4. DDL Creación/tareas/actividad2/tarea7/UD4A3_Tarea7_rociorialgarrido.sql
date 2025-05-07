use master

IF EXISTS (SELECT * FROM SYS.databases WHERE name = 'BDFOTOGRAFIA')
	BEGIN
		PRINT 'La base de datos ya existe. Se va a borrar.'
		DROP DATABASE BDFOTOGRAFIA
	END
GO 

CREATE DATABASE BDFOTOGRAFIA

ON PRIMARY (
	NAME = ArchivoPrincipal,
    FILENAME = 'C:\ArquivosBD\BDFotografia\ArchivoPrincipal.mdf',
    SIZE = 15 MB
),

FILEGROUP Datos_Fotografía DEFAULT (
    NAME='datosFotos1',
    FILENAME='C:\ArquivosBD\BDFotografia\datosFotos1.ndf',
    SIZE= 10 MB, 
	FILEGROWTH = 10%, 
    MAXSIZE = 50 MB  
),
(
    NAME='datosfotos2',
    FILENAME='C:\ArquivosBD\BDFotografia\datosfotos2.ndf',
    SIZE= 10 MB,
    FILEGROWTH = 10%, 
    MAXSIZE = 50MB
)

GO 
USE BDFOTOGRAFIA
GO

exec sp_helpdb 'bdfotografia' 

IF EXISTS (SELECT * FROM SYS.tables WHERE name='exposicion')

	DROP TABLE exposicion
GO 

--tabla exposicion

create table exposicion (
    codExposicion smallint IDENTITY (1,5) not null,
    nombreExposicion char(30) UNIQUE not null,
    descripcion varchar(50) null,
    tematica varchar(50) not null,

    CONSTRAINT PK_EXPOSICIONES PRIMARY KEY (codExposicion),
    CONSTRAINT CK_TEMATICA CHECK 
		(tematica IN ('naturaleza', 'gentes', 'fiestas', 'tradiciones', 'espacios', 'edificios', 'deportes'))
);

exec sp_help 'exposicion'
exec sp_helpconstraint 'exposicion'

GO
IF EXISTS (SELECT * FROM SYS.tables WHERE name='centro')
	DROP TABLE centro
GO 

--tabla centro 
create table centro (
	codCentro varchar(5),	
	nombreCentro varchar(30) NOT NULL, 
	fechainauguración DATE
		CONSTRAINT DF_FECHAINAUGURACIONCENTRO DEFAULT (DATEADD(YEAR, -2, GETDATE())),
	mCuadrados float,
	telefono varchar(9),
	páginaWeb varchar(30) NULL,
	direccion varchar(30) NOT NULL,
	localidad smallint NOT NULL,
	
	CONSTRAINT PK_CENTRO PRIMARY KEY (codCentro),
	CONSTRAINT U_NOMBRECENTRO UNIQUE (nombreCentro),
	
	CONSTRAINT CK_CODIGOCENTRO CHECK (codCentro LIKE '[A-Z]-[0-9][0-9][0-9]'),
    CONSTRAINT CK_TELEFONO CHECK (telefono LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
);
go
exec sp_help 'centro'
exec sp_helpconstraint 'centro'
go

--tabla provincia 
IF EXISTS (SELECT * FROM SYS.tables WHERE name='provincia')
	DROP TABLE provincia
GO 

create table provincia (
	codProvincia smallint IDENTITY (1,1),
	nombreProvincia varchar(40),
	
	
	CONSTRAINT PK_PROVINCIA PRIMARY KEY (codProvincia),
	CONSTRAINT U_NOMBREPROVINCIA UNIQUE (nombreProvincia),
);
go
exec sp_help 'provincia'
exec sp_helpconstraint 'provincia'
go

--tabla localidad
IF EXISTS (SELECT * FROM SYS.tables WHERE name='localidad')
	DROP TABLE localidad
GO 

create table localidad (
	codLocalidad smallint IDENTITY (1,1),
	nombreLocalidad varchar(40),
	paginaWeb varchar(70),
	numHabitantes int,
	provincia smallint,
	 
	CONSTRAINT PK_LOCALIDAD PRIMARY KEY (codLocalidad),
	CONSTRAINT U_NOMBRELOCALIDAD UNIQUE (nombreLocalidad),
	
	CONSTRAINT MINIMO_HABITANTES CHECK (numHabitantes > '1000'),
	CONSTRAINT FK_PROVINCIA_LOCALIDAD FOREIGN KEY (provincia)
		REFERENCES Provincia(codProvincia),
	CONSTRAINT d_habitantes CHECK (numHabitantes = '5000')
	
);
go
exec sp_help 'localidad'
exec sp_helpconstraint 'localidad'
go

ALTER TABLE centro 
	ADD CONSTRAINT FK_CENTRO_LOCALIDAD FOREIGN KEY (localidad) REFERENCES localidad(codLocalidad);

GO 
IF EXISTS (SELECT * FROM SYS.tables WHERE name='sala')
	DROP TABLE sala
GO 
create table sala (
	numSala smallint not null,
	codCentro varchar(5) not null,
	mCuadrados float
		CONSTRAINT DF_MCUADRADOS_SALA DEFAULT 100,
	fotografia smallint not null,
	
	CONSTRAINT PK_SALA PRIMARY KEY (numSala, codCentro),
	CONSTRAINT FK_CODCENTRO_SALA FOREIGN KEY (codCentro) REFERENCES centro (codCentro)
		ON DELETE CASCADE
		ON UPDATE CASCADE,

	CONSTRAINT CK_M2SALA CHECK (mCuadrados >= 20 AND mCuadrados <= 1000)
);

exec sp_help 'sala'
exec sp_helpconstraint 'sala'

--tabla SALAS-EXPOSICION

IF EXISTS (SELECT * FROM SYS.tables WHERE name='EXPOSICION_SALA')
	DROP TABLE EXPOSICION_SALA
GO 
create table EXPOSICION_SALA (
	numSala smallint not null,
	codCentro varchar(5) not null,
	codExposicion smallint not null,
	fechaInicio date not null,
	fechaFin date null,
	
	CONSTRAINT PK_SALA_EXPOSICION PRIMARY KEY (numSala, codCentro, codExposicion),
	
	CONSTRAINT FK_SALA_EXPOSICION_SALA FOREIGN KEY (numSala, codCentro) REFERENCES sala (numSala, codCentro)
		ON DELETE CASCADE
		ON UPDATE CASCADE,

	CONSTRAINT FK_SALA_EXPOSICION_EXPOSICION FOREIGN KEY (codExposicion) REFERENCES exposicion (codExposicion)
);


--ESQUEMA FOTOGRAFIAS 

GO
CREATE SCHEMA FOTOGRAFIAS AUTHORIZATION dbo;
GO

IF EXISTS (SELECT * FROM SYS.schemas WHERE name='FOTOGRAFIAS')
	BEGIN
		PRINT 'Este esquema ya existe. Se va a borrar.'
    	DROP schema FOTOGRAFIAS
    END 

GO

CREATE SCHEMA FOTOGRAFIAS AUTHORIZATION dbo;

GO


if exists (
	select * FROM sys.tables WHERE name = 'FOTOGRAFIA'
	AND SCHEMA_ID = SCHEMA_ID('FOTOGRAFIAS')
)
DROP TABLE FOTOGRAFIAS.FOTOGRAFIA;
GO 

CREATE TABLE FOTOGRAFIAS.FOTOGRAFIA (
	codFotografia smallint not null,
	nombre varchar(30) not null,
	fechaRealizacion date not null,
	medidas int not null,
	color varchar(1) not null,
	temática varchar(25) not null, 
	tipo varchar(25) not null, 
	
	CONSTRAINT PK_FOTOGRAFIA PRIMARY KEY (codFotografia),
	
	CONSTRAINT CK_COLORFOTOGRAFIA CHECK (color in ('s','n'))
);

GO

if exists (
	select * FROM sys.tables WHERE name = 'artistica'
	AND SCHEMA_ID = SCHEMA_ID('FOTOGRAFIAS')
)
DROP TABLE FOTOGRAFIAS.artistica;
GO 

CREATE TABLE FOTOGRAFIAS.artistica (
	
	codFotografia smallint not null,
	encuadre varchar(25)
		CONSTRAINT DF_ENCUADRE_FOTOARTISTICA DEFAULT 'vertical', 
	composicion varchar(50),
	
	CONSTRAINT PK_FOTOARTISTICA PRIMARY KEY (codFotografia),
	CONSTRAINT FK_FOTOARTISTICA FOREIGN KEY (codFotografia) REFERENCES fotografiaS.fotografia(codFotografia) 
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT CK_ENCUADRE_FOTOARTISTICA CHECK (encuadre IN ('horizontal', 'vertical', 'inclinado')),
);
GO 

if exists (
	select * FROM sys.tables WHERE name = 'documental'
	AND SCHEMA_ID = SCHEMA_ID('FOTOGRAFIAS')
)
DROP TABLE FOTOGRAFIAS.documental;
GO 

CREATE TABLE FOTOGRAFIAS.documental (
	codFotografia smallint not null,
	tipo varchar(25) -- (social, actualidad, etc..).
	
	CONSTRAINT PK_FOTODOCUMENTAL PRIMARY KEY (codFotografia),
	CONSTRAINT FK_FOTODOCUMENTAL FOREIGN KEY (codFotografia) REFERENCES fotografiaS.fotografia(codFotografia) 
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

GO
exec sp_help 'fotografias.fotografia'
exec sp_help 'fotografias.artistica'
exec sp_help 'fotografias.documental'

exec sp_helpconstraint 'fotografias.fotografia'
exec sp_helpconstraint 'fotografias.artistica'
exec sp_helpconstraint 'fotografias.documental'
GO


if exists (
	select * FROM sys.tables WHERE name = 'FOTOGRAFO'
)
DROP TABLE FOTOGRAFO;
GO 

CREATE TABLE FOTOGRAFO(
	codFotografo smallint IDENTITY (1,1) not null,
	nombre varchar(30) not null,
	apellido1 varchar(30) not null,
	apellido2 varchar(30) null,
	fechaNacimiento date,
	nacionalidad varchar(25),
	codInfluencer smallint, --tiene que ser el mismo tipo q la clave  
	
	CONSTRAINT PK_fotografo PRIMARY KEY (codFotografo),
	
	--fogorafo mayor de edad
	CONSTRAINT CK_EDAD_FOTOGRAFO CHECK (  
		DATEDIFF(YEAR, fechaNacimiento, GETDATE()) > 18 
			OR (
            DATEDIFF(YEAR, fechaNacimiento, GETDATE()) = 18 
            AND (
                MONTH(GETDATE()) > MONTH(fechaNacimiento) 
            OR (MONTH(GETDATE()) = MONTH(fechaNacimiento) AND DAY(GETDATE()) >= DAY(fechaNacimiento))
            )
			)
		),
		
	CONSTRAINT FK_FOTOGRAFO_INFLUENCER FOREIGN KEY (codInfluencer)
        REFERENCES FOTOGRAFO (codFotografo) 
        ON DELETE no action
        ON UPDATE no action
);

CREATE TABLE FOTOGRAFO_PREMIO (
	codFotografo smallint not null,
	premio int,
	
	CONSTRAINT PK_PREMIO_FOTOGRAFO PRIMARY KEY (codFotografo, premio),
	CONSTRAINT FK_PREMIO_FOTOGRAFO FOREIGN KEY (codFotografo) REFERENCES
		fotografo(codFotografo)

);

ALTER TABLE FOTOGRAFIAS.FOTOGRAFIA
	ADD fotografo smallint not null,
	CONSTRAINT FK_FOTOGRAFO_FOTOGRAFIA FOREIGN KEY (fotografo) 
		REFERENCES fotografo(codFotografo);

ALTER TABLE FOTOGRAFIAS.FOTOGRAFIA
	ADD exposicion smallint not null,
	CONSTRAINT FK_FOTOGRAFIA_EXPOSICION FOREIGN KEY (exposicion) 
		REFERENCES exposicion(codExposicion);