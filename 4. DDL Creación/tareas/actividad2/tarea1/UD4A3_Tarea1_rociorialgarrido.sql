-- EJERCICIO 1


-- a) Crear una base de datos 
CREATE DATABASE BD_TiposUsuario1;

-- Verificación de la creación de la base de datos 
SELECT name, database_id, create_date 
FROM sys.databases 
WHERE name = 'BD_TiposUsuario1';

-- Verificación de los archivos creados
USE BD_TiposUsuario1;
EXEC sp_helpfile;


-- b) Verificar si existe el tipo de dato y, si lo hace, borrarlo
IF EXISTS (SELECT * FROM sys.types WHERE name = 'TipoCodigo')
    DROP TYPE TipoCodigo;

IF EXISTS (SELECT * FROM sys.types WHERE name = 'TipoNum')
    DROP TYPE TipoNum;

IF EXISTS (SELECT * FROM sys.types WHERE name = 'TipoTelefono')
    DROP TYPE TipoTelefono;

IF EXISTS (SELECT * FROM sys.types WHERE name = 'TipoNombreCorto')
    DROP TYPE TipoNombreCorto;

-- Crear los tipos de datos personalizados 
CREATE TYPE TipoCodigo FROM CHAR(10) NOT NULL;

CREATE TYPE TipoNum FROM SMALLINT NOT NULL;

CREATE TYPE TipoTelefono FROM CHAR(9) NULL;

CREATE TYPE TipoNombreCorto FROM VARCHAR(15) NOT NULL;


-- c) Verificar si se han creado los tipos de datos
-- 1. sys.types
SELECT name, system_type_id, user_type_id, is_user_defined
FROM sys.types
WHERE is_user_defined = 1;

--2. Consultando el esquema de información
SELECT domain_name, data_type, character_maximum_length
FROM information_schema.domains
ORDER BY domain_name;


-- d) 
-- 1. Ejecutar sp_help
USE BD_TiposUsuario1;
EXEC sp_help;

-- 2. Ejecutar sp_help en la base de datos directamente
EXEC sp_help 'BD_TiposUsuario1';

-- 3. Ejecutar sp_help en el tipo de datos TipoCodigoç
USE BD_TiposUsuario1;
EXEC sp_help 'TipoCodigo';



-- EJERCICIO 2

-- Eliminar la base de datos
USE BD_TiposUsuario1;
GO

IF EXISTS (SELECT * FROM sys.types WHERE name = 'TipoCodigo')
    DROP TYPE TipoCodigo;
GO

IF EXISTS (SELECT * FROM sys.types WHERE name = 'TipoNum')
    DROP TYPE TipoNum;
GO

-- Comprobar si se ha eliminado
SELECT name, is_user_defined 
FROM sys.types 
WHERE name IN ('TipoCodigo', 'TipoNum');



