-- 25. Consulta que devolva o nome, apelidos e departamento dos empregados que teñan o soldo máis baixo

SELECT TOP 1 WITH TIES 
    e.Nome, e.Apelido1, e.Apelido2, d.NomeDepartamento, ef.Salario
FROM EMPREGADO e
INNER JOIN EMPREGADOFIXO ef ON e.NSS = ef.NSS
INNER JOIN DEPARTAMENTO d ON e.NumDepartamentoPertenece = d.NumDepartamento
ORDER BY ef.Salario;

-- con subconsultas

SELECT e.Nome, e.Apelido1, e.Apelido2, d.NomeDepartamento, ef.Salario
FROM EMPREGADO e
INNER JOIN EMPREGADOFIXO ef ON e.NSS = ef.NSS
INNER JOIN DEPARTAMENTO d ON e.NumDepartamentoPertenece = d.NumDepartamento
WHERE ef.Salario = (
    SELECT MIN(Salario) FROM EMPREGADOFIXO
)

-- Mínimo de su departamento

SELECT e1.Nome, e1.Apelido1, e1.Apelido2, d1.NomeDepartamento,ef1.Salario
FROM EMPREGADO e1
INNER JOIN EMPREGADOFIXO ef1 ON e1.NSS = ef1.NSS
INNER JOIN DEPARTAMENTO d1 ON e1.NumDepartamentoPertenece = d1.NumDepartamento
WHERE ef1.Salario = (
    SELECT MIN(Salario)
    FROM EMPREGADOFIXO EF2 INNER JOIN EMPREGADO E2 ON EF2.NSS = E2.NSS
    WHERE E2.NumDepartamentoPertenece = e1.NumDepartamentoPertenece
)

-- 26. Número de fillos por empregado, onde a suma das idades dos fillos sexa maior de 40

SELECT f.NSS_empregado, COUNT(*) AS NumeroFillos
FROM FAMILIAR f
WHERE f.Parentesco LIKE 'Hij_'
GROUP BY f.NSS_empregado
HAVING SUM(FLOOR(DATEDIFF(DD, f.DataNacemento, GETDATE())/365.25)) > 40

-- 27. Empregados con nome que comeza por J, M ou R e segunda letra A ou con xefe con apelido que comeza por V e teña 6 letras

SELECT d.NomeDepartamento, e.Nome, e.Apelido1, e.Apelido2
FROM EMPREGADO e
INNER JOIN DEPARTAMENTO d ON e.NumDepartamentoPertenece = d.NumDepartamento
WHERE (e.Nome LIKE '[JMR][A]%')
   OR EXISTS (
        SELECT 1
        FROM EMPREGADO xefe
        WHERE xefe.NSS = d.NSSDirector 
        AND (xefe.Apelido1 LIKE 'V_____'
        OR XEFE.Apelido2 LIKE 'V_____')
    )
    
-- Con multitablas

SELECT D.NOMEDEPARTAMENTO, E.NOME, E.APELIDO1, ISNULL(E.APELIDO2, ' ')
FROM EMPREGADO E
	INNER JOIN DEPARTAMENTO D ON E.NumDepartamentoPertenece = D.NumDepartamento
	LEFT JOIN EMPREGADO JEFE ON E.NSSSupervisa=JEFE.NSS
WHERE E.Nome LIKE '[JMR][A]%' OR
(JEFE.Apelido1 LIKE 'V_____' OR JEFE.Apelido2 LIKE 'V_____')

-- 28. Lugares onde hai proxectos con empregados do departamento 1

SELECT DISTINCT p.Lugar
FROM PROXECTO p
INNER JOIN EMPREGADO_PROXECTO ep ON p.NumProxecto = ep.NumProxecto
INNER JOIN EMPREGADO e ON e.NSS = ep.NSSEmpregado
WHERE e.NumDepartamentoPertenece = 1

-- Subconsultas

SELECT DISTINCT LUGAR FROM PROXECTO WHERE
NumProxecto IN (SELECT DISTINCT NumProxecto FROM EMPREGADO_PROXECTO
				WHERE NSSEmpregado IN (
					  SELECT NSS FROM EMPREGADO
					  WHERE NumDepartamentoPertenece = 1))

-- 29. Custo total de salarios do departamento 2 este ano (sen pagas extras)

