program ejercicio_6_P2;

const
  valorAlto = 9999;
  dimF = 10;

type
  str10 = string[10];
  Municipio = record
    codLocalidad: integer;
    codCepa: integer;
    cantCasosActivos: integer;
    cantCasosNuevos: integer;
    cantCasosRecuperados: integer;
    cantCasosFallecidos: integer;
  end;

  Localidad = record
    nomLocalidad: str10;
    nomCepa: str10;
    municipio: Municipio;
  end;

  ArchivoMaestro = file of Localidad;
  ArchivoDetalle = file of Municipio;

  vectorArchivoDetalle = array [1..dimF] of ArchivoDetalle;
  vectorRegistroDetalle = array [1..dimF] of Municipio;

{modulos}
procedure leer(var detalle: ArchivoDetalle; var dato: Municipio);
begin
  if(not(Eof(detalle))) then
    read(detalle,dato)
  else
    dato.codLocalidad := valorAlto;
end;

procedure minimo(var vD: vectorArchivoDetalle; var vR: vectorRegistroDetalle; var minRegD: Municipio);
var
  i,minLoc,minCepa,pos:integer;
begin
  minLoc := valorAlto;
  minCepa := valorAlto;
  pos := -1;
  for i := 1 to dimF do begin
    if(vR[i].codLocalidad < minLoc) or ((vR[i].codLocalidad = minLoc) and (vR.codCepa < minCepa)) then begin
      minLoc := vR[i].codLocalidad;
      minCepa := vR[i].codCepa;
      minRegD := vR[i];
      pos := i;
    end;
  end;
  if(minRegD.codLocalidad <> valorAlto) then
    leer(vD[pos],vR[pos]);
end;

procedure actualizarMaestro(var maestro: ArchivoMaestro; var vD: ArchivoDetalle);
var
  vR: vectorRegistroDetalle;
  minRegD: Municipio;
  regM: Localidad;
  i, cantLocalidades, cantCasosLocalidad, codLocAct, codCepaAct: integer;
  sumaFallecidos, sumaRecuperados, cantActivos, cantNuevos: integer;
begin
  Reset(maestro);
  for i := 1 to dimF do begin
    Reset(vD[i]);
    leer(vD[i], vR[i]);
  end;

  minimo(vD, vR, minRegD);
  cantLocalidades := 0;

  while (minRegD.codLocalidad <> valorAlto) do begin
    codLocAct := minRegD.codLocalidad;
    cantCasosLocalidad := 0;

    if not eof(maestro) then
      read(maestro, regM)
    else
      break; // Si el maestro está vacío, salgo del bucle

    while (not eof(maestro)) and (regM.municipio.codLocalidad <> codLocAct) do
      read(maestro, regM);

    while (minRegD.codLoc = codLocAct) do begin
      codCepaAct := minRegD.codCepa;
      sumaFallecidos := 0;
      sumaRecuperados := 0;

      while (minRegD.codLoc = codLocAct) and (minRegD.codCepa = codCepaAct) do begin
        sumaFallecidos := sumaFallecidos + minRegD.cantCasosFallecidos;
        sumaRecuperados := sumaRecuperados + minRegD.cantCasosRecuperados;
        cantActivos := minRegD.cantCasosActivos;
        cantNuevos := minRegD.cantCasosNuevos;
        cantCasosLocalidad := cantCasosLocalidad + minRegD.cantCasosActivos;
        minimo(vD, vR, minRegD);
      end;

      while (not eof(maestro)) and ((regM.municipio.codLocalidad <> codLocAct) or (regM.municipio.codCepa <> codCepaAct)) do
        read(maestro, regM);

      if (regM.municipio.codLocalidad = codLocAct) and (regM.municipio.codCepa = codCepaAct) then begin
        regM.municipio.cantCasosFallecidos := regM.municipio.cantCasosFallecidos + sumaFallecidos;
        regM.municipio.cantCasosRecuperados := regM.municipio.cantCasosRecuperados + sumaRecuperados;
        regM.municipio.cantCasosActivos := cantActivos;
        regM.municipio.cantCasosNuevos := cantNuevos;
        Seek(maestro, FilePos(maestro) - 1);
        write(maestro, regM);
      end;
    end;

    if (cantCasosLocalidad > 50) then
      cantLocalidades := cantLocalidades + 1;
  end;

  Close(maestro);
  for i := 1 to dimF do
    Close(vD[i]);

  Writeln(cantLocalidades, ' localidades tienen más de 50 casos activos en la Provincia de Buenos Aires.');
end;

{Programa Principal}
var
  maestro: ArchivoMaestro;
  vD: vectorArchivoDetalle;
  strI,nombre: string;
  i: integer;
begin
  Assign(maestro,'maestro.bin');
  for i := 1 to dimF do begin
    Str(i,strI);
    nombre := 'detalle' + strI;
    Assign(vD[i],nombre);
  end;
  actualizarMaestro(maestro,vD);
End.