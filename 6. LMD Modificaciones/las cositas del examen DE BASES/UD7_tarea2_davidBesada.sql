-- 1._ El propietario de la vivienda unifamiliar de la calle Pasi�n 3 
-- decide dividir la vivienda en 3 apartamentos de una habitaci�n: uno 
-- por cada planta y no pone ascensor.
USE CATASTRO
begin tran
begin try
	-- Insertar nuevo bloque
	INSERT INTO BLOQUEPISOS
	VALUES ('Pasi�n',3,3,'N')
	-- Actualizar el tipo de vivienda
	UPDATE VIVIENDA
	SET TIPOVIVIENDA = 'Bloque'
	WHERE CALLE = 'Pasi�n' AND NUMERO = 3
	-- Insertar los 3 pisos
	INSERT INTO PISO
	VALUES ('Pasi�n', 3, 1, 'A',1,50,55, (SELECT DNIPROPIETARIO
										  FROM CASAPARTICULAR
										  WHERE CALLE='Pasi�n' AND NUMERO = 3)),
		   ('Pasi�n', 3, 2, 'A',1,50,55, (SELECT DNIPROPIETARIO
										  FROM CASAPARTICULAR
										  WHERE CALLE='Pasi�n' AND NUMERO = 3)),
		   ('Pasi�n', 3, 3, 'A',1,46,55, (SELECT DNIPROPIETARIO
										  FROM CASAPARTICULAR
										  WHERE CALLE='Pasi�n' AND NUMERO = 3))
	-- Borramos la vivienda de CASAPARTICULAR
	DELETE FROM CASAPARTICULAR
	WHERE CALLE='Pasi�n' AND NUMERO=3
	commit
end try
begin catch
	rollback
	print 'Se ha producido un error'
end catch
	
-- 2._ Utiliza transacciones expl�citas para garantizar que 
-- se realiza la operaci�n completa correspondiente al ejercicio 
-- 4 de la Tarea 3 de la UD6.

USE EMPRESANEW2021

BEGIN TRAN
BEGIN TRY
	--DEL 1 AL 4 ESTABAN BIEN MENOS EL PRIMERO QUE TODOS ES ESTAD�STICA
	--PRIMER PASO
	UPDATE EMPREGADO
	SET NSSSupervisa = (SELECT NSSDirector FROM DEPARTAMENTO WHERE NomeDepartamento = 'ESTAD�STICA')
	WHERE NumDepartamentoPertenece = (SELECT NumDepartamento FROM DEPARTAMENTO WHERE NomeDepartamento = 'ESTAD�STICA')
	  AND NSS != (SELECT NSSDirector FROM DEPARTAMENTO WHERE NomeDepartamento = 'ESTAD�STICA')
	 
	--SEGUNDO PASO
	UPDATE EMPREGADO
	SET NSSSupervisa = (SELECT NSSDirector FROM DEPARTAMENTO WHERE NomeDepartamento = 'INNOVACI�N')
	WHERE NSS = (SELECT NSSDirector FROM DEPARTAMENTO WHERE NomeDepartamento = 'ESTAD�STICA') 

	--TERCER PASO	
	UPDATE EMPREGADO
	SET NumDepartamentoPertenece = (SELECT NumDepartamento FROM DEPARTAMENTO WHERE NomeDepartamento = 'INNOVACI�N')
	WHERE NumDepartamentoPertenece = (SELECT NumDepartamento FROM DEPARTAMENTO WHERE NomeDepartamento = 'ESTAD�STICA')

	--CUARTO PASO
	UPDATE PROXECTO
	SET NumDepartControla = (SELECT NumDepartamento FROM DEPARTAMENTO WHERE NomeDepartamento = 'INNOVACI�N')
	WHERE NumDepartControla = (SELECT NumDepartamento FROM DEPARTAMENTO WHERE NomeDepartamento = 'ESTAD�STICA')

	--QUINTO PASO -> FALTABA LUGAR
	UPDATE LUGAR 
	SET Num_departamento = (SELECT Num_departamento 
							FROM DEPARTAMENTO
							WHERE NomeDepartamento = 'INNOVACI�N')
	WHERE Num_departamento = (SELECT Num_departamento 
							 FROM DEPARTAMENTO
							 WHERE NomeDepartamento ='ESTAD�STICA')
	AND LUGAR NOT IN (SELECT LUGAR FROM LUGAR L INNER JOIN DEPARTAMENTO D
					  ON L.Num_departamento = D.NumDepartamento
					  WHERE NomeDepartamento = 'INNOVACI�N')

	--SEXTO PASO -> ESTE FALTABA			  
	DELETE FROM LUGAR
	WHERE Num_departamento = (SELECT Num_departamento
							  FROM DEPARTAMENTO
							  WHERE NomeDepartamento = 'ESTAD�STICA')
					  
	--S�PTIMO PASO -> BIEN		  					     						
	DELETE FROM DEPARTAMENTO
	WHERE NomeDepartamento = 'ESTAD�STICA'

	COMMIT
END TRY
BEGIN CATCH
ROLLBACK
PRINT 'ERROR: ROLLBACK'
END CATCH

-- 3.- Hubo un error en la asignaci�n de las horas semanales de los empleados 
-- del departamento  Persoal en el proyecto PORTAL. En los que no hay registrado
-- el n�mero de horas tiene que ser  15 y en los que si est� registrado tiene que 
-- aumentar el n�mero de horas en este valor, con l�mite 25 ( si supera el limite, 
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


-- 4._El departamento de PERSOAL crea un proyecto de nombre 'INFORMATIZACI�N DE PERMISOS'
-- que se va a realizar en VIGO y en el que quiere que se implique todo el personal que 
-- pertenece a este departamento 

-- Modifica el campo Nombre de Proyecto para poder permitir almacenar todos los caracteres del nombre del proyecto que se pretende crear.
-- El jefe de departamento le dedicar� 8 horas semanales.
-- Los empleados le dedicar�n 5 horas semanales cada uno, teniendo en cuenta que no pueden superar 42 horas semanales dedicadas a proyectos (En ese caso dedicar�an el n�mero de horas que tuviesen disponibles hasta llegar a 42 y si no tuvieran horas disponibles no se asignar�an al proyecto).  
-- A los empleados que pasen de 40 horas dedicadas a proyectos les incrementar� el sueldo, pag�ndoles 12 euros m�s a la semana por cada hora extra que hagan.
-- Utiliza transacciones impl�citas para garantizar que se realiza la operaci�n correctamente.

-- MODIFICAR EL TAMA�O DEL CAMPO
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