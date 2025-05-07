-- 1. Utiliza transacciones implícitas para garantizar que se realiza la operación completa correspondiente al ejercicio 2 y 3 de la tarea 2 de la UD6.

USE EMPRESANEW2021
SET IMPLICIT_TRANSACTIONS ON
BEGIN TRY
	INSERT INTO CURSO (Nome, Horas)
	VALUES ('Deseño Web', 30);

	INSERT INTO EDICION (Codigo, Numero, Data, Lugar, Profesor)
	VALUES ((SELECT CODIGO FROM CURSO WHERE Nome = 'Deseño Web'), 1, '2025-04-15', 'Pontevedra',
	   (SELECT DISTINCT NSSDirector
		FROM DEPARTAMENTO D
		WHERE NomeDepartamento = 'Técnico'))
		
	INSERT INTO EDICIONCURSO_EMPREGADO
	SELECT (select codigo from CURSO where Nome = 'Deseño Web'), 1, NSS
	FROM EMPREGADO INNER JOIN DEPARTAMENTO ON NumDepartamentoPertenece=NumDepartamento
	WHERE NomeDepartamento='Técnico' AND NSS != NSSDirector;
	
	COMMIT
END TRY
BEGIN CATCH
	ROLLBACK
	PRINT 'SE HA PRODUCIDO UN ERROR'
END CATCH
SET IMPLICIT_TRANSACTIONS OFF

-- 2. Los garajes libres de la calle Zurbarán 101 se venden a precio de saldo,
-- lo que hace que Clementina Ares García, con DNI 32444423M decida comprarlos
-- todos. Actualiza la base de datos para que refleje esta información utilizando 
-- transacciones implícitas si fuera necesario
USE CATASTRO

SELECT * FROM HUECO WHERE TIPO = 'GARAJE' AND CALLE = 'ZURBARÁN' AND NUMERO = '101';

IF NOT EXISTS (SELECT * FROM PROPIETARIO WHERE DNI = '32444423M')
	BEGIN
	INSERT INTO PROPIETARIO (DNI,NOMBRE,APELLIDO1,APELLIDO2,SEXO,TELEFONO)
	VALUES ('32444423M', 'Clementina', 'Ares', 'García', 'M',NULL);
	END 
ELSE PRINT 'Ya existe ese propietario'

UPDATE HUECO 
SET DNIPROPIETARIO = '32444423M'
WHERE TIPO = 'GARAJE' AND CALLE = 'ZURBARÁN' AND NUMERO = '101' AND DNIPROPIETARIO IS NULL;

SELECT * FROM HUECO WHERE TIPO = 'GARAJE' AND CALLE = 'ZURBARÁN' AND NUMERO = '101';

-- CON TRANSACCIONES

SET IMPLICIT_TRANSACTIONS ON
BEGIN TRY
 
	IF NOT EXISTS (SELECT * FROM PROPIETARIO WHERE DNI = '32444423M')
		BEGIN
		INSERT INTO PROPIETARIO (DNI,NOMBRE,APELLIDO1,APELLIDO2,SEXO,TELEFONO)
		VALUES ('32444423M', 'Clementina', 'Ares', 'García', 'M',NULL);
		END 
	ELSE PRINT 'Ya existe ese propietario'

	UPDATE HUECO 
	SET DNIPROPIETARIO = '32444423M'
	WHERE TIPO = 'GARAJE' AND CALLE = 'ZURBARÁN' AND NUMERO = '101' AND DNIPROPIETARIO IS NULL;
	COMMIT
	
END TRY
BEGIN CATCH

	ROLLBACK
	PRINT 'Se ha producido un error'
	
END CATCH
SET IMPLICIT_TRANSACTIONS OFF

-- 3. Se crea una nueva sede para el departamento Técnico en Villagarcía.
USE EMPRESANEW2021

SET IMPLICIT_TRANSACTIONS ON
BEGIN TRY
	
	IF NOT EXISTS (SELECT * FROM LUGAR WHERE Num_departamento = ( SELECT Num_departamento 
																  FROM DEPARTAMENTO 
																  WHERE NomeDepartamento = 'Técnico' AND Lugar = 'Vilagarcía' ))
	BEGIN
		INSERT INTO LUGAR
		VALUES ((SELECT MAX(ID)+1 FROM LUGAR),(SELECT NumDepartamento FROM DEPARTAMENTO WHERE NomeDepartamento = 'Técnico'), 'Vilagarcía')
	END 
	ELSE PRINT 'Ya existe ese departamento'
	
	COMMIT
END TRY
BEGIN CATCH
	ROLLBACK
	PRINT 'SE HA PRODUCIDO UN ERROR'
END CATCH

SET IMPLICIT_TRANSACTIONS OFF	


-- 4. El empleado de nombre Paulo Máximo Guerra se cambia de sexo y pasa a llamarse
-- Mónica. Actualiza la base de datos.

USE EMPRESANEW2021
SET IMPLICIT_TRANSACTIONS ON
BEGIN TRY
	
	IF EXISTS (SELECT * FROM EMPREGADO WHERE Nome = 'Paulo' AND Apelido1 = 'Máximo' AND Apelido2 = 'Guerra')
	BEGIN
		UPDATE EMPREGADO 
		SET Nome = 'Mónica', Sexo = 'M'
		WHERE Nome = 'Paulo' AND Apelido1 = 'Máximo' AND Apelido2 = 'Guerra'
	END 
	ELSE PRINT 'ESA PERSONA NO EXISTE'
	
	COMMIT
END TRY
BEGIN CATCH
	ROLLBACK
	PRINT 'SE HA PRODUCIDO UN ERROR'
END CATCH

SET IMPLICIT_TRANSACTIONS OFF	


-- 5. Utiliza transacciones explícitas para garantizar que se realiza la operación 
-- completa correspondiente al ejercicio 6 de la tarea 2 de la UD6.

BEGIN TRAN
	BEGIN TRY
		INSERT INTO PROXECTO (NumProxecto, NomeProxecto, Lugar, NumDepartControla)
		VALUES (
			(select MAX(numProxecto)+1 from PROXECTO),
			'Deseño nova WEB',
			'Vigo',
			(SELECT NumDepartamento FROM DEPARTAMENTO WHERE NomeDepartamento = 'Técnico')
		);

		INSERT INTO TAREFA (NumProxecto, numero, descripcion, data_inicio, data_fin, dificultade, estado)
		VALUES 
		((SELECT NUMPROXECTO FROM PROXECTO WHERE NomeProxecto = 'DESEÑO NOVA WEB'),1, 'Definir o obxectivo da páxina', DATEADD(DAY, 15, GETDATE()), DATEADD(DAY, 22, GETDATE()), 'Media', 'Pendiente'),
		((SELECT NUMPROXECTO FROM PROXECTO WHERE NomeProxecto = 'DESEÑO NOVA WEB'),(SELECT MAX(NUMERO)+1 FROM TAREFA), 'Elexir o estilo e crear o mapa do sitio', DATEADD(DAY, 20, GETDATE()), DATEADD(DAY, 27, GETDATE()), 'Media', 'Pendiente');
	COMMIT
	END TRY
	BEGIN CATCH
		ROLLBACK
		PRINT 'SE HA PRODUCIDO UN ERROR'
	END CATCH

	