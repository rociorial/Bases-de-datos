--32. Obt�n el nombre y apellidos de las personas que poseen una vivienda unifamiliar.

SELECT DISTINCT NOMBRE, APELLIDO1 + ' ' + ISNULL(APELLIDO2, ' ') AS APELLIDOS
FROM PROPIETARIO P INNER JOIN CASAPARTICULAR CP ON P.DNI = CP.DNIPROPIETARIO

--33. Haz una consulta que muestre la zona, n�mero de parques, calle, n�mero y metros de solar de las viviendas que se encuentran en una zona que posea m�s de un parque .

SELECT V.NOMBREZONA, NUMPARQUES, CALLE, NUMERO, METROSSOLAR
FROM VIVIENDA V INNER JOIN ZONAURBANA ZU ON V.NOMBREZONA = ZU.NOMBREZONA
WHERE ZU.NUMPARQUES > 1

--34. Haz una consulta que muestre para cada vivienda unifamiliar la calle, n�mero, plantas, metros del solar y metros construidos.

SELECT V.CALLE, V.NUMERO, NUMPLANTAS, METROSSOLAR, METROSCONSTRUIDOS
FROM CASAPARTICULAR CP INNER JOIN VIVIENDA V ON CP.CALLE = V.CALLE AND CP.NUMERO = V.NUMERO

--35. Obt�n el nombre y descripci�n de las zonas urbanas que tienen m�s de 2 parques donde se hayan construido bloques de pisos.

SELECT ZU.NOMBREZONA, DESCRIPCI�N
FROM ZONAURBANA ZU INNER JOIN VIVIENDA V ON ZU.NOMBREZONA = V.NOMBREZONA
WHERE NUMPARQUES > 2 AND V.TIPOVIVIENDA = 'Bloque'

--36. Haz una consulta que muestre para cada piso la calle, n�mero, planta, puerta, n�mero de habitaciones, metros �tiles, nombre de zona, n�mero de parques existentes en la zona y nombre y apellidos del propietario.

SELECT V.CALLE, V.NUMERO, P.PLANTA, P.PUERTA, P.NUMHABITACIONES, P.METROSUTILES, V.NOMBREZONA, ZU.NUMPARQUES, PP.NOMBRE, PP.APELLIDO1 + ' ' + ISNULL(PP.APELLIDO2, ' ') AS APELLIDOS
FROM VIVIENDA V INNER JOIN BLOQUEPISOS BP ON V.CALLE = BP.CALLE AND V.NUMERO = BP.NUMERO
				INNER JOIN PISO P ON V.CALLE = P.CALLE AND V.NUMERO = P.NUMERO
				INNER JOIN PROPIETARIO PP ON P.DNIPROPIETARIO = PP.DNI
				INNER JOIN ZONAURBANA ZU ON V.NOMBREZONA = ZU.NOMBREZONA

--37. Haz una consulta que muestre el nombre y apellidos de las mujeres que tienen bodegas de m�s de 9 metros cuadrados.

SELECT PP.NOMBRE, PP.APELLIDO1 + ' ' + ISNULL(PP.APELLIDO2, ' ') AS APELLIDOS
FROM PROPIETARIO PP INNER JOIN HUECO H ON PP.DNI = H.DNIPROPIETARIO
WHERE PP.SEXO LIKE 'M' AND H.TIPO = 'Bodega' AND H.METROS > 9

--38. Haz una consulta que devuelva DNI, nombre y apellidos de las mujeres que poseen una vivienda unifamiliar.

SELECT DNI, NOMBRE, APELLIDO1 + ' ' + ISNULL(APELLIDO2, ' ') AS APELLIDOS
FROM PROPIETARIO PP INNER JOIN CASAPARTICULAR CP ON PP.DNI = CP.DNIPROPIETARIO
WHERE PP.SEXO LIKE 'M'

--39. Haz una consulta que muestre los pisos (toda la informaci�n de la tabla piso) y el nombre completo 
--de los propietarios que se encuentran en una zona con dos parques que tienen entre 2 y 4 habitaciones 
--o que se encuentran en la zona Centro, con ascensor y que tienen m�s de 70 y menos de 110 metros cuadrados
--�tiles.

SELECT P.*, PP.NOMBRE + ' ' + PP.APELLIDO1 + ' ' + ISNULL(PP.APELLIDO2, ' ') AS [NOMBRE COMPLETO]
FROM PISO P INNER JOIN PROPIETARIO PP ON P.DNIPROPIETARIO = PP.DNI
			INNER JOIN BLOQUEPISOS BP ON P.CALLE = BP.CALLE AND P.NUMERO = BP.NUMERO
			INNER JOIN VIVIENDA V ON V.CALLE = P.CALLE AND V.NUMERO = P.NUMERO
			INNER JOIN ZONAURBANA ZU ON V.NOMBREZONA = ZU.NOMBREZONA
WHERE (ZU.NUMPARQUES = 2 AND (P.NUMHABITACIONES BETWEEN 2 AND 4)) OR 
(ZU.NOMBREZONA = 'Centro' AND BP.ASCENSOR = 'S' AND (P.METROSUTILES BETWEEN 70 AND 110))

--40. Haz una consulta que muestre el nombre en min�sculas y las viviendas unifamiliares de una planta, que poseen los hombres de los cuales tenemos tel�fono.

SELECT LOWER(NOMBRE), NUMERO, CALLE
FROM PROPIETARIO PP INNER JOIN CASAPARTICULAR CP ON PP.DNI = CP.DNIPROPIETARIO
WHERE TELEFONO IS NOT NULL

--41. Haz una consulta que muestre las viviendas (calle, numero y tipovivienda) y la zona urbana en la que se encuentran (nombrezona y descripci�n). 

SELECT DISTINCT V.*, ZU.NOMBREZONA, ZU.DESCRIPCI�N
FROM VIVIENDA V INNER JOIN ZONAURBANA ZU ON V.NOMBREZONA = ZU.NOMBREZONA 