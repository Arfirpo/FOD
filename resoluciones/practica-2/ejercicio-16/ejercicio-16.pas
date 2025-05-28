program ejercicio_16_P2;

const 
  valorAlto = 'ZZZ';
  dimF = 100;
type
  str10 = string[10];
  str20 = string[20];
  
  Emision = record
    fecha: str10;
    codSem: integer;
    nomSemanario: str10;
    desc: str20;
    precio: real;
    totEjemplares: integer;
    totEjempVendidos: integer;
  end;

  Venta = record
    fecha: str10;
    codSem: integer;
    cantEjemVendidos: integer;
  end;

  MaxMin = record
    maxVenta: integer;
    minVenta: integer;
    maxSem: integer;
    minSem: integer;
    maxFecha: str10;
    minFecha: str10;
  end;

  ArchivoMaestro = file of Emision;
  ArchivoDetalle = file of Venta;

  VectorDeArchivosDetalle = array [1..dimF] of ArchivoDetalle;
  VectorDeRegistrosDetalle = array [1..dimF] of Venta;

{modulos}

procedure leerDetalle(var detalle: ArchivoDetalle; var dato: Venta);
begin
  if(not(Eof(detalle))) then
    read(detalle,dato)
  else
    dato.fecha := valorAlto;
end;

procedure minimo(var vD: VectorDeArchivosDetalle; var vR: VectorDeRegistrosDetalle; var minRegD: Venta);
var
  i,pos: integer;
begin
  minRegD.fecha := valorAlto;
  for i := 1 to dimF do
  begin
    if (vR[i].fecha < minRegD.fecha) or ((vR[i].fecha = minRegD.fecha) and (vR[i].codSem < minRegD.codSem)) then begin
      minRegD := vR[i];
      pos := i;
    end;
  end;
  if(minRegD.fecha <> valorAlto) then
    leerDetalle(vD[pos],vR[pos]);
end;

procedure actualizarMaxMin(semAct,totVentas: integer; fechaAct: str10; var maxYmin: MaxMin);
begin
  if(totVentas > maxYmin.maxVenta) then begin
    maxYmin.maxVenta := totVentas;
    maxYmin.maxFecha := fechaAct;
    maxYmin.maxSem := semAct;
  end;
  if(totVentas < maxYmin.minVenta) then begin
    maxYmin.minVenta := totVentas;
    maxYmin.minFecha := fechaAct;
    maxYmin.minSem := semAct;
  end;
end;

procedure actualizarMaestro(var maestro: ArchivoMaestro, vD: VectorDeArchivosDetalle);
var
  vR: VectorDeRegistrosDetalle;
  regM: Emision;
  minRegD: Venta;
  fechaAct: str10;
  semAct,totVentas,i: integer;
  maxYmin: MaxMin;
begin
  Reset(maestro);
  for i := 1 to dimF do begin
    Reset(vD[i]);
    leerDetalle(vD[i],vR[i]);
  end;
  leerMaestro(maestro,regM);
  minimo(vD,vR,minRegD);

  maxYmin.minFecha := valorAlto; 
  maxYmin.maxFecha := '';
  maxYmin.maxSem := -1; 
  maxYmin.minSem := 9999;
  maxYmin.maxVenta := -1;
  maxYmin.minVenta := 9999;

  while (minRegD.fecha <> valorAlto) do begin
    fechaAct := minRegD.fecha;

    while (regM.fecha <> fechaAct) do
      read(maestro,regM);
    
    while (minRegD.fecha = fechaAct) do begin
      semAct := minRegD.codSem;

      while (regM.codSem <> semAct) do
        read(maestro,regM);
      
      totVentas := 0;
      while (minRegD.fecha = fechaAct) and (minRegD.codSem = semAct) do begin
        totVentas := totVentas + minRegD.cantEjemVendidos;
        minimo(vD,vR,minRegD);
      end;

      regM.totEjempVendidos := regM.totEjempVendidos + totVentas;
      seek(maestro,filepos(maestro) - 1);
      write(maestro,regM);

      actualizarMaxMin(semAct,totVentas,fechaAct,maxYmin);
    end;
    
  end;
  Writeln('El semanario ',maxYmin.minSem,'en la fecha ',maxYmin.minFecha,'es el que registra la menor cantidad de ventas');
  Writeln('El semanario ',maxYmin.maxSem,'en la fecha ',maxYmin.maxFecha,'es el que registra la mayor cantidad de ventas');
  close(maestro);
  for i := 1 to dimF do begin
    close(vD[i]);
  end;
end;
  
{Programa Principal}
var
  mae1: ArchivoMaestro;
  vD: VectorDeArchivosDetalle;
  strI,nom: string;
  i: integer;
begin
  Assign(mae1,'maestro.bin');
  for i := 1 to dimF do begin
    Str(i,strI);
    nom := 'detalle' + strI + '.bin';
    Assign(vD[i],nom);
  end;
  actualizarMaestro(mae1,vD);
End.
