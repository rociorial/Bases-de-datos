-- 1. Listado de sueldo medio y n�mero de empleados por localidad ordenado por provincia y dentro de esta por localidad.
-- La localidad debe verse de la forma Localidad (Provincia)
SELECT * FROM EMPREGADO ORDER BY Localidade

SELECT 
  Localidade + ' (' + ISNULL(Provincia, ' - ') + ')' AS Localidad_Provincia,
  CAST(AVG(EF.Salario) AS DECIMAL(10,2)) AS Sueldo_Medio,
  COUNT(*) AS Numero_Empleados
FROM EMPREGADO E
INNER JOIN EMPREGADOFIXO EF ON E.NSS = EF.NSS
GROUP BY Localidade, Provincia
ORDER BY Provincia, Localidade;

-- 2. �En qu� a�o nacieron m�s empleados?

SELECT TOP 1 WITH TIES
  YEAR(DataNacemento) AS A�o,
  COUNT(*) AS Total
FROM EMPREGADO
GROUP BY YEAR(DataNacemento)
ORDER BY Total DESC;

-- CON SUBCONSULTAS

SELECT
  YEAR(DataNacemento) AS A�o,
  COUNT(*) AS Total
FROM EMPREGADO
GROUP BY YEAR(DataNacemento)
HAVING COUNT(*) >= ALL (SELECT COUNT(*) FROM EMPREGADO GROUP BY YEAR(DATANACEMENTO))

-- CON TABLA DERIVADA

SELECT
  YEAR(DataNacemento) AS A�o,
  COUNT(*) AS Total
FROM EMPREGADO
GROUP BY YEAR(DataNacemento)
HAVING COUNT(*) >= ALL (SELECT COUNT(*) FROM EMPREGADO GROUP BY YEAR(DATANACEMENTO))

-- 3. Muestra, para la fecha actual: el a�o, el mes (su nombre), el d�a, el d�a del a�o, la semana, 
-- el d�a de la semana (nombre), la hora, los minutos y los segundos.

SELECT 
  GETDATE() AS FechaCompleta,
  YEAR(GETDATE()) AS Anio,
  DATENAME(MONTH, GETDATE()) AS Mes,
  DAY(GETDATE()) AS Dia,
  DATEPART(DAYOFYEAR, GETDATE()) AS DiaDelA�o,
  DATEPART(WEEK, GETDATE()) AS Semana,
  DATENAME(WEEKDAY, GETDATE()) AS DiaSemana,
  DATEPART(HOUR, GETDATE()) AS Hora,
  DATEPART(MINUTE, GETDATE()) AS Minuto,
  DATEPART(SECOND, GETDATE()) AS Segundo;


-- 4. Indica cu�ntos d�as, meses, semanas y a�os faltan para tu pr�ximo cumplea�os.
-- Cambia la fecha de nacimiento a la tuya real (formato YYYY-MM-DD)

SELECT 
  DATEDIFF(DAY, GETDATE(),
           CASE 
             WHEN CAST(CAST(YEAR(GETDATE()) AS VARCHAR) + '-04-03' AS DATE) >= GETDATE()
             THEN CAST(CAST(YEAR(GETDATE()) AS VARCHAR) + '-04-03' AS DATE)
             ELSE DATEADD(YEAR, 1, CAST(CAST(YEAR(GETDATE()) AS VARCHAR) + '-04-03' AS DATE))
           END
  ) AS Dias,

  DATEDIFF(MONTH, GETDATE(),
           CASE 
             WHEN CAST(CAST(YEAR(GETDATE()) AS VARCHAR) + '-04-03' AS DATE) >= GETDATE()
             THEN CAST(CAST(YEAR(GETDATE()) AS VARCHAR) + '-04-03' AS DATE)
             ELSE DATEADD(YEAR, 1, CAST(CAST(YEAR(GETDATE()) AS VARCHAR) + '-04-03' AS DATE))
           END
  ) AS Meses,

  DATEDIFF(WEEK, GETDATE(),
           CASE 
             WHEN CAST(CAST(YEAR(GETDATE()) AS VARCHAR) + '-04-03' AS DATE) >= GETDATE()
             THEN CAST(CAST(YEAR(GETDATE()) AS VARCHAR) + '-04-03' AS DATE)
             ELSE DATEADD(YEAR, 1, CAST(CAST(YEAR(GETDATE()) AS VARCHAR) + '-04-03' AS DATE))
           END
  ) AS Semanas,

  DATEDIFF(YEAR, GETDATE(),
           CASE 
             WHEN CAST(CAST(YEAR(GETDATE()) AS VARCHAR) + '-04-03' AS DATE) >= GETDATE()
             THEN CAST(CAST(YEAR(GETDATE()) AS VARCHAR) + '-04-03' AS DATE)
             ELSE DATEADD(YEAR, 1, CAST(CAST(YEAR(GETDATE()) AS VARCHAR) + '-04-03' AS DATE))
           END
  ) AS A�os;
  

-- CON DECLARES

DECLARE @cumple DATE = '2002-04-03';
DECLARE @hoy DATE = GETDATE();

DECLARE @anioActual INT = YEAR(@hoy);
DECLARE @fechaCumpleEsteAnio DATE = CAST(CAST(@anioActual AS VARCHAR) + '-' + 
                                          RIGHT('0' + CAST(MONTH(@cumple) AS VARCHAR), 2) + '-' + 
                                          RIGHT('0' + CAST(DAY(@cumple) AS VARCHAR), 2) AS DATE);

