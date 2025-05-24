program ejercicio_4_P2;

const 
  valorAlto = 9999;
  dimF = 30;


type
  str10 = string[10];

  Producto = record
    codProd: integer;
    nom: str10;
  end;

  Venta = record
    codProd: integer;
    uVendidas: integer;
  end;

  ArchivoMaestro = file of Producto;
  ArchivoDetalle = file of Venta;
  VectorDeDetalles = array[1..dimF] of ArchivoDetalle;
  VectorDeRegistros = array[1..dimF] of Venta;

{ Modulos }

// procedures o functions
procedure asignar(var v: VectorDeDetalles);
var i: integer;
begin
  for i := 1 to dimF do
    Assigin(v[i],'detalle'+i);
end;

procedure leer(var detalle: ArchivoDetalle; var dato: Venta);
begin
  if(not(Eof(detalle))) then read(detalle,dato)
  else dato.codProd := valorAlto;
end;

procedure minimo(vA: VectorDeDetalles; vR: VectorDeRegistros; var minVenta: Venta);
var
  i,minCod,pos:integer;
  regD: Vente;
begin
  minCod := valorAlto;
  pos := 0;
  for i := 1 to dimF do begin
    if(vR[i].codProd < minCod) then begin
      minCod := vR[i].codProd;
      minVenta := vR[i];
      pos := i;
    end;
  end;
  if(minCod <> valorAlto) then
    leer(vA[pos],vR[pos]);
end;

procedure actualizarMaestro(var maestro: ArchivoMaestro; var v: VectorDeDetalles);
var
  regM: Producto;
  minRegD: Venta;
  codAct,cant,i: integer;
  vDet: VectorDeDetalles;
begin
  for i := 1 to dimF do begin
    leer(v[i],vDet[i]);
  end;
  minimo(vDet);
end;


{ Programa Principal}
var
  vector: VectorDeDetalles;
  maestro: ArchivoMaestro;

begin
  Assign(maestro,'maestro.bin');
  reset(maestro);
  for i := 1 to dimF do begin
    Assign(vector[i],'detalle'+i);
    reset(vector[i]);
  end;
  actualizarMaestro(maestro,vector);
end.