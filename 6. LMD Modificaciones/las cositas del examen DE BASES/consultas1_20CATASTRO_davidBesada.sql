-- Haz una consulta que muestre el nombre, descripci�n y observaciones de las zonas urbanas.--

SELECT NOMBREZONA, DESCRIPCI�N, ISNULL(OBSERVACIONES, '')
FROM ZONAURBANA

-- Haz una consulta que devuelva el nombre de la calle, n�mero y n�mero de plantas de las viviendas unifamiliares. --

SELECT CALLE, NUMERO, NUMPLANTAS
FROM CASAPARTICULAR

-- Haz una consulta que devuelva el nombre de la calle, n�mero y metros construidos de las viviendas unifamiliares que tienen piscina. --

SELECT CALLE, NUMERO, METROSCONSTRUIDOS
FROM CASAPARTICULAR WHERE PISCINA = 'S'

-- Obtener la calle, n�mero y metros del solar de las viviendas unifamiliares.  --

SELECT CALLE, NUMERO, METROSSOLAR
FROM VIVIENDA WHERE TIPOVIVIENDA = 'Casa'

-- Muestra toda la informaci�n de los pisos que tienen 3 habitaciones. --

SELECT *
FROM PISO WHERE NUMHABITACIONES = '3'

-- Obtener una relaci�n de viviendas unifamiliares (calle, n�mero y metros de solar) de aquellas viviendas en las que los metros de solar est�n entre 190 y 300 metros. --

SELECT CALLE, NUMERO, METROSSOLAR
FROM VIVIENDA WHERE TIPOVIVIENDA = 'Casa' AND METROSSOLAR BETWEEN 190 AND 300

-- Obt�n una relaci�n de bloques de pisos que tienen m�s de 15 vecinos (pisos) ordenados por calle y n�mero. --

SELECT *
FROM BLOQUEPISOS WHERE NUMPISOS > 15 ORDER BY CALLE, NUMERO

-- Obtener la calle, n�mero y metros del solar de las viviendas unifamiliares situadas en la zona centro. --

SELECT CALLE, NUMERO, METROSSOLAR
FROM VIVIENDA WHERE TIPOVIVIENDA = 'Casa' AND NOMBREZONA = 'Centro'

-- Haz una consulta que devuelva DNI, nombre y apellidos de las personas que tienen L�pez como primer apellido ordenadas por apellidos y nombre. --

SELECT DNI, NOMBRE, APELLIDO1, APELLIDO2
FROM PROPIETARIO WHERE APELLIDO1 = 'L�pez' OR APELLIDO2 = 'L�pez' ORDER BY APELLIDO1, APELLIDO2, NOMBRE

-- Obtener la calle, n�mero y metros del solar de los bloques de pisos situados en la zona Centro o Palomar que tienen mas de 450 metros de solar. --

SELECT CALLE, NUMERO, METROSSOLAR
FROM VIVIENDA WHERE TIPOVIVIENDA = 'Bloque' AND (NOMBREZONA = 'Centro' OR NOMBREZONA = 'Palomar') AND METROSSOLAR > '450' 

-- Haz una consulta que muestre los garajes que est�n sin vender ordenados por calle, n�mero e id_hueco. --

SELECT *
FROM HUECO WHERE TIPO = 'GARAJE' AND DNIPROPIETARIO IS NULL ORDER BY CALLE, NUMERO, ID_HUECO

-- Obt�n el nombre y descripci�n de las zonas urbanas que tienen m�s de 1 parque ordenadas por el n�mero de parque descendente y nombre ascendente. --

SELECT NOMBREZONA, DESCRIPCI�N
FROM ZONAURBANA WHERE NUMPARQUES > 1 ORDER BY NUMPARQUES DESC, NOMBREZONA ASC

-- Mostrar toda la informaci�n de las zonas urbanas que tienen algo escrito en el campo de observaciones. -- 

SELECT *
FROM ZONAURBANA WHERE OBSERVACIONES IS NOT NULL

-- Haz una consulta que devuelva DNI, nombre y apellidos de las personas que tienen un nombre de 3 letras, ordenado por nombre y apellidos. --

SELECT DNI, NOMBRE, APELLIDO1, APELLIDO2
FROM PROPIETARIO WHERE LEN(NOMBRE) = 3 ORDER BY NOMBRE, APELLIDO1, APELLIDO2

-- Haz una consulta que muestre calle, n�mero, planta, puerta, metros (construidos y �tiles) y la diferencia existente entre los metros construidos y los metros �tiles ordenados por esta diferencia descendentemente. --

SELECT CALLE, NUMERO, PLANTA, PUERTA, METROSCONSTRUIDOS, METROSUTILES, (METROSCONSTRUIDOS - METROSUTILES ) AS DIFERENCIA
FROM PISO ORDER BY METROSCONSTRUIDOS DESC, METROSUTILES DESC

-- Muestra los datos de calle, n�mero, planta, puerta y n�mero de habitaciones de los pisos que tienen 1, 3, 5 � 6 habitaciones. --

SELECT CALLE, NUMERO, PLANTA, PUERTA, NUMHABITACIONES
FROM PISO WHERE NUMHABITACIONES = 1 OR NUMHABITACIONES = 3 OR NUMHABITACIONES = 5 OR NUMHABITACIONES = 6

-- Muestra toda la informaci�n de los pisos que tienen 1, 3, 5 � 6 habitaciones cuyos metros constru�dos superen en m�s de 10 a los metros �tiles. Deber�s mostrar tambi�n la diferencia entre los metros constru�dos y los metros �tiles (ll�male a este campo Diferencia) --

SELECT *, METROSCONSTRUIDOS-METROSUTILES AS DIFERENCIA
FROM PISO WHERE NUMHABITACIONES IN (1,3,5,6) AND METROSCONSTRUIDOS-METROSUTILES > 10

