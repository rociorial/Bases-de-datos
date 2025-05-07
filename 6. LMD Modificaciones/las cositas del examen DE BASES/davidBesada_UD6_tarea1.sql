-- 1. Crea una tabla con informaci�n de los pisos que poseen las mujeres que  tienen un nombre que empieza por M. La tabla debe llamarse PISOS_M y la informaci�n que debe contener es la calle, n�mero, planta, puerta, numhabitaciones, DNIPropietario, nombrezona.
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

-- 2. Queremos a�adir los datos de una nueva vivienda unifamiliar situada en la calle Ponzano 44 que se encuentra en la zona Centro. El c�digo postal es 23701, tiene 2 plantas y el propietario es Malena Franco Vali�o.

INSERT INTO VIVIENDA (CALLE, NUMERO, TIPOVIVIENDA, CODIGOPOSTAL, NOMBREZONA)
VALUES ('Ponzano', 44, 'Casa', 23701, 'Centro')

INSERT INTO CASAPARTICULAR (CALLE, NUMERO, NUMPLANTAS, DNIPROPIETARIO)
VALUES ('Ponzano', 44, 2, (SELECT DNI 
						   FROM PROPIETARIO 
						   WHERE NOMBRE = 'Malena' AND
							     APELLIDO1 = 'Franco' AND
							     APELLIDO2 = 'Vali�o')) 
							   
SELECT * FROM VIVIENDA V INNER JOIN CASAPARTICULAR CP
ON V.CALLE = CP.CALLE AND V.NUMERO = CP.NUMERO
WHERE DNIPROPIETARIO = (SELECT DNI 
						   FROM PROPIETARIO 
						   WHERE NOMBRE = 'Malena' AND
							     APELLIDO1 = 'Franco' AND
							     APELLIDO2 = 'Vali�o')
							     
-- 3. El propietario de la vivienda situada en la calle Damasco, n�mero 6 ampli� su vivienda en 20 metros y constuy� una piscina. Actualiza la base de datos para que refleje estos cambio.

UPDATE CASAPARTICULAR
SET METROSCONSTRUIDOS = METROSCONSTRUIDOS + 20,
	PISCINA = 'S'
WHERE CALLE = 'Damasco' AND NUMERO = 6;

SELECT * FROM CASAPARTICULAR WHERE CALLE = 'Damasco' AND NUMERO = 6;

-- 4. Se instal� un enchufe en todas las bodegas de la calle Zurbar�n 101. Refleja esta informaci�n en la base de datos. (en el campo observaciones.)

UPDATE HUECO
SET OBSERVACIONES = ISNULL(OBSERVACIONES,'') + 'Se instal� un enchufe'
WHERE TIPO = 'Bodega' AND CALLE = 'Zurbar�n' AND NUMERO = 101;

SELECT * FROM HUECO WHERE TIPO = 'Bodega' AND CALLE = 'Zurbar�n' AND NUMERO = 101;

-- 5. Haz una consulta que devuelva el n�mero de hombres y de mujeres que tienen un piso pero no tienen una vivienda unifamiliar.

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
			  