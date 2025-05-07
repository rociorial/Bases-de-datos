---- 42. �Cu�l es la m�xima altura que tienen los pisos que pertenecen a un propietario cuyo nombre empieza por M?

SELECT MAX(PLANTA) AS 'M�xima altura'
FROM PISO P INNER JOIN PROPIETARIO PR ON P.DNIPROPIETARIO = PR.DNI
WHERE NOMBRE LIKE 'M%'

-- Con subsconsultas

SELECT MAX(PLANTA) AS 'M�xima altura'
FROM PISO
WHERE DNIPROPIETARIO IN (SELECT DNI FROM PROPIETARIO WHERE NOMBRE LIKE 'M%') 

-- 43. Haz una consulta que devuelva el total de parques que hay en la ciudad .

SELECT SUM(NUMPARQUES) AS 'Total de parques'
FROM ZONAURBANA

-- 44. Haz una consulta que nos indique cual es el tama�o del solar m�s grande.

SELECT MAX(METROSSOLAR) AS 'Solar m�s grande'
FROM VIVIENDA

-- 45. �Cu�l es la m�xima altura que tienen los pisos en la calle Damasco? (Utiliza la tabla piso).

SELECT MAX(PLANTA) AS 'M�xima altura'
FROM PISO
WHERE CALLE = 'Damasco'

-- 46. Indica cual es el tama�o m�nimo y m�ximo (de metros �tiles) de los pisos situados en la calle Lucas de Tena 22.

SELECT MIN(METROSUTILES) AS 'Tama�o m�nimo', MAX(METROSUTILES) AS 'Tama�o m�ximo'
FROM PISO
WHERE CALLE = 'Luca de Tena' AND NUMERO = 22

-- 47. Obtener la media de parques por zona urbana.

SELECT AVG(NUMPARQUES) AS 'Media de parques'
FROM ZONAURBANA

-- o con decimales

SELECT AVG(CAST(NUMPARQUES AS FLOAT)) AS 'Media de parques'
FROM ZONAURBANA

-- 48. Indica cuantas viviendas unifamiliares hay en la zona Palomar o Atocha.

SELECT COUNT(*) AS 'Viviendas unifamiliares'
FROM VIVIENDA
WHERE NOMBREZONA IN ('Palomar', 'Atocha') AND TIPOVIVIENDA = 'Casa'

-- 49. �Cu�l es el tama�o medio de una vivienda unifamiliar?.

SELECT CAST((AVG(1.0*METROSCONSTRUIDOS)) AS DECIMAL(8,2)) AS 'Tama�o medio'
FROM CASAPARTICULAR

-- 50. �Cu�ntos bloques de pisos hay en la zona Centro o Cuatrovientos cuyo solar pasa de 300 metros cuadrados?.

SELECT COUNT(*) AS 'Bloques de pisos'
FROM BLOQUEPISOS B
INNER JOIN VIVIENDA V ON B.CALLE = V.CALLE AND B.NUMERO = V.NUMERO
WHERE V.NOMBREZONA IN ('Centro', 'Cuatrovientos') AND V.METROSSOLAR > 300

-- 51. Haz una consulta que devuelva el n�mero de personas distintas que poseen una vivienda unifamiliar.

SELECT COUNT(DISTINCT DNIPROPIETARIO) AS [Propietarios �nicos]
FROM CASAPARTICULAR

-- 52. Haz una consulta que devuelva el n�mero de hombres que poseen un trastero en las zonas Palomar y Centro.

SELECT COUNT(DISTINCT P.DNI) AS 'Hombres con trastero'
FROM PROPIETARIO P
INNER JOIN HUECO H ON P.DNI = H.DNIPROPIETARIO
INNER JOIN VIVIENDA V ON H.CALLE = V.CALLE AND H.NUMERO = V.NUMERO
WHERE H.TIPO = 'Trastero' AND V.NOMBREZONA IN ('Palomar', 'Centro') AND P.SEXO = 'H'

