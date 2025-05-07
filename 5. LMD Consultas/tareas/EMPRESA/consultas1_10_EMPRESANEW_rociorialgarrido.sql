-- 1. Selecciona todas las empleadas que viven en Pontevedra, Santiago o Vigo. 
SELECT * 
FROM EMPREGADO 
WHERE Localidade IN ('Pontevedra', 'Santiago', 'Vigo') 
AND Sexo = 'M';

-- 2. Haz una consulta que devuelva los nombres y fecha de nacimiento de los hijos e hijas de modo que aparezcan en 
-- primer lugar los hijos de empleados y a continuación las hijas y dentro de esto ordenados por edad. 
SELECT Nome, Data_nacimento 
FROM FAMILIAR 
WHERE Parentesco IN ('Hijo', 'Hija')
ORDER BY 
    CASE WHEN Parentesco = 'Hijo' THEN 1 ELSE 2 END,
    Data_nacimento;

-- 3. Haz una consulta que muestre el nombre del curso y el número de horas de los dos cursos que más duran, En el 
-- caso de haber un empate deben visualizarse todos. 
SELECT Nome, Horas 
FROM CURSO 
WHERE Horas >= (SELECT DISTINCT Horas 
                FROM CURSO 
                ORDER BY Horas DESC 
                LIMIT 2);

-- 4. ¿En qué localidades se desarrollan proyectos? Muéstralas por orden alfabético.   
SELECT DISTINCT Lugar 
FROM PROXECTO 
ORDER BY Lugar;

-- 5. Muestra los datos de las tareas que están sin terminar. 
SELECT * 
FROM TAREFA 
WHERE estado != 'Finalizada';

-- 6. Muestra el nombre completo y NSS de los empleados que tienen un supervisor, de Lugo o Monforte, que nacieron entre el año 1970 y 1990.
SELECT Nome, Apelido1, Apelido2, NSS 
FROM EMPREGADO 
WHERE NSSSupervisa IS NOT NULL 
AND Localidade IN ('Lugo', 'Monforte') 
AND DataNacemento BETWEEN '1970-01-01' AND '1990-12-31';


/* 7. Obtén una relación de localidades de empleados junto con sus gentilicios teniendo en cuenta que no deben aparecer valores duplicados y las siguientes correspondencias (en caso de no tener correspondencia deberá indicar "Otro").
    Lugo - lucense
    Pontevedra - pontevedrés
    Vigo - vigués
    Santiago - compostelano
    Monforte - monfortino   */
SELECT DISTINCT Localidade, 
       CASE 
           WHEN Localidade = 'Lugo' THEN 'lucense'
           WHEN Localidade = 'Pontevedra' THEN 'pontevedrés'
           WHEN Localidade = 'Vigo' THEN 'vigués'
           WHEN Localidade = 'Santiago' THEN 'compostelano'
           WHEN Localidade = 'Monforte' THEN 'monfortino'
           ELSE 'Otro'
       END AS Gentilicio
FROM EMPREGADO;


/* 8. Vamos a mejorar la consulta anterior para que tenga en cuenta si se trata de un hombre o una mujer y de este modo ponga:
    Lugo - lucense 
    Pontevedra - pontevedrés / pontevedresa
    Vigo - vigués / viguesa
    Santiago - compostelano /compostelana
    Monforte - monfortino /monfortina   */
SELECT DISTINCT Localidade, 
       CASE 
           WHEN Localidade = 'Lugo' THEN 'lucense'
           WHEN Localidade = 'Pontevedra' AND Sexo = 'H' THEN 'pontevedrés'
           WHEN Localidade = 'Pontevedra' AND Sexo = 'M' THEN 'pontevedresa'
           WHEN Localidade = 'Vigo' AND Sexo = 'H' THEN 'vigués'
           WHEN Localidade = 'Vigo' AND Sexo = 'M' THEN 'viguesa'
           WHEN Localidade = 'Santiago' AND Sexo = 'H' THEN 'compostelano'
           WHEN Localidade = 'Santiago' AND Sexo = 'M' THEN 'compostelana'
           WHEN Localidade = 'Monforte' AND Sexo = 'H' THEN 'monfortino'
           WHEN Localidade = 'Monforte' AND Sexo = 'M' THEN 'monfortina'
           ELSE 'Otro'
       END AS Gentilicio
FROM EMPREGADO;


-- 9. Muestra el nombre completo de los empleados y la fecha de nacimiento de la siguiente manera: Miércoles, 28 de Febrero de 1996
SELECT CONCAT(Nome, ' ', Apelido1, ' ', Apelido2) AS "Nombre completo",
       DATE_FORMAT(DataNacemento, '%W, %d de %M de %Y') AS "DataNacemento"
FROM EMPREGADO;

-- 10. Muestra el nombre completo de los familiares que tienen un apellido (cuaquiera de los dos) de menos 
-- de 5 letras, ordenados por primer apellido y dentro de este por segundo apellido.
SELECT Nome || ' ' || Apelido1 || ' ' || Apelido2 AS "Nombre Completo"
FROM FAMILIAR
WHERE LENGTH(Apelido1) < 5 OR LENGTH(Apelido2) < 5
ORDER BY Apelido1, Apelido2;