SELECT SUM(ef.Salario* 12) AS TotalPagoAnual
FROM EMPREGADOFIXO ef
INNER JOIN EMPREGADO e ON ef.NSS = e.NSS
WHERE e.NumDepartamentoPertenece = 2

-- 30. Empregados fixos que teñen máis idade

SELECT TOP 1 WITH TIES 
    e.Nome, e.Apelido1, e.Apelido2
FROM EMPREGADOFIXO ef
INNER JOIN EMPREGADO e ON ef.NSS = e.NSS
ORDER BY FLOOR(DATEDIFF(DD, e.DataNacemento, GETDATE())/365.25) DESC;

-- Con subconsultas

SELECT e.Nome, e.Apelido1, e.Apelido2
FROM EMPREGADOFIXO ef
INNER JOIN EMPREGADO e ON ef.NSS = e.NSS
WHERE FLOOR(DATEDIFF(DD, e.DataNacemento, GETDATE())/365.25) = (
    SELECT MAX(FLOOR(DATEDIFF(DD, e2.DataNacemento, GETDATE())/365.25))
    FROM EMPREGADOFIXO ef2
    INNER JOIN EMPREGADO e2 ON ef2.NSS = e2.NSS
)

-- 31. Salario medio, mínimo e máximo dos empregados que NON son xefes, agrupado por sexo

SELECT e.Sexo,
       CAST(AVG(ef.Salario) AS DECIMAL(10,2)) AS SalarioMedio,
       MIN(ef.Salario) AS SalarioMinimo,
       MAX(ef.Salario) AS SalarioMaximo,
       COUNT(*) AS NúmeroEmpleados
FROM EMPREGADOFIXO ef
INNER JOIN EMPREGADO e ON ef.NSS = e.NSS
WHERE e.NSS NOT IN (
    SELECT NSSDirector FROM DEPARTAMENTO
)
GROUP BY e.Sexo

-- 32. Nomes dos proxectos nos que participan persoas con salario NULO

SELECT DISTINCT p.NomeProxecto
FROM PROXECTO p
INNER JOIN EMPREGADO_PROXECTO ep ON p.NumProxecto = ep.NumProxecto
INNER JOIN EMPREGADOFIXO ef ON ep.NSSEmpregado = ef.NSS
WHERE ef.Salario IS NULL;

-- Alternativa con subconsulta

SELECT DISTINCT NomeProxecto
FROM PROXECTO
WHERE NumProxecto IN (
    SELECT ep.NumProxecto
    FROM EMPREGADO_PROXECTO ep
    JOIN EMPREGADOFIXO ef ON ep.NSSEmpregado = ef.NSS
    WHERE ef.Salario IS NULL
)

-- 33. Nome completo dos empregados que teñen máis familiares ao seu cargo

SELECT TOP 1 WITH TIES 
    e.Nome + ' ' + e.Apelido1 + ' ' + e.Apelido2 AS NomeCompleto,
    COUNT(*) AS TotalFamiliares
FROM EMPREGADO e
INNER JOIN FAMILIAR f ON e.NSS = f.NSS_empregado
GROUP BY e.Nome, e.Apelido1, e.Apelido2
ORDER BY COUNT(f.Numero) DESC;

-- Con subconsultas

SELECT e.Nome + ' ' + e.Apelido1 + ' ' + e.Apelido2 AS NomeCompleto
FROM EMPREGADO e
WHERE e.NSS IN (
    SELECT NSS_empregado
    FROM FAMILIAR
    GROUP BY NSS_empregado
    HAVING COUNT(*) = (
        SELECT MAX(Total)
        FROM (
            SELECT COUNT(*) AS Total
            FROM FAMILIAR
            GROUP BY NSS_empregado
        ) AS Contadores
    )
)

-- Alternativa con CTE
WITH NumFamiliares AS (
    SELECT NSS_empregado, COUNT(*) AS TotalFamiliares
    FROM FAMILIAR
    GROUP BY NSS_empregado
),
MaxFamiliares AS (
    SELECT MAX(TotalFamiliares) AS MaxF FROM NumFamiliares
)
SELECT e.Nome + ' ' + e.Apelido1 + ' ' + e.Apelido2 AS NomeCompleto
FROM EMPREGADO e
JOIN NumFamiliares nf ON e.NSS = nf.NSS_empregado
JOIN MaxFamiliares mf ON nf.TotalFamiliares = mf.MaxF;
