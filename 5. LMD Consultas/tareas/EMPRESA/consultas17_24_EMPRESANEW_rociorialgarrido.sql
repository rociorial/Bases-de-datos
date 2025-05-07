Use EMPRESANEW

-- 17._ ¿Cánto suman os salarios dos empregados fixos? ¿E cal é a media? Fai unha consulta que devolva os dous valores.

SELECT SUM(Salario) AS Suma_Salarios, AVG(Salario) AS Media_Salarios
FROM EMPREGADOFIXO;


-- 18._ Fai unha consulta que devolva o número de empregados fixos que ten cada departamento e a media dos salarios.

SELECT D.NomeDepartamento, COUNT(E.NSS) AS Num_Empleados_Fixos, AVG(EF.Salario) AS Media_Salarios
FROM EMPREGADOFIXO EF
JOIN EMPREGADO E ON EF.NSS = E.NSS
JOIN DEPARTAMENTO D ON E.NumDep = D.NumDepartamento
GROUP BY D.NomeDepartamento;


-- 19._ Fai unha consulta que nos diga cantos empregados naceron cada ano a partir de 1969.

SELECT YEAR(E.DataNacemento) AS Ano, COUNT(*) AS Num_Empleados
FROM EMPREGADO E
WHERE YEAR(E.DataNacemento) >= 1969
GROUP BY YEAR(E.DataNacemento)
ORDER BY Ano;


-- 20._Fai unha consulta que devolva o número de empregados de cada sexo. Deberá visualizarse o texto do xeito seguinte: O número de homes é 24 (e o mesmo para as mulleres). 
 
SELECT 
    Sexo, 
    CASE 
        WHEN Sexo = 'H' THEN 'O número de homes é ' 
        WHEN Sexo = 'M' THEN 'O número de mulleres é ' 
    END AS Texto, 
    COUNT(*) AS Num_Empleados
FROM EMPREGADO
GROUP BY Sexo;



-- 21._Fai unha consulta que devolva o número de empregados temporales e fixos de cada sexo. Deberá visualizarse o texto do xeito seguinte: O número de empregados fixos de sexo masculino son 24 (e o mesmo para as mulleres e os empregados temporais). 

SELECT 
    Sexo, 
    CASE 
        WHEN EF.NSS IS NOT NULL AND Sexo = 'H' THEN 'O número de empregados fixos de sexo masculino son'
        WHEN EF.NSS IS NOT NULL AND Sexo = 'M' THEN 'O número de empregados fixos de sexo feminino son'
        WHEN ET.NSS IS NOT NULL AND Sexo = 'H' THEN 'O número de empregados temporais de sexo masculino son'
        WHEN ET.NSS IS NOT NULL AND Sexo = 'M' THEN 'O número de empregados temporais de sexo feminino son'
    END AS Texto, 
    COUNT(*) AS Num_Empleados
FROM EMPREGADO E
LEFT JOIN EMPREGADOFIXO EF ON E.NSS = EF.NSS
LEFT JOIN EMPREGADOTEMPORAL ET ON E.NSS = ET.NSS
GROUP BY Sexo, EF.NSS, ET.NSS;


-- 22._Mostra o nome completo dos empregados que teñen máis dun fillo de calquera sexo.

SELECT E.Nome + ' ' + E.Apelido1 + ' ' + ISNULL(E.Apelido2, '') AS Nome_Completo
FROM EMPREGADO E
JOIN FAMILIAR F ON E.NSS = F.NSS_empregado
GROUP BY E.NSS
HAVING COUNT(F.Numero) > 1;


-- 23._Crea unha consulta que mostre para cada empregado (nome e apelido mostrados nun so campo chamado Nome_completo) as horas totais que traballa cada empregado en todos os proxectos.

SELECT E.Nome + ' ' + E.Apelido1 + ' ' + ISNULL(E.Apelido2, '') AS NomeCompleto, SUM(EP.Horas) AS Horas_Totais
FROM EMPREGADO E
JOIN EMPREGADO_PROXECTO EP ON E.NSS = EP.NSSEmpregado
GROUP BY E.Nome, E.Apelido1, E.Apelido2;



-- 24._ Supoñendo que as horas semanais que debe traballar un empregado son 40, modifica a consulta anterior para que amose os traballadores que teñen sobrecarga, indicando en cantas horas se pasan.

SELECT Nome_Completo, (SUM(Horas) - 40) AS Horas_Extra
FROM (
    SELECT E.Nome + ' ' + E.Apelido1 + ' ' + ISNULL(E.Apelido2, '') AS Nome_Completo, EP.Horas
    FROM EMPREGADO E
    JOIN EMPREGADO_PROXECTO EP ON E.NSS = EP.NSSEmpregado
) AS Trabajadores
GROUP BY Nome_Completo
HAVING SUM(Horas) > 40;

