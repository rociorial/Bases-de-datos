-- EJERCICIO 1

-- a) Crear base de datos

CREATE DATABASE BD_AlterDB1;


-- b) Alterar base de datos 

ALTER DATABASE BD_AlterDB1
ADD FILE 
(
	NAME = BD_AlterDB1_Datos, 
	FILENAME = “C:\database\BD_AlterDB1_Datos.ndf”,
	SIZE = 3MB,
	FILEGROWTH = 2MB, 
	MAXSIZE = UNLIMITED
);


-- c) Cambiar el tamaño de archivo a 5MB

ALTER DATABASE BD_AlterDB1
MODIFY FILE 
	(
		NAME = BD_AlterDB1_Datos, 
		SIZE = 5MB
	);

-- c) Volver a reducirlo a 3MB

ALTER DATABASE BD_AlterDB1
MODIFY FILE 
	(
		NAME = BD_AlterDB1_Datos, 
		SIZE = 3MB
	);



-- EJERCICIO 2

-- a) Crear base de datos

CREATE DATABASE BD_AlterDB2
ON
(
	NAME = BD_AlterDB2_Datos,
	FILENAME = "C:\database\BD_AlterDB2_Datos.mdf",
	SIZE = 3MB,
	MAXSIZE = 4MB,
	FILEGROWTH = 0
);


-- b) Modificar la base de datos

ALTER DATABASE BD_AlterDB2
MODIFY FILE 
	(
		NAME = BD_AlterDB2_Datos, 
		SIZE = 6MB
	);



-- EJERCICIO 3

-- a) Crear base de datos

CREATE DATABASE BD_AlterDB3
ON
(
	NAME = BD_AlterDB3_Data1,
	FILENAME = "C:\database\BD_AlterDB3_Data1.mdf",
	SIZE = 3MB,
	MAXSIZE = 10MB,
	FILEGROWTH = 1MB
);


-- b) Modificar la base de datos

ALTER DATABASE BD_AlterDB3
ADD FILE
(
	NAME = BD_AlterDB3_Data2,
	FILENAME = "C:\database\BD_AlterDB3_Data2.mdf",
	SIZE = 5MB,
	MAXSIZE = 15MB,
	FILEGROWTH = 2MB
);



-- c) Crear grupo de archivos

ALTER DATABASE BD_AlterDB3
ADD FILEGROUP Grupo1;

ALTER DATABASE DB_AlterDB3
ADD FILE
(
	NAME = BD_AlterDB3_Data3,
	FILENAME = "C:\database\BD_AlterDB3_Data3.mdf",
	SIZE = 1MB,
	MAXSIZE = UNLIMITED,
	FILEGROWTH = 10%
);

ALTER DATABASE BD_AlterDB3
ADD FILE
(
	NAME = BD_AlterDB3_Data4,
	FILENAME = "C:\database\BD_AlterDB3_Data4.mdf",
	SIZE = 1MB,
	MAXSIZE = UNLIMITED,
	FILEGROWTH = 10%
);



-- EJERCICIO 4

ALTER DATABASE BD_AlterDB3
REMOVE FILE BD_AlterDB3_Data3;



-- EJERCICIO 5

ALTER DATABASE BD_AlterDB3
MODIFY FILE
(
	NAME = BD_AlterDB3_Data1,
	SIZE = 4MB,
	FILEGROWTH = 3MB
);



-- EJERCICIO 6

ALTER DATABASE BD_AlterDB3
SET READ_WRITE;



-- EJERCICIO 7

ALTER DATABASE BD_AlterDB3
REMOVE FILEGROUP Grupo1;