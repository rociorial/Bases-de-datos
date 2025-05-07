USE EMPRESANEW

-- 25. Realiza unha consulta que devolva o nome, apelidos e departamento dos empregados que teñan o soldo máis baixo.
SELECT (E.NOME + ' ' + E.Apelido1 + ' ' + E.Apelido2) AS NOMBRE, D.NumDepartamento, EF.Salario
FROM EMPREGADO E 
INNER JOIN DEPARTAMENTO D ON E.NumDepartamentoPertenece = D.NumDepartamento
INNER JOIN EMPREGADOFIXO EF ON E.NSS = EF.NSS
WHERE EF.Salario = (SELECT MIN(Salario)
					FROM EMPREGADOFIXO) 
					

-- 26. Fai unha consulta que devolva o número de fillos de calquera sexo que ten cada empregado, pero só para aqueles nos que a suma das idades dos fillos sexa maior de 40.
SELECT (E.NOME + ' ' + E.Apelido1 + ' ' + E.Apelido2) AS NOMBRE 
FROM EMPREGADO E INNER JOIN FAMILIAR F ON E.NSS = F.NSS_empregado
WHERE F.Parentesco = 'Hijo'
GROUP BY E.Nome, E.Apelido1, E.Apelido2, E.NSS
HAVING SUM(DATEDIFF(YEAR, F.DataNacemento, GETDATE())) > 40;



-- 27. Crea unha consulta que devolva o nome do departamento, nome e apelidos dos empregados que teñen un nome que comeza por  J, M ou R 
-- e teña por segunda letra o A, ou a dos empregados que teñen como xefe unha persoa que ten un apelido que comeza por V e teña 6 letras.
SELECT D.NumDepartamento, (E.Nome + ' ' + E.Apelido1 + ' ' + E.Apelido2) AS NOMBRE
FROM DEPARTAMENTO D INNER JOIN EMPREGADO E ON D.NumDepartamento = E.NumDepartamentoPertenece
WHERE E.Nome LIKE '[JMR]A%' OR E.NumDepartamentoPertenece IN (SELECT D.NumDepartamento 
															  FROM DEPARTAMENTO D 
															  INNER JOIN EMPREGADO Jefe ON D.NSSDirector = Jefe.NSS
															  WHERE Jefe.Apelido1 LIKE 'V_____')
								

-- 28. Queremos ter información dos lugares nos que se están desenvolvendo proxectos nos que participe algún empregado do departamento 1. 
SELECT P.NumProxecto, P.NomeProxecto, P.LUGAR
FROM PROXECTO P INNER JOIN EMPREGADO_PROXECTO EP ON P.NumProxecto = EP.NumProxecto
				INNER JOIN EMPREGADO E ON E.NSS = EP.NSSEmpregado
WHERE E.NumDepartamentoPertenece = 1


-- 29. Calcula canto deberá pagar o departamento 2 aos seus empregados este ano sen ter en conta as pagas extras. 
SELECT SUM(EF.SALARIO) AS TOTAL_SALARIO_DEP2
FROM EMPREGADO E INNER JOIN EMPREGADOFIXO EF ON E.NSS = EF.NSS
WHERE E.NumDepartamentoPertenece = 2


-- 30. ¿Cales  son os empregados fixos (nome e apelidos) que tienen más edad?
SELECT TOP 1 WITH TIES (E.NOME + ' ' + E.Apelido1 + ' ' + E.Apelido2) AS NOMBRE, E.DataNacemento, 
					    DATEDIFF(YEAR, E.DataNacemento, GETDATE()) AS EDAD
FROM EMPREGADO E INNER JOIN EMPREGADOFIXO EF ON E.NSS = EF.NSS
WHERE E.DataNacemento IS NOT NULL
ORDER BY E.DataNacemento ASC

-- 31. Fai unha consulta que devolva o salario medio, o salario mínimo e o salario máximo que teñen os empregados que non 
-- son xefes de departamento por sexo.
SELECT AVG(EF.SALARIO) AS MEDIA_SALARIO, 
	   MIN(EF.SALARIO) AS MIN_SALARIO, 
	   MAX(EF.SALARIO) AS MAX_SALARIO
FROM EMPREGADOFIXO EF INNER JOIN EMPREGADO E ON EF.NSS = e.NSS
					  INNER JOIN DEPARTAMENTO D ON E.NSS != D.NSSDirector
					 	  

-- 32. Realiza unha consulta que busque os nomes dos proxectos nos que participan aquelas persoas que teñen o salario Nulo.
SELECT NomeProxecto
FROM PROXECTO P INNER JOIN EMPREGADO_PROXECTO EP ON P.NumProxecto = EP.NumProxecto
				INNER JOIN EMPREGADO E ON EP.NSSEmpregado = E.NSS
				INNER JOIN EMPREGADOFIXO EF ON E.NSS = EF.NSS
WHERE Salario IS NULL


-- 33. Mostra o nome completo dos empregados que teñen máis familiares ao seu cargo
SELECT TOP 1 WITH TIES (E.NOME + ' ' + E.Apelido1 + ' ' + E.Apelido2) AS NOMBRE, COUNT(F.NSS_empregado) AS NUM_FAMILIARES
FROM EMPREGADO E INNER JOIN FAMILIAR F ON E.NSS = F.NSS_empregado
GROUP BY E.NOME, E.Apelido1, E.Apelido2, E.NSS
ORDER BY COUNT(F.NSS_empregado) DESC;