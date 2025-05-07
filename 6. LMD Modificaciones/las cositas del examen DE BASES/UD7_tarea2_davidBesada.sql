-- 1._ El propietario de la vivienda unifamiliar de la calle Pasión 3 
-- decide dividir la vivienda en 3 apartamentos de una habitación: uno 
-- por cada planta y no pone ascensor.
USE CATASTRO
begin tran
begin try
	-- Insertar nuevo bloque
	INSERT INTO BLOQUEPISOS
	VALUES ('Pasión',3,3,'N')
	-- Actualizar el tipo de vivienda
	UPDATE VIVIENDA
	SET TIPOVIVIENDA = 'Bloque'
	WHERE CALLE = 'Pasión' AND NUMERO = 3
	-- Insertar los 3 pisos
	INSERT INTO PISO
	VALUES ('Pasión', 3, 1, 'A',1,50,55, (SELECT DNIPROPIETARIO
										  FROM CASAPARTICULAR
										  WHERE CALLE='Pasión' AND NUMERO = 3)),
		   ('Pasión', 3, 2, 'A',1,50,55, (SELECT DNIPROPIETARIO
										  FROM CASAPARTICULAR
										  WHERE CALLE='Pasión' AND NUMERO = 3)),
		   ('Pasión', 3, 3, 'A',1,46,55, (SELECT DNIPROPIETARIO
										  FROM CASAPARTICULAR
										  WHERE CALLE='Pasión' AND NUMERO = 3))
	-- Borramos la vivienda de CASAPARTICULAR
	DELETE FROM CASAPARTICULAR
	WHERE CALLE='Pasión' AND NUMERO=3
	commit
end try
begin catch
	rollback
	print 'Se ha producido un error'
end catch
	
-- 2._ Utiliza transacciones explícitas para garantizar que 
-- se realiza la operación completa correspondiente al ejercicio 
-- 4 de la Tarea 3 de la UD6.

USE EMPRESANEW2021

BEGIN TRAN
BEGIN TRY
	--DEL 1 AL 4 ESTABAN BIEN MENOS EL PRIMERO QUE TODOS ES ESTADÍSTICA
	--PRIMER PASO
	UPDATE EMPREGADO
	SET NSSSupervisa = (SELECT NSSDirector FROM DEPARTAMENTO WHERE NomeDepartamento = 'ESTADÍSTICA')
	WHERE NumDepartamentoPertenece = (SELECT NumDepartamento FROM DEPARTAMENTO WHERE NomeDepartamento = 'ESTADÍSTICA')
	  AND NSS != (SELECT NSSDirector FROM DEPARTAMENTO WHERE NomeDepartamento = 'ESTADÍSTICA')
	 
	--SEGUNDO PASO
	UPDATE EMPREGADO
	SET NSSSupervisa = (SELECT NSSDirector FROM DEPARTAMENTO WHERE NomeDepartamento = 'INNOVACIÓN')
	WHERE NSS = (SELECT NSSDirector FROM DEPARTAMENTO WHERE NomeDepartamento = 'ESTADÍSTICA') 

	--TERCER PASO	
	UPDATE EMPREGADO
	SET NumDepartamentoPertenece = (SELECT NumDepartamento FROM DEPARTAMENTO WHERE NomeDepartamento = 'INNOVACIÓN')
	WHERE NumDepartamentoPertenece = (SELECT NumDepartamento FROM DEPARTAMENTO WHERE NomeDepartamento = 'ESTADÍSTICA')

	--CUARTO PASO
	UPDATE PROXECTO
	SET NumDepartControla = (SELECT NumDepartamento FROM DEPARTAMENTO WHERE NomeDepartamento = 'INNOVACIÓN')
	WHERE NumDepartControla = (SELECT NumDepartamento FROM DEPARTAMENTO WHERE NomeDepartamento = 'ESTADÍSTICA')

	--QUINTO PASO -> FALTABA LUGAR
	UPDATE LUGAR 
	SET Num_departamento = (SELECT Num_departamento 
							FROM DEPARTAMENTO
							WHERE NomeDepartamento = 'INNOVACIÓN')
	WHERE Num_departamento = (SELECT Num_departamento 
							 FROM DEPARTAMENTO
							 WHERE NomeDepartamento ='ESTADÍSTICA')
	AND LUGAR NOT IN (SELECT LUGAR FROM LUGAR L INNER JOIN DEPARTAMENTO D
					  ON L.Num_departamento = D.NumDepartamento
					  WHERE NomeDepartamento = 'INNOVACIÓN')

	--SEXTO PASO -> ESTE FALTABA			  
	DELETE FROM LUGAR
	WHERE Num_departamento = (SELECT Num_departamento
							  FROM DEPARTAMENTO
							  WHERE NomeDepartamento = 'ESTADÍSTICA')
					  
	--SÉPTIMO PASO -> BIEN		  					     						
	DELETE FROM DEPARTAMENTO
	WHERE NomeDepartamento = 'ESTADÍSTICA'

	COMMIT
