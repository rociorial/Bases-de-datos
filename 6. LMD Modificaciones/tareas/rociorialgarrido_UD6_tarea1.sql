USE CATASTRO 

-- 1. Crea una tabla con informaci�n de los pisos que poseen las mujeres que  tienen un nombre que empieza por M. 
-- La tabla debe llamarse PISOS_M y la informaci�n que debe contener es la calle, n�mero, planta, puerta, 
-- numhabitaciones, DNIPropietario, nombrezona.
SELECT P.CALLE, P.NUMERO, P.PLANTA, P.PUERTA, P.NUMHABITACIONES, P.DNIPROPIETARIO, V.NOMBREZONA INTO PISOS_M
FROM PISO P	INNER JOIN PROPIETARIO PR ON P.DNIPROPIETARIO = PR.DNI
			INNER JOIN BLOQUEPISOS BP ON P.CALLE = BP.CALLE AND BP.NUMERO = P.NUMERO
			INNER JOIN VIVIENDA V ON V.CALLE = BP.CALLE AND BP.NUMERO = V.NUMERO
WHERE PR.SEXO = 'M'

-- 2. Queremos a�adir los datos de una nueva vivienda unifamiliar situada en la calle Ponzano 44 que se encuentra en la zona Centro. 
-- El c�digo postal es 23701, tiene 2 plantas y el propietario es Malena Franco Vali�o.
INSERT INTO VIVIENDA (CALLE, NUMERO, TIPOVIVIENDA, CODIGOPOSTAL, NOMBREZONA)
VALUES ('Ponzano', 44, 'Casa', 23701, 'Centro')

-- 2.
INSERT INTO CASAPARTICULAR (CALLE, NUMERO, NUMPLANTAS, DNIPROPIETARIO)
SELECT 'Ponzano', 44, DNI 
FROM PROPIETARIO
WHERE NOMBRE = 'Malena' AND APELLIDO1 = 'Franco' AND APELLIDO2 = 'Vali�o'



-- 3. El propietario de la vivienda situada en la calle Damasco, n�mero 6 ampli� su vivienda en 20 metros y constuy� una piscina. Actualiza la base de datos para que refleje estos cambio.
UPDATE CASAPARTICULAR 
SET PISCINA = 'Si', METROSCONSTRUIDOS = METROSCONSTRUIDOS + 20
WHERE CALLE = 'Damasco' AND NUMERO = 6

-- 4. Se instal� un enchufe en todas las bodegas de la calle Zurbar�n 101. Refleja esta informaci�n en la base de datos. (en el campo observaciones.)
UPDATE HUECO
SET OBSERVACIONES = ISNULL(OBSERVACIONES, '') + ' Tiene enchufe'
WHERE TIPO = 'Bodega' AND CALLE = 'Zurbar�n' AND NUMERO = 101   

-- 5. Haz una consulta que devuelva el n�mero de hombres y de mujeres que tienen un piso pero no tienen una vivienda unifamiliar.
SELECT SEXO, COUNT(*) NUMERO 
FROM PROPIETARIO
WHERE EXISTS (SELECT *
			  FROM PISO 
			  WHERE DNIPROPIETARIO = DNI)
AND NOT EXISTS (SELECT * 
				FROM CASAPARTICULAR 
				WHERE DNIPROPIETARIO = DNI)
GROUP BY SEXO
			   
-- 6. Haz una consulta que devuelva el nombre completo de los propietarios que tienen un garaje o un trastero en las zonas Palomar o Centro y que no tienen ni pisos ni viviendas unifamiliares.
SELECT (NOMBRE + ' ' + APELLIDO1 + ' ' + APELLIDO2) AS PROPIETARIO
FROM PROPIETARIO
WHERE DNI IN (SELECT DISTINCT DNIPROPIETARIO
			  FROM HUECO H INNER JOIN VIVIENDA V ON H.CALLE = V.CALLE AND H.NUMERO = V.NUMERO
			  WHERE TIPO IN ('GARAJE', 'TRASTERO')
			  AND NOMBREZONA IN ('Palomar', 'Centro'))
AND DNI NOT IN (SELECT DNIPROPIETARIO FROM PISO 
				UNION 
				SELECT DNIPROPIETARIO FROM CASAPARTICULAR)
