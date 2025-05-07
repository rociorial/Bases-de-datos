USE EMPRESANEW

-- 1. El empleado con NSS 1122331 va a trabajar 3 horas en el proyecto 'Melloras sociais'.
SELECT Nome, PR.NomeProxecto, EP.Horas
FROM EMPREGADO E INNER JOIN EMPREGADO_PROXECTO EP ON E.NSS = EP.NSSEmpregado
				 INNER JOIN PROXECTO PR ON PR.NumProxecto = EP.NumProxecto
WHERE E.NSS = '1122331'

--2. Elimina los salarios de los empleados del departamento de INNOVACIÓN.
UPDATE EMPREGADOFIXO
SET Salario = NULL
WHERE NSS IN (
    SELECT E.NSS FROM EMPREGADO E
    INNER JOIN DEPARTAMENTO D ON E.NumDepartamentoPertenece = D.NumDepartamento
    WHERE D.NomeDepartamento = 'INNOVACIÓN'
);

--3. Todas las personas que no son jefas de ningún departamento, de las que no tenemos registrado su salario pasan a cobrar 1900.
UPDATE EMPREGADOFIXO
SET Salario = 1900
WHERE NSS 
IN (SELECT E.NSS FROM EMPREGADO E
LEFT JOIN DEPARTAMENTO D ON D.NSSDirector = E.NSS
WHERE D.NSSDirector IS NULL)
AND (Salario IS NULL);

--4. La empresa va a realizar un ajuste, con lo cual decide eliminar el departamento de estadística, pasando a depender del departamento de Innovación los empleados que pertenecían a este departamento. Haz los cambios que consideres necesarios teniendo en cuenta que :
-- A el que era jefe del departamento de estadística pasa a depender del jefe de departamento de Innovación y tiene a su cargo al resto de empleados que cambiaron de departamento.
UPDATE EMPREGADO
SET NumDepartamentoPertenece = (SELECT NumDepartamento FROM DEPARTAMENTO WHERE NomeDepartamento = 'INNOVACIÓN')
WHERE NumDepartamentoPertenece = (SELECT NumDepartamento FROM DEPARTAMENTO WHERE NomeDepartamento = 'ESTADÍSTICA');

--4.B Los proyectos que dependían de este departamento pasan a depender del departamento de Innovación.
UPDATE EMPREGADO
SET NSSSupervisa = (SELECT NSSDirector FROM DEPARTAMENTO WHERE NomeDepartamento = 'INNOVACIÓN')
WHERE NSS = (SELECT NSSDirector FROM DEPARTAMENTO WHERE NomeDepartamento = 'ESTADÍSTICA');
DELETE FROM DEPARTAMENTO
WHERE NomeDepartamento = 'ESTADÍSTICA';

--5. El jefe de departamento de Innovación pasa a cobrar 3900.
UPDATE EMPREGADOFIXO
SET Salario = 3900
WHERE NSS = (SELECT NSSDirector FROM DEPARTAMENTO WHERE NomeDepartamento = 'INNOVACIÓN');
GO

--6. Haz una consulta que cree una tabla (DPTO_CONTA) con el nombre, apellidos y proyectos (nombre) en los que están trabajando todos los empleados que trabajan en el departamento de contabilidad.
SELECT E.Nome, E.Apelido1, E.Apelido2, P.NomeProxecto
INTO DPTO_CONTA
FROM EMPREGADO E
INNER JOIN EMPREGADO_PROXECTO EP ON E.NSS = EP.NSSEmpregado
INNER JOIN PROXECTO P ON EP.NumProxecto = P.NumProxecto
WHERE E.NumDepartamentoPertenece = 
(SELECT NumDepartamento FROM DEPARTAMENTO 
WHERE NomeDepartamento = 'CONTABILIDAD');


--7. Elimina el contenido de la tabla DPTO_CONTA.
TRUNCATE TABLE DPTO_CONTA;


--8. El departamento TÉCNICO decide que ningún empleado del departamento debería cobrar menos del "actual" salario medio del departamento, con lo cual decide subir el sueldo a aquellos empleados que cobran menos de este salario para pasar a cobrar esta cantidad.
UPDATE EMPREGADOFIXO
SET EMPREGADOFIXO.Salario = (
    SELECT AVG(EF2.Salario) FROM EMPREGADOFIXO EF2
    INNER JOIN EMPREGADO E2 ON EF2.NSS = E2.NSS
    WHERE E2.NumDepartamentoPertenece = 
        (SELECT NumDepartamento FROM DEPARTAMENTO 
        WHERE NomeDepartamento = 'TÉCNICO')
    )
FROM EMPREGADOFIXO EF
    INNER JOIN EMPREGADO E ON EF.NSS = E.NSS
WHERE E.NumDepartamentoPertenece = (SELECT NumDepartamento FROM DEPARTAMENTO WHERE NomeDepartamento = 'TÉCNICO')
  AND EF.Salario < (
      SELECT AVG(EF2.Salario)
      FROM EMPREGADOFIXO EF2
      INNER JOIN EMPREGADO E2 ON EF2.NSS = E2.NSS
      WHERE E2.NumDepartamentoPertenece = 
              (SELECT NumDepartamento FROM DEPARTAMENTO 
            WHERE NomeDepartamento = 'TÉCNICO')
  );


--9. Introduce en la DPTO_CONTA el nombre y los apellidos de los empleados del departamento de Contabilidad que son de Vigo, tienen algún hijo (o hija) y cobran un salario mayor que la media del salario de todos los empleados de la empresa.
INSERT INTO DPTO_CONTA (NomeEmpregado, Apelido1, Apelido2, NomeProxecto)
SELECT E.Nome, E.Apelido1, E.Apelido2, NULL
FROM EMPREGADO E
INNER JOIN EMPREGADOFIXO EF ON E.NSS = EF.NSS
INNER JOIN FAMILIAR F ON E.NSS = F.NSS_empregado
WHERE E.NumDepartamentoPertenece = (SELECT NumDepartamento FROM DEPARTAMENTO WHERE NomeDepartamento = 'CONTABILIDAD')
  AND E.Localidade = 'Vigo'
  AND F.Parentesco IN ('Hijo', 'Hija')
  AND EF.Salario > (SELECT AVG(Salario) FROM EMPREGADOFIXO);