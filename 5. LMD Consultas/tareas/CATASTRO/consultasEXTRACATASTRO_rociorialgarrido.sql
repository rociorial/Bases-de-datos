-- EXTRA
-- Obtén el nombre y apellidos de las personas que no poseen una vivienda unifamiliar.
SELECT DISTINCT NOMBRE, APELLIDO1, APELLIDO2
FROM PROPIETARIO P JOIN CASAPARTICULAR CP ON P.DNI != CP.DNIPROPIETARIO

-- Obtén todos los datos de las zonas urbanas donde no haya viviendas
-- Multitabla
SELECT ZU.* 
FROM ZONAURBANA ZU INNER JOIN VIVIENDA V ON ZU.NOMBREZONA != V.NOMBREZONA 
-- Subconsulta
SELECT *
FROM ZONAURBANA
WHERE (SELECT ZONAURBANA
	FROM VIVIENDA
	WHERE ZONAURBANA IS

-- 35. Obtén el nombre y descripción de las zonas urbanas que tienen más de 2 parques donde se 
-- hayan construido bloques de pisos. SUBCONSULTA
SELECT NOMBREZONA, DESCRIPCIÓN
FROM ZONAURBANA
WHERE NUMPARQUES > 2
AND 	(SELECT *
	FROM 

-- 37. Haz una consulta que muestre el nombre y apellidos de las mujeres que tienen bodegas de 
-- más de 9 metros cuadrados. SUBCONSULTA
SELECT NOMBRE, APELLIDO1, APELLIDO2
FROM PROPIETARIOS
WHERE SEXO = 'M'
AND 	(SELECT * 
	FROM HUECO
	WHERE TIPO = 'BODEGA' 	
	AND METROS > 9)


-- 38. Haz una consulta que devuelva DNI, nombre y apellidos de las mujeres que poseen una 
-- vivienda unifamiliar. SUBCONSULTA
SELECT DNI, NOMBRE, APELLIDO1, APELLIDO2
FROM PROPIETARIO
WHERE SEXO = 'M'
AND 	(SELECT *
	FROM CASAPARTICULAR
	WHERE )