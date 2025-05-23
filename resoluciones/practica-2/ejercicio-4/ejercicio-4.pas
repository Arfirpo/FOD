program ejercicio_4_P2;
const 
	valorAlto = 9999;
	dimF = 30;
type
	str10 = string[10];
	str20 = string[20];
	
	Producto = record
		codProd: integer;
		nom: str10;
		desc: str20;
		stockDisp: integer;
		stockMin: integer;
	end;

	Venta = record
		codProd: integer;
		uVendidas: integer;
	end;

	ArchivoMaestro = file of Producto;
	ArchivoDetalle = file of Venta;

	vectorArchivoDetalle= array [1..dimF] of;
	vectorRegistroVenta= array [1..dimF] of;

{modulos}
procedure leer(var det: ArchivoDetalle; dato: Venta);
begin
	if(not(Eof(det))) then
		read(det,dato);
	else
		dato.codProd := valorAlto;
end;

procedure minimo(vD: vectorArchivoDetalle; vR: vectorRegistroVenta; var minRegD: venta);
var
	i,minCod,pos: integer;
begin
	minCod := valorAlto;
	pos := 1;
	for i := 1 to dimF do begin
		if(vR[i].codProd < minCod) then begin
			minCod := vR[i].codProd;
			minRegD := vR[i];
			pos := i;
		end;
	end;
	if(minRegD.codProd <> valorAlto) then
		leer(vD[pos],vR[pos]);
end;

procedure actualizarMaestro(var maestro: ArchivoMaestro; vDetalles: vectorArchivoDetalle);
var
	minRegD: Venta;
	totVendido: integer;
	vRegistros: vectorRegistroVenta;
begin
	
end;


{Programa Principal}
var
	i: integer;
	mae1: ArchivoMaestro;

begin
	Assign(mae1,'maestro');
	Reset(mae1);
	for i := 1 to dimF do begin
		Assign(vD[i],'detalle'+ i);
		Reset(vD[i]);
	end;
	actualizarMaestro(mae1,vD);
end.
