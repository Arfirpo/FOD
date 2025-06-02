program ejercicio_8_P3;

const
  valorAlto = 'ZZZZ';

type

  DistribucionLinux = record
    nom: string[10];
    anioLanzamiento: string[4];
    versionKernel: real;
    cantDesarrolladores: integer;
    descripcion: string[20];
  end;

  ArchivoMaestro = file of DistribucionLinux;

{Modulos}

procedure leerMaestro(var maestro: ArchivoMaestro; var dato: DistribucionLinux);
begin
  if(not(Eof(maestro))) then
    read(maestro,dato)
  else
    dato.nom := valorAlto;
end;

function BuscarDistribucion(var maestro: ArchivoMaestro; nomBuscado: string[10]): integer;
var
  pos: integer;
  encontre: Boolean;
  regM: DistribucionLinux;
begin
  pos := -1;
  encontre := false;
  Reset(maestro);
  leerMaestro(maestro,regM);
  while (regM.nom <> valorAlto) and not(encontre) do begin
    if (regM.nom = nomBuscado) then begin
      pos := FilePos(maestro) - 1;
      encontre := true;
    end
    else
      leerMaestro(maestro,regM);
  end;
  Close(maestro);
  BuscarDistribucion := pos;  
end;

procedure AltaDistribucion(var maestro: ArchivoMaestro; distribucion: DistribucionLinux);
var 
  cabecera,libre: DistribucionLinux;
  posLibre: integer;
begin
  if(buscarDistribucion(maestro,distribucion.nom) = -1) then begin
    Reset(maestro);
    read(maestro,cabecera);
    if(cabecera.cantDesarrolladores < 0) then begin
      posLibre := Abs(cabecera.cantDesarrolladores);
      Seek(maestro,posLibre);
      Read(maestro,libre);
      Seek(maestro,posLibre);
      Write(maestro,distribucion);
      Seek(maestro,0);
      Write(maestro,libre);
      Writeln('El registro fue dado de alta en el NRR: ',posLibre,'.');
    end
    else begin
      Seek(maestro,FileSize(maestro));
      Write(maestro,distribucion);
      Writeln('El registro fue dado de alta en el ultimo NRR: ',FileSize(maestro) - 1,'.');
    end;
    Close(maestro);
  end
  else
    Writeln('Ya existe la distribución.');
end;

procedure BajaDistribucion(var maestro: ArchivoMaestro; nomBuscado: string[10]);
var
  cabecera,elim: DistribucionLinux;
  posElim: integer;
begin
  posElim := BuscarDistribucion(maestro,nomBuscado);
  if(posElim <> -1) then begin
    Reset(maestro);
    read(maestro,cabecera);
    Seek(maestro,posElim);
    read(maestro,elim);
    elim.cantDesarrolladores := -posElim;
    Seek(maestro,posElim);
    Write(maestro,cabecera);
    Seek(maestro,0);
    Write(maestro,elim);
    Close(maestro);
  end
  else
    Writeln('Distribucion no existente.');
end;

{Programa Principal}
var
  mae1: ArchivoMaestro;
  opc: integer;
  nomDist: string[10];
  regM: DistribucionLinux;
begin
  Assign(mae1,'archivoMaestro.bin');
  WriteLn();
  repeat
    WriteLn('**** MENU DE OPCIONES - MANTENIMIENTO DE ARCHIVO ****');
    WriteLn('1  .- Dar de alta una Distribucion de linux.');
    WriteLn('2  .- Dar de baja una distribucion de linux.');
    WriteLn('-1. - Finalizar Programa.');
    Write('Ingrese opcion elegida: '); Readln(opc);
    
    case opc of
      1: 
        begin
          leerDistribucion(regM); // se dispone, no se implemento en este ejercicio.
          AltaDistribucion(mae1,regM);
        end;
      2: 
        begin
          Write('Ingrese nombre de la Distribucion de Linux: '); Readln(nomDist);
          BajaDistribucion(mae1,nomDist);
        end;
    end;
  until (opc = -1);
  WriteLn('Programa finalizado.');
End.