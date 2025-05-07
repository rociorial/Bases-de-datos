USE NEWEMPRESA

--1. El empleado con NSS 1122331 va a trabajar 3 horas en el proyecto 'Melloras sociais'. -> LISTO Y BIEN

INSERT INTO EMPREGADO_PROXECTO
VALUES ('1122331', (SELECT NUMPROXECTO FROM PROXECTO WHERE NomeProxecto = 'Melloras sociais'), 3)

--TODOS LOS EMPLEADOS QUE SEAN DE VIGO

INSERT INTO EMPREGADO_PROXECTO (NSSEmpregado, NumProxecto, Horas)
SELECT NSS, (SELECT NUMPROXECTO FROM PROXECTO WHERE NomeProxecto = 'Melloras sociais'), 5
FROM EMPREGADO WHERE Localidade = 'VIGO'


--2. Elimina los salarios de los empleados del departamento de INNOVACI�N. -> LISTO Y BIEN MENOS QUE SOBRABA EL FROM
--PARA CONSULTAR LOS DATOS
SELECT *
FROM EMPREGADOFIXO
WHERE NSS IN (SELECT NSS FROM EMPREGADO INNER JOIN DEPARTAMENTO
			  ON NumDepartamento = NumDepartamentoPertenece
			  WHERE NomeDepartamento = 'INNOVACI�N')

--ACTUALIZACI�N
UPDATE EMPREGADOFIXO
SET Salario = null
WHERE NSS IN (SELECT NSS FROM EMPREGADO WHERE NumDepartamentoPertenece = (SELECT NumDepartamento FROM DEPARTAMENTO WHERE NomeDepartamento = 'INNOVACI�N'))


--3. Todas las personas que no son jefas de ning�n departamento, de las que no tenemos registrado su salario pasan a cobrar 1900. -> LISTO, FALTABA LO DE MUJER Y LA SEGUNDA CONDICION DEL WHERE DE LA SUBCONSULTA

UPDATE EMPREGADOFIXO
SET Salario = 1900
WHERE Salario IS NULL
AND NSS NOT IN (SELECT NSS FROM EMPREGADO INNER JOIN DEPARTAMENTO
				  ON NumDepartamento = NumDepartamentoPertenece
				  WHERE Sexo = 'M' AND NSS=NSSDirector)


--4. La empresa va a realizar un ajuste, con lo cual decide eliminar el departamento de estad�stica, pasando a depender del departamento de Innovaci�n los empleados que pertenec�an a este departamento. 
--Haz los cambios que consideres necesarios teniendo en cuenta que : -> ESTABAN CASI TODOS LOS PASOS BIEN ALGUNOS FALLOS
	--el que era jefe del departamento de estad�stica pasa a depender del jefe de departamento de Innovaci�n y tiene a su cargo al resto de empleados que cambiaron de departamento.
	--Los proyectos que depend�an de este departamento pasan a depender del departamento de Innovaci�n.

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

	
--5. El jefe de departamento de Innovaci�n pasa a cobrar 3900. -> LISTO Y BIEN

UPDATE EMPREGADOFIXO
SET Salario = 3900
WHERE NSS = (SELECT NSSDirector FROM DEPARTAMENTO WHERE NomeDepartamento = 'INNOVACI�N')


--6. Haz una consulta que cree una tabla (DPTO_CONTA) con el nombre, apellidos y proyectos (nombre) en los que est�n trabajando todos los empleados que trabajan en el departamento de contabilidad. -> NO LISTO

SELECT e.Nome, e.Apelido1, e.Apelido2, p.NomeProxecto
INTO DPTO_CONTA
FROM EMPREGADO e
JOIN EMPREGADO_PROXECTO ep ON e.NSS = ep.NSSEmpregado
JOIN PROXECTO p ON ep.NumProxecto = p.NumProxecto
WHERE e.NumDepartamentoPertenece = (SELECT NumDepartamento FROM DEPARTAMENTO WHERE NomeDepartamento = 'CONTABILIDAD')


SELECT * FROM DEPARTAMENTO INNER JOIN EMPREGADO  ON NumDepartamento = NumDepartamentoPertenece
WHERE NomeDepartamento = 'CONTABILIDAD'


--7. Elimina el contenido de la tabla DPTO_CONTA. 

DELETE FROM DPTO_CONTA

--CHECKIDENT ('tabla', reseed, valor) -> esto sirve para resetear el identity


--8. El departamento T�CNICO decide que ning�n empleado del departamento deber�a cobrar menos del "actual" salario medio del departamento, 
--con lo cual decide subir el sueldo a aquellos empleados que cobran menos de este salario para pasar a cobrar esta cantidad. -> PERFECTO

DECLARE @SalarioMedioT�cnico FLOAT

SELECT @SalarioMedioT�cnico = AVG(Salario)
FROM EMPREGADOFIXO
WHERE NSS IN (
    SELECT NSS
    FROM EMPREGADO
    WHERE NumDepartamentoPertenece = (SELECT NumDepartamento FROM DEPARTAMENTO WHERE NomeDepartamento = 'T�CNICO')
)

UPDATE EMPREGADOFIXO
SET Salario = @SalarioMedioT�cnico
WHERE NSS IN (
    SELECT NSS
    FROM EMPREGADO
    WHERE NumDepartamentoPertenece = (SELECT NumDepartamento FROM DEPARTAMENTO WHERE NomeDepartamento = 'T�CNICO')) AND Salario < @SalarioMedioT�cnico


--9. Introduce en la DPTO_CONTA el nombre y los apellidos de los empleados del departamento de Contabilidad que son de Vigo, tienen alg�n hijo (o hija) 
--y cobran un salario mayor que la media del salario de todos los empleados de la empresa.

DECLARE @SalarioMedioEmpresa FLOAT

SELECT @SalarioMedioEmpresa = AVG(Salario)
FROM EMPREGADOFIXO

INSERT INTO DPTO_CONTA (Nome, Apelido1, Apelido2)
SELECT e.Nome, e.Apelido1, e.Apelido2
FROM EMPREGADO e
JOIN FAMILIAR f ON e.NSS = f.NSS_empregado
JOIN EMPREGADOFIXO ef ON e.NSS = ef.NSS
WHERE e.NumDepartamentoPertenece = (SELECT NumDepartamento FROM DEPARTAMENTO WHERE NomeDepartamento = 'CONTABILIDAD')
  AND e.Localidade = 'Vigo'
  AND (f.Parentesco = 'Hijo' OR f.Parentesco = 'Hija')
  AND ef.Salario > @SalarioMedioEmpresa
GROUP BY e.Nome, e.Apelido1, e.Apelido2
