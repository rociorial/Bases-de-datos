-- 34. Realiza unha consulta que devolva o nome, apelidos, tel�fono e departamento dos empregados
-- e matr�cula e modelo do veh�culo dos empregados que te�en un veh�culo de m�is de 4 anos. 
-- Para o tel�fono queremos visualizar o tel�fono1 no caso de que o te�a, se non o ten miraremos se ten o tel�fono2 
-- e en caso de non ter ning�n visualizarase 'Desco�ecido'.

SELECT 
    E.Nome + ' ' + E.Apelido1 + ' ' + ISNULL(E.Apelido2,' ') AS [Nome completo],
    COALESCE(E.Telefono1, E.Telefono2, 'Desco�ecido') AS Telefono,
    D.NomeDepartamento,
    V.Matricula, V.Modelo
FROM EMPREGADO E
INNER JOIN DEPARTAMENTO D ON E.NumDepartamentoPertenece = D.NumDepartamento
INNER JOIN VEHICULO V ON E.NSS = V.NSS
WHERE DATEDIFF(DD,V.DATACOMPRA,GETDATE()) /365.25 > 4;


-- 35._ Fai unha consulta que devolva informaci�n dos cursos que se celebran en Vigo e Pontevedra. Para cada curso queremos saber o nome, n�mero de horas e total de alumnos nas edici�ns que se te�an celebrado deste curso polo momento. Tam�n queremos saber cal foi o n�mero de alumnos m�is grande e m�is pequeno para cada unha das edici�ns do curso.

SELECT
	C.Nome AS NomeCurso,
	C.Horas AS NumeroHoras,
	SUM(EE.NumEmpleados) AS TotalEmpleados,
	MAX(EE.NumEmpleados) AS MaxEmpleados,
	MIN(EE.NumEmpleados) AS MinEmpleados
FROM CURSO C
	INNER JOIN EDICION E ON C.Codigo = E.Numero
	INNER JOIN (
		SELECT Codigo, COUNT(NSS) AS NumEmpleados 
		FROM EDICIONCURSO_EMPREGADO
		GROUP BY Codigo
		) EE ON E.Codigo = EE.Codigo
WHERE E.Lugar IN ('Vigo', 'Pontevedra')
GROUP BY C.Nome, C.Horas;

-- 36._ Cantos empregados hai en cada provincia?. Para saber a provincia utiliza os dous primeiros caracteres do c�digo postal e traduce este de modo que se visualice o nome e en caso de non ter CP indica de cantos se desco�ece a provincia.
-- 36 :'PONTEVEDRA'     27 :'LUGO'  15 :'SANTIAGO'
SELECT 
    CASE 
        WHEN SUBSTRING(CP, 1, 2) = '36' THEN 'PONTEVEDRA'
        WHEN SUBSTRING(CP, 1, 2) = '27' THEN 'LUGO'
        WHEN SUBSTRING(CP, 1, 2) = '15' THEN 'SANTIAGO'
        ELSE 'Desco�ecida'
    END AS Provincia,
    COUNT(*) AS NumeroEmpleados
FROM EMPREGADO
GROUP BY SUBSTRING(CP, 1, 2);

-- 37._ Crea unha consulta que mostre para todos os empregados o seu nome completo (p.e: Javier Quintero Alvarez) e no caso de ter marido ou muller o nome completo deste indicando se se trata de marido ou de muller. Deber�n visualizarse todos os empregados independentemente de se te�en parella ou non.

SELECT 
    E.Nome + ' ' + E.Apelido1 + ' ' + ISNULL(E.Apelido2, ' ') AS NomeEmpregado,
    CASE 
        WHEN F.Sexo = 'M' THEN 'Muller'
        WHEN F.Sexo = 'H' THEN 'Marido'
        ELSE 'Desco�ecido'
    END AS TipoParella,
    ISNULL(F.Nome + ' ' + F.Apelido1 + ' ' + F.Apelido2, 'Sen parella') AS NomeParella
