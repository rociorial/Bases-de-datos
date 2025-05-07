USE CATASTRO

-- 42. ¿Cuál es la máxima altura que tienen los pisos que pertenecen a un propietario cuyo nombre empieza por M?
SELECT MAX(P.PLANTA) FROM PISO P
WHERE P.DNIPROPIETARIO IN(SELECT PP.DNI FROM PROPIETARIO PP WHERE PP.NOMBRE LIKE 'M%')

-- 43. Haz una consulta que devuelva el total de parques que hay en la ciudad .
SELECT SUM(NUMPARQUES) FROM ZONAURBANA

-- 44. Haz una consulta que nos indique cual es el tamaño del solar más grande.
SELECT MAX(METROSSOLAR) FROM VIVIENDA

-- 45. ¿Cuál es la máxima altura que tienen los pisos en la calle Damasco? (Utiliza la tabla piso).
SELECT MAX(P.PLANTA) FROM PISO P
WHERE P.CALLE = 'Damasco'

-- 46. Indica cual es el tamaño mínimo y máximo (de metros útiles) de los pisos situados en la calle Luca de Tena 22.
SELECT MAX(P.METROSUTILES), MIN(P.METROSUTILES) FROM PISO P
WHERE P.CALLE = 'Luca de Tena' AND P.NUMERO = 22

-- 47. Obtener la media de parques por zona urbana.
SELECT AVG(NUMPARQUES) FROM ZONAURBANA

-- 48. Indica cuantas viviendas unifamiliares hay en la zona Palomar o Atocha.
SELECT COUNT(*) FROM VIVIENDA V
WHERE V.NOMBREZONA IN ('Palomar','Atocha')
	
-- 49. ¿Cuál es el tamaño medio de una vivienda unifamiliar?.
SELECT AVG(METROSSOLAR) FROM VIVIENDA

-- 50. ¿Cuántos bloques de pisos hay en la zona Centro o Cuatrovientos cuyo solar pasa de 300 metros cuadrados?.
SELECT COUNT(*) FROM PISO P
	INNER JOIN VIVIENDA V ON P.CALLE = V.CALLE AND P.NUMERO = V.NUMERO
WHERE V.NOMBREZONA IN ('centro', 'cuatrovientos')

-- 51. Haz una consulta que devuelva el número de personas distintas que poseen una vivienda unifamiliar.
SELECT COUNT( DISTINCT CP.DNIPROPIETARIO) 
FROM CASAPARTICULAR CP
WHERE CP.DNIPROPIETARIO IN (SELECT PP.DNI FROM PROPIETARIO PP)

-- 52. Haz una consulta que devuelva el número de hombres que poseen un trastero en las zonas Palomar y Centro.
SELECT COUNT( DISTINCT H.DNIPROPIETARIO) 
FROM HUECO H
	INNER JOIN VIVIENDA V ON V.CALLE = H.CALLE AND V.NUMERO = H.NUMERO
	INNER JOIN PROPIETARIO PP ON PP.DNI = H.DNIPROPIETARIO
WHERE H.TIPO = 'trastero' AND V.NOMBREZONA IN('palomar','centro') AND PP.SEXO = 'H'


-- 53. Haz una consulta que devuelva el número de viviendas (de cualquier tipo) que hay en cada zona urbana.
SELECT COUNT(*), V.NOMBREZONA 
FROM VIVIENDA V
GROUP BY V.NOMBREZONA

-- 54. Haz una consulta que devuelva el número de bloques de pisos que hay en cada zona urbana.
SELECT COUNT(*), V.NOMBREZONA FROM BLOQUEPISOS BP
	INNER JOIN VIVIENDA V ON BP.CALLE = V.CALLE AND BP.NUMERO = V.NUMERO
GROUP BY V.NOMBREZONA

-- 55. Indica para cada bloque de pisos (calle y número) el número de pisos que hay en este y cual es el piso 
-- más alto de cada uno de estos.
SELECT pisoMasAlto=MAX(BP.NUMPISOS),BP.NUMPISOS, BP.CALLE, BP.NUMERO FROM BLOQUEPISOS BP
GROUP BY BP.NUMPISOS, BP.CALLE, BP.NUMERO

-- 56. Muestra los bloques de pisos (calle y número) que tienen más de 4 pisos.
SELECT BP.NUMPISOS, BP.CALLE, BP.NUMERO FROM BLOQUEPISOS BP
WHERE BP.NUMPISOS > 4

