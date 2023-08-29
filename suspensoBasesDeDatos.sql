-- Crear la tabla cliente
CREATE TABLE Cliente (
    Cli_dni VARCHAR(20) PRIMARY KEY,
    Cli_nombre VARCHAR(100),
    Cli_apellido VARCHAR(100),
    Cli_direccion VARCHAR(200),
    Cli_eMail VARCHAR(100),
    Cli_telefono VARCHAR(20),
    Cli_fecha_nacimiento DATE
);
CREATE TABLE Producto (
    Pro_id INT PRIMARY KEY,
    Pro_nombre VARCHAR(100),
    Pro_valor DECIMAL(10, 2)
);
CREATE TABLE Sabor (
    Sab_id INT PRIMARY KEY,
    Sap_nombre VARCHAR(100),
    Sap_descipcion TEXT
);
CREATE TABLE Orden (
    Ord_id INT PRIMARY KEY,
    Ord_fecha DATE,
    Ord_subtotal DECIMAL(10, 2),
    Ord_IVA DECIMAL(10, 2),
    Ord_total DECIMAL(10, 2),
    Cli_dni VARCHAR(20),
    FOREIGN KEY (Cli_dni) REFERENCES Cliente(Cli_dni)
);
-- crear tabla orden detalle
CREATE TABLE OrdenDetalle (
    OrdDet_id INT PRIMARY KEY,
    Ord_id INT,
    Pro_id INT,
    Sab_id1 INT,
    Sab_id2 INT,
    OrdDet_cantidad INT,
    FOREIGN KEY (Ord_id) REFERENCES Orden(Ord_id),
    FOREIGN KEY (Pro_id) REFERENCES Producto(Pro_id),
    FOREIGN KEY (Sab_id1) REFERENCES Sabor(Sab_id),
    FOREIGN KEY (Sab_id2) REFERENCES Sabor(Sab_id)
);
-- insertar 3 clientes 
INSERT INTO Cliente (Cli_dni, Cli_nombre, Cli_apellido, Cli_direccion, Cli_eMail, Cli_telefono, Cli_fecha_nacimiento)
VALUES ('0605795517', 'Juan', 'Pérez', 'Calle 123', 'juan@example.com', '1234567890', '1990-01-15');

INSERT INTO Cliente (Cli_dni, Cli_nombre, Cli_apellido, Cli_direccion, Cli_eMail, Cli_telefono, Cli_fecha_nacimiento)
VALUES ('0102804655', 'María', 'Gómez', 'Avenida 456', 'maria@example.com', '9876543210', '1985-06-20');

INSERT INTO Cliente (Cli_dni, Cli_nombre, Cli_apellido, Cli_direccion, Cli_eMail, Cli_telefono, Cli_fecha_nacimiento)
VALUES ('50405795517', 'Carlos', 'López', 'Calle 789', 'carlos@example.com', '5555555555', '1995-09-10');

-- insertar 3 productos
INSERT INTO Producto (Pro_id, Pro_nombre, Pro_valor)
VALUES (1, 'Helado de Cono 1 Sabor', 3.50);

INSERT INTO Producto (Pro_id, Pro_nombre, Pro_valor)
VALUES (2, 'Helado de Cono 2 Sabores', 4.50);

INSERT INTO Producto (Pro_id, Pro_nombre, Pro_valor)
VALUES (3, 'Milkshake', 5.00);

-- para ver cuantos helados se vendieron hoy, primero agregamos una venta e dia de hoy
INSERT INTO Orden (Ord_id, Ord_fecha, Ord_subtotal, Ord_IVA, Ord_total, Cli_dni)
VALUES (2, '2023-08-28', 15.00, 1.50, 16.50, '0605795517');

INSERT INTO Sabor (Sab_id, Sap_nombre, Sap_descipcion)
VALUES (1, 'Sabor1', 'Descripción del Sabor 1');
SELECT Sab_id, Sap_nombre FROM Sabor;


INSERT INTO OrdenDetalle (OrdDet_id, Ord_id, Pro_id, Sab_id1, OrdDet_cantidad)
VALUES (1, 2, 1, 1, 2); -- Detalle de orden: Helado de Cono 1 Sabor (2 unidades)
 -- Detalle de orden: Helado de Cono 1 Sabor (2 unidades)
 -- cuantos helados se vendieron hoy
 SELECT SUM(OrdDet_cantidad) AS TotalHeladosVendidos
FROM OrdenDetalle
JOIN Producto ON OrdenDetalle.Pro_id = Producto.Pro_id
WHERE Pro_nombre LIKE 'Helado de Cono%'
  AND Ord_id IN (SELECT Ord_id FROM Orden WHERE Ord_fecha = CURDATE());
  
  -- cuantos clientes cumplen años el dia de hoy 
SELECT COUNT(*) AS ClientesCumplenHoy
FROM Cliente
WHERE DATE_FORMAT(Cli_fecha_nacimiento, '%m-%d') = DATE_FORMAT(CURDATE(), '%m-%d');

INSERT INTO Cliente (Cli_dni, Cli_nombre, Cli_apellido, Cli_direccion, Cli_eMail, Cli_telefono, Cli_fecha_nacimiento)
VALUES ('987654321', 'Lucy', 'Rodas', 'Calle 123', 'cliente@example.com', '1234567890', '1997-08-28');
-- 7)    Quiero un reporte de los clientes que cumplen años el día de hoy para ofrecerles un Milkshake de cortesía. (1 punto)
SELECT Cli_nombre, Cli_apellido
FROM Cliente
WHERE DATE_FORMAT(Cli_fecha_nacimiento, '%m-%d') = DATE_FORMAT(CURDATE(), '%m-%d');

