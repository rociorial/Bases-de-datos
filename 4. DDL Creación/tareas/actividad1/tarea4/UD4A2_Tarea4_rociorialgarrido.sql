-- ================================
-- UD4A2_Tarea4_rociorialgarrido.sql
-- Creacion y comprobacion de la base de datos "Ventas"
-- ================================

-- ===========================================
-- TAREA 1: CREACION DE LA BASE DE DATOS
-- ===========================================

-- 1. CREACION DE LA BASE DE DATOS "Ventas" CON SUS ARCHIVOS CORRESPONDIENTES
CREATE DATABASE Ventas
ON 
-- Archivo principal
PRIMARY (
    NAME = Ventas_root,
    FILENAME = 'C:\SQLData\Ventas_root.mdf',
    SIZE = 10MB,
    MAXSIZE = 50MB,
    FILEGROWTH = 15%
),
-- Grupo de archivos de clientes
FILEGROUP grupo_clientes
(
    NAME = cliente_data1,
    FILENAME = 'C:\SQLData\cliente_data1.ndf',
    SIZE = 10MB,
    MAXSIZE = 50MB,
    FILEGROWTH = 15%
),
(
    NAME = cliente_data2,
    FILENAME = 'C:\SQLData\cliente_data2.ndf',
    SIZE = 10MB,
    MAXSIZE = 50MB,
    FILEGROWTH = 15%
),
(
    NAME = cliente_data3,
    FILENAME = 'C:\SQLData\cliente_data3.ndf',
    SIZE = 10MB,
    MAXSIZE = 50MB,
    FILEGROWTH = 15%
),
-- Grupo de archivos de productos
FILEGROUP grupo_productos
(
    NAME = producto_data1,
    FILENAME = 'C:\SQLData\producto_data1.ndf',
    SIZE = 10MB,
    MAXSIZE = 10MB, -- No permite crecer
    FILEGROWTH = 0
),
(
    NAME = producto_data2,
    FILENAME = 'C:\SQLData\producto_data2.ndf',
    SIZE = 10MB,
    MAXSIZE = 10MB, -- No permite crecer
    FILEGROWTH = 0
)
-- Archivo de LOG
LOG ON (
    NAME = log_data1,
    FILENAME = 'C:\SQLData\log_data1.ldf',
    SIZE = 5MB,
    MAXSIZE = 25MB,
    FILEGROWTH = 5MB
);

-- ===========================================
-- 2. VERIFICAR LA CREACION DE LA BASE DE DATOS
-- ===========================================
EXEC sp_helpdb Ventas;

-- ===========================================
-- TAREA 2: OBTENCION DE INFORMACION SOBRE BASES DE DATOS Y GRUPOS
-- ===========================================

-- 3
EXEC sp_databases;

-- 4
SELECT name AS NombreBaseDatos 
FROM sys.databases
WHERE database_id > 4;

-- 5 a)
SELECT name, type_desc 
FROM sys.filegroups;

-- 4 b)
SELECT name, physical_name, size, max_size, growth, type_desc 
FROM sys.database_files;

-- 5 a)
SELECT name, database_id, state_desc, recovery_model_desc 
FROM sys.databases
WHERE name = 'Ventas';

-- 5 b)
EXEC sp_helpdb Ventas;