-- 79. Muestra nombre de zona, y observaciones para todas las zonas urbanas. 
-- En el caso de que no haya información en el campo observaciones debe mostrar “no hay observaciones”.

SELECT 
    Z.NOMBREZONA, 
    ISNULL(Z.OBSERVACIONES, 'No hay observaciones') AS OBSERVACIONES
FROM 
    ZONAURBANA Z;


-- 80. Obtén una relación de propietarios de viviendas unifamiliares (DNI, nombre y apellidos, nombre_zona, calle) 
-- por cada zona urbana y ordénalos por los dos últimos caracteres de la zona urbana y dentro de esto por el nombre de la calle.

SELECT 
    P.DNI, 
    P.NOMBRE + ' ' +
    P.APELLIDO1 + ' ' + 
    ISNULL(P.APELLIDO2,' ') AS NOMBRECOMPLETO, 
    Z.NOMBREZONA, 
    CP.CALLE + ', ' + CAST(CP.NUMERO AS VARCHAR(3)) AS DIRECCION
FROM 
    PROPIETARIO P
INNER JOIN 
    CASAPARTICULAR CP ON P.DNI = CP.DNIPROPIETARIO
INNER JOIN 
    VIVIENDA V ON CP.CALLE = V.CALLE AND CP.NUMERO = V.NUMERO
INNER JOIN 
    ZONAURBANA Z ON V.NOMBREZONA = Z.NOMBREZONA
ORDER BY 
    RIGHT(Z.NOMBREZONA, 2), 
    V.CALLE;

-- SUBCONSULTAS

SELECT 
    P.DNI, 
    P.NOMBRE + ' ' + P.APELLIDO1 + ' ' + ISNULL(P.APELLIDO2, ' ') AS NOMBRECOMPLETO, 
    (SELECT V.NOMBREZONA 
     FROM VIVIENDA V 
     WHERE V.CALLE = CP.CALLE AND V.NUMERO = CP.NUMERO) AS NOMBREZONA,
    CP.CALLE + ', ' + CAST(CP.NUMERO AS VARCHAR(3)) AS DIRECCION
FROM 
    PROPIETARIO P
INNER JOIN 
    CASAPARTICULAR CP ON P.DNI = CP.DNIPROPIETARIO
WHERE 
    EXISTS (SELECT 1 
            FROM VIVIENDA V 
            WHERE V.CALLE = CP.CALLE AND V.NUMERO = CP.NUMERO)
ORDER BY 
    RIGHT((SELECT V.NOMBREZONA 
            FROM VIVIENDA V 
            WHERE V.CALLE = CP.CALLE AND V.NUMERO = CP.NUMERO), 2), 
    CP.CALLE;

-- 81. Se realiza un sorteo entre los propietarios de pisos. 
-- Selecciona 2 propietarios (DNI, nombre y apellidos) al azar.

SELECT TOP 2 
    PR.DNI, 
    PR.NOMBRE + ' ' +
    PR.APELLIDO1 + ' ' + 
    ISNULL(PR.APELLIDO2,' ') AS NOMBRECOMPLETO
FROM 
    PROPIETARIO PR
INNER JOIN 
    PISO P ON PR.DNI = P.DNIPROPIETARIO
ORDER BY 
    NEWID();

-- 82. Obtén una relación de pisos (calle, número, planta, puerta, número de habitaciones, metros útiles y nombre y apellidos del propietario), 
-- para los pisos que se encuentran en alguna zona que posea más de un parque, 
-- y donde haya edificada alguna vivienda unifamiliar un registro por cada piso donde indicarás de qué tipo de piso se trata. 

SELECT 
    P.CALLE, 
    P.NUMERO, 
    P.PLANTA, 
    P.PUERTA, 
    P.NUMHABITACIONES, 
    P.METROSUTILES, 
    PR.NOMBRE + ' ' + PR.APELLIDO1 + ' ' + ISNULL(PR.APELLIDO2, ' ') AS PROPIETARIO,
    CASE 
        WHEN P.NUMHABITACIONES BETWEEN 1 AND 2 THEN 'APARTAMENTO'
        WHEN P.NUMHABITACIONES BETWEEN 3 AND 4 THEN 'PISO'
        ELSE 'PISAZO' 
    END AS TIPO_PISO
FROM 
    PISO P
INNER JOIN
	PROPIETARIO PR ON P.DNIPROPIETARIO = PR.DNI
INNER JOIN 
    VIVIENDA V ON P.CALLE = V.CALLE AND P.NUMERO = V.NUMERO
INNER JOIN 
    ZONAURBANA Z ON V.NOMBREZONA = Z.NOMBREZONA
WHERE 
    Z.NUMPARQUES > 1 AND 
    EXISTS ( 
        SELECT 1
        FROM VIVIENDA V2
        WHERE V2.NOMBREZONA = V.NOMBREZONA AND V2.TIPOVIVIENDA = 'Casa'
    )
ORDER BY 
    P.NUMHABITACIONES;

