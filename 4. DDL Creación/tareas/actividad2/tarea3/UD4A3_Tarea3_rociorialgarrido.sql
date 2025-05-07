-- EJERCICIO 1
USE ProyectosdeInvestigacion;

ALTER DATABASE ProyectosdeInvestigacion
ADD FILEGROUP GrupoProfes;

ALTER DATABASE ProyectosdeInvestigacion
ADD FILE (NAME = Profes1, FILENAME = 'C:\SQLData\Profes1.ndf', SIZE = 2MB, MAXSIZE = 15MB, FILEGROWTH = 1MB)
TO FILEGROUP GrupoProfes;

CREATE TABLE Profesores (
    DNI TipoDNI PRIMARY KEY,
    Nombre NVARCHAR(100) NULL,
    Apellidos NVARCHAR(200) NULL,
    Titulacion NVARCHAR(100) NOT NULL,
    FechaInicioInvestigacion DATE DEFAULT GETDATE(),
    FechaFinInvestigacion DATE CHECK (YEAR(FechaFinInvestigacion) <> 2014 AND FechaFinInvestigacion >= FechaInicioInvestigacion) NULL,
    Grupo INT,
    Hombre BIT NOT NULL,
    NumHijos INT DEFAULT 0,
    EstadoCivil NVARCHAR(50),
    Suplemento AS (NumHijos * 100) PERSISTED,
    AñosDeInvestigacion AS DATEDIFF(YEAR, FechaInicioInvestigacion, GETDATE()) PERSISTED,
    Usuario AS USER PERSISTED,
    CONSTRAINT UQ_Profesor UNIQUE (Nombre, Apellidos)
) ON GrupoProfes;

-- EJERCICIO 2
CREATE TABLE ProyectosInv (
    CodigoProyecto INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    GuidProyecto UNIQUEIDENTIFIER DEFAULT NEWID() UNIQUE,
    NombreProyecto NVARCHAR(200) NOT NULL CHECK (NombreProyecto NOT LIKE '[0-9]%'),
    Presupuesto DECIMAL(18,2) CHECK (Presupuesto > 1000),
    FechaInicio DATE NOT NULL DEFAULT DATEADD(DAY, -15, GETDATE()),
    FechaFin DATE CHECK (YEAR(FechaFin) = YEAR(FechaInicio) AND MONTH(FechaFin) = MONTH(FechaInicio)),
    Grupo INT
);

-- EJERCICIO 3
CREATE TABLE Participa (
    DNI TipoDNI,
    CodigoProyecto INT,
    FechaInicio DATE,
    FechaCese DATE,
    Dedicacion INT,
    Observaciones NVARCHAR(MAX),
    PRIMARY KEY (DNI, CodigoProyecto, FechaInicio)
);

-- EJERCICIO 4
CREATE TABLE Ubicacion (
    CodigoSede SMALLINT,
    CodigoDepartamento INT,
    OrdenAntigüedad INT CHECK (OrdenAntigüedad > 0),
    PRIMARY KEY (CodigoSede, CodigoDepartamento)
) ON GrupoProfes;

-- EJERCICIO 5
CREATE TABLE Programas (
    CodigoPrograma CHAR(3) DEFAULT 'P00' CHECK (CodigoPrograma LIKE '[PR]%' AND CodigoPrograma LIKE '%[0-9]%'),
    NombrePrograma NVARCHAR(200) NULL,
    CONSTRAINT UQ_NombrePrograma UNIQUE (NombrePrograma)
);

CREATE TABLE Financiacion (
    CodigoPrograma CHAR(3),
    CodigoProyecto INT,
    Financiacion DECIMAL(18,2),
    FOREIGN KEY (CodigoPrograma) REFERENCES Programas(CodigoPrograma) ON DELETE CASCADE,
    FOREIGN KEY (CodigoProyecto) REFERENCES ProyectosInv(CodigoProyecto)
);