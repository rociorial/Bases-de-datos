-- 1. Utiliza transacciones impl�citas para garantizar que se realiza la operaci�n completa correspondiente al ejercicio 2 y 3 de la tarea 2 de la UD6.

USE EMPRESANEW2021
SET IMPLICIT_TRANSACTIONS ON
BEGIN TRY
	INSERT INTO CURSO (Nome, Horas)
	VALUES ('Dese�o Web', 30);

	INSERT INTO EDICION (Codigo, Numero, Data, Lugar, Profesor)
	VALUES ((SELECT CODIGO FROM CURSO WHERE Nome = 'Dese�o Web'), 1, '2025-04-15', 'Pontevedra',
	   (SELECT DISTINCT NSSDirector
		FROM DEPARTAMENTO D
		WHERE NomeDepartamento = 'T�cnico'))
		
	INSERT INTO EDICIONCURSO_EMPREGADO
	SELECT (select codigo from CURSO where Nome = 'Dese�o Web'), 1, NSS
	FROM EMPREGADO INNER JOIN DEPARTAMENTO ON NumDepartamentoPertenece=NumDepartamento
	WHERE NomeDepartamento='T�cnico' AND NSS != NSSDirector;
	
	COMMIT
END TRY
BEGIN CATCH
	ROLLBACK
	PRINT 'SE HA PRODUCIDO UN ERROR'
END CATCH
SET IMPLICIT_TRANSACTIONS OFF

-- 2. Los garajes libres de la calle Zurbar�n 101 se venden a precio de saldo,
-- lo que hace que Clementina Ares Garc�a, con DNI 32444423M decida comprarlos
-- todos. Actualiza la base de datos para que refleje esta informaci�n utilizando 
-- transacciones impl�citas si fuera necesario
USE CATASTRO

SELECT * FROM HUECO WHERE TIPO = 'GARAJE' AND CALLE = 'ZURBAR�N' AND NUMERO = '101';

IF NOT EXISTS (SELECT * FROM PROPIETARIO WHERE DNI = '32444423M')
	BEGIN
	INSERT INTO PROPIETARIO (DNI,NOMBRE,APELLIDO1,APELLIDO2,SEXO,TELEFONO)
	VALUES ('32444423M', 'Clementina', 'Ares', 'Garc�a', 'M',NULL);
	END 
ELSE PRINT 'Ya existe ese propietario'

UPDATE HUECO 
SET DNIPROPIETARIO = '32444423M'
WHERE TIPO = 'GARAJE' AND CALLE = 'ZURBAR�N' AND NUMERO = '101' AND DNIPROPIETARIO IS NULL;

SELECT * FROM HUECO WHERE TIPO = 'GARAJE' AND CALLE = 'ZURBAR�N' AND NUMERO = '101';

-- CON TRANSACCIONES

SET IMPLICIT_TRANSACTIONS ON
BEGIN TRY
 
	IF NOT EXISTS (SELECT * FROM PROPIETARIO WHERE DNI = '32444423M')
		BEGIN
		INSERT INTO PROPIETARIO (DNI,NOMBRE,APELLIDO1,APELLIDO2,SEXO,TELEFONO)
		VALUES ('32444423M', 'Clementina', 'Ares', 'Garc�a', 'M',NULL);
		END 
	ELSE PRINT 'Ya existe ese propietario'

	UPDATE HUECO 
	SET DNIPROPIETARIO = '32444423M'
	WHERE TIPO = 'GARAJE' AND CALLE = 'ZURBAR�N' AND NUMERO = '101' AND DNIPROPIETARIO IS NULL;
	COMMIT
	
END TRY
BEGIN CATCH

	ROLLBACK
	PRINT 'Se ha producido un error'
	
END CATCH
SET IMPLICIT_TRANSACTIONS OFF

-- 3. Se crea una nueva sede para el departamento T�cnico en Villagarc�a.
USE EMPRESANEW2021

SET IMPLICIT_TRANSACTIONS ON
BEGIN TRY
	
	IF NOT EXISTS (SELECT * FROM LUGAR WHERE Num_departamento = ( SELECT Num_departamento 
																  FROM DEPARTAMENTO 
																  WHERE NomeDepartamento = 'T�cnico' AND Lugar = 'Vilagarc�a' ))
	BEGIN
		INSERT INTO LUGAR
		VALUES ((SELECT MAX(ID)+1 FROM LUGAR),(SELECT NumDepartamento FROM DEPARTAMENTO WHERE NomeDepartamento = 'T�cnico'), 'Vilagarc�a')
	END 
	ELSE PRINT 'Ya existe ese departamento'
	
	COMMIT
END TRY
BEGIN CATCH
	ROLLBACK
	PRINT 'SE HA PRODUCIDO UN ERROR'
END CATCH

SET IMPLICIT_TRANSACTIONS OFF	


-- 4. El empleado de nombre Paulo M�ximo Guerra se cambia de sexo y pasa a llamarse
-- M�nica. Actualiza la base de datos.

USE EMPRESANEW2021
SET IMPLICIT_TRANSACTIONS ON
BEGIN TRY
	
	IF EXISTS (SELECT * FROM EMPREGADO WHERE Nome = 'Paulo' AND Apelido1 = 'M�ximo' AND Apelido2 = 'Guerra')
	BEGIN
		UPDATE EMPREGADO 
		SET Nome = 'M�nica', Sexo = 'M'
		WHERE Nome = 'Paulo' AND Apelido1 = 'M�ximo' AND Apelido2 = 'Guerra'
	END 
	ELSE PRINT 'ESA PERSONA NO EXISTE'
	
	COMMIT
END TRY
BEGIN CATCH
	ROLLBACK
	PRINT 'SE HA PRODUCIDO UN ERROR'
END CATCH

SET IMPLICIT_TRANSACTIONS OFF	


-- 5. Utiliza transacciones expl�citas para garantizar que se realiza la operaci�n 
-- completa correspondiente al ejercicio 6 de la tarea 2 de la UD6.

BEGIN TRAN
	BEGIN TRY
		INSERT INTO PROXECTO (NumProxecto, NomeProxecto, Lugar, NumDepartControla)
		VALUES (
			(select MAX(numProxecto)+1 from PROXECTO),
			'Dese�o nova WEB',
			'Vigo',
			(SELECT NumDepartamento FROM DEPARTAMENTO WHERE NomeDepartamento = 'T�cnico')
		);

		INSERT INTO TAREFA (NumProxecto, numero, descripcion, data_inicio, data_fin, dificultade, estado)
		VALUES 
		((SELECT NUMPROXECTO FROM PROXECTO WHERE NomeProxecto = 'DESE�O NOVA WEB'),1, 'Definir o obxectivo da p�xina', DATEADD(DAY, 15, GETDATE()), DATEADD(DAY, 22, GETDATE()), 'Media', 'Pendiente'),
		((SELECT NUMPROXECTO FROM PROXECTO WHERE NomeProxecto = 'DESE�O NOVA WEB'),(SELECT MAX(NUMERO)+1 FROM TAREFA), 'Elexir o estilo e crear o mapa do sitio', DATEADD(DAY, 20, GETDATE()), DATEADD(DAY, 27, GETDATE()), 'Media', 'Pendiente');
	COMMIT
	END TRY
	BEGIN CATCH
		ROLLBACK
		PRINT 'SE HA PRODUCIDO UN ERROR'
	END CATCH

	