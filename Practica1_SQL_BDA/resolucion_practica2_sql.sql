/* 1. Listar el nombre y precio de aquellos productos que aún no han sido comprados por ningún cliente. */
SELECT Nombre, Precio_venta
FROM producto PROD
LEFT JOIN cliente_compra_producto CPP
	ON CPP.CodigoProducto = PROD.CodigoProducto
    WHERE CPP.DNI is NULL;
    
-- otra manera de resolverlo, mas simple de entender, busca los productos que no esten en la tabla cliente_compra_producto
SELECT distinct PROD.Nombre, PROD.Precio_venta
FROM producto PROD
WHERE PROD.CodigoProducto NOT IN(
	SELECT CCP.CodigoProducto
    FROM cliente_compra_producto CCP);

/* 2. Genere un listado de aquellos proveedores que proveen más de un producto, indicando CUIT, nombre del 
proveedor y cantidad de productos que provee. */
SELECT PROV.CUIT, PROV.Nombre, COUNT(PP.CODIGOPRODUCTO) AS CANTIDADPRODUCTOS
FROM proveedor PROV
INNER JOIN producto_proveedor PP
	ON PP.CUIT = PROV.CUIT
    GROUP BY PROV.CUIT
    HAVING CANTIDADPRODUCTOS > 1;


/* 3. Actualizar el nombre de todos los proveedores que tengan un espacio al principio, quitando ese espacio. 
¿Cuántos registros se actualizaron? */
-- Primero hago el select para verificar INVESTIGAR LA FUNCION LTRIM
SELECT Nombre, LTRIM(Nombre)
FROM proveedor
WHERE Nombre LIKE' %';

-- ahora si actualizamos
UPDATE PROVEEDOR 
SET NOMBRE = LTRIM(NOMBRE)
WHERE NOMBRE LIKE ' %';


/* 4. Actualizar el precio de aquellos productos, que tiene un precio entre 1000$ y 2000$ y no tienen proveedor 
aún, incrementando su precio de venta en un 10%. */
-- verificamos primeramente si existen registros
SELECT PROD.CodigoProducto, PROD.Nombre, (PROD.Precio_venta * 1.10) AS PRECIONUEVO
FROM producto PROD
WHERE PROD.Precio_venta >= 1000 AND PROD.Precio_venta <= 2000 AND PROD.CodigoProducto NOT IN(
	SELECT PP.CodigoProducto
    FROM producto_proveedor PP
); -- 5 REGISTROS ENCONTRADOS

UPDATE producto PRO 
LEFT JOIN producto_proveedor PP ON PP.CodigoProducto = PRO.CodigoProducto
SET PRO.PRECIO_VENTA = (PRO.PRECIO_VENTA * 1.10)
WHERE PP.CodigoProducto IS NULL
AND PRO.PRECIO_VENTA between 1000 AND 2000;  -- 5 REGISTROS ACTUALIZADOS

-- PARA VERIFICAR MIRO PRECIO DEL PRODUCTO CON CODIGO = 12
SELECT * FROM PRODUCTO WHERE CODIGOPRODUCTO = 12;



/* 5. Genere una vista llamada “Buenos_Clientes” que tenga el apellido, nombre, fecha de nacimiento, y 
cantidad total de productos, de aquellos clientes que compraron más de 5 productos iguales o diferentes 
en total. */
CREATE OR REPLACE VIEW `buenos_clientes` AS
SELECT CLI.NOMBRE, CLI.APELLIDO, CLI.FECHA_NACIMIENTO, SUM(CCC.CANTIDAD) AS cantidadproductos
FROM CLIENTE CLI
INNER JOIN CLIENTE_COMPRA_PRODUCTO CCC ON CCC.DNI = CLI.DNI
GROUP BY CLI.DNI
HAVING cantidadproductos > 5;     -- SON 59 CLIENTES ACTUALMENTE

/* 6. Realice un select a la vista Buenos_clientes. ¿Cuántos registros devuelve? */
SELECT * FROM buenos_clientes;


/* 7. Agregar un registro en la tabla cliente_compra_producto, donde el cliente cuyo DNI = 31325083, compro 12  
‘Yogur natural 190g'. Controlar ya que los nombres de los productos pueden tener espacios delante y 
detrás. */
INSERT INTO CLIENTE_COMPRA_PRODUCTO
(SELECT CLI.DNI, PRO.CODIGOPRODUCTO, 12
FROM CLIENTE CLI, PRODUCTO PRO
WHERE CLI.DNI = 32141924 AND
      PRO.NOMBRE LIKE ' Manteca 200g ' );

/* 8. Realice nuevamente un select a la vista Buenos_clientes. ¿Cuántos registros devuelve? */
SELECT * FROM buenos_clientes;

/* 9. Genere una función que calcule la edad de un cliente, donde uno pueda realizar 
edad(cliente.fecha_nacimiento) y devuelva un valor entero que corresponde a la edad del cliente. */


/* 10. Utilizando la función generada en el punto anterior, genere un listado que muestre el apellido, nombre y 
edad de los clientes ordenados alfabéticamente por apellido y nombre. */

/* 11. Genere un reporte que contenga el apellido, nombre y edad de aquellos clientes que tengan más de 65 
años. Ordene de forma descendente por edad. */

/* 12. Muestre apellido, nombre, edad y fecha de nacimiento del cliente más joven. */

/* 13. Borrar los registros de aquellos proveedores que no proveen ningún producto, y cuyo nombre incluya la 
palabra “Premoldedados”. ¿Cuántos registros se eliminaron? */

/* 14. Borrar los registros de los clientes que tienen menos de 70 años y no han comprado ningún producto. */

/* 15. Diseñe una forma de auditoría, que cada vez que se modifica o borra un registro en la tabla Producto, 
quede registrado, la operación realizada, el usuario que la realizo, la fecha y hora de la operación y todos 
los valores anteriores a la operación de esta tabla. */

