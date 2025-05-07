USE EMPRESA

-- 1. Selecciona todas las empleadas que viven en Pontevedra, Santiago o Vigo.

SELECT Nome, Apelido1, Apelido2
FROM EMPREGADO WHERE Localidade IN('Pontevedra','Santiago','Vigo') AND Sexo = 'M'

-- 2. Haz una consulta que devuelva los nombres y fecha de nacimiento de los hijos e hijas de modo que aparezcan en primer lugar los hijos de empleados y a continuación las hijas y dentro de esto ordenados por edad.

SELECT Nome + ' ' + Apelido1 + ' ' + ISNULL(Apelido2, '') AS Nombre
FROM FAMILIAR WHERE Parentesco IN ('Hijo','Hija') ORDER BY Parentesco DESC, DataNacemento ASC

-- 3. Haz una consulta que muestre el nombre del curso y el número de horas de los dos cursos que más duran, En el caso de haber un empate deben visualizarse todos.

SELECT TOP 2 WITH TIES Nome, Horas
FROM CURSO ORDER BY Horas DESC

-- 4. ¿En qué localidades se desarrollan proyectos? Muéstralas por orden alfabético.  

SELECT DISTINCT LUGAR
FROM PROXECTO ORDER BY LUGAR

-- 5. Muestra los datos de las tareas que están sin terminar.

SELECT *
FROM TAREFA 
WHERE data_fin IS NULL

-- 6. Muestra el nombre completo y NSS de los empleados que tienen un supervisor, de Lugo o Monforte, que nacieron entre el año 1970 y 1990.

SELECT *
FROM EMPREGADO
WHERE Localidade IN ('Lugo','Monforte') AND NSSSupervisa IS NOT NULL AND YEAR(dataNacemento) BETWEEN 1970 AND 1990

-- 7. Obtén una relación de localidades de empleados junto con sus gentilicios teniendo en cuenta que no deben aparecer valores duplicados y las siguientes correspondencias (en caso de no tener correspondencia deberá indicar "Otro").

SELECT DISTINCT Localidade,
		CASE Localidade
			WHEN 'Lugo' THEN 'lucense'
			WHEN 'Pontevedra' THEN 'pontevedrés'
			WHEN 'Vigo' THEN 'vigués'
			WHEN 'Santiago' THEN 'compostelano'
			WHEN 'Monforte' THEN 'monfortino'
			ELSE 'otro'
		END AS Gentilicio
FROM EMPREGADO
			 
-- 8. Vamos a mejorar la consulta anterior para que tenga en cuenta si se trata de un hombre o una mujer y de este modo ponga:

SELECT DISTINCT Localidade, Sexo,
		CASE 
			WHEN Localidade='Lugo' THEN 'lucense'
			WHEN Localidade='Pontevedra' AND Sexo='H' THEN 'pontevedrés'
			WHEN Localidade='Pontevedra' AND Sexo='M' THEN 'pontevedresa'
			WHEN Localidade='Vigo' AND Sexo='H' THEN 'vigués'
			WHEN Localidade='Vigo' AND Sexo='M' THEN 'viguesa'
			WHEN Localidade='Santiago' AND Sexo='H' THEN 'compostelano'
			WHEN Localidade='Santiago' AND Sexo='M' THEN 'compostelana'
			WHEN Localidade='Monforte' AND Sexo='H' THEN 'monfortino'
			WHEN Localidade='Monforte' AND Sexo='M' THEN 'monfortina'
			ELSE 'otro'
		END AS Gentilicio
FROM EMPREGADO

-- 9.  Muestra el nombre completo de los empleados y la fecha de nacimiento de la siguiente manera:

SELECT Nome + ' ' + Apelido1 + ' ' + ISNULL(Apelido2, '') AS 'Nombre Completo', +
		DATENAME(weekday,DataNacemento) + ', ' + cast(DAY(DataNacemento) as varchar(2)) + ' de ' 
		+ DATENAME(MONTH,DataNacemento) + ' de ' + cast(YEAR(DataNacemento) as varchar(4)) AS DataNacemento
FROM EMPREGADO

-- 10. Muestra el nombre completo de los familiares que tienen un apellido (cuaquiera de los dos) de menos de 5 letras, ordenados por primer apellido y dentro de este por segundo apellido.

SELECT Nome + ' ' + Apelido1 + ' ' + ISNULL(Apelido2, '') AS 'Nombre Completo'
FROM FAMILIAR WHERE LEN(Apelido1)<5 OR LEN(Apelido2)<5 ORDER BY Apelido1,Apelido2
