--1.-Selecciona todos los empleados varones que nacieron después del año 1970 y que tengan a Sara Plaza Marín como jefa.

SELECT e.NOME + ' ' + e.APELIDO1 + ' ' + ISNULL(e.APELIDO2, ' ') AS NombreCompleto, e.DataNacemento
	FROM EMPREGADO E
		INNER JOIN EMPREGADO JEFA ON E.NSSSupervisa = JEFA.NSS
	WHERE e.SEXO = 'H'
		AND YEAR(e.DataNacemento) > 1970
		AND jefa.NOME = 'Sara' 
		AND jefa.APELIDO1 = 'Plaza' 
		AND jefa.APELIDO2 = 'Marín';

--2.-Muestra nombre, apellidos y teléfono de los empleados que son jefes ordenado primero por apellidos y luego por nombre. 
--Solo se visualiza un teléfono, cuando existan los dos, se visualiza el primero y si no tienen ninguno en blanco.

SELECT DISTINCT JEFE.NOME, JEFE.APELIDO1, JEFE.APELIDO2, COALESCE(JEFE.TELEFONO1, JEFE.TELEFONO2, ' ') AS TELEFONO
FROM EMPREGADO E
	 INNER JOIN EMPREGADO JEFE ON E.NSSSupervisa = JEFE.NSS
ORDER BY 2,3,1;

-- CON SUBCONSULTA

SELECT Nome, Apelido1, ISNULL(APELIDO2, '') AS APELIDO2, COALESCE(TELEFONO1,TELEFONO2,'') AS TELEFONO
FROM EMPREGADO
WHERE NSS IN (SELECT NSSSupervisa FROM EMPREGADO)
ORDER BY Apelido1, Apelido2, Nome

--3- Muestra nombre junto a los apellidos y la edad de los empleados que no son jefes y mayores de 30 años, ordenado primero por apellidos descendentemente y luego por nombre ascendentemente. Hazlo de varias maneras.              

-- CORRECCION PEPA
	
SELECT DISTINCT E.Nome, E.Apelido1, E.Apelido2,
	FLOOR(DATEDIFF(DD,E.DATANACEMENTO,GETDATE())/365.25) AS EDAD
FROM EMPREGADO E 
	 LEFT JOIN EMPREGADO SUPERVISA ON E.NSS = SUPERVISA.NSSSupervisa
WHERE SUPERVISA.NSS IS NULL 
	 AND DATEDIFF(DD,E.DATANACEMENTO,GETDATE())/365.25>30
	 
-- CON SUBCONSULTAS
 SELECT NOME, APELIDO1, APELIDO2,
	FLOOR(DATEDIFF(DD,DATANACEMENTO,GETDATE())/365.25) AS EDAD
 FROM EMPREGADO
 WHERE DATEDIFF(DD,DATANACEMENTO,GETDATE())/365.25>30 AND
	NSS NOT IN (SELECT DISTINCT NSSSupervisa 
				FROM EMPREGADO
				WHERE NSSSupervisa IS NOT NULL)
 ORDER BY 2,3,1 DESC

--4.- Para los empleados que se conoce solo un teléfono, visualizar el nombre completo, el teléfono que tenemos,  junto al nombre completo de su jefe. Para los que no tienen jefe se visualizará el texto "Sin Jefe".

SELECT E.Nome + ' ' +E.Apelido1+ ' '+ISNULL(E.APELIDO2,'') EMPLEADO,
COALESCE(E.TELEFONO1,E.TELEFONO2) AS TELEFONO,
ISNULL(JEFE.NOME+' '+JEFE.Apelido1+' '+ISNULL(JEFE.APELIDO2,''),'SIN JEFE') SUPERVISOR
FROM EMPREGADO E LEFT JOIN EMPREGADO JEFE ON E.NSSSUPERVISA=JEFE.NSS
WHERE (E.telefono1 IS NOT NULL AND E.telefono2 IS NULL OR E.telefono1 IS NULL AND E.telefono2 IS NOT NULL)
ORDER BY JEFE.Nome ASC


-- SUBCONSULTAS

SELECT E.Nome + ' ' +E.Apelido1+ ' '+ISNULL(E.APELIDO2,'') EMPLEADO,
COALESCE(E.TELEFONO1,E.TELEFONO2) AS TELEFONO,
ISNULL((SELECT JEFE.NOME+' '+JEFE.Apelido1+' '+ISNULL(JEFE.APELIDO2,'')
	FROM EMPREGADO JEFE
	WHERE JEFE.NSS=E.NSSSUPERVISA),'SIN JEFE')AS NOMBREJEFE