FROM EMPREGADO E
LEFT JOIN FAMILIAR F ON E.NSS = F.NSS_empregado AND F.Parentesco IN ('Muller', 'Marido');

-- 38._ �Existe alg�n empregado que traballa en m�is dun proxectos que se desenvolven en lugares diferentes?.

SELECT E.NSS, E.Nome + ' ' + E.Apelido1 + ' ' + ISNULL(E.Apelido2, ' ') AS NomeEmpregado
FROM EMPREGADO E
INNER JOIN EMPREGADO_PROXECTO EP ON E.NSS = EP.NSSEmpregado
INNER JOIN PROXECTO P ON EP.NumProxecto = P.NumProxecto
GROUP BY E.NSS, E.Nome, E.Apelido1, E.Apelido2
HAVING COUNT(DISTINCT P.Lugar) > 1;

-- 39._ Desexamos identificar a cada empregado por un mote que ter� as d�as primeiras letras do nome, as d�as segundas do apelido1 e a primeira e a �ltima da localidade na que reside (todo en min�sculas). Crea unha t�boa que conte�a para cada empregado o seu NSS, mote e o nome do departamento no que traballa.


SELECT 
    E.NSS,
    LOWER(SUBSTRING(E.Nome, 1, 2) + SUBSTRING(E.Apelido1, 3, 2) + LEFT(E.Localidade, 1) + RIGHT(E.Localidade, 1)) AS Mote,
    D.NomeDepartamento
INTO EMPLEADO_MOTE
FROM EMPREGADO E
INNER JOIN DEPARTAMENTO D ON E.NumDepartamentoPertenece = D.NumDepartamento;

SELECT * FROM EMPLEADO_MOTE

-- 40._ Queremos ver que empregados podemos asignar aos proxectos que est�n en marcha. Para elo imos seleccionar os empregados que viven no mesmo lugar no que se desenvolve o proxecto e que non est�n traballando en ning�n proxecto na ciudade na que residen. A informaci�n que se amosar� ser� o nome de proxecto e NSS , nome e apelido1 dos empregados dispo�ibles.
SELECT 
    P.NomeProxecto, 
    E.NSS, 
    E.Nome + ' ' + E.Apelido1 + ' ' + ISNULL(E.Apelido2, ' ') AS NomeEmpregado
FROM EMPREGADO E
INNER JOIN PROXECTO P ON E.Localidade = P.Lugar
LEFT JOIN EMPREGADO_PROXECTO EP ON E.NSS = EP.NSSEmpregado
WHERE EP.NumProxecto IS NULL;

-- TA MAL

SELECT NomeProxecto, NSS, Nome, Apelido1
FROM EMPREGADO E
INNER JOIN PROXECTO P ON Lugar = Localidade
WHERE Localidade NOT IN (SELECT LUGAR
						 FROM PROXECTO P INNER JOIN EMPREGADO_PROXECTO EP
						 ON P.NumProxecto = EP.NumProxecto
						 WHERE EP.NSSEmpregado = E.NSS)
						 
-- 41._ O mesmo que a anterior pero s� para os empregados que te�an m�is de 10 horas dispo�ibles � semana tendo en conta que o n� de horas m�ximo � semana � de 40 horas.

SELECT NomeProxecto, NSS, Nome, Apelido1
FROM EMPREGADO E
INNER JOIN PROXECTO P ON Lugar = Localidade
WHERE Localidade NOT IN (SELECT LUGAR
						 FROM PROXECTO P INNER JOIN EMPREGADO_PROXECTO EP
						 ON P.NumProxecto = EP.NumProxecto
						 WHERE EP.NSSEmpregado = E.NSS)
						 AND (SELECT (40 - SUM(HORAS)) AS HORAS_LIBRES
						 FROM EMPREGADO_PROXECTO
						 WHERE NSSEmpregado = E.NSS
						 ) > 10