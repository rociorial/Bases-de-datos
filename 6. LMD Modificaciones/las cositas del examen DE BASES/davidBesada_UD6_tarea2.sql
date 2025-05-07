
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

-- 2. Crear curso "Deseño Web" con primera edición en Pontevedra, impartido por el jefe técnico

INSERT INTO CURSO (Nome, Horas)
VALUES ('Deseño Web', 30);

INSERT INTO EDICION (Codigo, Numero, Data, Lugar, Profesor)
VALUES ((SELECT CODIGO FROM CURSO WHERE Nome = 'Deseño Web'), 1, '2025-04-15', 'Pontevedra',
   (SELECT DISTINCT NSSDirector
    FROM DEPARTAMENTO D
    WHERE NomeDepartamento = 'Técnico'))

-- 3. Inscribir empleados del departamento Técnico (excepto su jefe)

INSERT INTO EDICIONCURSO_EMPREGADO
SELECT (select codigo from CURSO where Nome = 'Deseño Web'), 1, NSS
FROM EMPREGADO INNER JOIN DEPARTAMENTO ON NumDepartamentoPertenece=NumDepartamento
WHERE NomeDepartamento='Técnico' AND NSS != NSSDirector;

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

-- 5. Corregir asignación de proyecto para empleada con NSS = 9900000

UPDATE EMPREGADO_PROXECTO
SET NumProxecto=(SELECT NumProxecto
				 FROM PROXECTO
				 WHERE NomeProxecto = 'Xestion da calidade')
WHERE NSSEmpregado='9900000' AND NumProxecto = (SELECT NumProxecto
												FROM PROXECTO
												WHERE NomeProxecto = 'Portal');

-- 6. Crear proyecto "Deseño nova WEB" y registrar tareas

INSERT INTO PROXECTO (NumProxecto, NomeProxecto, Lugar, NumDepartControla)
VALUES (
    (select MAX(numProxecto)+1 from PROXECTO),
    'Deseño nova WEB',
    'Vigo',
    (SELECT NumDepartamento FROM DEPARTAMENTO WHERE NomeDepartamento = 'Técnico')
);

INSERT INTO TAREFA (NumProxecto, numero, descripcion, data_inicio, data_fin, dificultade, estado)
VALUES 
((SELECT NUMPROXECTO FROM PROXECTO WHERE NomeProxecto = 'DESEÑO NOVA WEB'),1, 'Definir o obxectivo da páxina', DATEADD(DAY, 15, GETDATE()), DATEADD(DAY, 22, GETDATE()), 'Media', 'Pendiente'),
((SELECT NUMPROXECTO FROM PROXECTO WHERE NomeProxecto = 'DESEÑO NOVA WEB'),(SELECT MAX(NUMERO)+1 FROM TAREFA), 'Elexir o estilo e crear o mapa do sitio', DATEADD(DAY, 20, GETDATE()), DATEADD(DAY, 27, GETDATE()), 'Media', 'Pendiente');

select * from TAREFA
-- 7. Asignar horas al proyecto

-- Jefe del departamento técnico - 8 horas
INSERT INTO EMPREGADO_PROXECTO (NSSEmpregado, NumProxecto, Horas)
VALUES (
    (SELECT NSSDirector FROM DEPARTAMENTO WHERE NomeDepartamento='Técnico'),
    (SELECT NUMPROXECTO FROM PROXECTO WHERE NomeProxecto='Deseño nova web'), 8);
    
-- Felix Barreiro Valiña - 5 horas
INSERT INTO EMPREGADO_PROXECTO (NSSEmpregado, NumProxecto, Horas)
VALUES (
    (SELECT NSS FROM EMPREGADO WHERE Nome = 'Felix' AND Apelido1 = 'Barreiro' AND Apelido2 = 'Valiña'),
    (SELECT NUMPROXECTO FROM PROXECTO WHERE NomeProxecto='Deseño nova web'), 5);

