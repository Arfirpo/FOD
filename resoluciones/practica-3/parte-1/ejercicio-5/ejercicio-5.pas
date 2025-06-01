program ejercicio_5_P3;

const
  valorAlto = 9999;

type
  reg_flor = record 
  nombre: String[45]; 
  codigo: integer; 
end; 
 
  tArchFlores = file of reg_flor;

{modulos}
procedure leer(var flores: tArchFlores; var dato: reg_flor);
begin
  if(not(Eof(flores))) then
    read(flores,dato)
  else
    dato.codigo := valorAlto;
end;

procedure listarContenido(var flores: tArchFlores);
var 
  f: reg_flor;
begin
  Reset(flores);
  leer(flores,f);
  WriteLn('**** LISTADO DE FLORES ****');
  WriteLn('===========================');
  while (f.codigo <> valorAlto) do begin
    if not(f.codigo < 1) then begin
      WriteLn('Flor: ',f.nombre,' | Codigo: ',f.codigo,'.');
      WriteLn('---------------------');
    end;
    leer(flores,f);
  end;
  WriteLn('===========================');
  Close(flores);
end;

procedure generarArchivo(var flores: tArchFlores);
var
  f: reg_flor;
begin
  Rewrite(flores);
  f.codigo := 0; //codigo cabecera
  write(flores,f); //guardo la cabecera
  Write('Ingresar codigo de flor: '); Readln(cod);
  while (cod <> -1) do begin
    Write('Ingrese nombre de la flor: '); ReadLn(nomFlor);
    Write(flores,f);
    Write('Ingresar codigo de flor: '); Readln(cod);
  end;
end;

procedure modificarArchivo(var flores: tArchFlores);

  procedure agregarFlor(var flores: tArchFlores; nombre: String; codigo: integer);
  var 
    nuevo,cabecera,libre: reg_flor;
    posLibre: integer;
  begin
    Reset(flores);
    nuevo.codigo := codigo;
    nuevo.nombre := nombre;
    leer(flores,cabecera);

    if(cabecera.codigo < 0) then begin
      posLibre := -cabecera.codigo;
      Seek(flores,posLibre);
      Read(flores,libre);
      Seek(flores,posLibre);
      Write(flores,nuevo);
      Seek(flores,0);
      Write(flores,libre);
    end
    else begin
      Seek(flores,FileSize(flores));
      Write(flores,nuevo);
    end;
    Close(flores);
  end;

  procedure eliminarFlor(var flores: tArchFlores; flor: reg_flor);
  var
    cabecera,f: reg_flor;
    codBuscado,posLibre: Integer;
    econtrado: boolean;
  begin
    Reset(flores);
    encontrado := false;
    read(flores,cabecera);
    leer(flores,f);
    while (f.codigo <> valorAlto) and not(encontrado) do
      if(f.codigo = flor.codigo) then
        encontrado := true
      else
        leer(flores,f);

    if(encontrado) then begin
      posLibre := FilePos(flores) - 1;
      f := cabecera;
      Seek(flores,posLibre);
      write(flores,f);
      Seek(flores,0);
      cabecera.codigo := -posLibre;
      Write(flores,cabecera);
      WriteLn('Flor eliminada exitosamente.');
    end
    else
      WriteLn('No se encontro la flor buscada.',codBuscado,'.');
    Close(flores);
  end;

var
  opc: integer;
  f: reg_flor;
  nomFlor: string[45];
  encontre: boolean;
begin
  WriteLn();
  repeat
    WriteLn('*** MENU DE OPCIONES - MANTENIMIENTO ***');
    WriteLn();
    WriteLn('1.- Agregar flores al archivo.');
    WriteLn('3.- Eliminar una flor del archivo.');
    WriteLn('-1.- Finalizar Programa.');
    case opc of
      1:  agregarFlor(flores);
      2:  
        begin
          Write('Ingrese el nombre de la flor a eliminar: '); readln(nomFlor);
          leer(flores,f);
          encontre := false;
          while (f.codigo <> valorAlto) and not(encontre) do begin
             if(f.nombre = nomFlor) then
              encontrado := true
            else
              leer(flores,f);
          end;
          if(encontre) then
            eliminarFlor(flores,f)
          else
            WriteLn('No se encontro la flor buscada.');
        end;
    end;
  until (opc = -1);
end;


{Programa Principal}
var
  flores: tArchFlores;
  nom: String;
  nomFlor: string[45];
  cod: integer;
  f: reg_flor;
Begin
  Write('Ingrese el nombre del archivo a abrir: '); 
  Readln(nom);
  nom := nom + '.bin';
  Assign(flores,nom);
  WriteLn();
  repeat
    WriteLn('*** MENU DE OPCIONES ***');
    WriteLn();
    WriteLn('1.- Generar Archivo de flores.');
    WriteLn('2.- Modificar Archivo de flores.');
    WriteLn('-1.- Finalizar Programa.');
    case opc of
      1:  generarArchivo(flores);
      2:  modificarArchivo(flores);
    end;
  until (opc = -1);
  Writeln('Programa finalizado.');
End.