{
2.- El encargado de ventas de un negocio de productos de limpieza desea administrar el stock de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los productos que comercializa. De cada producto se maneja la siguiente información: código de producto, nombre comercial, precio de venta, stock actual y stock minimo. Diariamentese genera un archivo detalle donde se registran todas las ventas de productos realizadas. De cada venta se registran: código de producto y cantidad de unidades vendias. Se pide realizar un programa con opciones para:
	a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
			* Ambos archivos estan ordenados por código de producto.
			* Cada registro del maestro puede ser actualizado por 0, 1 o mas registros del archivo detalle.
			* El archivo detalle solo contiene registros que estan en el archivo maestro.
	b. Listar en un archivo de texto llamado "stock_minimo.txt" aquellos productos cuyo stock actual este por debajo del stock minimo permitido.
}

program ejercicio_2_P2;

type
	venta = record
		cod_prod: integer;
		u_vendidas: integer;
	end;
	producto = record
		cod_prod: integer;
		nom: string;
		precio: real;
		stock_act: int;
		stock_min: int;
	end;
	maestro = file of producto;
	detalle = file of venta;

{Programa Principal}
var
	regM: producto;
	regD: venta;
	mae1: maestro;
	det1: detalle;
begin
	Assign(mae1,'maestro');
	Assign(det1,'detalle');
	reset(mae1);
	reset(det1);
	while(not(Eof(det1))) do begin
		read(mae1,regM);
		read(det1,regD);
		while(regM.cod_prod <> regD.cod_prod) do
			read(mae1,regM);
		regM.stock_act = regM.stock_act - regD.u_vendidas;
		seek(mae1,filepos(mae1) - 1);
		write(mae1,regM);		
	end;
	close(det1);
	close(mae1);
End.