FROM EMPREGADO E
WHERE (E.telefono1 IS NOT NULL AND E.telefono2 IS NULL OR E.telefono1 IS NULL AND E.telefono2 IS NOT NULL)
ORDER BY NOMBREJEFE ASC

--5.-Visualizar el nombre y apellidos de los empleados jefes que no dirigen ningún departamento.

SELECT e.NOME, e.APELIDO1, e.NOME + ' ' + e.APELIDO1 + ' ' + ISNULL(e.APELIDO2, ' ') AS NombreCompleto
	FROM EMPREGADO e

	WHERE e.NSS IN 
		(SELECT DISTINCT NSSSupervisa 
			FROM EMPREGADO 
			WHERE NSSSupervisa IS NOT NULL)
		AND e.NSS NOT IN 
			(SELECT NSSDirector 
				FROM DEPARTAMENTO);
				
-- CORRECCION PEPA

SELECT DISTINCT JEFE.NSS,JEFE.Nome,JEFE.Apelido1,JEFE.Apelido2
FROM EMPREGADO JEFE
	 INNER JOIN EMPREGADO E ON JEFE.NSS=E.NSSSupervisa
	 LEFT JOIN DEPARTAMENTO D ON JEFE.NSS=D.NSSDirector
WHERE D.NSSDirector IS NULL

--6.- Muestra el nombre de los empleados que viven en una localidad en la que existe una sede del departamento al que pertenecen.

SELECT e.NOME + ' ' + e.APELIDO1 + ' ' + ISNULL(e.APELIDO2, ' ') AS NombreCompleto, Localidade
	FROM EMPREGADO e
	INNER JOIN LUGAR L ON e.NumDepartamentoPertenece = L.Num_departamento
	WHERE e.Localidade = L.Lugar
	ORDER BY LOCALIDADE
	
-- SUBCONSULTA

SELECT NOME + ' ' + APELIDO1 + ' ' + ISNULL(APELIDO2, ' ') AS NombreCompleto, Localidade
FROM EMPREGADO E
WHERE LOCALIDADE IN (SELECT LUGAR FROM LUGAR L WHERE E.NumDepartamentoPertenece=L.Num_departamento)
ORDER BY Localidade

-- O

SELECT NOME + ' ' + APELIDO1 + ' ' + ISNULL(APELIDO2, ' ') AS NombreCompleto, Localidade
FROM EMPREGADO E
WHERE EXISTS (SELECT LUGAR FROM LUGAR L WHERE E.NumDepartamentoPertenece=L.NUM_DEPARTAMENTO AND LUGAR = Localidade)

--7.- La cree una consulta que muestre para todos los empleados su nombre completo, calle, número, piso, localidad y nombre de departamento. 
--La información debe estar ordenada por localidad en el caso de tratarse de mujeres y por nombre de departamento en el caso de tratarse de hombres.

SELECT 
    e.NOME + ' ' + e.APELIDO1 + ' ' + ISNULL(e.APELIDO2, ' ') AS NombreCompleto,
    e.Rua + ', ' + CAST(e.Numero_Calle AS VARCHAR) + ', ' + 
    e.Piso,
    e.Localidade,
    d.NomeDepartamento
	FROM EMPREGADO e
		INNER JOIN DEPARTAMENTO d ON e.NumDepartamentoPertenece = d.NumDepartamento
	ORDER BY 
		CASE 
			WHEN e.SEXO = 'M' THEN e.Localidade
		END ASC,
		CASE 
			WHEN e.SEXO = 'H' THEN d.NomeDepartamento
		END ASC
		
-- SUBCONSULTAS

SELECT NOME + ' ' + APELIDO1 + ' ' + ISNULL(APELIDO2, ' ') AS NombreCompleto, RUA, NUMERO_CALLE, PISO, LOCALIDADE, 
	   (SELECT NomeDepartamento FROM DEPARTAMENTO WHERE NumDepartamentoPertenece = NumDepartamento) AS NomeDepartamento
FROM EMPREGADO
ORDER BY
	CASE WHEN Sexo = 'M' THEN Localidade END,
	CASE WHEN Sexo = 'H' THEN (SELECT NOMEDEPARTAMENTO FROM DEPARTAMENTO
								WHERE NumDepartamentoPertenece = NumDepartamento)
	END
