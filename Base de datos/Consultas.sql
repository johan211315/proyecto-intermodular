-- ============================
-- Consultas basicas
-- ============================

-- Ver todo el listado de clientes registrados
SELECT * FROM CLIENTE;

-- Ver todas las categorías literarias que existen en la editorial
SELECT * FROM CATEGORIA;

-- Queremos ver solo el título de los libros y cuándo se publicaron
SELECT 
    Titulo, 
    Fecha_Lanzamiento 
FROM .OBRA_LITERARIA;

-- Queremos el nombre y el correo de los autores para mandarles un email
SELECT 
    Nombre, 
    Apellidos, 
    Email 
FROM AUTOR;

-- Filtrado de Datos
-- Buscar a un autor por su nacionalidad específica
SELECT Nombre, Apellidos, Nacionalidad 
FROM AUTOR 
WHERE Nacionalidad = 'Española';

-- Ver los libros que cuestan más de 20 euros
SELECT ISBN, Formato, Precio_Base 
FROM EDICION_LIBRO 
WHERE Precio_Base > 20.00;

-- Ver solo las ediciones que son en formato digital (eBook)
SELECT ISBN, Precio_Base 
FROM EDICION_LIBRO 
WHERE Formato = 'ebook';

-- Otros tipos de consultas basicas

-- Listar a los clientes en orden alfabético (De la A a la Z)
SELECT Nombre_Completo, Email 
FROM CLIENTE 
ORDER BY Nombre_Completo ASC;

-- Ver los contratos ordenados por quién cobra más regalías (De mayor a menor)
SELECT ID_Autor, ID_Obra, Porcentaje_Regalias 
FROM CONTRATO 
ORDER BY Porcentaje_Regalias DESC;

-- ¿Cuáles son las 3 ediciones más caras de nuestro catálogo?
SELECT ISBN, Formato, Precio_Base 
FROM db_articwolves.EDICION_LIBRO 
ORDER BY Precio_Base DESC 
LIMIT 3;

-- Mostrar el último pedido que ha entrado en el sistema (el más reciente)
SELECT ID_Pedido, Fecha_Pedido, Estado 
FROM db_articwolves.PEDIDO 
ORDER BY Fecha_Pedido DESC 
LIMIT 1;

-- Buscar cualquier libro que tenga la palabra "Fundación" en su título
SELECT Titulo, Fecha_Lanzamiento 
FROM db_articwolves.OBRA_LITERARIA 
WHERE Titulo LIKE '%Fundación%';

-- Buscar a todos los clientes que usan un correo de "email.com"
SELECT Nombre_Completo, Email 
FROM db_articwolves.CLIENTE 
WHERE Email LIKE '%@email.com%';


-- ============================
-- Consultas intermedias
-- ============================

-- ¿Cuántas ediciones tenemos por cada tipo de formato y cuál es el precio medio?
SELECT 
    Formato, 
    COUNT(*) AS Total_Ediciones, 
    AVG(Precio_Base) AS Precio_Medio,
    MIN(Precio_Base) AS Mas_Barato,
    MAX(Precio_Base) AS Mas_Caro
FROM EDICION_LIBRO
GROUP BY Formato;

-- ¿Qué categorías literarias son las más "Premium" (Precio medio superior a 15€)?

SELECT 
    C.Nombre_Categoria, 
    AVG(E.Precio_Base) AS Precio_Medio_Categoria
FROM db_articwolves.CATEGORIA C
INNER JOIN db_articwolves.OBRA_CATEGORIA OC ON C.ID_Categoria = OC.ID_Categoria
INNER JOIN db_articwolves.EDICION_LIBRO E ON OC.ID_Obra = E.ID_Obra
GROUP BY C.Nombre_Categoria
HAVING Precio_Medio_Categoria > 15.00
ORDER BY Precio_Medio_Categoria DESC;

-- ============================
-- JOINS
-- ============================

-- Listado de Autores, sus libros y su porcentaje de regalías.

SELECT 
    A.Nombre, 
    A.Apellidos, 
    O.Titulo, 
    C.Porcentaje_Regalias,
    C.Fecha_Firma
FROM db_articwolves.AUTOR A
INNER JOIN db_articwolves.CONTRATO C ON A.ID_Autor = C.ID_Autor
INNER JOIN db_articwolves.OBRA_LITERARIA O ON C.ID_Obra = O.ID_Obra
ORDER BY C.Porcentaje_Regalias DESC;

-- Comprobación de inventario y formatos digitales.

SELECT 
    E.ISBN, 
    O.Titulo, 
    E.Formato, 
    I.Stock_Actual, 
    I.Pasillo
FROM db_articwolves.EDICION_LIBRO E
LEFT JOIN db_articwolves.OBRA_LITERARIA O ON E.ID_Obra = O.ID_Obra
LEFT JOIN db_articwolves.INVENTARIO I ON E.ISBN = I.ISBN;

-- Comprobacion de inventario y formatos digitales (otra forma de escribir la consulta anterior)

SELECT 
    I.Stock_Actual, 
    I.Pasillo, 
    E.ISBN, 
    E.Formato
FROM db_articwolves.INVENTARIO I
RIGHT JOIN db_articwolves.EDICION_LIBRO E ON I.ISBN = E.ISBN;


-- ============================
-- VISTAS
-- ============================

CREATE OR REPLACE VIEW db_articwolves.Vista_Ventas_Finanzas AS
SELECT 
    O.Titulo,
    E.Formato,
    SUM(DP.Cantidad) AS Total_Ejemplares_Vendidos,
    SUM(DP.Cantidad * DP.Precio_Unitario) AS Ingresos_Generados
FROM db_articwolves.DETALLE_PEDIDO DP
INNER JOIN db_articwolves.EDICION_LIBRO E ON DP.ISBN = E.ISBN
INNER JOIN db_articwolves.OBRA_LITERARIA O ON E.ID_Obra = O.ID_Obra
GROUP BY O.Titulo, E.Formato;

-- Para comprobar que la vista funciona 
SELECT * FROM db_articwolves.Vista_Ventas_Finanzas ORDER BY Ingresos_Generados DESC;


-- ============================
-- INSERT, UPDATE, DELETE
-- ============================

INSERT INTO AUTOR (Nombre, Apellidos, Email, Nacionalidad) 
VALUES ('Isabel', 'Allende', 'ialende_oficial@email.com', 'Chilena');

INSERT INTO TRACKING_ESTADO (ID_Envio, Estado_Actual, Fecha_Actualizacion) 
VALUES 
(1, 'En tránsito', '2026-04-12 10:15:00'),
(2, 'Incidencia', '2026-04-12 11:30:00');

-- ============================

UPDATE EDICION_LIBRO 
SET Precio_Base = 9.95 
WHERE ISBN = '978-84-20006-01';

UPDATE EDICION_LIBRO 
SET Precio_Base = Precio_Base * 1.05 
WHERE Formato = 'ebook';


-- ============================

DELETE FROM db_articwolves.CATEGORIA 
WHERE Nombre_Categoria = 'Romance Juvenil';

DELETE FROM TRACKING_ESTADO 
WHERE ID_Envio = 1 AND Estado_Actual = 'Incidencia';


-- ============================
-- Prueba de DELTE RESTRICT
-- ============================

DELETE FROM db_articwolves.AUTOR WHERE Nombre = 'Brandon';