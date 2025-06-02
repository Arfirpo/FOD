program ejercicio_1_P3_Pte2;

const
  valorAlto = 9999;

type

  Producto = record
    codProd: integer;
    nom: string[10];
    precio: real;
    stockAct: integer;
    stockMin: integer;
  end;

  Venta = record
    codProd: integer;
    uVendidas: integer;
  end;

  ArchivoMaestro = file of Producto;
  ArchivoDetalle = file of Venta;

{Modulos}
procedure leerDetalle(var det1: ArchivoDetalle; var dato: Venta);
begin
  if(not(Eof(det1))) then
    read(det1,dato)
  else
    dato.codProd := valorAlto;
end;

procedure actuaizarMaestro(var maestro: ArchivoMaestro; var detalle: ArchivoDetalle);

  function BuscarRegM(var maestro: ArchivoMaestro; codProd: integer): integer;
  var
    regM: Producto;
    pos: integer;
    encontre: Boolean;
  begin
    pos := -1;
    encontre := false;
    Seek(maestro,0);
    while not(Eof(maestro)) and not(encontre) do begin
      read(maestro,regM);
      if(regM.codProd = codProd) then begin
        pos := FilePos(maestro) - 1;
        encontre := true;
      end;
    end;
    BuscarRegM := pos;
  end;

var
  regM: Producto;
  regD: Venta;
  pos: integer;
begin
  Reset(maestro);
  Reset(detalle);
  leerDetalle(detalle,regD);

  while (regD.codProd <> valorAlto) do begin
    pos := BuscarRegM(maestro,regD.codProd);
    if(pos <> -1) then begin
      Seek(maestro,pos);
      Read(maestro,regM);
      regM.stockAct := regM.stockAct - regD.uVendidas;
      Seek(maestro,pos);
      Write(maestro,regM);
    end;



  end;
end;


{Programa Principal}
var
  mae1: ArchivoMaestro;
  det1: ArchivoDetalle;
begin
  Assign(mae1,'archivoMaestro.bin');
  Assign(det1,'archivoDetalle.bin');
  actuaizarMaestro(mae1,det1);
End.