-- 57. Indica cual es el tamaño mínimo y máximo (de metros útiles) de los pisos de la zona Centro.
SELECT min_m2_utiles=MIN(P.METROSUTILES), max_m2_utiles=MAX(P.METROSUTILES) FROM PISO P
	INNER JOIN VIVIENDA V ON P.CALLE = V.CALLE AND P.NUMERO = V.NUMERO
WHERE V.NOMBREZONA = 'centro'

-- 58. Haz una consulta que muestre cuantos huecos hay de cada tipo en cada calle, teniendo en 
-- cuenta unicamente los huecos que están asociados a algún piso.

/* -- PRUEBA
SELECT DISTINCT CODIGO FROM HUECO H
	INNER JOIN PISO P ON 'Zurbarán' = P.CALLE AND P.NUMERO = H.NUMERO
WHERE H.TIPO = 'garaje' AND 'Zurbarán' = H.CALLE AND P.NUMERO = H.NUMERO AND P.PLANTA = H.PLANTA
*/

SELECT COUNT(DISTINCT CODIGO), TIPO, H.CALLE FROM HUECO H
	INNER JOIN PISO P ON H.CALLE = P.CALLE AND P.NUMERO = H.NUMERO
WHERE P.CALLE = H.CALLE AND P.NUMERO = H.NUMERO AND P.PLANTA = H.PLANTA
GROUP BY H.TIPO,H.CALLE
ORDER BY H.TIPO,H.CALLE

-- 59. ¿Cuántos bloques de pisos hay en la zona Centro o Palomar que poseen pisos de más de 3 habitaciones 
-- y que están entre 100 y 180 metros cuadrados(útiles)?

SELECT COUNT(*) FROM BLOQUEPISOS BP
	INNER JOIN VIVIENDA V ON BP.CALLE = V.CALLE AND BP.NUMERO = V.NUMERO
	INNER JOIN PISO P ON BP.CALLE = P.CALLE AND BP.NUMERO = P.NUMERO
WHERE V.NOMBREZONA IN('centro','palomar') AND P.NUMHABITACIONES > 3 AND (P.METROSUTILES BETWEEN 100 AND 180)


-- 60. Indica cuantas viviendas unifamiliares de una o dos plantas hay en cada calle teniendo en cuenta 
-- unicamente aquellas calles en las que el total de metros construidos es mayor de 250.
SELECT nViviendas = COUNT(*), metrosConstruidosCalle = SUM(METROSCONSTRUIDOS), CP.CALLE FROM CASAPARTICULAR CP
WHERE CP.NUMPLANTAS IN (1,2)
GROUP BY CP.CALLE
HAVING SUM(METROSCONSTRUIDOS)>250


-- 61. Haz una consulta que devuelva el número de pisos de 3 o 4 habitaciones que hay en cada zona urbana, 
-- mostrando para cada zona su nombre, descripción y número de parques, ordenado por número de parques descendentemente.
SELECT nPisos= COUNT(*), V.NOMBREZONA, ZU.DESCRIPCIÓN, ZU.NUMPARQUES FROM PISO P
	INNER JOIN VIVIENDA V ON P.CALLE = V.CALLE AND P.NUMERO = V.NUMERO
	INNER JOIN ZONAURBANA ZU ON V.NOMBREZONA = ZU.NOMBREZONA
WHERE P.NUMHABITACIONES IN(3,4)
GROUP BY V.NOMBREZONA, ZU.DESCRIPCIÓN, ZU.NUMPARQUES
ORDER BY ZU.NUMPARQUES DESC

-- 62. Haz una consulta que nos diga cuantos propietarios de pisos hay de cada sexo, indicando los 
-- valores Hombres o Mujeres en función del valor del campo sexo.
/* -- PRUEBA
SELECT DISTINCT DNI FROM PROPIETARIO PP
	INNER JOIN PISO P ON P.DNIPROPIETARIO = PP.DNI
WHERE PP.SEXO ='H'
ORDER BY PP.DNI
*/

SELECT COUNT(DISTINCT DNI), sexoPropietario = (
	CASE PP.SEXO
		WHEN 'H' THEN 'Hombre'
		WHEN 'M' THEN 'Mujer'
		ELSE 'Desconocido'
		END
	) 
FROM PROPIETARIO PP
	INNER JOIN PISO P ON P.DNIPROPIETARIO = PP.DNI

GROUP BY PP.SEXO