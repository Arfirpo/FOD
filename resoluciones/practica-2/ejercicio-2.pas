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
	ArchivoMaestro = file of producto;
	ArchivoDetalle = file of venta;


{modulos}
procedure actualizarArchivoMaestro(var maestro: ArchivoMaestro; var detalle: ArchivoDetalle);
var
	regM: producto;
	regD: venta;
	tot_u_vendidas: integer;
begin
	reset(maestro);
	reset(detalle);
	while(not(Eof(detalle))) do begin
		read(maestro,regM);
		read(detalle,regD);
		while(regM.cod_prod <> regD.cod_prod) do
			read(maestro,regM);
		tot_u_vendidas := 0;
		while (not(Eof(detalle))) and (regM.cod_prod = regD.cod_prod) do begin
			tot_u_vendidas := tot_u_vendidas + regD.u_vendidas;
			read(detalle,regD);
		end;
		regM.stock_act := regM.stock_act - tot_u_vendidas;
		seek(maestro,filepos(maestro) - 1);
		write(maestro,regM);
	end;
	close(detalle);
	close(maestro);
end;

procedure exportarProductosConStockBajo(var maestro: ArchivoMaestro);

	procedure copiarProducto(var carga: text; p: producto);
	begin
		WriteLn(carga,p.nom);
		WriteLn(carga,p.cod_prod,' ',p.precio:0:2);
		WriteLn(carga,p.stock_act,' ',p.stock_min);
	end;

var p: producto; carga: Text;
begin
  Reset(maestro);
  Assign(carga,'StockMinimo.txt');
  Rewrite(carga);
  WriteLn(carga, 'LISTADO DE PRODUCTOS SIN STOCK');
  WriteLn(carga, '============================');
  WriteLn(carga);
  while not(Eof(maestro)) do begin
    Read(maestro,p);
    if(p.stock_act < p.stock_minimo) then
      copiarProducto(carga,p);
  end;
  WriteLn(carga);
  WriteLn(carga, '============================');
  Close(maestro); Close(carga);
  WriteLn();
  WriteLn('Listado exportado exitosamente.');
  WriteLn();
end;


{Programa Principal}
var
	regM: producto;
	regD: venta;
	mae1: ArchivoMaestro;
	det1: ArchivoDetalle;
begin
	Assign(mae1,'maestro');
	Assign(det1,'detalle');
	actualizarArchivoMaestro(mae1,det1);
	exportarProductosConStockBajo(mae1);
End.
