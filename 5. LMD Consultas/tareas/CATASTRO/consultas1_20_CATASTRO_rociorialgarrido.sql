-- 1. Nombre, descripción y observaciones de las zonas urbanas
SELECT NOMBREZONA, DESCRIPCIÓN, OBSERVACIONES
FROM ZONAURBANA;

-- 2. Nombre de la calle, número y número de plantas de las viviendas unifamiliares
SELECT CALLE, NUMERO, NUMPLANTAS
FROM CASAPARTICULAR;

-- 3. Nombre de la calle, número y metros construidos de las viviendas unifamiliares que tienen piscina
SELECT CALLE, NUMERO, METROSCONSTRUIDOS;
FROM CASAPARTICULAR
WHERE PISCINA = 'S';

-- 4. Calle, número y metros del solar de las viviendas unifamiliares.  
SELECT CALLE, NUMERO, METROSSOLAR
FROM VIVIENDA
WHERE TIPOVIVIENDA = 'Casa';

-- 5. Toda la información de los pisos que tienen 3 habitaciones
SELECT *
FROM PISO 
WHERE NUMHABITACIONES = 3;

-- 6. Obtener una relación de viviendas unifamiliares (calle, número y metros de solar) de aquellas viviendas
-- en las que los metros de solar están entre 190 y 300 metros
SELECT CALLE, NUMERO, METROSSOLAR
FROM VIVIENDA
WHERE TIPOVIVIENDA = 'Casa'
AND (METROSSOLAR > 190 AND METROSSOLAR < 300);

-- 7. Obtén una relación de bloques de pisos que tienen más de 15 vecinos (pisos) ordenados por calle y número
SELECT CALLE, NUMERO
FROM BLOQUEPISOS
WHERE NUMPISOS > 15
ORDER BY CALLE, NUMERO;

-- 8. Obtener la calle, número y metros del solar de las viviendas unifamiliares situadas en la zona centro
SELECT CALLE, NUMERO, METROSSOLAR
FROM VIVIENDA
WHERE TIPOVIVIENDA = 'Casa'
AND NOMBREZONA = 'Centro';
!!!!!!!!!!!!

-- 9. Haz una consulta que devuelva DNI, nombre y apellidos de las personas que tienen López como primer apellido 
-- ordenadas por apellidos y nombre
SELECT DNI, NOMBRE, APELLIDO1, APELLIDO2
FROM PROPIETARIO
WHERE APELLIDO1 = 'López'
ORDER BY APELLIDO1, APELLIDO2, NOMBRE;

-- 10. Obtener la calle, número y metros del solar de los bloques de pisos situados en la zona Centro o Palomar que 
-- tienen mas de 450 metros de solar.
SELECT CALLE, NUMERO, METROSSOLAR
FROM VIVIENDA
WHERE TIPOVIVIENDA = 'Bloque'
AND (NOMBREZONA = 'Zona centro') OR (NOMBREZONA = 'Palomar')
AND METROSSOLAR > 450;

-- 11. Haz una consulta que muestre los garajes que están sin vender ordenados por calle, número e id_hueco.
SELECT *
FROM HUECO
WHERE TIPO = 'GARAJE'
AND DNIPROPIETARIO IS NULL;


-- 12. Obtén el nombre y descripción de las zonas urbanas que tienen más de 1 parque ordenadas por el número de parque 
-- descendente y nombre ascendente.
SELECT NOMBREZONA, DESCRIPCIÓN
FROM ZONAURBANA
WHERE NUMPARQUES > 1
ORDER BY NOMBREZONA, NUMPARQUES DESC;

-- 13. Mostrar toda la información de las zonas urbanas que tienen algo escrito en el campo de observaciones.
SELECT *
FROM ZONAURBANA
WHERE OBSERVACIONES IS NOT NULL;

-- 14. Haz una consulta que devuelva DNI, nombre y apellidos de las personas que tienen un nombre de 3 letras, ordenado por nombre y apellidos.


-- 15. Haz una consulta que muestre calle, número, planta, puerta, metros (construidos y útiles) y la diferencia existente entre los metros 
-- construidos y los metros útiles ordenados por esta diferencia descendentemente.

-- 16. Muestra los datos de calle, número, planta, puerta y número de habitaciones de los pisos que tienen 1, 3, 5 ó 6 habitaciones.

-- 17. Muestra toda la información de los pisos que tienen 1, 3, 5 ó 6 habitaciones cuyos metros construídos superen en más de 10 a los metros 
-- útiles. Deberás mostrar también la diferencia entre los metros construídos y los metros útiles (llámale a este campo Diferencia)

-- 18. Obtén los nombres de zona y número de parques de las zonas que poseen menos de 3 parques y en los que el campo de observaciones está vacio.

-- 19. Haz un consulta que muestre los pisos de dos habitaciones que hay en una calle que empiece por la letra “L” y que tienen menos de 100 metros útiles.

-- 20. Haz una consulta que muestre los nombres de zona donde hay viviendas unifamiliares construidas ordenadas descendentemente.