-- CON SUBCONSULTAS

/* SELECT COUNT(DNI) FROM PROPIETARIO F
WHERE SEXO = 'H' AND DNI IN (SELECT DNIPROPIETARIO FROM HUECO
							 WHERE TIPO = 'TRASTERO'
							 AND CALLE+CAST(NUMERO AS VARCHAR(4))
							 IN */

-- 53. Haz una consulta que devuelva el n�mero de viviendas (de cualquier tipo) que hay en cada zona urbana.

SELECT NOMBREZONA, COUNT(*) AS 'N�mero de viviendas'
FROM VIVIENDA
GROUP BY NOMBREZONA

-- SI QUIERES FILTRAR 

SELECT NOMBREZONA, COUNT(*) AS 'N�mero de viviendas'
FROM VIVIENDA
GROUP BY NOMBREZONA
HAVING COUNT(*)>2

-- 54. Haz una consulta que devuelva el n�mero de bloques de pisos que hay en cada zona urbana.

SELECT V.NOMBREZONA, COUNT(*) AS 'N�mero de bloques'
FROM BLOQUEPISOS B
INNER JOIN VIVIENDA V ON B.CALLE = V.CALLE AND B.NUMERO = V.NUMERO
GROUP BY V.NOMBREZONA

-- 55. Indica para cada bloque de pisos (calle y n�mero) el n�mero de pisos que hay en este y cual es el piso m�s alto de cada uno de estos.

SELECT CALLE, NUMERO, COUNT(*) AS 'N�mero de pisos', MAX(PLANTA) AS 'Piso m�s alto'
FROM PISO
GROUP BY CALLE, NUMERO

-- 56. Muestra los bloques de pisos (calle y n�mero) que tienen m�s de 4 pisos.

SELECT CALLE, NUMERO, COUNT(*) AS 'N�mero de pisos'
FROM PISO
GROUP BY CALLE, NUMERO
HAVING COUNT(*)>4

-- 57. Indica cual es el tama�o m�nimo y m�ximo (de metros �tiles) de los pisos de la zona Centro.

SELECT MIN(METROSUTILES) AS 'Tama�o m�nimo', MAX(METROSUTILES) AS 'Tama�o m�ximo'
FROM PISO P
INNER JOIN VIVIENDA V ON P.CALLE = V.CALLE AND P.NUMERO = V.NUMERO
WHERE V.NOMBREZONA = 'Centro'

-- CON SUBCONSULTAS

SELECT MIN(METROSUTILES) AS 'Tama�o m�nimo', MAX(METROSUTILES) AS 'Tama�o m�ximo'
FROM PISO P
WHERE CALLE+CAST(NUMERO AS VARCHAR(4)) IN (SELECT CALLE+CAST(NUMERO AS VARCHAR(4)) FROM VIVIENDA WHERE NOMBREZONA = 'Centro')

-- 58. Haz una consulta que muestre cuantos huecos hay de cada tipo en cada calle, teniendo en cuenta unicamente los huecos que est�n asociados a alg�n piso.

SELECT P.CALLE, H.TIPO, COUNT(*) AS 'NUMERO'
FROM HUECO H
INNER JOIN PISO P ON H.CALLE = P.CALLE AND H.NUMERO = P.NUMERO AND H.PUERTA = P.PUERTA AND H.PLANTA = P.PLANTA
GROUP BY P.CALLE, H.TIPO
ORDER BY P.CALLE

-- CON SUBCONSULTAS

SELECT CALLE, TIPO, COUNT(*) AS NUMERO FROM HUECO H
WHERE CALLE+CAST(NUMERO AS VARCHAR(4))+CAST(PLANTA AS VARCHAR(3)) +
PUERTA IN (SELECT CALLE+CAST(NUMERO AS VARCHAR(4))+CAST(PLANTA AS VARCHAR(3))
+ PUERTA FROM PISO )
GROUP BY CALLE, TIPO

