-- 1. Hallar el n�mero de empleados por departamento (visualiza el nombre) solo para aquellos departamentos que controlan m�s de 2 proyectos.
SELECT d.NomeDepartamento AS Departamento, 
       COUNT(e.NSS) AS Numero_Empleados
FROM EMPREGADO e
INNER JOIN DEPARTAMENTO d ON e.NumDepartamentoPertenece = d.NumDepartamento
INNER JOIN PROXECTO p ON p.NumDepartControla = d.NumDepartamento
GROUP BY d.NomeDepartamento
HAVING COUNT(p.NumProxecto) > 2;

-- 2 a. �Cu�l es la media del n�mero de empleados por departamento? Redondea al n�mero entero m�s alto.
SELECT CEILING(AVG(Numero_Empleados)) AS Media_Empleados
FROM (
    SELECT d.NumDepartamento, COUNT(e.NSS) AS Numero_Empleados
    FROM EMPREGADO e
    INNER JOIN DEPARTAMENTO d ON e.NumDepartamentoPertenece = d.NumDepartamento
    GROUP BY d.NumDepartamento
) AS EmpleadosPorDepartamento;

-- 2 b. Visualiza el nombre del departamento y n�mero de proyectos que controlan para aquellos departamentos que el n�mero de empleados asignados supera a la media del n�mero de empleados por departamento.
SELECT d.NomeDepartamento AS Departamento, 
       COUNT(p.NumProxecto) AS Numero_Proyectos
FROM EMPREGADO e
INNER JOIN DEPARTAMENTO d ON e.NumDepartamentoPertenece = d.NumDepartamento
INNER JOIN PROXECTO p ON p.NumDepartControla = d.NumDepartamento
GROUP BY d.NomeDepartamento
HAVING COUNT(e.NSS) > (
    SELECT AVG(Numero_Empleados)
    FROM (
        SELECT d.NumDepartamento, COUNT(e.NSS) AS Numero_Empleados
        FROM EMPREGADO e
        INNER JOIN DEPARTAMENTO d ON e.NumDepartamentoPertenece = d.NumDepartamento
        GROUP BY d.NumDepartamento
    ) AS EmpleadosPorDepartamento
);

-- 3 a. Para los departamentos que tienen m�s de 1 empleado con menos de 3 familias a su cargo, hallar el n�mero de proyectos que controlan.
SELECT d.NomeDepartamento AS Departamento, 
       COUNT(p.NumProxecto) AS Numero_Proyectos
FROM EMPREGADO e
INNER JOIN DEPARTAMENTO d ON e.NumDepartamentoPertenece = d.NumDepartamento
INNER JOIN PROXECTO p ON p.NumDepartControla = d.NumDepartamento
LEFT JOIN FAMILIAR f ON e.NSS = f.NSS_empregado  -- Relacionamos los familiares con el empleado
GROUP BY d.NomeDepartamento
HAVING COUNT(f.Numero) < 3 
   AND COUNT(e.NSS) > 1;

-- 3 b. Para los departamentos que tienen m�s de 1 empleado con menos de 3 familias a su cargo, hallar el n�mero de proyectos que controlan si estos representan m�s del 15% del n�mero de proyectos que hay.
SELECT d.NomeDepartamento AS Departamento, 
       COUNT(p.NumProxecto) AS Numero_Proyectos
FROM EMPREGADO e
INNER JOIN DEPARTAMENTO d ON e.NumDepartamentoPertenece = d.NumDepartamento
INNER JOIN PROXECTO p ON p.NumDepartControla = d.NumDepartamento
LEFT JOIN FAMILIAR f ON e.NSS = f.NSS_empregado
GROUP BY d.NomeDepartamento
HAVING COUNT(f.Numero) < 3
   AND COUNT(e.NSS) > 1
   AND COUNT(p.NomeProxecto) > (
       SELECT 0.15 * COUNT(*)
       FROM PROXECTO P
       INNER JOIN DEPARTAMENTO D ON NumDepartControla =  D.NumDepartamento
       WHERE NumDepartControla = d.NumDepartamento
   );

-- 4. Haz una consulta para mostrar la siguiente informaci�n referente a los empleados: Edad, n�mero de mujeres, n�mero de hombres, total.
SELECT 
    CASE 
        WHEN DATEDIFF(DAY, E.DataNacemento, GETDATE()) / 365.25 BETWEEN 40 AND 50 THEN 'Entre 40 y 50 a�os'
        WHEN DATEDIFF(DAY, E.DataNacemento, GETDATE()) / 365.25 > 50 THEN 'Mayor 50 a�os'
        WHEN DATEDIFF(DAY, E.DataNacemento, GETDATE()) / 365.25 < 40 THEN 'Menores de 40 a�os'
    END AS Edad,
    
    -- N�mero de mujeres (Sexo = 'M')
    SUM(CASE WHEN Sexo = 'M' THEN 1 ELSE 0 END) AS Numero_Mujeres,
    
    -- N�mero de hombres (Sexo = 'H')
    SUM(CASE WHEN Sexo = 'H' THEN 1 ELSE 0 END) AS Numero_Hombres,
    
    -- Total de empleados
    COUNT(*) AS Total
FROM EMPREGADO E
GROUP BY 
    CASE 
        WHEN DATEDIFF(DAY, E.DataNacemento, GETDATE()) / 365.25 BETWEEN 40 AND 50 THEN 'Entre 40 y 50 a�os'
        WHEN DATEDIFF(DAY, E.DataNacemento, GETDATE()) / 365.25 > 50 THEN 'Mayor 50 a�os'
        WHEN DATEDIFF(DAY, E.DataNacemento, GETDATE()) / 365.25 < 40 THEN 'Menores de 40 a�os'
    END;

-- 5. Hallar la media de la edad (se visualiza con dos decimales) de aquellos empleados que dirigen alg�n departamento con m�s de 4 empleados.

SELECT 
    CAST(AVG(DATEDIFF(DAY, E.DataNacemento, GETDATE()) / 365.25) AS DECIMAL (10,2)) AS Media_Edad
FROM EMPREGADO E
INNER JOIN DEPARTAMENTO D ON E.NumDepartamentoPertenece = D.NumDepartamento
WHERE E.NumDepartamentoPertenece IN (
    SELECT D.NumDepartamento
    FROM EMPREGADO E
    INNER JOIN DEPARTAMENTO D ON E.NumDepartamentoPertenece = D.NumDepartamento
    GROUP BY D.NumDepartamento
    HAVING COUNT(E.NSS) > 4
);

-- 6. Para los proyectos que han tenido el mayor n�mero de problemas, visualiza el nombre del proyecto, nombre del departamento que lo controla y n�mero de empleados asignados.

SELECT TOP 1 
    P.NomeProxecto, 
    D.NomeDepartamento, 
    COUNT(E.NSS) AS Numero_Empleados
FROM PROXECTO P
INNER JOIN DEPARTAMENTO D ON P.NumDepartControla = D.NumDepartamento
INNER JOIN EMPREGADO E ON E.NumDepartamentoPertenece = D.NumDepartamento
GROUP BY P.NomeProxecto, D.NomeDepartamento
ORDER BY COUNT(P.NumDepartControla) DESC;
