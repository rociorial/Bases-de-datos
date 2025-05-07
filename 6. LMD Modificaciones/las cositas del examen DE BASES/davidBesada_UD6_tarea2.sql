
-- 1. Registrar 3 horas extra trabajadas ayer por Eligio Rodrigo y Xiao Vecino Vecino

DECLARE @nss_eligio INT = (
    SELECT NSS 
    FROM EMPREGADO 
    WHERE Nome = 'Eligio' AND Apelido1 = 'Rodrigo'
);

DECLARE @nss_xiao INT = (
    SELECT NSS 
    FROM EMPREGADO 
    WHERE Nome = 'Xiao' AND Apelido1 = 'Vecino' AND Apelido2 = 'Vecino'
);

INSERT INTO HORASEXTRAS (Data, NSS, HorasExtras)
VALUES 
    (DATEADD(DAY, -1, GETDATE()), @nss_eligio, 3),
    (DATEADD(DAY, -1, GETDATE()), @nss_xiao, 3);

-- 2. Crear curso "Dese�o Web" con primera edici�n en Pontevedra, impartido por el jefe t�cnico

INSERT INTO CURSO (Nome, Horas)
VALUES ('Dese�o Web', 30);

INSERT INTO EDICION (Codigo, Numero, Data, Lugar, Profesor)
VALUES ((SELECT CODIGO FROM CURSO WHERE Nome = 'Dese�o Web'), 1, '2025-04-15', 'Pontevedra',
   (SELECT DISTINCT NSSDirector
    FROM DEPARTAMENTO D
    WHERE NomeDepartamento = 'T�cnico'))

-- 3. Inscribir empleados del departamento T�cnico (excepto su jefe)

INSERT INTO EDICIONCURSO_EMPREGADO
SELECT (select codigo from CURSO where Nome = 'Dese�o Web'), 1, NSS
FROM EMPREGADO INNER JOIN DEPARTAMENTO ON NumDepartamentoPertenece=NumDepartamento
WHERE NomeDepartamento='T�cnico' AND NSS != NSSDirector;

SELECT * FROM EDICIONCURSO_EMPREGADO

-- 4. Incrementar salario un 2% a empleados del departamento de Contabilidade

UPDATE EF
SET EF.Salario = EF.Salario * 1.02
FROM EMPREGADOFIXO EF
WHERE NSS = (select NSS 
			 from EMPREGADO 
			 where NumDepartamentoPertenece = 
				(select NumDepartamento 
				 from DEPARTAMENTO 
				 where NomeDepartamento = 'Contabilidad'));

select NSS from EMPREGADO where NumDepartamentoPertenece = (select NumDepartamento from DEPARTAMENTO where NomeDepartamento = 'Contabilidad') 

-- 5. Corregir asignaci�n de proyecto para empleada con NSS = 9900000

UPDATE EMPREGADO_PROXECTO
SET NumProxecto=(SELECT NumProxecto
				 FROM PROXECTO
				 WHERE NomeProxecto = 'Xestion da calidade')
WHERE NSSEmpregado='9900000' AND NumProxecto = (SELECT NumProxecto
												FROM PROXECTO
												WHERE NomeProxecto = 'Portal');

-- 6. Crear proyecto "Dese�o nova WEB" y registrar tareas

INSERT INTO PROXECTO (NumProxecto, NomeProxecto, Lugar, NumDepartControla)
VALUES (
    (select MAX(numProxecto)+1 from PROXECTO),
    'Dese�o nova WEB',
    'Vigo',
    (SELECT NumDepartamento FROM DEPARTAMENTO WHERE NomeDepartamento = 'T�cnico')
);

INSERT INTO TAREFA (NumProxecto, numero, descripcion, data_inicio, data_fin, dificultade, estado)
VALUES 
((SELECT NUMPROXECTO FROM PROXECTO WHERE NomeProxecto = 'DESE�O NOVA WEB'),1, 'Definir o obxectivo da p�xina', DATEADD(DAY, 15, GETDATE()), DATEADD(DAY, 22, GETDATE()), 'Media', 'Pendiente'),
((SELECT NUMPROXECTO FROM PROXECTO WHERE NomeProxecto = 'DESE�O NOVA WEB'),(SELECT MAX(NUMERO)+1 FROM TAREFA), 'Elexir o estilo e crear o mapa do sitio', DATEADD(DAY, 20, GETDATE()), DATEADD(DAY, 27, GETDATE()), 'Media', 'Pendiente');

select * from TAREFA
-- 7. Asignar horas al proyecto

-- Jefe del departamento t�cnico - 8 horas
INSERT INTO EMPREGADO_PROXECTO (NSSEmpregado, NumProxecto, Horas)
VALUES (
    (SELECT NSSDirector FROM DEPARTAMENTO WHERE NomeDepartamento='T�cnico'),
    (SELECT NUMPROXECTO FROM PROXECTO WHERE NomeProxecto='Dese�o nova web'), 8);
    
-- Felix Barreiro Vali�a - 5 horas
INSERT INTO EMPREGADO_PROXECTO (NSSEmpregado, NumProxecto, Horas)
VALUES (
    (SELECT NSS FROM EMPREGADO WHERE Nome = 'Felix' AND Apelido1 = 'Barreiro' AND Apelido2 = 'Vali�a'),
    (SELECT NUMPROXECTO FROM PROXECTO WHERE NomeProxecto='Dese�o nova web'), 5);

