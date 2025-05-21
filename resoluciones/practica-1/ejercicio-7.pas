{7. Realizar un programa que permita:
	a) Crear un archivo binario a partir de la información almacenada en un archivo de texto. El nombre del archivo de texto es: “novelas.txt”. La información en el archivo de texto consiste en: código de novela, nombre, género y precio de diferentes novelas argentinas. Los datos de cada novela se almacenan en dos líneas en el archivo de texto. La primera línea contendrá la siguiente información: código novela, precio y género, y la segunda línea almacenará el nombre de la novela.
	b) Abrir el archivo binario y permitir la actualización del mismo. Se debe poder agregar una novela y modificar una existente. Las búsquedas se realizan por código de novela.
NOTA: El nombre del archivo binario es proporcionado por el usuario desde el teclado.}

program ejercicio_7_P1;

  const corte = 'fin';

{ Sección de tipos }
type
  str30 = string[30];
  Novela = record
    cod: integer;
    nom: str30;
    gen: str30;
    precio: real;
  end;

  ArchivoNovelas = file of Novela;

{ Modulos }

procedure leerNovela(var n: Novela);
begin
  with n do begin
    Write('Ingrese nombre de la novela: '); ReadLn(nom);
    if nom <> corte then begin
      Write('Ingrese codigo de la novela: '); ReadLn(cod);
      Write('Ingrese precio de la novela: '); ReadLn(precio);
      Write('Ingrese genero de la novela: '); ReadLn(gen);      
    end;
  end;
end;

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

procedure actualizarArchivo(var Novelas: ArchivoNovelas);

  procedure agregarNovela(var Novelas: ArchivoNovelas);
  var n: Novela;
  begin
    Reset(Novelas);
    Seek(Novelas,FileSize(Novelas));
    leerNovela(n);
    while n.nom <> corte do begin
      Write(Novelas,n);
      leerNovela(n);
    end;
    WriteLn('Novelas agregadas con exito.');
    WriteLn();
    Close(Novelas);
  end;

  procedure modificarNovela(var Novelas: ArchivoNovelas);
  var opc: integer; cod: Integer; pos: integer; n: Novela;
  begin
    Writeln();
    Write('Ingrese codigo de la novela a buscar: '); ReadLn(cod);
    Writeln();
    pos := buscarNovela(Novelas,cod);
    if pos <> -1 then begin
      Reset(Novelas);
      Seek(Novelas,pos);
      Read(Novelas,n);
      repeat
        Writeln('------ Menu de Modificacion ------');
        Writeln();
        Writeln('----> Opciones: ');
        Writeln();
        Writeln('1.----> Modificar nombre de la novela.');
        Writeln('2.----> Modificar genero de la novela.');
        Writeln('3.----> Modificar precio de la novela.');
        Writeln('4.----> Modificar codigo de la novela.');
        Writeln();
        Write('Ingrese la opcion elegida -0 para finalizar-: '); Readln(opc);
        Writeln();
        case opc of
          1: begin Write('Ingrese el nombre de la novela: '); ReadLn(n.nom); end;
          2: begin Write('Ingrese el genero de la novela: '); ReadLn(n.gen); end;
          3: begin Write('Ingrese el precio de la novela: '); ReadLn(n.precio); end;
          4: begin Write('Ingrese el codigo de la novela: '); ReadLn(n.cod); end;
        end;
        Write(Novelas,n);
        WriteLn();
        WriteLn('Novela modificada con exito.');
        WriteLn();
      until(opc = 0);      
    end
    else begin
      WriteLn('No se encontro la novela buscada.');
      WriteLn();
    end;    
  end;

var opc: integer;
begin
  repeat
    Writeln();
    Writeln('------ Menu de Actualizacion ------');
    Writeln();
    Writeln('----> Opciones: ');
    Writeln();
    Writeln('1.----> Agregar novelas al archivo.');
    Writeln('2.----> Modificar una novela ya existente.');
    Writeln();
    Write('Ingrese la opcion elegida -0 para finalizar-: '); Readln(opc);
    Writeln();
    case opc of
      1: agregarNovela(Novelas);
      2: modificarNovela(Novelas);
    end;
  until(opc = 0);
end;

procedure listarArchivo(var Novelas: ArchivoNovelas);

  procedure imprimirNovela(n: Novela);
  begin
    with n do begin
      WriteLn('Titulo: ',nom);
      WriteLn('Codigo: ',cod);
      WriteLn('Precio: $',precio:0:2);
      WriteLn('Genero: ',gen);
    end;
  end;

var n: Novela;
begin
  Reset(Novelas);
  WriteLn('Lista de Novelas');
  WriteLn('================');
  WriteLn();
  while not(Eof(Novelas)) do begin
    Read(Novelas,n);
    imprimirNovela(n);
    Writeln();
  end;
  Close(Novelas);
  WriteLn();
  WriteLn('================');
end;

procedure exportarArchivo(var Novelas: ArchivoNovelas);
var carga: Text; n: Novela; nomArch: String;
begin
  Reset(Novelas);
  Write('Ingrese nombre del archivo exportado: '); ReadLn(nomArch);
  Assign(carga,nomArch + '.txt');
  Rewrite(carga);
  WriteLn(carga,'Lista de Novelas');
  WriteLn(carga,'================');
  WriteLn(carga);
  while not(Eof(Novelas)) do begin
    Read(Novelas,n);
    WriteLn(carga,'Codigo: ',n.cod,' - ','Titulo: ',n.nom,' - ','Precio: $',n.precio:0:2,' - ','Genero: ',n.gen,'.');
  end;
  WriteLn(carga);
  WriteLn(carga,'================');
  WriteLn();
  WriteLn('Archivo exportado exitosamente.');
  WriteLn();
  Close(Novelas); Close(carga);
end;

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
    Writeln('3.----> Mostrar archivo de novelas.');
    Writeln('4.----> Exportar archivo de novelas.');
    Writeln();
    Write('Ingrese la opcion elegida -0 para finalizar-: '); Readln(opc);
    Writeln();
    if(opc >= 1) and (opc <= 4) then begin
      Write('Ingrese el nombre del achivo a crear/leer: '); Readln(nomArch);
      Assign(Novelas,nomArch + '.bin');
      Writeln();
    end;
    case opc of
      1: crearArchivo(Novelas);
      2: actualizarArchivo(Novelas);
      3: listarArchivo(Novelas);
      4: exportarArchivo(Novelas);
    end;
  until(opc = 0);
end.
