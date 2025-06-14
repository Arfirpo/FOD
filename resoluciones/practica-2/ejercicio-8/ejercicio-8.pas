program ejercicio_8_P2;

const
  valorAlto = 9999;
  dimF = 16;

type
  str10 = string[10];
  Provincia = record
    codProv: integer;
    nomProv: str10;
    cantHab: integer;
    consumoHistorico: real;
  end;

  Relevamiento = record
    codProv: integer;
    consumoMensual: real;
  end;

  ArchivoDetalle = file of Relevamiento;
  ArchivoMaestro = file of Provincia;

  VectorArchivoDetalle = array [1..dimF] of ArchivoDetalle;
  VectorRegistroDetalle = array [1..dimF] of Relevamiento;

{modulos}

procedure leerMaestro(var maestro: ArchivoMaestro; var dato: Provincia);
begin
  if (not(Eof(maestro))) then
    read(maestro,dato)
  else
    dato.codProv := valorAlto;
end;

procedure leerDetalle(var detalle: ArchivoDetalle; var dato: Relevamiento);
begin
  if (not(Eof(detalle))) then
    read(detalle,dato)
  else
    dato.codProv := valorAlto;
end;

procedure minimo(var vD: VectorArchivoDetalle; var vR: VectorRegistroDetalle; var minRegD:Relevamiento);
var i,pos:integer;
begin
  minRegD.codProv := valorAlto;
  for i := 1 to dimF do begin
    if(vR[i].codProv < minRegD.codProv) then begin
      minRegD := vR[i];
      pos := i;
    end;
  end;
  if(minRegD.codProv <> valorAlto) then
    leerDetalle(vD[pos],vR[pos]);
end;

procedure actualizarMaestro(var maestro: ArchivoMaestro; var vD: VectorArchivoDetalle);
var
  vR: VectorRegistroDetalle;
  minRegD: Relevamiento;
  regM: Provincia;
  codAct,cantConsumida,i: integer;
  consHab: real;

begin
  Reset(maestro);
  for i := 1 to dimF do begin
    Reset(vD[i]);
    leerDetalle(vD[i],vR[i]);
  end;
  leerMaestro(maestro,regM);
  minimo(vD,vR,minRegD);

  while(regM.codProv <> valorAlto) do begin
    codAct := regM.codProv;

    
    cantConsumida := 0;
    while (minRegD.cod = codAct) do begin
      cantConsumida := cantConsumida + minRegD.consumoMensual;
      minimo(vD,vR,minRegD);
    end;

    regM.consumoHistorico := regM.consumoHistorico + cantConsumida;
    seek(maestro,filepos(maestro) - 1);
    write(maestro,regM);

    if(regM.consumoHistorico > 10000) then begin
      consHab := regM.consumoHistorico / regM.cantHab;
      writeln('La provincia de ',regM.nomProv,' - Codigo N° ',regM.codProv,' consume un promedio de ',consHab:0:2,'Kg de yerba por habitante.');
    end;

    leerMaestro(maestro,regM);
    minimo(vD,vR,minRegD);  
  end;
  close(maestro);
  for i := 1 to dimF do
    close(vD[i]);
end;

{Programa Principal}
var
  mae1: ArchivoMaestro;
  vD: VectorArchivoDetalle;
  nom,strI: string;
begin
  Assign(mae1,'maestro.bin');
  for i := 1 to dimF do
  begin
    Str(i,strI);
    nom := 'detalle' + strI + '.bin';
    Assign(vD[i],nombre);
  end;
  actualizarMaestro(mae1,vD);
end.