DECLARE @proximoCumple DATE = 
    CASE 
        WHEN @fechaCumpleEsteAnio >= @hoy THEN @fechaCumpleEsteAnio
        ELSE DATEADD(YEAR, 1, @fechaCumpleEsteAnio)
    END;

SELECT 
  DATEDIFF(DAY, @hoy, @proximoCumple) AS Dias,
  DATEDIFF(MONTH, @hoy, @proximoCumple) AS Meses,
  DATEDIFF(WEEK, @hoy, @proximoCumple) AS Semanas,
  DATEDIFF(YEAR, @hoy, @proximoCumple) AS A�os;
  

-- 5. Lista de todos los departamentos y los empleados que pertenecen a ellos,
-- incluyendo los departamentos sin empleados asignados.

SELECT 
  D.NomeDepartamento,
  E.Nome + ' ' + E.Apelido1 + ISNULL(' ' + E.Apelido2, '') AS NombreCompleto
FROM DEPARTAMENTO D
LEFT JOIN EMPREGADO E ON D.NumDepartamento = E.NumDepartamentoPertenece
ORDER BY D.NomeDepartamento, NombreCompleto;


-- 6. Consulta que muestra el n�mero de caracteres del nombre de departamento y el nombre en formato inverso.

SELECT 
  NomeDepartamento,
  LEN(NomeDepartamento) AS NumCaracteres,
  REVERSE(NomeDepartamento) AS NombreInvertido
FROM DEPARTAMENTO;


-- 7a. Consulta para obtener el nombre del departamento y la cantidad total de proyectos que controla
-- a) S�lo departamentos que controlan proyectos

SELECT 
  D.NomeDepartamento,
  COUNT(P.NumProxecto) AS TotalProyectos
FROM DEPARTAMENTO D
INNER JOIN PROXECTO P ON D.NumDepartamento = P.NumDepartControla
GROUP BY D.NomeDepartamento;


-- 7b. Consulta que muestra todos los departamentos y, en caso de no controlar ninguno, pondr� 'No tiene'

SELECT 
  D.NomeDepartamento,
  ISNULL(CAST(COUNT(P.NumProxecto) AS VARCHAR), 'No tiene') AS TotalProyectos
FROM DEPARTAMENTO D
LEFT JOIN PROXECTO P ON D.NumDepartamento = P.NumDepartControla
GROUP BY D.NomeDepartamento;


-- 8. Consulta que cuente el n�mero de espacios que tienen los nombres de proyecto.

SELECT 
  NomeProxecto,
  LEN(NomeProxecto) - LEN(REPLACE(NomeProxecto, ' ', '')) AS Espacios
FROM PROXECTO;


-- 9. Consulta para obtener todos los empleados (nss y nombre completo) y los proyectos (nombre)
-- en los que est�n asignados, incluso si no tienen proyectos asignados.

SELECT 
  E.NSS,
  E.Nome + ' ' + E.Apelido1 + ISNULL(' ' + E.Apelido2, '') AS NombreCompleto,
  ISNULL(P.NomeProxecto, 'SEN PROXECTO')
FROM EMPREGADO E
LEFT JOIN EMPREGADO_PROXECTO EP ON E.NSS = EP.NSSempregado
LEFT JOIN PROXECTO P ON EP.NumProxecto = P.NumProxecto;


-- 10. Consulta para obtener todos los proyectos y los empleados asignados a ellos,
-- incluso si no hay empleados asignados a alg�n proyecto.

SELECT 
  P.NomeProxecto,
  E.NSS,
  E.Nome + ' ' + E.Apelido1 + ISNULL(' ' + E.Apelido2, '') AS NombreCompleto
FROM PROXECTO P
LEFT JOIN EMPREGADO_PROXECTO EP ON P.NumProxecto = EP.NumProxecto
LEFT JOIN EMPREGADO E ON EP.NSSempregado = E.NSS;


-- 11. Consulta para obtener los cinco proyectos con la cantidad total de horas semanales m�s alta asignadas.
-- En caso de empate, deben verse todos.

WITH ProyectoHoras AS (
  SELECT 
    P.NumProxecto,
    P.NomeProxecto,
    SUM(EP.Horas) AS TotalHoras
  FROM PROXECTO P
  INNER JOIN EMPREGADO_PROXECTO EP ON P.NumProxecto = EP.NumProxecto
  GROUP BY P.NumProxecto, P.NomeProxecto
)
SELECT *
FROM ProyectoHoras
WHERE TotalHoras IN (
    SELECT TOP 5 TotalHoras
    FROM ProyectoHoras
    ORDER BY TotalHoras DESC
)
ORDER BY TotalHoras DESC;


-- 12. Consulta para obtener los dos departamentos con el menor n�mero de caracteres en sus nombres (sin empates).

SELECT TOP 2 
  NomeDepartamento,
  LEN(NomeDepartamento) AS NumCaracteres
FROM DEPARTAMENTO
ORDER BY LEN(NomeDepartamento), NomeDepartamento;


-- 13. Consulta para obtener los empleados (NSS) que no est�n asignados a ning�n proyecto.

SELECT 
  E.NSS,
  E.Nome + ' ' + E.Apelido1 + ISNULL(' ' + E.Apelido2, '') AS NombreCompleto
FROM EMPREGADO E
LEFT JOIN EMPREGADO_PROXECTO EP ON E.NSS = EP.NSSempregado
WHERE EP.NumProxecto IS NULL;
