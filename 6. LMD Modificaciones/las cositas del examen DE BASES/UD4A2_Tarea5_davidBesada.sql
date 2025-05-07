-- TAREA 1: Creación de la base de datos DB_Ventas_1

CREATE DATABASE DB_Ventas_1
ON (NAME = Ventas1,
FILENAME = 'E:\Base de datos\ventas1'),
(NAME = ventas2,
FILENAME = 'E:\Base de datos\ventas2'),
(NAME = ventas3,
FILENAME = 'E:\Base de datos\ventas3')

-- TAREA 2: Creación de la base de datos DB_Ventas_2 (no funciona)

CREATE DATABASE DB_Ventas_2
ON (NAME = Ventas2_1),
(NAME = ventas2_2'),
(NAME = ventas2_3')

-- TAREA 3: Creación de la base de datos DB_Ejemplo6

CREATE DATABASE DB_Ejemplo6
ON 
( NAME = DB_Ejemplo6_dat1, 
  FILENAME = 'E:\DB_Ejemplo\DB_Ejemplo6dat1.mdf',
  SIZE = 10MB, 
  MAXSIZE = 300MB, 
  FILEGROWTH = 15% ),
( NAME = DB_Ejemplo6_dat2, 
  FILENAME = 'E:\DB_Ejemplo\DB_Ejemplo6dat2.ndf',
  SIZE = 5MB, 
  MAXSIZE = 500MB, 
  FILEGROWTH = 15% ),
( NAME = DB_Ejemplo6_dat3, 
  FILENAME = 'E:\DB_Ejemplo\DB_Ejemplo6dat3.ndf',
  SIZE = 20MB, 
  MAXSIZE = UNLIMITED, 
  FILEGROWTH = 1MB ),
( NAME = DB_Ejemplo6_dat4, 
  FILENAME = 'E:\DB_Ejemplo\DB_Ejemplo6dat4.ndf',
  SIZE = 20MB, 
  MAXSIZE = UNLIMITED, 
  FILEGROWTH = 1MB ),
( NAME = DB_Ejemplo6_dat5, 
  FILENAME = 'E:\DB_Ejemplo\DB_Ejemplo6dat5.ndf',
  SIZE = 20MB, 
  MAXSIZE = UNLIMITED, 
  FILEGROWTH = 1MB )
LOG ON 
( NAME = DB_Ejemplo6_log1,
  FILENAME = 'E:\DB_Ejemplo\DB_Ejemplo6log1.ldf',
  SIZE = 5MB, 
  MAXSIZE = 25MB, 
  FILEGROWTH = 5MB );