-- 83. Haz una consulta que nos dé información de quien posee un piso o una casa de la siguiente manera: 
-- “Felipe Reyes posee un piso en la calle Lavapies nº 5” … Así para cada propietario de una vivienda, indicando si se trata de un piso o una casa.

SELECT 
    P.NOMBRE + ' ' + P.APELLIDO1 + ' ' + P.APELLIDO2 + ' posee un ' + 
    CASE 
        WHEN Pi.CALLE IS NOT NULL THEN 'piso' 
        ELSE 'casa' 
    END + 
    ' en la calle ' + 
    ISNULL(Pi.CALLE, V.CALLE) + ' nº ' + 
    ISNULL(CAST(Pi.NUMERO AS VARCHAR), CAST(V.NUMERO AS VARCHAR))
FROM 
    PROPIETARIO P
LEFT JOIN 
    PISO Pi ON P.DNI = Pi.DNIPROPIETARIO
LEFT JOIN 
    CASAPARTICULAR V ON P.DNI = V.DNIPROPIETARIO;

-- 84. Muestra un listado de casas unifamiliares y pisos (calle, numero, planta, puerta ,número de habitaciones, piscina, metros) 
-- donde metros es el número de metros útiles para los pisos y los metros de solar para las viviendas unifamiliares. 
-- Deberá aparecer ordenado por el números de habitaciones para el caso de los pisos y por los metros para las viviendas unifamiliares.
SELECT * FROM
((SELECT 
    P.CALLE, 
    P.NUMERO, 
    P.PLANTA, 
    P.PUERTA, 
    P.NUMHABITACIONES, 
    NULL AS PISCINA, 
    P.METROSUTILES AS METROS
FROM 
    PISO P)
    
UNION

(SELECT 
    CP.CALLE, 
    CP.NUMERO, 
    NULL AS PLANTA, 
    NULL AS PUERTA, 
    NULL AS NUMHABITACIONES, 
    CP.PISCINA, 
    V.METROSSOLAR AS METROS
FROM 
    CASAPARTICULAR CP
INNER JOIN 
    VIVIENDA V ON CP.CALLE = V.CALLE AND CP.NUMERO = V.NUMERO
)) AS T
ORDER BY 
    CASE 
        WHEN NUMHABITACIONES IS NOT NULL THEN NUMHABITACIONES 
        ELSE METROS
    END;

-- 85. ¿Quién posee más pisos: los hombres o las mujeres?

SELECT 
    PR.SEXO, 
    COUNT(P.CALLE) AS NUM_PISOS
FROM 
    PROPIETARIO PR
LEFT JOIN 
    PISO P ON PR.DNI = P.DNIPROPIETARIO
GROUP BY 
    PR.SEXO
ORDER BY 
    NUM_PISOS DESC;
    
-- 86. Consulta que muestre para cada propietario cuantos pisos, viviendas unifamiliares, garajes, trasteros y bodegas posee de la siguiente manera

SELECT 
    PR.NOMBRE + ' ' + PR.APELLIDO1 + ' ' + PR.APELLIDO2 AS PROPIETARIO,
    'PISO' AS TIPO_PROPIEDAD,
    COUNT(P.CALLE) AS NUMERO
FROM 
    PROPIETARIO PR
LEFT JOIN 
    PISO P ON PR.DNI = P.DNIPROPIETARIO
GROUP BY 
    PR.NOMBRE, PR.APELLIDO1, PR.APELLIDO2

UNION ALL

SELECT 
    PR.NOMBRE + ' ' + PR.APELLIDO1 + ' ' + PR.APELLIDO2 AS PROPIETARIO,
    'VIVIENDA UNIFAMILIAR' AS TIPO_PROPIEDAD,
    COUNT(CP.CALLE) AS NUMERO
FROM 
    PROPIETARIO PR
LEFT JOIN 
    CASAPARTICULAR CP ON PR.DNI = CP.DNIPROPIETARIO
GROUP BY 
    PR.NOMBRE, PR.APELLIDO1, PR.APELLIDO2

UNION ALL

SELECT 
    PR.NOMBRE + ' ' + PR.APELLIDO1 + ' ' + PR.APELLIDO2 AS PROPIETARIO,
    'GARAJE' AS TIPO_PROPIEDAD,
    COUNT(H.CALLE) AS NUMERO
FROM 
    PROPIETARIO PR
LEFT JOIN 
    HUECO H ON PR.DNI = H.DNIPROPIETARIO AND H.TIPO = 'GARAJE'
GROUP BY 
    PR.NOMBRE, PR.APELLIDO1, PR.APELLIDO2

UNION ALL

SELECT 
    PR.NOMBRE + ' ' + PR.APELLIDO1 + ' ' + PR.APELLIDO2 AS PROPIETARIO,
    'TRASTERO' AS TIPO_PROPIEDAD,
    COUNT(H.CALLE) AS NUMERO
FROM 
    PROPIETARIO PR
LEFT JOIN 
    HUECO H ON PR.DNI = H.DNIPROPIETARIO AND H.TIPO = 'TRASTERO'
