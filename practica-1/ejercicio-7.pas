{7. Realizar un programa que permita:
	a) Crear un archivo binario a partir de la información almacenada en un archivo de texto. El nombre del archivo de texto es: “novelas.txt”. La información en el archivo de texto consiste en: código de novela, nombre, género y precio de diferentes novelas argentinas. Los datos de cada novela se almacenan en dos líneas en el archivo de texto. La primera línea contendrá la siguiente información: código novela, precio y género, y la segunda línea almacenará el nombre de la novela.
	b) Abrir el archivo binario y permitir la actualización del mismo. Se debe poder agregar una novela y modificar una existente. Las búsquedas se realizan por código de novela.
NOTA: El nombre del archivo binario es proporcionado por el usuario desde el teclado.}

program ejercicio_7_P1;

{ Sección de tipos }
type
  str15 = string[15];
  Novela = record
    cod: integer;
    nom: str15;
    gen: str15;
    precio: real;
  end;

  ArchivoNovelas = file of Novela;

{ Modulos }

function buscarNovela(var Novelas: ArchivoNovelas; cod: integer): integer;
var pos: integer; n: Novela; ok: Boolean;
begin
  pos := -1;
  ok := false;
  Reset(Novelas);
  while not(Eof(Novelas)) and not(ok) do begin
    Read(Novelas,n);
    if n.cod = cod then begin
      ok := true;
      pos := FilePos(Novelas) - 1;
    end;
  end;
  Close(Novelas);
  buscarNovela := pos;
end;

procedure crearArchivo(var Novelas: ArchivoNovelas);
var n: Novela; carga: Text;
begin
  Rewrite(Novelas);
  Assign(carga,'novelas.txt');
  Reset(carga);
  while not(Eof(carga)) do
  begin
    Readln(carga,n.cod,n.precio,n.gen);
    Readln(carga,n.nom);
    Write(Novelas,n);
  end;
  Writeln('Archivo creado exitosamente.');
  Writeln();
  Close(Novelas); Close(carga);
end;

// procedure actualizarArchivo(var Novelas: ArchivoNovelas);
// var
// begin
// end;

{ Programa Principal}
var novelas: ArchivoNovelas; opc: integer; nomArch: string;
begin
  repeat
    Writeln();
    Writeln('------ Menu Principal ------');
    Writeln();
    Writeln('----> Opciones: ');
    Writeln();
    Writeln('1.----> Crear archivo de novelas.');
    Writeln('2.----> Actualizar archivo de novelas.');
    Writeln();
    Write('Ingrese la opcion elegida -0 para finalizar-: '); Readln(opc);
    Writeln();
    if(opc >= 1) and (opc <= 2) then begin
      Write('Ingrese el nombre del achivo a crear/leer: '); Readln(nomArch);
      Assign(Novelas,nomArch + '.bin');
      Writeln();
    end;
    case opc of
      1: crearArchivo(Novelas);
      // 2: actualizarArchivo(Novelas);
    end;
  until(opc = 0);
end.