--59. �Cu�ntos bloques de pisos hay en la zona Centro o Palomar que poseen pisos de m�s de 3 habitaciones y que est�n entre 100 y 180 metros cuadrados(�tiles)?

SELECT COUNT(DISTINCT (B.CALLE + CAST(B.NUMERO AS VARCHAR))) AS 'NUMERO DE BLOQUES'
FROM BLOQUEPISOS B
JOIN PISO P ON B.CALLE = P.CALLE AND B.NUMERO = P.NUMERO
JOIN VIVIENDA V ON B.CALLE = V.CALLE AND B.NUMERO = V.NUMERO
WHERE V.NOMBREZONA IN ('Centro', 'Palomar') 
AND P.NUMHABITACIONES > 3 
AND P.METROSUTILES BETWEEN 100 AND 180;

-- SUBCONSULTAS
SELECT COUNT(CALLE+CAST(NUMERO AS VARCHAR(20))) AS 'NUMERO DE BLOQUES'
FROM PISO
WHERE CALLE+CAST(NUMERO AS VARCHAR(4)) IN
		(SELECT CALLE+CAST(NUMERO AS VARCHAR(4)) FROM VIVIENDA
		 WHERE NOMBREZONA IN ('Centro', 'Palomar'))
		 AND NUMHABITACIONES>3
		 AND METROSUTILES BETWEEN 100 AND 180

-- 60. Indica cuantas viviendas unifamiliares de una o dos plantas hay en cada calle teniendo en cuenta unicamente aquellas calles en las que el total de metros construidos es mayor de 250.

SELECT CALLE, COUNT(*) AS 'Viviendas unifamiliares'
FROM CASAPARTICULAR
WHERE NUMPLANTAS IN (1,2)
GROUP BY CALLE
HAVING SUM(METROSCONSTRUIDOS) > 250 -- EN EL HAVING PQ COMPRUEBA A POSTERIORI QUE LA SUMA DE LOS METROS DE LOS PISOS SEA 250

-- 61. Haz una consulta que devuelva el n�mero de pisos de 3 o 4 habitaciones que hay en cada zona urbana, mostrando para cada zona su nombre, descripci�n y n�mero de parques, ordenado por n�mero de parques descendentemente.

SELECT Z.NOMBREZONA, DESCRIPCI�N, Z.NUMPARQUES, COUNT(P.PUERTA) AS 'N�mero de pisos'
FROM PISO P
	 INNER JOIN VIVIENDA V ON P.CALLE = V.CALLE AND P.NUMERO = V.NUMERO
	 INNER JOIN ZONAURBANA Z ON V.NOMBREZONA = Z.NOMBREZONA
WHERE P.NUMHABITACIONES IN (3,4)
GROUP BY Z.NOMBREZONA, DESCRIPCI�N, Z.NUMPARQUES
ORDER BY Z.NUMPARQUES DESC


-- 62. Haz una consulta que nos diga cuantos propietarios de pisos hay de cada sexo, indicando los valores Hombres o Mujeres en funci�n del valor del campo sexo.

SELECT 
    CASE 
        WHEN SEXO = 'H' THEN 'Hombres'
        WHEN SEXO = 'M' THEN 'Mujeres'
    END AS 'Sexo',
    COUNT(*) AS 'Cantidad'
FROM PROPIETARIO
INNER JOIN PISO ON PROPIETARIO.DNI = PISO.DNIPROPIETARIO
GROUP BY SEXO

-- ^^ ESTA MAL, SE REPITEN LOS PROPIETARIOS

SELECT 
    CASE 
        WHEN SEXO = 'H' THEN 'Hombres'
        WHEN SEXO = 'M' THEN 'Mujeres'
    END AS 'Sexo',
    COUNT(*) AS 'Cantidad'
FROM PROPIETARIO
WHERE DNI IN (SELECT DNIPROPIETARIO FROM PISO)
GROUP BY SEXO
