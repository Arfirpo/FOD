{
2.- El encargado de ventas de un negocio de productos de limpieza desea administrar el stock de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los productos que comercializa. De cada producto se maneja la siguiente información: código de producto, nombre comercial, precio de venta, stock actual y stock minimo. Diariamentese genera un archivo detalle donde se registran todas las ventas de productos realizadas. De cada venta se registran: código de producto y cantidad de unidades vendias. Se pide realizar un programa con opciones para:
	a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
			* Ambos archivos estan ordenados por código de producto.
			* Cada registro del maestro puede ser actualizado por 0, 1 o mas registros del archivo detalle.
			* El archivo detalle solo contiene registros que estan en el archivo maestro.
	b. Listar en un archivo de texto llamado "stock_minimo.txt" aquellos productos cuyo stock actual este por debajo del stock minimo permitido.
}

program ejercicio_2_P2;

const valorAlto = 9999;

type
	venta = record
		cod_prod: integer;
		u_vendidas: integer;
	end;
	producto = record
		cod_prod: integer;
		nom: string;
		precio: real;
		stock_act: Integer;
		stock_min: Integer;
	end;
	ArchivoMaestro = file of producto;
	ArchivoDetalle = file of venta;


{modulos}
procedure leer(var det: ArchivoDetalle; var regD: venta);
begin
	if(not(Eof(det))) then
		read(det,regD)
	else
		regD.cod_prod :=valorAlto;
end;

procedure actualizarArchivoMaestro(var maestro: ArchivoMaestro; var detalle: ArchivoDetalle);
var
	regM: producto;
	regD: venta;
	tot_u_vendidas: integer;
	codAct: Integer;
begin
	reset(maestro);
	reset(detalle);
	leer(detalle,regD);
	while (regD.cod_prod <> valorAlto) do begin
		tot_u_vendidas := 0;
		codAct := regD.cod_prod;
		while (regD.cod_prod = codAct) do begin
			tot_u_vendidas := tot_u_vendidas + regD.u_vendidas;
			leer(detalle,regD);
		end;
		Read(maestro,regM);
		while(regM.cod_prod <> codAct) do
			read(maestro,regM);
		regM.stock_act := regM.stock_act - tot_u_vendidas;
		seek(maestro,filepos(maestro) - 1);
		write(maestro,regM);
		if(not(Eof(maestro))) then
			read(maestro,regM);
	end;
	close(detalle);
	close(maestro);
end;

procedure exportarProductosConStockBajo(var maestro: ArchivoMaestro);

	procedure copiarProducto(var carga: Text; p: producto);
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
    if(p.stock_act < p.stock_min) then
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
	mae1: ArchivoMaestro;
	det1: ArchivoDetalle;
begin
	Assign(mae1,'maestro.bin');
	Assign(det1,'detalle.bin');
	actualizarArchivoMaestro(mae1,det1);
	exportarProductosConStockBajo(mae1);
End.
