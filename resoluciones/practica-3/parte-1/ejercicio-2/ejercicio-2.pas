program ejercicio_2_P3;
const
  valorAlto = 9999;
type
  str10 = string[10];
  str15 = string[15];
  Asistente = record
    nroAsistente: integer;
    apeYnom: str15;
    email: str15;
    tel: str15;
    dni: str10;
  end;

  ArchivoAsistentes = file of Asistente;

{modulos}
procedure leerAsistente(var a: Asistente);
begin
  with a do begin
    write('Ingrese numero del asistente: '); Readln(nroAsistente);
    if (nroAsistente <> -1) then begin
      write('Ingrese apellido y nombre del asistente: '); Readln(apeYnom);
      write('Ingrese email del asistente: '); Readln(email);
      write('Ingrese telefono del asistente: '); Readln(tel);
      write('Ingrese dni del asistente: '); Readln(dni);
    end;
  end;
end;

procedure generarArchivoAsistentes(var asistentes: ArchivoAsistentes);
var a: Asistente;
begin
  Rewrite(asistentes);
  leerAsistente(a);
  while (a.nroAsistente <> -1) do begin
    write(asistentes,a);
    leerAsistente(a);
  end;
  Close(asistentes);
  WriteLn('Archivo de asistentes creado con exito.');
end;

procedure leer(var asistentes: ArchivoAsistentes; var dato: Asistente);
begin
  if(not(Eof(asistentes))) then
    read(asistentes,dato)
  else
    dato.nroAsistente := valorAlto;
end;

procedure eliminacionLogica(var asistentes: ArchivoAsistentes);
var a: Asistente;
begin
  Reset(asistentes);
  leer(asistentes,a);
  while (a.nroAsistente <> valorAlto) do begin
    if(a.nroAsistente < 1000) then begin
      if (a.apeYnom[1] <> '@') then
        a.apeYnom := '@' + a.apeYnom;
      Seek(asistentes,FilePos(asistentes) - 1);
      write(asistentes,a);
    end;    
    leer(asistentes,a);
  end;
  close(asistentes);
  WriteLn('Eliminacion de asistentes completada.');
end;

procedure imprimirArchivo(var asistentes: ArchivoAsistentes);
var a: Asistente;
begin
  Reset(asistentes);
  leer(asistentes,a);
  WriteLn('***** ASISTENTES *****');
  WriteLn('-------------------------------');
  while (a.nroAsistente <> valorAlto) do begin
    if not(a.apeYnom[1] = '@') then begin
      Writeln('Numero de Assitente: ',a.nroAsistente);
      Writeln('Nombre y Apellido: ',a.apeYnom);
      Writeln('Email: ',a.email);
      Writeln('Telefono: ',a.tel);
      Writeln('Dni: ',a.dni);
      WriteLn('-------------------------------');
    end;
    leer(asistentes,a);
  end;
  Close(asistentes);
end;

{Programa Principal}
var
  asistentes: ArchivoAsistentes;
  nomArchivo: str10;
  opc: integer;
begin
    Write('Ingrese nombre del archivo: ');Readln(nomArchivo);
    nomArchivo := nomArchivo + '.bin';
    Assign(asistentes,nomArchivo);
  repeat
    writeln('*** MENU DE OPCIONES ***');
    writeln('1.- Generar archivo de asistentes.');
    writeln('2.- Eliminar logicamente asistentes.');
    writeln('3.- Imprimir archivo asistentes.');
    writeln('-1.- Finalizar programa.');
    Write('Opcion elegida: '); readln(opc);
    case opc of
      1: generarArchivoAsistentes(asistentes);
      2: eliminacionLogica(asistentes);
      3: imprimirArchivo(asistentes);
    end;
  until (opc = -1);
  writeln('Programa finalizado.')
End.