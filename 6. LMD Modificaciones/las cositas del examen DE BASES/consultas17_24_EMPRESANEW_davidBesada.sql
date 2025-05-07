-- 17._ �C�nto suman os salarios dos empregados fixos? �E cal � a media? Fai unha consulta que devolva os dous valores.

SELECT COUNT(*) AS 'N�mero de empregados', SUM(SALARIO) AS 'Suma dos salarios', AVG(SALARIO) AS 'Media dos salarios'
FROM EMPREGADOFIXO

-- 18._ Fai unha consulta que devolva o n�mero de empregados fixos que ten cada departamento e a media dos salarios.

SELECT NomeDepartamento, COUNT(*) AS 'N�mero de empregados', CAST(AVG(SALARIO) AS DECIMAL(8,2)) AS 'Media dos salarios'
FROM EMPREGADOFIXO EF
	 INNER JOIN EMPREGADO E ON EF.NSS = E.NSS
	 INNER JOIN DEPARTAMENTO D ON E.NumDepartamentoPertenece = D.NumDepartamento
GROUP BY NomeDepartamento 

-- 19._ Fai unha consulta que nos diga cantos empregados naceron cada ano a partir de 1969.

SELECT COUNT(*) AS 'N�mero de nados tras 1969'
FROM EMPREGADO 
WHERE YEAR(DATANACEMENTO) >= 1969

-- 20._Fai unha consulta que devolva o n�mero de empregados de cada sexo. Deber� visualizarse o texto do xeito seguinte: O n�mero de homes � 24 (e o mesmo para as mulleres).  

SELECT CASE 
		WHEN SEXO = 'H' THEN 'O n�mero de homes � ' + CAST(COUNT(*) AS VARCHAR(4))
		WHEN SEXO = 'M' THEN 'O n�mero de mulleres � ' + CAST(COUNT(*) AS VARCHAR(4))
		END AS 'Empleados de cada sexo'
FROM EMPREGADO
GROUP BY SEXO

-- 21._Fai unha consulta que devolva o n�mero de empregados temporales e fixos de cada sexo. Deber� visualizarse o texto do xeito seguinte: O n�mero de empregados fixos de sexo masculino son 24 (e o mesmo para as mulleres e os empregados temporais). 

SELECT 
    CASE 
        WHEN E.SEXO = 'H' THEN 'O n�mero de empregados fixos de sexo masculino � ' + 
            CAST(COUNT(DISTINCT EF.NSS) AS VARCHAR(10)) 
        WHEN E.SEXO = 'M' THEN 'O n�mero de empregadas fixas de sexo feminino � ' + 
            CAST(COUNT(DISTINCT EF.NSS) AS VARCHAR(10)) 
    END AS 'Empregados fixos',
    CASE 
        WHEN E.SEXO = 'H' THEN 'O n�mero de empregados temporais de sexo masculino � ' + 
            CAST(COUNT(DISTINCT ET.NSS) AS VARCHAR(10)) 
        WHEN E.SEXO = 'M' THEN 'O n�mero de empregadas temporais de sexo feminino � ' + 
            CAST(COUNT(DISTINCT ET.NSS) AS VARCHAR(10)) 
    END AS 'Empregados temporais'
FROM EMPREGADO E
LEFT JOIN EMPREGADOFIXO EF ON EF.NSS = E.NSS
LEFT JOIN EMPREGADOTEMPORAL ET ON ET.NSS = E.NSS
WHERE EF.NSS IS NOT NULL OR ET.NSS IS NOT NULL  -- Para evitar nulos
GROUP BY E.SEXO;


-- 22._Mostra o nome completo dos empregados que te�en m�is dun fillo de calquera sexo.

SELECT E.Nome + ' ' + E.Apelido1 + ' ' + ISNULL(E.Apelido2,' ') AS 'Nome completo'
FROM EMPREGADO E
WHERE (SELECT COUNT(*) FROM FAMILIAR F WHERE F.NSS_empregado = E.NSS) > 1;

-- 23._Crea unha consulta que mostre para cada empregado (nome e apelido mostrados nun so campo chamado Nome_completo) as horas totais que traballa cada empregado en todos os proxectos.

SELECT E.Nome + ' ' + E.Apelido1 + ' ' + ISNULL(E.Apelido2,' ') AS 'Nome completo', SUM(EP.Horas) AS Horas_totais
FROM EMPREGADO E
INNER JOIN EMPREGADO_PROXECTO EP ON E.NSS = EP.NSSEmpregado
GROUP BY E.Nome, E.Apelido1, E.Apelido2;

-- 24._ Supo�endo que as horas semanais que debe traballar un empregado son 40, modifica a consulta anterior para que amose os traballadores que te�en sobrecarga, indicando en cantas horas se pasan.

SELECT E.Nome + ' ' + E.Apelido1 + ' ' + ISNULL(E.Apelido2,' ') AS 'Nome completo',
       SUM(EP.Horas) AS Horas_totais,
       CASE 
           WHEN SUM(EP.Horas) > 40 THEN SUM(EP.Horas) - 40
           ELSE 0
       END AS Sobrecarga_horas
FROM EMPREGADO E
INNER JOIN EMPREGADO_PROXECTO EP ON E.NSS = EP.NSSEmpregado
GROUP BY E.Nome, E.Apelido1, E.Apelido2
HAVING SUM(EP.Horas) > 40;