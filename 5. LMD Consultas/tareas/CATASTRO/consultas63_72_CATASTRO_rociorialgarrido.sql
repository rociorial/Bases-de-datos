USE CATASTRO

-- 63. Obtén una relación de pisos (calle, número, planta, puerta, número de habitaciones, metros útiles y nombre y apellidos del propietario) cuyos metros útiles superan la media de los metros construidos.
SELECT P.*, (PR.NOMBRE + ' ' + PR.APELLIDO1 + ' ' + PR.APELLIDO2) AS NOMBRE
FROM PISO P left JOIN PROPIETARIO PR ON P.DNIPROPIETARIO = PR.DNI
WHERE METROSUTILES > (SELECT AVG(METROSCONSTRUIDOS)
					  FROM PISO)
					  

-- 64. Haz una consulta que nos indique cual el tamaño medio de los solares en los que hay edificados bloques de pisos con más de 15 viviendas (pisos).
SELECT AVG(METROSUTILES) AS TAMAÑOMEDIO
FROM PISO P INNER JOIN BLOQUEPISOS BP ON (P.CALLE = BP.CALLE AND P.NUMERO = BP.NUMERO)
WHERE BP.NUMPISOS > 15


-- 65. Haz una consulta que muestre devuelva el número de parques que hay en las zonas urbanas donde hay edificada alguna vivienda.
SELECT DISTINCT V.NOMBREZONA, ZU.NUMPARQUES
FROM ZONAURBANA ZU INNER JOIN VIVIENDA V ON ZU.NOMBREZONA = V.NOMBREZONA
WHERE V.TIPOVIVIENDA IS NOT NULL 


-- 66. Haz una consulta que muestre todas las zonas (nombre y descripción) y las viviendas unifamiliares (calle, número y metros solar) que hay construidas en éstas.
SELECT ZU.NOMBREZONA, ZU.DESCRIPCIÓN, V.CALLE, V.NUMERO, V.METROSSOLAR
FROM ZONAURBANA ZU 
INNER JOIN VIVIENDA V ON ZU.NOMBREZONA = V.NOMBREZONA
INNER JOIN CASAPARTICULAR CP ON V.CALLE = CP.CALLE AND V.NUMERO = CP.NUMERO
 

-- 67. Haz una consulta que muestre DNI, nombre y apellidos de los propietarios de algún piso y/o vivienda, indicando cuántos pisos poseen y cuantas viviendas unifamiliares poseen.
SELECT PR.DNI, 
	(PR.NOMBRE + ' ' + PR.APELLIDO1 + ' ' + PR.APELLIDO2) AS NOMBRE, 
	COUNT(DISTINCT CP.CALLE + CP.NUMERO) AS NUM_CASAS, 
	COUNT(DISTINCT P.CALLE + P.NUMERO) AS NUM_PISOS 
FROM PROPIETARIO PR 
LEFT JOIN CASAPARTICULAR CP ON PR.DNI = CP.DNIPROPIETARIO
LEFT JOIN PISO P ON P.DNIPROPIETARIO = PR.DNI
GROUP BY PR.DNI, PR.NOMBRE, PR.APELLIDO1, PR.APELLIDO2


-- 68. Lista los pisos (calle, numero, planta y puerta) cuyo propietario es una mujer, que tienen el máximo número de habitaciones.
SELECT P.CALLE, P.NUMERO, P.PLANTA, P.PUERTA
FROM PISO P INNER JOIN PROPIETARIO PR ON P.DNIPROPIETARIO = PR.DNI
WHERE PR.SEXO = 'M' AND P.NUMHABITACIONES = (SELECT MAX(NUMHABITACIONES)AS MAX_HABITACIONES
											 FROM PISO)


-- 69. Lista las viviendas unifamiliares que no tienen piscina y en las que los metros construidos son menores que la media de los de todas las viviendas unifamiliares)
USE CATASTRO 
SELECT CALLE, NUMERO
FROM CASAPARTICULAR
WHERE PISCINA IS NULL AND 
METROSCONSTRUIDOS < (SELECT AVG(METROSCONSTRUIDOS)
					 FROM CASAPARTICULAR)


-- 70. Muestra DNI, nombre, apellidos y número de pisos de las personas que poseen más de un piso que tenga como mínimo dos habitaciones.
SELECT PR.DNI, 
       (PR.NOMBRE + ' ' + PR.APELLIDO1 + ' ' + PR.APELLIDO2) AS NOMBRE, 
       COUNT(P.CALLE + P.NUMERO + P.PLANTA + P.PUERTA) AS NUM_PISOS
FROM PROPIETARIO PR 
INNER JOIN PISO P ON PR.DNI = P.DNIPROPIETARIO
WHERE P.NUMHABITACIONES >= 2
GROUP BY PR.DNI, PR.NOMBRE, PR.APELLIDO1, PR.APELLIDO2
HAVING COUNT(P.CALLE + P.NUMERO + P.PLANTA + P.PUERTA) > 1;


-- 71. Muestra DNI, nombre y apellidos de las personas que no poseen ningún piso.
SELECT PR.DNI, (PR.NOMBRE + ' ' + PR.APELLIDO1 + ' ' + PR.APELLIDO2) AS NOMBRE
FROM PROPIETARIO PR INNER JOIN PISO P ON PR.DNI = P.DNIPROPIETARIO
WHERE P.CALLE IS NULL AND P.NUMERO IS NULL AND P.PLANTA IS NULL AND P.PUERTA IS NULL


-- 72. Muestra DNI, nombre, apellidos y número de pisos de las personas que poseen más de un piso y que no poseen ninguna vivienda
-- unifamiliar.
SELECT PR.DNI, (PR.NOMBRE + ' ' + PR.APELLIDO1 + ' ' + PR.APELLIDO2) AS NOMBRE, 
       COUNT(DISTINCT (P.CALLE + P.NUMERO + P.PLANTA + P.PUERTA)) AS NUM_PISO, 
       COUNT(DISTINCT (CP.CALLE + CP.NUMERO)) AS NUM_CASA
FROM PROPIETARIO PR INNER JOIN PISO P ON PR.DNI = P.DNIPROPIETARIO
					INNER JOIN CASAPARTICULAR CP ON CP.DNIPROPIETARIO = PR.DNI
GROUP BY PR.DNI, PR.NOMBRE, PR.APELLIDO1, PR.APELLIDO2
HAVING COUNT(DISTINCT (P.CALLE + P.NUMERO + P.PLANTA + P.PUERTA)) > 1 
   AND COUNT(DISTINCT (CP.CALLE + CP.NUMERO)) = 0;