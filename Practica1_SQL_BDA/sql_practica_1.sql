#SELECT * FROM u2_ejercicio1.cliente;


SELECT Apellido, Nombre
FROM cliente
WHERE YEAR(Fecha_Nacimiento)=1964 # Filtramos por un anio de fecha de nacimiento
ORDER BY Apellido; # Ordenamos alfabeticamente de A-Z ya que el campo es string, si fuera int de 1-9...
# ORDER BY Apellido DESC; # Ordenamos de orden Descendente con "DESC"

SELECT count(*) FROM cliente;
