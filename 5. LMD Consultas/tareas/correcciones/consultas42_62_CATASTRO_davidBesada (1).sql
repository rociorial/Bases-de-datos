-- 42. ¿Cuál es la máxima altura que tienen los pisos que pertenecen a un propietario cuyo nombre empieza por M?

SELECT MAX(PLANTA) AS 'Máxima altura'
FROM PISO P INNER JOIN PROPIETARIO PR ON P.DNIPROPIETARIO = PR.DNI
WHERE NOMBRE LIKE 'M%'

-- Con subsconsultas

SELECT MAX(PLANTA) AS 'Máxima altura'
FROM PISO
WHERE DNIPROPIETARIO IN (SELECT DNI FROM PROPIETARIO WHERE NOMBRE LIKE 'M%') 

-- 43. Haz una consulta que devuelva el total de parques que hay en la ciudad .

SELECT 
FROM ZONAURBANA WHERE 

-- 44. Haz una consulta que nos indique cual es el tamaño del solar más grande.



-- 45. ¿Cuál es la máxima altura que tienen los pisos en la calle Damasco? (Utiliza la tabla piso).



-- 46. Indica cual es el tamaño mínimo y máximo (de metros útiles) de los pisos situados en la calle Lucas de Tena 22.



-- 47. Obtener la media de parques por zona urbana.



-- 48. Indica cuantas viviendas unifamiliares hay en la zona Palomar o Atocha.



-- 49. ¿Cuál es el tamaño medio de una vivienda unifamiliar?.



-- 50. ¿Cuántos bloques de pisos hay en la zona Centro o Cuatrovientos cuyo solar pasa de 300 metros cuadrados?.



-- 51. Haz una consulta que devuelva el número de personas distintas que poseen una vivienda unifamiliar.



-- 52. Haz una consulta que devuelva el número de hombres que poseen un trastero en las zonas Palomar y Centro.



-- 53. Haz una consulta que devuelva el número de viviendas (de cualquier tipo) que hay en cada zona urbana.



-- 54. Haz una consulta que devuelva el número de bloques de pisos que hay en cada zona urbana.



-- 55. Indica para cada bloque de pisos (calle y número) el número de pisos que hay en este y cual es el piso más alto de cada uno de estos.



-- 56. Muestra los bloques de pisos (calle y número) que tienen más de 4 pisos.



-- 57. Indica cual es el tamaño mínimo y máximo (de metros útiles) de los pisos de la zona Centro.



-- 58. Haz una consulta que muestre cuantos huecos hay de cada tipo en cada calle, teniendo en cuenta unicamente los huecos que están asociados a algún piso.



--59. ¿Cuántos bloques de pisos hay en la zona Centro o Palomar que poseen pisos de más de 3 habitaciones y que están entre 100 y 180 metros cuadrados(útiles)?



-- 60. Indica cuantas viviendas unifamiliares de una o dos plantas hay en cada calle teniendo en cuenta unicamente aquellas calles en las que el total de metros construidos es mayor de 250.



-- 61. Haz una consulta que devuelva el número de pisos de 3 o 4 habitaciones que hay en cada zona urbana, mostrando para cada zona su nombre, descripción y número de parques, ordenado por número de parques descendentemente.



-- 62. Haz una consulta que nos diga cuantos propietarios de pisos hay de cada sexo, indicando los valores Hombres o Mujeres en función del valor del campo sexo.