GROUP BY 
    PR.NOMBRE, PR.APELLIDO1, PR.APELLIDO2

UNION ALL

SELECT 
    PR.NOMBRE + ' ' + PR.APELLIDO1 + ' ' + PR.APELLIDO2 AS PROPIETARIO,
    'BODEGA' AS TIPO_PROPIEDAD,
    COUNT(H.CALLE) AS NUMERO
FROM 
    PROPIETARIO PR
LEFT JOIN 
    HUECO H ON PR.DNI = H.DNIPROPIETARIO AND H.TIPO = 'BODEGA'
GROUP BY 
    PR.NOMBRE, PR.APELLIDO1, PR.APELLIDO2
ORDER BY 
    PROPIETARIO, TIPO_PROPIEDAD;


-- ¿Cuál es el mayor número de propiedades (de cualquier tipo: pisos, viviendas unifamiliares o huecos) que posee una misma persona?

SELECT TOP 1 
    PROPIETARIO,
    MAX(NUMERO) AS MAXIMO_NUMERO_PROP
FROM 
    (SELECT 
        PR.NOMBRE + ' ' + PR.APELLIDO1 + ' ' + PR.APELLIDO2 AS PROPIETARIO,
        COUNT(P.CALLE) AS NUMERO
    FROM 
        PROPIETARIO PR
    LEFT JOIN 
        PISO P ON PR.DNI = P.DNIPROPIETARIO
    GROUP BY 
        PR.NOMBRE, PR.APELLIDO1, PR.APELLIDO2

    UNION ALL

    SELECT 
        PR.NOMBRE + ' ' + PR.APELLIDO1 + ' ' + PR.APELLIDO2 AS PROPIETARIO,
        COUNT(CP.CALLE) AS NUMERO
    FROM 
        PROPIETARIO PR
    LEFT JOIN 
        CASAPARTICULAR CP ON PR.DNI = CP.DNIPROPIETARIO
    GROUP BY 
        PR.NOMBRE, PR.APELLIDO1, PR.APELLIDO2

    UNION ALL

    SELECT 
        PR.NOMBRE + ' ' + PR.APELLIDO1 + ' ' + PR.APELLIDO2 AS PROPIETARIO,
        COUNT(H.CALLE) AS NUMERO
    FROM 
        PROPIETARIO PR
    LEFT JOIN 
        HUECO H ON PR.DNI = H.DNIPROPIETARIO
    GROUP BY 
        PR.NOMBRE, PR.APELLIDO1, PR.APELLIDO2) AS COMBINADO
GROUP BY 
    PROPIETARIO
ORDER BY 
    MAXIMO_NUMERO_PROP DESC;
    
    
-- 88. ¿Quién o quiénes son los propietarios que poseen más propiedades?

SELECT 
    PROPIETARIO, 
    SUM(NUMERO) AS TOTAL_PROP
FROM 
    (SELECT 
        PR.NOMBRE + ' ' + PR.APELLIDO1 + ' ' + PR.APELLIDO2 AS PROPIETARIO,
        COUNT(P.CALLE) AS NUMERO
    FROM 
        PROPIETARIO PR
    LEFT JOIN 
        PISO P ON PR.DNI = P.DNIPROPIETARIO
    GROUP BY 
        PR.NOMBRE, PR.APELLIDO1, PR.APELLIDO2

    UNION ALL

    SELECT 
        PR.NOMBRE + ' ' + PR.APELLIDO1 + ' ' + PR.APELLIDO2 AS PROPIETARIO,
        COUNT(CP.CALLE) AS NUMERO
    FROM 
        PROPIETARIO PR
    LEFT JOIN 
        CASAPARTICULAR CP ON PR.DNI = CP.DNIPROPIETARIO
    GROUP BY 
        PR.NOMBRE, PR.APELLIDO1, PR.APELLIDO2

    UNION ALL

    SELECT 
        PR.NOMBRE + ' ' + PR.APELLIDO1 + ' ' + PR.APELLIDO2 AS PROPIETARIO,
        COUNT(H.CALLE) AS NUMERO
    FROM 
        PROPIETARIO PR
    LEFT JOIN 
        HUECO H ON PR.DNI = H.DNIPROPIETARIO
    GROUP BY 
        PR.NOMBRE, PR.APELLIDO1, PR.APELLIDO2) AS COMBINADO
GROUP BY 
    PROPIETARIO
ORDER BY 
    TOTAL_PROP DESC;


-- 89. Calcula la media de los salarios de los empleados sin tener en cuenta los valores máximos y mínimos (sobre la base de datos EMPRESA)

USE EMPRESANEW2

SELECT 
    AVG(SALARIO) AS MEDIA_SALARIO
FROM 
    EMPREGADOFIXO
WHERE 
    SALARIO NOT IN (SELECT MAX(SALARIO) FROM EMPREGADOFIXO)
    AND SALARIO NOT IN (SELECT MIN(SALARIO) FROM EMPREGADOFIXO);

