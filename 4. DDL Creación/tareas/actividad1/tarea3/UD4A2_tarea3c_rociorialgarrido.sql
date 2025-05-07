IF EXISTS (SELECT * FROM sys.databases WHERE name = 'INSTITUTO')
BEGIN
    PRINT 'La base de datos INSTITUTO existe. Procediendo a eliminarla...';
    DROP DATABASE INSTITUTO;
    PRINT 'La base de datos INSTITUTO ha sido eliminada.';
END
ELSE
BEGIN
    PRINT 'La base de datos INSTITUTO no existe. Procediendo a crearla...';
    CREATE DATABASE INSTITUTO;
    PRINT 'La base de datos INSTITUTO ha sido creada.';
END;
