-- 11. Mostra unha relación de departamentos (nome) y persoal (nome completo) asociados a este, ordeados por departamento e 
-- dentro deste por nome  completo en orden descendente.
SELECT D.NomeDepartamento, E.Nome || ' ' || E.Apelido1 || ' ' || E.Apelido2 AS "Nome Completo"
FROM DEPARTAMENTO D
JOIN EMPREGADO E ON D.NumDepartamento = E.NumDepPertenec
ORDER BY D.NomeDepartamento, "Nome Completo" DESC;

-- 12. Selecciona todas as empregadas fixas que viven en Pontevedra, Santiago ou Vigo ou aqueles empregados fixos que cobran 
-- máis de 3000 euros.
SELECT E.*
FROM EMPREGADO E
JOIN EMPREGADOFIXO EF ON E.NSS = EF.NSS
WHERE (E.Localidade IN ('Pontevedra', 'Santiago', 'Vigo') AND E.Sexo = 'M')
   OR EF.Salario > 3000;

-- 13. Fai unha consulta que seleccione todas as empregadas (NSS, nome e apelido1) que viven en Pontevedra ou Vigo e que teñen 
-- algún familiar dado de alta na empresa.
SELECT E.NSS, E.Nome, E.Apelido1
FROM EMPREGADO E
JOIN FAMILIAR F ON E.NSS = F.NSS_empregado
WHERE E.Localidade IN ('Pontevedra', 'Vigo') AND E.Sexo = 'M';

-- 14. Fai unha relación (nome do departamento e nome completo do empregado e do fillo/filla) de todos os empregados do departamento 
-- técnico ou de informática e que son pais dun neno (de calquera sexo)..  
SELECT D.NomeDepartamento, 
       E.Nome || ' ' || E.Apelido1 || ' ' || E.Apelido2 AS "Nome Completo Empregado",
       F.Nome AS "Nome Fillo/Filla"
FROM EMPREGADO E
JOIN FAMILIAR F ON E.NSS = F.NSS_empregado
JOIN DEPARTAMENTO D ON E.NumDepPertenec = D.NumDepartamento
WHERE D.NomeDepartamento IN ('TÉCNICO', 'INFORMÁTICA')
  AND F.Parentesco IN ('Hijo', 'Hija');

-- 15. Fai unha consulta que amose o 20% dos homes que traballan no departamento de Informática, Estadística ou Innovación.
SELECT *
FROM EMPREGADO
WHERE Sexo = 'H' 
  AND NumDepPertenec IN (
      SELECT NumDepartamento 
      FROM DEPARTAMENTO 
      WHERE NomeDepartamento IN ('INFORMÁTICA', 'ESTADÍSTICA', 'INNOVACIÓN')
  )
ORDER BY RANDOM()
LIMIT (SELECT COUNT(*) * 0.2 FROM EMPREGADO WHERE Sexo = 'H');

-- 16. Mostra todos os datos da táboa empregado xunto co nome e número de horas dos proxectos nos que participou o empregado e salario, pero 
-- só para aqueles empregados fixos dos departamentos de Informática e Técnico que cobran entre 1500 e 3000 euros e que naceron con anterioridade ao ano 1980.
SELECT E.*, P.NomeProxecto, EP.Horas, EF.Salario
FROM EMPREGADO E
JOIN EMPREGADOFIXO EF ON E.NSS = EF.NSS
JOIN EMPREGADO_PROXECTO EP ON E.NSS = EP.NSSEmpregado
JOIN PROXECTO P ON EP.NumProxecto = P.NumProxecto
WHERE E.NumDepPertenec IN (
      SELECT NumDepartamento 
      FROM DEPARTAMENTO 
      WHERE NomeDepartamento IN ('INFORMÁTICA', 'TÉCNICO'))
  AND EF.Salario BETWEEN 1500 AND 3000
  AND E.DataNacemento < '1980-01-01';
