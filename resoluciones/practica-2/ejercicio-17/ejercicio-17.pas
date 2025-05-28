program ejercicio_17_P2;

const
  valorAlto = 9999;
  dimF = 10;
type
  str10 = string[10];
  str20 = string[20];
  Moto = record
    codMoto: integer;
    nom: str10;
    desc: str20;
    modelo: str10;
    marca: str10;
    stock: integer;
  end;
  Venta = record
    codMoto: integer;
    precio: real;
    fechaVenta: str10;
  end;

  ArchivoMaestro = file of Moto;
  ArchivoDetalle = file of Venta;

  VectorArchivosDetalle = array [1..10] of ArchivoDetalle;
  VectorRegistrosDetalle = array [1..10] of Venta;

{ Modulos }

procedure leerDetalle(var detalle: ArchivoDetalle; var dato: Venta);
begin
  if(not(Eof(detalle))) then
    read(detalle,venta)
  else
    dato.codMoto := valorAlto;
end;


procedure minimo(var vD: VectorArchivoDetalle; var vR: VectorRegistroDetalle; var minregD: Venta);
var
  i,pos: integer;
begin
  minRegD.codMoto := valorAlto;
  for i := 1 to dimF do begin
    if(vR[i].codMoto < minRegD.codMoto) then begin
      minRegD := vR[i];
      pos := i;
    end;
  end;
  if(minregD.codMoto <> valorAlto) then
    leerDetalle(vD[pos], vR[pos]);
end;

procedure actualizarMaximo(motoAct,cantVentas: integer; var maxMoto,maxVentas: integer);
begin
  if(cantVentas > maxVentas) then begin
    maxVentas := cantVentas;
    maxMoto := motoAct;
  end;
end;

procedure actualizarMaestro(var maestro: ArchivoMaestro; var vD: VectorArchivosDetalle);
var
  i,cantVentas,maxVentas,motoAct,maxMoto:integer;
  minRegD: Venta;
  vR: VectorRegistrosDetalle;
  regM: Moto;
begin
  Reset(maestro);
  for i := 1 to dimF do begin
    Reset(vD[i]);
    leerDetalle(vD[I],vR[i]);
  end;
  minimo(vD,vR,minRegD);
  read(maestro,regM);
  maxMoto := -1;
  maxVentas := -1;

  while (minRegD.codMoto <> valorAlto) do begin
    motoAct := minregD.codMoto;
    
    while (regM.codMoto <> motoAct) do
      read(maestro,regM);
    
    cantVentas := 0;
    while (minRegD.codMoto = motoAct) do begin
      cantVentas := cantVentas + 1;
      minimo(vD,vR,minRegD);
    end;

    actualizarMaximo(motoAct,cantVentas,maxMoto,maxVentas);

    regM.stock := regM.stock - cantVentas;
    seek(maestro,filepos(maestro) - 1);
    write(maestro,regM);

  end;
  Writeln('La moto con codigo Nro ',maxMoto,' fue la mas vendida');
  close(maestro);
  for i := 1 to dimF do 
    close(vD[i]);
end;

{ Programa Principal}
var
  mae1: ArchivoMaestro;
  vD: VectorDeArchivosDetalle;
  i: integer;
  strI,nom: string;
begin
  Assign(mae1,'maestro.bin');
  for i := 1 to dimF do begin
    Str(i,strI);
    nom := 'detalle' + strI + '.bin';
    Assign(vD[i],nom);
  end;
  actualizarMaestro(mae1,vD);
end.