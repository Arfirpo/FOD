program ejercicio_3_P3;

const
  valorAlto = 9999;

type
  str10 = string[10];
  Novela = record
    codNovela: integer;
    gen: str10;
    nom: str10;
    dur: str10;
    director: str10;
    precio: real;
  end;

  ArchivoNovelas = file of Novela;

{modulo}
procedure leerNovela(var n: Novela);
begin
  with n do begin
    Write('Ingrese codigo de la novela: '); readln(codNovela);
    if(n.codNovela <> -1) then begin
      Write('Ingrese genero de la novela: '); readln(gen);
      Write('Ingrese nombre de la novela: '); readln(nom);
      Write('Ingrese duracion de la novela: '); readln(dur);
      Write('Ingrese director de la novela: '); readln(director);
      Write('Ingrese precio de la novela: '); readln(precio);
    end;
  end;
end;

procedure leer(var novelas: ArchivoNovelas; var dato: Novela);
begin
  if(not(Eof(novelas))) then
    read(novelas,dato)
  else
    dato.codNovela := valorAlto;
end;

procedure generarArchivo(var novelas: ArchivoNovelas);
var 
  n: Novela;
begin
  Rewrite(novelas);
  n.codNovela := 0; //registro de cabecera
  write(novelas,n);
  leerNovela(n);
  while (n.codNovela <> -1) do begin
    Write(novelas,n);
    leerNovela(n);
  end;
  writeln('Archivo generado exitosamente.');
  close(novelas);
end;

procedure modificarArchivo(var novelas: ArchivoNovelas);

  procedure agregarNovela(var novelas: ArchivoNovelas);
  var
    cabecera,nueva,libre: Novela;
    posLibre: integer;
  begin
    Reset(novelas);
    leerNovela(nueva);
    read(novelas,cabecera); //leo el registro de cabecera
    if(cabecera.codNovela < 0) then begin
      posLibre := -cabecera.codNovela;
      Seek(novelas,posLibre);
      read(novelas,libre);
      Seek(novelas,0);
      Write(novelas,libre);
      Seek(novelas,posLibre);
      write(novelas,nueva);
    end
    else begin      
      Seek(novelas,FileSize(novelas));
      Write(novelas,nueva);
    end;
    WriteLn('Novela agregada exitosamente.');
    Close(novelas);
  end;

  procedure modificarNovela(var novelas: ArchivoNovelas);
  var
    cod: integer;
    n: Novela;
  begin
    Reset(novelas);
    Writeln();
    Write('Ingrese codigo de novela a modificar: '); readln(cod);
    leer(novelas,n);
    while (n.codNovela <> valorAlto) and (n.codNovela <> cod) do
      leer(novelas,n);
    if(n.codNovela = cod) then begin
      with n do begin
        Write('Ingrese genero de la novela: '); readln(gen);
        Write('Ingrese nombre de la novela: '); readln(nom);
        Write('Ingrese duracion de la novela: '); readln(dur);
        Write('Ingrese director de la novela: '); readln(director);
        Write('Ingrese precio de la novela: '); readln(precio);      
      end;
    end;
    Seek(novelas,FilePos(novelas) - 1);
    Write(novelas,n);
    Close(novelas);
  end;

  procedure eliminarNovela(var novelas: ArchivoNovelas);
  var
    codBuscado,posElim: integer;
    n,cabecera: Novela;
  begin
    Reset(novelas);
    Writeln();
    Write('Ingrese codigo de novela a eliminar: '); readln(codBuscado);
    read(novelas,cabecera);
    leer(novelas,n);
    while (n.codNovela <> valorAlto) and (n.codNovela <> codBuscado) do
      leer(novelas,n);
    if(n.codNovela = codBuscado) then begin
      posElim := FilePos(novelas) - 1;
      n.codNovela := cabecera.codNovela;
      Seek(novelas,FilePos(novelas) - 1);
      Write(novelas,n);
      cabecera.codNovela := -posElim;
      Seek(novelas,0);
      Write(novelas,cabecera);
      Writeln('Novela eliminada exitosamente.');
    end
    else
      Writeln('No se encontró una novela con ese código.');
    Close(novelas);
  end;


var
  opc: integer;
begin
  WriteLn();
  repeat
    WriteLn('*** MENU DE OPCIONES - MANTENIMIENTO ***');
    WriteLn();
    WriteLn('1.- Agregar novela al archivo.');
    WriteLn('2.- Modificar datos de una Novela.');
    WriteLn('3.- Eliminar una novela del archivo.');
    WriteLn('-1.- Finalizar Programa.');
    case opc of
      1:  agregarNovela(novelas);
      2:  modificarNovela(novelas);
      3:  eliminarNovela(novelas);
    end;
  until (opc = -1);
end;

procedure exportarATexto(var novelas: ArchivoNovelas);
var
  carga: Text;
  n: Novela;
begin
  Reset(novelas);
  Assign(carga,'novelas.txt');
  Rewrite(carga);
  leer(novelas,n);
  WriteLn(carga,'***** LISTADO DE NOVELAS *****');
  WriteLn(carga,'==============================');
  while (n.codNovela <> valorAlto) do begin
    if(n.codNovela < 0) then
      WriteLn(carga,'Posicion ', -n.codNovela,' libre.')
    else if (n.codNovela = 0) then
      WriteLn('No quedan espacios libres')
    else begin
      WriteLn(carga,n.codNovela);
      WriteLn(carga,'genero de la novela: ',n.gen,'.');
      WriteLn(carga,'titulo de la novela: ',n.nom,'.');
      WriteLn(carga,'duracion de la novela: ',n.dur,'.');
      WriteLn(carga,'director de la novela: ',n.director,'.');      
      WriteLn(carga,'precio de la novela: ',n.precio,'.');      
    end;
    WriteLn(carga,'------------------------------');
    leer(novelas,n);
  end;
  WriteLn(carga,'==============================');
  Close(novelas);
  Close(carga);
end;
{Programa Principal}
var
  novelas: ArchivoNovelas;
  nom: str10;
  opc: integer;
begin
  Write('Ingrese el nombre del archivo: '); ReadLn(nom);
  nom := nom + '.bin';
  Assign(novelas,nom);
  WriteLn();
  repeat
    WriteLn('*** MENU DE OPCIONES ***');
    WriteLn();
    WriteLn('1.- Generar Archivo de Novelas.');
    WriteLn('2.- Modificar Archivo de Novelas.');
    WriteLn('3.- Exportar Archivo de Novelas a texto.');
    WriteLn('-1.- Finalizar Programa.');
    case opc of
      1:  generarArchivo(novelas);
      2:  modificarArchivo(novelas);
      3:  exportarATexto(novelas);
    end;
  until (opc = -1);
  Writeln('Programa finalizado.');
End.