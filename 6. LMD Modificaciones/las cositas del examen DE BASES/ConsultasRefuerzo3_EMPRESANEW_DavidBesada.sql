-- 1. Hallar el número de empleados por departamento (visualiza el nombre) solo para aquellos departamentos que controlan más de 2 proyectos.
SELECT d.NomeDepartamento AS Departamento, 
       COUNT(e.NSS) AS Numero_Empleados
FROM EMPREGADO e
INNER JOIN DEPARTAMENTO d ON e.NumDepartamentoPertenece = d.NumDepartamento
INNER JOIN PROXECTO p ON p.NumDepartControla = d.NumDepartamento
GROUP BY d.NomeDepartamento
HAVING COUNT(p.NumProxecto) > 2;

-- 2. ¿Cuál es la media del número de empleados por departamento? Redondea al número entero más alto.
SELECT CEILING(AVG(Numero_Empleados)) AS Media_Empleados
FROM (
    SELECT d.NumDepartamento, COUNT(e.NSS) AS Numero_Empleados
    FROM EMPREGADO e
    INNER JOIN DEPARTAMENTO d ON e.NumDepartamentoPertenece = d.NumDepartamento
    GROUP BY d.NumDepartamento
) AS EmpleadosPorDepartamento;

-- 3. Visualiza el nombre del departamento y número de proyectos que controlan para aquellos departamentos que el número de empleados asignados supera a la media del número de empleados por departamento.
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

-- 4. Para los departamentos que tienen más de 1 empleado con menos de 3 familias a su cargo, hallar el número de proyectos que controlan.
SELECT d.NomeDepartamento AS Departamento, 
       COUNT(p.NumProxecto) AS Numero_Proyectos
FROM EMPREGADO e
INNER JOIN DEPARTAMENTO d ON e.NumDepartamentoPertenece = d.NumDepartamento
INNER JOIN PROXECTO p ON p.NumDepartControla = d.NumDepartamento
LEFT JOIN FAMILIAR f ON e.NSS = f.NSS_empregado  -- Relacionamos los familiares con el empleado
GROUP BY d.NomeDepartamento
HAVING COUNT(f.Numero) < 3 
   AND COUNT(e.NSS) > 1;

-- 5. Para los departamentos que tienen más de 1 empleado con menos de 3 familias a su cargo, hallar el número de proyectos que controlan si estos representan más del 15% del número de proyectos que hay.
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

-- 6. Haz una consulta para mostrar la siguiente información referente a los empleados: Edad, número de mujeres, número de hombres, total.
SELECT 
    CASE 
        WHEN DATEDIFF(DAY, E.DataNacemento, GETDATE()) / 365.25 BETWEEN 40 AND 50 THEN 'Entre 40 y 50 años'
        WHEN DATEDIFF(DAY, E.DataNacemento, GETDATE()) / 365.25 > 50 THEN 'Mayor 50 años'
        WHEN DATEDIFF(DAY, E.DataNacemento, GETDATE()) / 365.25 < 40 THEN 'Menores de 40 años'
    END AS Edad,
    
    -- Número de mujeres (Sexo = 'M')
    SUM(CASE WHEN Sexo = 'M' THEN 1 ELSE 0 END) AS Numero_Mujeres,
    
    -- Número de hombres (Sexo = 'H')
    SUM(CASE WHEN Sexo = 'H' THEN 1 ELSE 0 END) AS Numero_Hombres,
    
    -- Total de empleados
    COUNT(*) AS Total
FROM EMPREGADO E
GROUP BY 
    CASE 
        WHEN DATEDIFF(DAY, E.DataNacemento, GETDATE()) / 365.25 BETWEEN 40 AND 50 THEN 'Entre 40 y 50 años'
        WHEN DATEDIFF(DAY, E.DataNacemento, GETDATE()) / 365.25 > 50 THEN 'Mayor 50 años'
        WHEN DATEDIFF(DAY, E.DataNacemento, GETDATE()) / 365.25 < 40 THEN 'Menores de 40 años'
    END;

-- 7. Hallar la media de la edad (se visualiza con dos decimales) de aquellos empleados que dirigen algún departamento con más de 4 empleados.

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

-- 8. Para los proyectos que han tenido el mayor número de problemas, visualiza el nombre del proyecto, nombre del departamento que lo controla y número de empleados asignados.

SELECT TOP 1 
    P.NomeProxecto, 
    D.NomeDepartamento, 
    COUNT(E.NSS) AS Numero_Empleados
FROM PROXECTO P
INNER JOIN DEPARTAMENTO D ON P.NumDepartControla = D.NumDepartamento
INNER JOIN EMPREGADO E ON E.NumDepartamentoPertenece = D.NumDepartamento
GROUP BY P.NomeProxecto, D.NomeDepartamento
ORDER BY COUNT(P.NumDepartControla) DESC;
