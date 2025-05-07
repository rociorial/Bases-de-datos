IF DB_ID('Clientes') IS NOT NULL
BEGIN
    PRINT 'La base de datos Clientes existe. Procediendo a eliminarla...';
    DROP DATABASE Clientes;
    PRINT 'La base de datos Clientes ha sido eliminada.';
END
ELSE
BEGIN
    PRINT 'No existe la base de datos Clientes.';
END;