END TRY
BEGIN CATCH
ROLLBACK
PRINT 'ERROR: ROLLBACK'
END CATCH

-- 3.- Hubo un error en la asignación de las horas semanales de los empleados 
-- del departamento  Persoal en el proyecto PORTAL. En los que no hay registrado
-- el número de horas tiene que ser  15 y en los que si está registrado tiene que 
-- aumentar el número de horas en este valor, con límite 25 ( si supera el limite, 
-- se asigna este valor).

UPDATE EMPREGADO_PROXECTO
SET Horas = CASE
				WHEN ISNULL(HORAS,0) +15 <=25 THEN ISNULL(HORAS,0) +15
				ELSE 25
			END
FROM EMPREGADO E INNER JOIN EMPREGADO_PROXECTO EP ON E.NSS = EP.NSSEmpregado
				 INNER JOIN PROXECTO P ON EP.NumProxecto = P.NumProxecto
WHERE NumDepartamentoPertenece=(SELECT NumDepartamento 
								FROM DEPARTAMENTO 
								WHERE NomeDepartamento = 'Persoal') 
								AND NomeProxecto = 'Portal'


-- 4._El departamento de PERSOAL crea un proyecto de nombre 'INFORMATIZACIÓN DE PERMISOS'
-- que se va a realizar en VIGO y en el que quiere que se implique todo el personal que 
-- pertenece a este departamento 

-- Modifica el campo Nombre de Proyecto para poder permitir almacenar todos los caracteres del nombre del proyecto que se pretende crear.
-- El jefe de departamento le dedicará 8 horas semanales.
-- Los empleados le dedicarán 5 horas semanales cada uno, teniendo en cuenta que no pueden superar 42 horas semanales dedicadas a proyectos (En ese caso dedicarían el número de horas que tuviesen disponibles hasta llegar a 42 y si no tuvieran horas disponibles no se asignarían al proyecto).  
-- A los empleados que pasen de 40 horas dedicadas a proyectos les incrementará el sueldo, pagándoles 12 euros más a la semana por cada hora extra que hagan.
-- Utiliza transacciones implícitas para garantizar que se realiza la operación correctamente.

-- MODIFICAR EL TAMAÑO DEL CAMPO
ALTER TABLE PROXECTO
ALTER COLUMN NOMEPROXECTO VARCHAR(50) NOT NULL
--

-- VARIABLES
DECLARE @DEP SMALLINT, @DIR VARCHAR(15), @NUMPRO SMALLINT;
SET @DEP=(SELECT NUMDEPARTAMENTO FROM DEPARTAMENTO WHERE NomeDepartamento='Persoal')
SET @DIR=(SELECT NSSDirector FROM DEPARTAMENTO WHERE NomeDepartamento='Persoal')
SET @NUMPRO=(SELECT MAX(NUMPROXECTO)+1 FROM PROXECTO);

SET IMPLICIT_TRANSACTIONS ON
BEGIN TRY
-- INSERTAMOS EL NEVO PROYECTO
	INSERT INTO PROXECTO
	VALUES (