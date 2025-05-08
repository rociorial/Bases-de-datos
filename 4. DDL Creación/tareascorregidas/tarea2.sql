USE master

-- Ejercicio 1
-- Comprobar la existencia de la base de datos
IF EXISTS (SELECT * FROM SYS.databases WHERE name='ProyectosdeInvestigacion')
	DROP DATABASE ProyectosdeInvestigacion

-- Crear la base de datos
CREATE DATABASE ProyectosdeInvestigacion

-- Mostrar información de la base de datos
exec sp_helpdb ProyectosdeInvestigacion

-- Comprobar la existencia de la tabla Departamento
IF EXISTS (SELECT * FROM SYS.tables WHERE name='Departamento')
	DROP DATABASE Departamento

-- Crear tabla Departamento
CREATE TABLE Departamento(
    CodigoDpto SMALLINT IDENTITY (1,1) NOT NULL,
    Nombredto VARCHAR(30) NOT NULL, 
    Telefono VARCHAR(30) NULL,
    
    CONSTRAINT PK_CodigoDepartamento PRIMARY KEY (CodigoDpto),
    CONSTRAINT U_NombreDepartamento UNIQUE (Nombredto)
)

-- Mostrar información de la tabla
exec sp_help Departamento
exec sp_helpconstraint Departamento


-- Comprobar existencia de la tabla
IF EXISTS (SELECT * FROM SYS.tables WHERE name='Sedes')
	DROP TABLE Sedes
CREATE TABLE Sedes(
	CodigoSede SMALLINT IDENTITY (1, 1) NOT NULL,
	NombreSede VARCHAR(30) NOT NULL,
	Campus VARCHAR(30) NULL,
	
	CONSTRAINT PK_CodigoSede PRIMARY KEY (CodigoSede),
	CONSTRAINT U_NombreSede UNIQUE (NombreSede)
)

-- Mostrar información de la tabla
exec sp_help Sedes
exec sp_helpconstraint Sedes

-- Crear tipo DNI
IF EXISTS (SELECT * FROM sys.types WHERE name = 'TipoDNI')
	DROP TYPE TipoDNI
CREATE TYPE TipoDNI FROM CHAR(9) NOT NULL

-- Comprobar existencia de la tabla 
IF EXISTS (SELECT * FROM SYS.tables WHERE name='Grupos')
	DROP DATABASE Grupos
CREATE TABLE Grupos(
	CodigoGrupo SMALLINT IDENTITY(1, 1) NOT NULL,
	NombreGrupo VARCHAR(30) NOT NULL,
	CodigoDpto SMALLINT NULL,
	AreaConocimiento VARCHAR(30) NULL,
	Lider TipoDNI NULL,
	
	
	CONSTRAINT PK_CodigoGrupo PRIMARY KEY (CodigoGrupo),
	CONSTRAINT FK_CodigoDepartamentoGrupo FOREIGN KEY (CodigoDpto) REFERENCES Departamento(CodigoDpto),
	CONSTRAINT U_NombreGrupo UNIQUE (NombreGrupo)
)	

-- Mostrar la tabla creada
exec sp_help Grupos
exec sp_helpconstraint Grupos