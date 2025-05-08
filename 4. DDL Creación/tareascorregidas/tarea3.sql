-- Comprobamos existencia de la tabla
IF EXISTS (SELECT * FROM SYS.tables WHERE name='Profesores')
	DROP TABLE Profesores

-- Creamos tabla profesores
CREATE TABLE Profesores(
	DNI TipoDNI NOT NULL,
	Nombre VARCHAR(30) NULL,
	Apellidos VARCHAR(30) NULL,
	Titulacion VARCHAR(30) NOT NULL,
	FechaInicioInvestigacion DATE NOT NULL
		CONSTRAINT DF_FechaInicioInvestigacionProfesores DEFAULT GETDATE(),
	FechaFinInvestigacion DATE NULL
		CONSTRAINT DF_FechaFinInvevigacionProfesor DEFAULT NULL,
	Grupo INT NULL,
	Hombre BIT NOT NULL,
	NumHijos SMALLINT NOT NULL
		CONSTRAINT DF_NumHijosProfesores DEFAULT 0,
	EstadoCivil VARCHAR(30), 
	Suplemento INT NOT NULL,
	AñosDeInvestigacion INT NOT NULL,
	Usuario as USER,
	
	CONSTRAINT PK_DNIProfesor PRIMARY KEY (DNI),
	CONSTRAINT CK_FechaFinInvestigacionProfesor CHECK (FechaFinInvestigacion >= FechaInicioInvestigacion
														AND YEAR(FechaFinInvestigacion) != 2014),
	CONSTRAINT CK_SuplementoProfesor CHECK (Suplemento = NumHijos * 100),
	CONSTRAINT CK_AñosDeInvestigacion CHECK (DATEDIFF(YEAR, FechaInicioInvestigacion, 
											FechaFinInvestigacion) = AñosDeInvestigacion)	
)

-- Mostramos la tabla
exec sp_help Profesores
exec sp_helpconstraint Profesores


-- Comprobamos si está creada la tabla
IF EXISTS (SELECT * FROM SYS.tables WHERE name='ProyectosInv')
	DROP TABLE ProyectosInv
-- Creamos la tabla
CREATE TABLE ProyectosInv(
	CodigoProyecto INT IDENTITY(1,1) NOT NULL,
	GuidProyecto UNIQUEIDENTIFIER NOT NULL
		CONSTRAINT DF_GuidProyecto DEFAULT NEWID(),
	NombreProyecto VARCHAR(30) NOT NULL,
	Presupuesto INT NOT NULL,
	FechaInicio DATE NOT NULL
		CONSTRAINT DF_FechaInincioProyectosInv DEFAULT DATEADD(DAY, -15, GETDATE()),
	FechaFin DATE NOT NULL,
	Grupo SMALLINT NULL,
	
	CONSTRAINT PK_CodigoProyectosInv PRIMARY KEY (CodigoProyecto),
	CONSTRAINT CK_NombreProyectosInv CHECK (NombreProyecto NOT LIKE '[0-9]%'),
	CONSTRAINT CK_PresupuestoProyectosInv CHECK (Presupuesto > 1000),
    CONSTRAINT FK_Profesor_Proyectos FOREIGN KEY (Grupo) REFERENCES Grupo(CodigoGrupo),
	CONSTRAINT CK_FechaFinProyectosInv CHECK (YEAR(FechaFin) = YEAR(FechaInicio) AND MONTH(FechaFin) = MONTH(FechaInicio))
)

-- Mostrar tabla
exec sp_help ProyectosInv
exec sp_helpconstraint ProyectosInv