-- visualizar el menu de la heladeria 
SELECT Pro_nombre, Pro_valor
FROM Producto;

-- aumentar 10% el precio del milshake 
UPDATE Producto
SET Pro_valor = Pro_valor * 1.10
WHERE Pro_id = 3;


-- crear la tabla de complementos 

CREATE TABLE Complemento (
    Com_id INT AUTO_INCREMENT PRIMARY KEY,
    Com_nombre VARCHAR(50) NOT NULL,
    Com_descripcion VARCHAR(255),
    Com_precio DECIMAL(10, 2) NOT NULL
);

-- aumentar el atributo complemento en el detalle de orden 
ALTER TABLE OrdenDetalle
ADD COLUMN Com_id INT,
ADD FOREIGN KEY (Com_id) REFERENCES Complemento(Com_id);

SELECT C.Cli_nombre, C.Cli_apellido, P.Pro_nombre
FROM Cliente C
JOIN Orden O ON C.Cli_dni = O.Cli_dni
JOIN OrdenDetalle OD ON O.Ord_id = OD.Ord_id
JOIN Producto P ON OD.Pro_id = P.Pro_id
JOIN Sabor S ON OD.Sab_id1 = S.Sab_id
WHERE DATE(O.Ord_fecha) = '2023-08-28' AND S.Sap_nombre = 'Mora';

DELIMITER //

CREATE PROCEDURE InsertarCliente(
    IN p_dni VARCHAR(15),
    IN p_nombre VARCHAR(50),
    IN p_apellido VARCHAR(50),
    IN p_direccion VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_telefono VARCHAR(15),
    IN p_fecha_nacimiento DATE
)
BEGIN
    INSERT INTO Cliente (Cli_dni, Cli_nombre, Cli_apellido, Cli_direccion, Cli_eMail, Cli_telefono, Cli_fecha_nacimiento)
    VALUES (p_dni, p_nombre, p_apellido, p_direccion, p_email, p_telefono, p_fecha_nacimiento);
END;

//

DELIMITER ;

CALL InsertarCliente('1234567890', 'Nuevo', 'Cliente', 'Calle 123', 'nuevo@cliente.com', '9876543210', '1995-01-01');

-- El Cliente Danilo Martínez con CC 0603010959 desea comprar 1 tulipanes de chicle con oreo, 1 cono de chocolate, 1 como de ron pasa y un Milkshake de oreo. Elaborar un procedimiento almacenado que me permita ingresar la orden (utilizar el procedimiento almacenado de la pregunta 13). (3 punto)

DELIMITER //

CREATE PROCEDURE InsertarOrdenClienteDanilo()
BEGIN
    -- Insertar datos del cliente
    CALL InsertarCliente('0603010959', 'Danilo', 'Martínez', 'Calle 456', 'danilo@example.com', '1234567890', '1990-05-15');

    -- Insertar la orden
    INSERT INTO Orden (Ord_id, Ord_fecha, Ord_subtotal, Ord_IVA, Ord_total, Cli_codigo)
    SELECT 4, CURDATE(), 0, 0, 0, Cli_id FROM Cliente WHERE Cli_dni = '0603010959';

    -- Insertar detalles de los productos
    INSERT INTO OrdenDetalle (OrdDet_id, Ord_id, Pro_id, Sab_id1, OrdDet_cantidad)
    VALUES (4, 4, 2, 2, 1); -- Tulipanes de chicle con oreo (1 unidad)
    
    INSERT INTO OrdenDetalle (OrdDet_id, Ord_id, Pro_id, Sab_id1, OrdDet_cantidad)
    VALUES (5, 4, 1, 4, 1); -- Cono de chocolate (1 unidad)
    
    INSERT INTO OrdenDetalle (OrdDet_id, Ord_id, Pro_id, Sab_id1, OrdDet_cantidad)
    VALUES (6, 4, 2, 3, 1); -- Tulipanes de ron pasa (1 unidad)
    
    INSERT INTO OrdenDetalle (OrdDet_id, Ord_id, Pro_id, OrdDet_cantidad)
    VALUES (7, 4, 3, 1); -- Milkshake de oreo (1 unidad)

    -- Actualizar subtotal, IVA y total en la orden
    UPDATE Orden
    SET Ord_subtotal = (SELECT SUM(Pro_valor) FROM Producto WHERE Pro_id IN (2, 1, 2, 3)),
        Ord_IVA = Ord_subtotal * 0.12,
        Ord_total = Ord_subtotal + Ord_IVA
    WHERE Ord_id = 4;
END;

//

DELIMITER ;

CALL InsertarOrdenClienteDanilo();

-- procedimiento para cierre de caja

DELIMITER //

CREATE PROCEDURE CierreDeCaja()
BEGIN
    -- Variables para almacenar los totales
    DECLARE total_ventas DECIMAL(10, 2);
    DECLARE total_iva DECIMAL(10, 2);
    
    -- Calcular los totales de ventas y IVA del día
    SELECT SUM(Ord_total), SUM(Ord_IVA) INTO total_ventas, total_iva
    FROM Orden
    WHERE DATE(Ord_fecha) = CURDATE();
    
    -- Insertar los totales en una tabla de cierre de caja
    INSERT INTO CierreCaja (Cie_fecha, Cie_total_ventas, Cie_total_iva)
    VALUES (CURDATE(), total_ventas, total_iva);
END;

//

DELIMITER ;

CALL CierreDeCaja();
















