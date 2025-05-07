IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'ALUMNOS')
BEGIN
    PRINT 'La base de datos ALUMNOS no existe. Procediendo a crearla...';
    CREATE DATABASE ALUMNOS;
    PRINT 'La base de datos ALUMNOS ha sido creada.';
END
ELSE
BEGIN
    PRINT 'La base de datos ALUMNOS ya existe.';
END;
