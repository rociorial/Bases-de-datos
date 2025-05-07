USE CATASTRO

-- 73. ¿Quién es el propietario que posee más pisos de más de 2 habitaciones que no están situados en la zona centro?
SELECT TOP 1 WITH TIES (PR.NOMBRE + ' ' + PR.APELLIDO1 + ' ' + PR.APELLIDO2) AS Nombre, COUNT(*) AS Num_Pisos, V.NOMBREZONA
FROM PROPIETARIO PR INNER JOIN PISO P ON PR.DNI = P.DNIPROPIETARIO
					INNER JOIN BLOQUEPISOS BP ON (P.CALLE = BP.CALLE AND P.NUMERO = BP.NUMERO)
					INNER JOIN VIVIENDA V ON (V.CALLE = BP.CALLE AND V.NUMERO = BP.NUMERO)
WHERE NUMHABITACIONES > 2 AND V.NOMBREZONA != 'Zona Centro'
GROUP BY V.NOMBREZONA, PR.NOMBRE, PR.APELLIDO1, PR.APELLIDO2
ORDER BY  COUNT(*) DESC


-- 74. Indica para cada bloque de pisos (calle y número) el máximo de metros útiles y máximo de número de habitaciones, pero sólo para aquellos bloques en los que tenemos almacenados más de 3 pisos.
SELECT (BP.CALLE + ', ' +CAST(BP.NUMERO AS VARCHAR)) AS Direccion, 
		MAX(P.METROSUTILES) AS Max_MetrosUtiles, 
		MAX(P.NUMHABITACIONES) AS Max_NumHabitaciones
FROM BLOQUEPISOS BP INNER JOIN PISO P ON (BP.CALLE = P.CALLE AND BP.NUMERO = P.NUMERO)
WHERE BP.NUMPISOS > 3
GROUP BY BP.CALLE, BP.NUMERO
ORDER BY Max_MetrosUtiles DESC, Max_NumHabitaciones DESC


-- 75. Obtén el DNI, nombre y apellidos de las personas que tenemos en nuestra base de datos. En el caso de que posean una vivienda de cualquier tipo deberá visualizarse la calle y número de la vivienda de la que son propietarios. Deberá ir ordenado por apellidos y nombre ascendentemente
SELECT PR.DNI, (PR.NOMBRE + ' ' + PR.APELLIDO1 + ' ' + PR.APELLIDO2) AS NOMBRE, V.CALLE, V.NUMERO
FROM PROPIETARIO PR LEFT JOIN PISO P ON PR.DNI = P.DNIPROPIETARIO
					LEFT JOIN VIVIENDA V ON P.CALLE = V.CALLE AND P.NUMERO = V.NUMERO
ORDER BY PR.APELLIDO1, PR.APELLIDO2, PR.NOMBRE ASC


-- 76. ¿Quién es el propietario de la bodega más pequeña? Debe visualizarse nombre y apellidos.
SELECT TOP 1 (PR.NOMBRE + ' ' + PR.APELLIDO1 + ' ' + PR.APELLIDO2) AS NOMBRE, H.METROS
FROM HUECO H INNER JOIN PROPIETARIO PR ON H.DNIPROPIETARIO = PR.DNI
WHERE TIPO = 'BODEGA'
ORDER BY H.METROS 


-- 77. Obtén el nombre completo y DNI de las mujeres que tenemos en nuestra base de datos. En el caso de que posean un 
-- trastero de más de 10 metros o un garaje de menos de 13 metros deberá visualizarse la calle , número, tipo y metros
-- de la propiedad que poseen.
SELECT PR.DNI, (PR.NOMBRE + ' ' + PR.APELLIDO1 + ' ' + PR.APELLIDO2) AS NOMBRE, P.CALLE, P.NUMERO, H.TIPO, H.METROS
FROM PROPIETARIO PR LEFT JOIN PISO P ON PR.DNI = P.DNIPROPIETARIO
					LEFT JOIN HUECO H ON P.CALLE = H.CALLE AND P.NUMERO = H.NUMERO AND P.PLANTA = H.PLANTA AND P.PUERTA = H.PUERTA
WHERE SEXO = 'M'
AND (H.TIPO = 'Trastero' AND H.METROS > 10 
       OR H.TIPO = 'Garaje' AND H.METROS < 13)
ORDER BY PR.APELLIDO1, PR.APELLIDO2, PR.NOMBRE


-- 78. Muestra el nombre de la zona urbana que más “propiedades” posee. Entendiendo como propiedades tanto los pisos, 
-- como las viviendas unifamiliares como huecos
SELECT V.NOMBREZONA, 
       COUNT(DISTINCT P.CALLE + '-' + P.NUMERO + '-' + P.PLANTA + '-' + P.PUERTA) + 
       COUNT(DISTINCT H.CALLE + '-' + H.NUMERO + '-' + H.PLANTA + '-' + H.PUERTA) + 
       COUNT(DISTINCT CP.CALLE + '-' + CP.NUMERO) AS Total_Propiedades
FROM VIVIENDA V 
INNER JOIN BLOQUEPISOS BP ON V.CALLE = BP.CALLE AND V.NUMERO = BP.NUMERO
INNER JOIN PISO P ON P.CALLE = BP.CALLE AND P.NUMERO = BP.NUMERO
INNER JOIN HUECO H ON P.CALLE = H.CALLE AND P.NUMERO = H.NUMERO AND P.PLANTA = H.PLANTA AND P.PUERTA = H.PUERTA
INNER JOIN CASAPARTICULAR CP ON V.CALLE = CP.CALLE AND V.NUMERO = CP.NUMERO
GROUP BY V.NOMBREZONA
ORDER BY Total_Propiedades DESC;

