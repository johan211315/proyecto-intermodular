-- ====================================================================
-- SCRIPT DE CREACIÓN DE BASE DE DATOS\
-- ====================================================================
CREATE DATABASE IF NOT EXISTS db_articwolves;
USE db_articwolves;


CREATE TABLE AUTOR (
    ID_Autor INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Apellidos VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Nacionalidad VARCHAR(50)
);

CREATE TABLE OBRA_LITERARIA (
    ID_Obra INT AUTO_INCREMENT PRIMARY KEY,
    Titulo VARCHAR(150) NOT NULL,
    Sinopsis TEXT,
    Fecha_Lanzamiento DATE
);

CREATE TABLE CATEGORIA (
    ID_Categoria INT AUTO_INCREMENT PRIMARY KEY,
    Nombre_Categoria VARCHAR(50) NOT NULL UNIQUE
);


CREATE TABLE CONTRATO (
    ID_Contrato INT AUTO_INCREMENT PRIMARY KEY,
    ID_Autor INT NOT NULL,
    ID_Obra INT NOT NULL,
    Porcentaje_Regalias DECIMAL(5,2) NOT NULL,
    Fecha_Firma DATE NOT NULL,
    Exclusividad BOOLEAN DEFAULT TRUE,
    constraint fk_contrato_autor
        FOREIGN KEY (ID_Autor) REFERENCES AUTOR(ID_Autor) ON UPDATE CASCADE ON DELETE RESTRICT,
    constraint fk_contrato_obra
        FOREIGN KEY (ID_Obra) REFERENCES OBRA_LITERARIA(ID_Obra) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE OBRA_CATEGORIA (
    ID_Obra INT,
    ID_Categoria INT,
    PRIMARY KEY (ID_Obra, ID_Categoria),
    CONSTRAINT fk_obra_obra_categoria
        FOREIGN KEY (ID_Obra) REFERENCES OBRA_LITERARIA(ID_Obra) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_categoria_obra_categoria
        FOREIGN KEY (ID_Categoria) REFERENCES CATEGORIA(ID_Categoria) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE EDICION_LIBRO (
    ISBN VARCHAR(20) PRIMARY KEY,
    ID_Obra INT NOT NULL,
    Formato ENUM('tapa_dura','tapa_blanda','ebook') NOT NULL,
    Precio_Base DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_edicion_obra
        FOREIGN KEY (ID_Obra) REFERENCES OBRA_LITERARIA(ID_Obra) ON UPDATE CASCADE ON DELETE RESTRICT
);



CREATE TABLE CLIENTE (
    ID_Cliente INT AUTO_INCREMENT PRIMARY KEY,
    Nombre_Completo VARCHAR(150) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Direccion VARCHAR(200)
);

CREATE TABLE ALMACEN_FISICO (
    ID_Almacen INT AUTO_INCREMENT PRIMARY KEY,
    Nombre_Instalacion VARCHAR(100) NOT NULL,
    Direccion VARCHAR(200) NOT NULL
);


CREATE TABLE PEDIDO (
    ID_Pedido INT AUTO_INCREMENT PRIMARY KEY,
    ID_Cliente INT NOT NULL,
    Fecha_Pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    Estado VARCHAR(30) DEFAULT 'Procesando',
    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (ID_Cliente) REFERENCES CLIENTE(ID_Cliente) ON DELETE RESTRICT
);

CREATE TABLE DETALLE_PEDIDO (
    ID_Detalle INT AUTO_INCREMENT PRIMARY KEY,
    ID_Pedido INT NOT NULL,
    ISBN VARCHAR(20) NOT NULL,
    Cantidad INT NOT NULL DEFAULT 1,
    Precio_Unitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_detalle_pedido_pedido
        FOREIGN KEY (ID_Pedido) REFERENCES PEDIDO(ID_Pedido) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_detalle_pedido_edicion
        FOREIGN KEY (ISBN) REFERENCES EDICION_LIBRO(ISBN) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE FACTURA (
    ID_Factura INT AUTO_INCREMENT PRIMARY KEY,
    ID_Pedido INT NOT NULL UNIQUE, -- (Relación 1:1)
    Fecha_Emision DATETIME DEFAULT CURRENT_TIMESTAMP,
    Total_Factura DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_factura_pedido
        FOREIGN KEY (ID_Pedido) REFERENCES PEDIDO(ID_Pedido) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE PAGO (
    ID_Pago INT AUTO_INCREMENT PRIMARY KEY,
    ID_Factura INT NOT NULL,
    Metodo_Pago VARCHAR(50) NOT NULL,
    Estado_Transaccion VARCHAR(30) NOT NULL,
    FOREIGN KEY (ID_Factura) REFERENCES FACTURA(ID_Factura) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE ENVIO (
    ID_Envio INT AUTO_INCREMENT PRIMARY KEY,
    ID_Pedido INT NOT NULL UNIQUE, -- (Relación 1:1)
    Empresa_Transporte VARCHAR(50),
    Num_Seguimiento VARCHAR(100),
    CONSTRAINT fk_envio_pedido
        FOREIGN KEY (ID_Pedido) REFERENCES PEDIDO(ID_Pedido) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE TRACKING_ESTADO (
    ID_Tracking INT AUTO_INCREMENT PRIMARY KEY,
    ID_Envio INT NOT NULL,
    Estado_Actual VARCHAR(50) NOT NULL,
    Fecha_Actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_tracking_envio
        FOREIGN KEY (ID_Envio) REFERENCES ENVIO(ID_Envio) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE INVENTARIO (
    ID_Inventario INT AUTO_INCREMENT PRIMARY KEY,
    ISBN VARCHAR(20) NOT NULL,
    ID_Almacen INT NOT NULL,
    Stock_Actual INT NOT NULL DEFAULT 0,
    Pasillo VARCHAR(10),
    Estanteria VARCHAR(10),
    CONSTRAINT fk_inventario_edicion
        FOREIGN KEY (ISBN) REFERENCES EDICION_LIBRO(ISBN) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_inventario_almacen
        FOREIGN KEY (ID_Almacen) REFERENCES ALMACEN_FISICO(ID_Almacen) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ---------------------------------------------------------
--  INSERCIÓN DE DATOS
-- ---------------------------------------------------------


INSERT INTO AUTOR (Nombre, Apellidos, Email, Nacionalidad) VALUES
('Brandon', 'Sanderson', 'brandon.s@gmail.com', 'Estadounidense'),
('Laura', 'Gallego', 'laura.g@gmail.com', 'Española'),
('Stephen', 'King', 'sking@gmail.com', 'Estadounidense'),
('Joanne', 'Rowling', 'jk.rowling@outlook.com', 'Británica'),
('Isaac', 'Asimov', 'iasimov@outlook.com', 'Estadounidense'),
('Agatha', 'Christie', 'achristie@outlook.com', 'Británica'),
('George', 'R.R. Martin', 'grrmartin@yahoo.com', 'Estadounidense');

INSERT INTO OBRA_LITERARIA (Titulo, Sinopsis, Fecha_Lanzamiento) VALUES
('El Imperio de los Lobos', 'Una épica historia de supervivencia en las tundras del norte.', '2024-05-15'),
('Ecos del Sótano', 'Un thriller psicológico ambientado en misteriosas oficinas.', '2023-10-31'),
('La Rosa de Hielo', 'Romance y fantasía se entrelazan cuando la magia del invierno amenaza.', '2025-01-20'),
('El Guardián de la Magia', 'Un joven descubre que tiene poderes ocultos.', '1997-06-26'),
('La Cámara Oculta', 'Un monstruo aterroriza los pasillos del castillo mágico.', '1998-07-02'),
('Fundación: El Origen', 'Un matemático predice la caída del imperio galáctico.', '1951-05-01'),
('Fundación y el Imperio', 'La colonia se enfrenta a la fuerza militar del imperio.', '1952-01-01'),
('Segunda Fundación', 'El misterio de la colonia oculta se desvela.', '1953-01-01'),
('Asesinato en el Tren Nocturno', 'Un detective debe resolver un crimen imposible en la nieve.', '1934-01-01'),
('Diez Sombras', 'Diez extraños comienzan a desaparecer en una isla.', '1939-11-06'),
('El Trono de las Espadas', 'Casas nobles luchan por el control de un continente.', '1996-08-01'),
('Choque de Reyes y Coronas', 'La guerra civil estalla y reclaman el trono.', '1998-11-16'),
('Tormenta de Fuego y Hielo', 'Alianzas se rompen y la sangre tiñe los castillos.', '2000-08-08');

INSERT INTO CATEGORIA (Nombre_Categoria) VALUES
('Fantasía Épica'),
('Terror'),
('Ciencia Ficción'),
('Romance Juvenil'),
('Misterio y Suspense');

INSERT INTO CLIENTE (Nombre_Completo, Email, Direccion) VALUES
('Juan Pérez Gómez', 'juan.perez@email.com', 'Calle Gran Vía 12, 3B, Madrid, España'),
('Librerías Central S.L.', 'compras@libreriascentral.es', 'Av. de la Lectura 45, Nave 3, Barcelona, España'),
('Maria Silva', 'msilva_99@email.com', 'Rua Nova 8, Lisboa, Portugal'),
('Pedro Martínez', 'pedro@gmail.com', 'avenida del corredor 9, Barcelona, España'),
('Lucía Fernández', 'lucia.fernandez@email.com', 'Calle Mayor 5, Sevilla, España');

INSERT INTO ALMACEN_FISICO (Nombre_Instalacion, Direccion) VALUES
('Almacen Principal', 'Poligono Industrial Las Letras, Nave 101'),
('Almacén Secundario', 'Polígono Industrial Las Letras, Nave 102');
-- ---------------------------------------------------------
-- MAS INSERCIONES DE DATOS 
-- ---------------------------------------------------------
INSERT INTO CONTRATO (ID_Autor, ID_Obra, Porcentaje_Regalias, Fecha_Firma, Exclusividad) VALUES
(1, 1, 12.50, '2023-01-10', TRUE),
(3, 2, 15.00, '2022-05-20', TRUE),
(2, 3, 10.00, '2024-02-15', FALSE),
(4, 4, 15.00, '1996-05-10', TRUE),
(4, 5, 15.00, '1997-08-12', TRUE),
(5, 6, 8.50, '1950-02-01', FALSE),
(5, 7, 8.50, '1951-03-15', FALSE),
(5, 8, 8.50, '1952-06-20', FALSE),
(6, 9, 12.00, '1933-05-10', TRUE),
(6, 10, 12.00, '1938-10-12', TRUE),
(7, 11, 14.00, '1995-01-20', TRUE),
(7, 12, 14.00, '1997-04-10', TRUE),
(7, 13, 14.00, '1999-07-05', TRUE);

INSERT INTO OBRA_CATEGORIA (ID_Obra, ID_Categoria) VALUES
(1, 1), (2, 2), (3, 1), (3, 4), 
(4, 1), (5, 1), 
(6, 3), (7, 3), (8, 3), 
(9, 5), (10, 5), 
(11, 1), (12, 1), (13, 1);

INSERT INTO EDICION_LIBRO (ISBN, ID_Obra, Formato, Precio_Base) VALUES
('978-84-10001-01', 1, 'tapa_dura', 24.95),
('978-84-10001-02', 1, 'ebook', 9.99),
('978-84-10002-01', 2, 'tapa_blanda', 18.50),
('978-84-10003-01', 3, 'tapa_dura', 22.90),
('978-84-10003-02', 3, 'ebook', 8.50),
('978-84-20004-01', 4, 'tapa_dura', 19.90),
('978-84-20005-01', 5, 'tapa_blanda', 14.50),
('978-84-20006-01', 6, 'tapa_blanda', 12.95),
('978-84-20007-01', 7, 'tapa_blanda', 12.95),
('978-84-20008-01', 8, 'tapa_blanda', 12.95),
('978-84-20009-01', 9, 'tapa_dura', 18.00),
('978-84-20010-01', 10, 'tapa_dura', 18.00),
('978-84-20011-01', 11, 'tapa_dura', 28.50),
('978-84-20011-02', 11, 'ebook', 10.99),
('978-84-20012-01', 12, 'tapa_dura', 28.50),
('978-84-20013-01', 13, 'tapa_dura', 28.50);

INSERT INTO PEDIDO (ID_Cliente, Fecha_Pedido, Estado) VALUES
(1, '2026-04-10 10:30:00', 'Enviado'),
(2, '2026-04-11 09:15:00', 'Procesando'), 
(3, '2026-04-11 11:45:00', 'Pendiente de Pago');

INSERT INTO DETALLE_PEDIDO (ID_Pedido, ISBN, Cantidad, Precio_Unitario) VALUES
(1, '978-84-10001-01', 1, 24.95),
(1, '978-84-10003-02', 1, 8.50),
(2, '978-84-10001-01', 50, 18.00), 
(2, '978-84-10002-01', 30, 14.00);

INSERT INTO FACTURA (ID_Pedido, Fecha_Emision, Total_Factura) VALUES
(1, '2026-04-10 10:35:00', 33.45),   
(2, '2026-04-11 10:00:00', 1320.00); 

INSERT INTO PAGO (ID_Factura, Metodo_Pago, Estado_Transaccion) VALUES
(1, 'Tarjeta de Crédito', 'Completado'),
(2, 'Transferencia Bancaria', 'Pendiente');

INSERT INTO ENVIO (ID_Pedido, Empresa_Transporte, Num_Seguimiento) VALUES
(1, 'SEUR', 'SEUR-AW-987654321'),
(2, 'Logística Industrial', 'LOG-AW-11223344');

INSERT INTO TRACKING_ESTADO (ID_Envio, Estado_Actual, Fecha_Actualizacion) VALUES
(1, 'Recogido en Sede', '2026-04-10 18:00:00'),
(1, 'En Reparto', '2026-04-11 08:30:00'),
(2, 'Preparando Palés', '2026-04-11 11:00:00');

INSERT INTO INVENTARIO (ISBN, ID_Almacen, Stock_Actual, Pasillo, Estanteria) VALUES
('978-84-10001-01', 1, 150, 'A1', 'E-03'),
('978-84-10002-01', 1, 85, 'A2', 'E-01'),
('978-84-10003-01', 2, 400, 'C4', 'E-12'),
('978-84-20004-01', 1, 300, 'B1', 'E-05'),
('978-84-20005-01', 1, 250, 'B1', 'E-06'),
('978-84-20006-01', 2, 500, 'A4', 'E-10'),
('978-84-20007-01', 2, 480, 'A4', 'E-11'),
('978-84-20008-01', 2, 490, 'A4', 'E-12'),
('978-84-20009-01', 1, 120, 'C2', 'E-01'),
('978-84-20010-01', 1, 115, 'C2', 'E-02'),
('978-84-20011-01', 2, 800, 'D1', 'E-01'),
('978-84-20012-01', 2, 750, 'D1', 'E-02'),
('978-84-20013-01', 2, 700, 'D1', 'E-03');

-- ====================================================================
-- FIN DEL SCRIPT
-- ====================================================================