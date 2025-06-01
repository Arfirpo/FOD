program ejercicio_7_P3;

const
  valorAlto = 9999;
type
  str10 = string[10];
  str20 = string[20];
  AveEPDE = record
    codAve: integer;
    nomEspecie: str10;
    famAve: str10;
    desc: str20;
    zonaGeo: str10;
  end;
  ArchivoMaestro = file of AveEPDE;

{modulos}

procedure leer(var aves: ArchivoMaestro; var dato: AveEPDE);
begin
  if(not(Eof(aves))) then
    read(aves.dato)
  else
    dato.codAve := valorAlto;
end;

procedure bajaLogica(var aves: ArchivoMaestro);

  procedure marcarAveExtinta(var aves: ArchivoMaestro; codBuscado: integer);
  var
    a: AveEPDE;
    encontre: boolean;
  begin
    Seek(aves,0);
    encontre := false;
    leer(aves,a);
    while (a.codAve <> valorAlto) and  not(encontre) do begin
      if(a.codAve = codBuscado) then begin
        a.nomEspecie := '@' + a.nomEspecie;
        Seek(aves,FilePos(aves) - 1);
        Write(aves,a);
        encontre := true;
      end
      else
        leer(aves,a);
      end;
    if(encontre) then
      WriteLn('Ave marcada como extinta exitosamente.')
    else
    WriteLn('No se encontro el ave con el codigo: ',codBuscado,'.');
  end;

var
  codBuscado: integer;
begin
  Reset(aves);
  repeat
    WriteLn();
    Write('Ingrese el codigo del ave extinta (-1 para finalizar): '); 
    ReadLn(codBuscado);
    marcarAveExtinta(aves,codBuscado);
  until (codBuscado = -1);
  WriteLn('Proceso de baja logica finalizado.');
  Close(aves);
end;

procedure bajaFisica(var aves: ArchivoMaestro);
var
  a: AveEPDE;
  posElim: integer;
begin
  Reset(aves);
  leer(aves,a);
  while (a.codAve <> valorAlto) do begin
    if(a.nomEspecie[1] = '@') then begin
      posElim := FilePos(aves) - 1;
      Seek(aves,FileSize(aves) - 1);
      Read(aves,a);
      Seek(aves,posElim);
      write(aves,a);
      truncate(aves);
    end;    
    leer(aves,a);
  end;
  Close(aves);
end;


{Programa Principal}
var
  aves: ArchivoMaestro;
begin
  Assign(aves,'avesEPDE.bin');
  bajaLogica(aves);
  bajaFisica(aves); //todavia no implementado
End.