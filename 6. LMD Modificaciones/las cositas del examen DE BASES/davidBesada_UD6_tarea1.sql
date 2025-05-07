-- 1. Crea una tabla con información de los pisos que poseen las mujeres que  tienen un nombre que empieza por M. La tabla debe llamarse PISOS_M y la información que debe contener es la calle, número, planta, puerta, numhabitaciones, DNIPropietario, nombrezona.
IF OBJECT_ID ('PISOS_M') IS NOT NULL
DROP TABLE PISOS_M
GO

SELECT P.CALLE + ' ' + CAST(P.NUMERO AS VARCHAR(4)) + ', ' + CAST(PLANTA AS VARCHAR(4)) + '' + PUERTA AS DIRECCION, NUMHABITACIONES, DNIPROPIETARIO, NOMBREZONA 
	INTO PISOS_M
	FROM PISO P
	INNER JOIN VIVIENDA V ON P.CALLE = V.CALLE AND P.NUMERO = V.NUMERO
	INNER JOIN PROPIETARIO PR ON P.DNIPROPIETARIO = PR.DNI
	WHERE NOMBRE LIKE 'M%' AND SEXO = 'M'
	
SELECT * FROM PISOS_M

-- 2. Queremos añadir los datos de una nueva vivienda unifamiliar situada en la calle Ponzano 44 que se encuentra en la zona Centro. El código postal es 23701, tiene 2 plantas y el propietario es Malena Franco Valiño.

INSERT INTO VIVIENDA (CALLE, NUMERO, TIPOVIVIENDA, CODIGOPOSTAL, NOMBREZONA)
VALUES ('Ponzano', 44, 'Casa', 23701, 'Centro')

INSERT INTO CASAPARTICULAR (CALLE, NUMERO, NUMPLANTAS, DNIPROPIETARIO)
VALUES ('Ponzano', 44, 2, (SELECT DNI 
						   FROM PROPIETARIO 
						   WHERE NOMBRE = 'Malena' AND
							     APELLIDO1 = 'Franco' AND
							     APELLIDO2 = 'Valiño')) 
							   
SELECT * FROM VIVIENDA V INNER JOIN CASAPARTICULAR CP
ON V.CALLE = CP.CALLE AND V.NUMERO = CP.NUMERO
WHERE DNIPROPIETARIO = (SELECT DNI 
						   FROM PROPIETARIO 
						   WHERE NOMBRE = 'Malena' AND
							     APELLIDO1 = 'Franco' AND
							     APELLIDO2 = 'Valiño')
							     
-- 3. El propietario de la vivienda situada en la calle Damasco, número 6 amplió su vivienda en 20 metros y constuyó una piscina. Actualiza la base de datos para que refleje estos cambio.

UPDATE CASAPARTICULAR
SET METROSCONSTRUIDOS = METROSCONSTRUIDOS + 20,
	PISCINA = 'S'
WHERE CALLE = 'Damasco' AND NUMERO = 6;

SELECT * FROM CASAPARTICULAR WHERE CALLE = 'Damasco' AND NUMERO = 6;

-- 4. Se instaló un enchufe en todas las bodegas de la calle Zurbarán 101. Refleja esta información en la base de datos. (en el campo observaciones.)

UPDATE HUECO
SET OBSERVACIONES = ISNULL(OBSERVACIONES,'') + 'Se instaló un enchufe'
WHERE TIPO = 'Bodega' AND CALLE = 'Zurbarán' AND NUMERO = 101;

SELECT * FROM HUECO WHERE TIPO = 'Bodega' AND CALLE = 'Zurbarán' AND NUMERO = 101;

-- 5. Haz una consulta que devuelva el número de hombres y de mujeres que tienen un piso pero no tienen una vivienda unifamiliar.

SELECT SEXO, COUNT(*) NUMERO
FROM PROPIETARIO PR
WHERE DNI IN (SELECT DNIPROPIETARIO FROM PISO) AND 
	  DNI NOT IN (SELECT DNIPROPIETARIO FROM CASAPARTICULAR)
GROUP BY SEXO

-- 6. Haz una consulta que devuelva el nombre completo de los propietarios que tienen un garaje o un trastero en las zonas Palomar o Centro y que no tienen ni pisos ni viviendas unifamiliares.

SELECT NOMBRE + ' ' + APELLIDO1 + ISNULL(APELLIDO2, ' ') AS NOMBRE_COMPLETO
FROM PROPIETARIO
WHERE DNI IN (SELECT DNIPROPIETARIO FROM HUECO H
			  INNER JOIN VIVIENDA V ON H.CALLE = V.CALLE AND H.NUMERO = V.NUMERO
			  WHERE (TIPO = 'Garaje' OR TIPO = 'Trastero') AND
			  (NOMBREZONA = 'Centro' AND NOMBREZONA = 'Palomar')) AND
	  DNI NOT IN (SELECT DNIPROPIETARIO FROM CASAPARTICULAR) AND
	  DNI NOT IN (SELECT DNIPROPIETARIO FROM PISO)
			  