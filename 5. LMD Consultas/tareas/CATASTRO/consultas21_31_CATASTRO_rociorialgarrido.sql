-- 21. Haz una consulta que muestre el 25% de los pisos con más habitaciones. En el 
-- caso de haber más pisos con ese número de habitaciones deberían visualizarse también.
SELECT TOP 25 PERCENT WITH TIES * 
FROM PISO
ORDER BY NUMHABITACIONES DESC;

-- 22. Haz una consulta que muestre toda la información de los garajes con al menos 14 
-- metros. En caso de no tener propietario deberá mostrar desconocido.
SELECT *,
ISNULL(DNIPROPIETARIO, 'DESCONOCIDO') AS DNIPROPIETARIO
FROM HUECO 
WHERE TIPO = 'GARAJE'
AND METROS > 14;


-- 23. Haz una consulta que muestre el nombre completo (p.e. Javier López Díaz) de los 
-- propietarios cuyo nombre no empiece por a, b, c, d o e cuyo apellido1 tenga más de 4 
-- letras ordenados por sexo , nombre y apellidos.
SELECT NOMBRE
FROM PROPIETARIO
WHERE NOMBRE NOT LIKE '[A-E]%'
OR LEN(APELLIDO1) > 4
ORDER BY SEXO, NOMBRE, APELLIDO1, APELLIDO2;

-- 24. Muestra información de las viviendas de la calle Damasco o General Mola cuyos metros 
-- solar empiecen por 2.
SELECT *
FROM VIVIENDA
WHERE CALLE IN ('Damasco', 'General Mola')
AND METROSSOLAR LIKE '2%';

-- 25. Haz una consulta que muestre para cada propietario el nombre, apellido1, sexo y un 
-- identificador que se creará concatenando el sexo con las 3 primeras letras del nombre y 
-- las dos últimas del apellido1.
SELECT NOMBRE, APELLIDO1, SEXO, 
SEXO + LEFT(NOMBRE,3) + RIGHT(APELLIDO1,2) AS IDENTIFICADOR
FROM PROPIETARIO;

-- 26. Haz una consulta que muestre los distintos tipos de huecos que hay en la calle Sol o 
-- Luca de Tena.
SELECT TIPO
FROM HUECO
WHERE CALLE IN ('Sol', 'Luca de Tena');

-- 27. Haz una consulta que muestre información de los 5 huecos más pequeños. En el caso de 
-- que haya más cuyo tamaño sea igual deberán visualizarse todos.
SELECT TOP 5 WITH TIES *
FROM HUECO
ORDER BY METROS ASC;

-- 28. Muestra los nombres de las mujeres con los caracteres invertidos.
SELECT NOMBRE, REVERSE(NOMBRE) AS REVERSA
FROM PROPIETARIO
WHERE SEXO = 'M';

-- 29. Muestra los trasteros o garajes sin mostrar los decimales de los metros.
SELECT CODIGO, CALLE, NUMERO, PLANTA, PUERTA, ID_HUECO, TIPO, CAST(METROS AS INT) AS METROS, DNIPROPIETARIO, OBSERVACIONES
FROM HUECO
WHERE TIPO IN ('TRASTERO', 'GARAJE')

-- 30. Muestra los distintos tipos de huecos de manera que se visualice la primera letra en 
-- mayúsculas y las siguientes en minúsculas.
SELECT DISTINCT
UPPER(LEFT(TIPO, 1)) + LOWER(SUBSTRING(TIPO, 2, LEN(TIPO))) AS TIPO_FORMATO
FROM HUECO;

-- 31. Haz una consulta que muestre nombre completo de los propietarios y sexo, indicando los 
-- valores Masculino o Femenino en función del valor del campo sexo.
SELECT NOMBRE, APELLIDO1, APELLIDO2,
CASE SEXO 
	WHEN 'H' THEN 'Hombre'
	WHEN 'M' THEN 'Mujer'
END AS SEXO
FROM PROPIETARIO
