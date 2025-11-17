USE u2_ejercicio1;

-- 1. Consulte la cantidad de clientes. ¿Cuál es el valor obtenido? 
SELECT count(*) FROM cliente;
-- 2. Consulte la cantidad de productos. ¿Cuál es el valor obtenido? 
SELECT count(*) FROM producto;
-- 3. Consulte la cantidad de proveedores. ¿Cuál es el valor obtenido? 
SELECT count(*) FROM proveedor;

-- 4. Liste el apellido y nombre de los clientes que nacieron en el año 1964. ¿Cuántos registros obtiene? 
SELECT Apellido, Nombre
FROM cliente
WHERE year(Fecha_Nacimiento) = 1964;

-- 5. Liste el nombre de los proveedores que comienzan con la letra “A” ordenados alfabéticamente de forma 
-- descendente. ¿Cuántos registros obtiene?
SELECT Nombre
FROM proveedor
WHERE trim(Nombre) LIKE "A%"
ORDER BY Nombre DESC; # 8 resultados

-- 6. Liste el nombre y precio de los productos cuyo precio es mayor a 1500$. Ordénelos por precio de menor a 
-- mayor. ¿Cuántos registros obtiene? 
SELECT Nombre, Precio_venta
FROM producto
WHERE Precio_venta > 1500
ORDER BY Precio_venta; # 35 resultados

-- 7. Liste el código y nombre de todos los productos cuyo precio es menor a 1000$   o mayor a 1900$ 
-- ordenados por su nombre. ¿Cuántos registros obtiene? 
SELECT CodigoProducto, Nombre
FROM producto
WHERE Precio_venta < 1000 OR Precio_venta > 1900
ORDER BY Nombre;

-- 8. Listar nombre del proveedor, nombre del producto, precio del producto y costo indicado por el proveedor, 
-- para aquellos productos que ya tienen un proveedor asociado.
SELECT proveedor.Nombre, producto.Nombre, producto.Precio_venta, producto_proveedor.Costo
FROM producto
INNER JOIN producto_proveedor
	ON producto.CodigoProducto = producto_proveedor.CodigoProducto
INNER JOIN proveedor
	ON proveedor.CUIT = producto_proveedor.CUIT;

-- 9. Liste el nombre y precio de venta de los productos que no han sido comprados por ningún cliente.
SELECT producto.Nombre, producto.Precio_venta
FROM producto
LEFT JOIN cliente_compra_producto CCP
	ON CCP.CodigoProducto = producto.CodigoProducto
    WHERE CCP.CodigoProducto is NULL;

-- 10. Liste el nombre del producto, nombre del proveedor y precio de venta, de aquellos productos que tienen 
-- mas de un proveedor asociado. 
SELECT PROD.Nombre, prov.Nombre, PROD.Precio_venta
FROM producto PROD
INNER JOIN producto_proveedor PP
	ON PP.CodigoProducto = PROD.CodigoProducto
INNER JOIN proveedor prov
	ON prov.CUIT = PP.CUIT
WHERE PROD.CodigoProducto in
	(SELECT P1.CodigoProducto
    FROM producto_proveedor P1
    WHERE P1.CUIT <> PP.CUIT); # <> significa "Distinto de"

-- 11. Agregue un nuevo producto, con las siguientes características: 
#	Codigo Producto 
#	101
#	Nombre 
#	Telefono Celular SAMSUNG S25 
#	Precio Venta 
#	2389000 
INSERT INTO `producto` (`CodigoProducto`, `Nombre`, `Precio_venta`)
VALUES ('101', 'Telefono Celular SAMSUNG S25', '2389000');

SELECT *
FROM PROVEEDOR
WHERE PROVEEDOR.CUIT LIKE "20172019731";


-- 12. Agregue en la tabla Producto_proveedor que el teléfono cargado en el item anterior es provisto por el 
-- proveedor cuyo nombre es Megatone y el costo es igual al 60% del precio de venta.
INSERT INTO producto_proveedor 
SELECT  PROD.CodigoProducto, Prove.CUIT, 1, PROD.Precio_Venta * 0.60
FROM PRODUCTO PROD, PROVEEDOR PROVE
WHERE PROD.CodigoProducto = 101 AND
      PROVE.CUIT LIKE "20172019731";

# query para comprobar si se agrego
SELECT * 
FROM producto_proveedor PP
where PP.CodigoProducto = 101;

-- 13. Insertar en la tabla Cliente_Compra_Producto los registros que respondan a que todos los clientes nacidos 
-- a partir del año 1989 han comprado solo una unidad del celular Samsung agregado en el punto 11.
INSERT INTO cliente_compra_producto
SELECT CLI.DNI, PROD.CodigoProducto, 1
FROM cliente CLI, producto PROD
WHERE year(CLI.Fecha_nacimiento) >= 1989 AND PROD.CodigoProducto = 101;

# TRAER LOS PRODUCTOS QUE TENGAN UNA CANTIDAD ENTRE 5 Y 20
SELECT *
FROM cliente_compra_producto CCP
WHERE CCP.Cantidad >= 5 AND CCP.Cantidad <= 20;


