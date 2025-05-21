
{6. Agregar al menú del programa del ejercicio 5, opciones para:
	a. Añadir uno o más celulares al final del archivo con sus datos ingresados por teclado.
	b. Modificar el stock de un celular dado.
	c. Exportar el contenido del archivo binario a un archivo de texto denominado: ”SinStock.txt”, con aquellos celulares que tengan stock 0.
NOTA: Las búsquedas deben realizarse por nombre de celular.}

Program ejercicio_5_P1;

Const corte = 'fin';

Type 
  str10 = string[10];

  rCelular = Record
    cod: Integer;
    desc: String;
    marca: str10;
    precio: Real;
    nom: str10;
    stockMin: Integer;
    stockAct: Integer;
  End;

  ArchivoCelulares = file Of rCelular;

{modulos}

function buscarCelular(var Celulares: ArchivoCelulares; nombre: string): integer;
var ok: boolean; c: rCelular; pos: integer;
begin
  pos := -1;
  ok := false;
  Reset(Celulares);
  while (not(Eof(Celulares)) and not(ok)) do 
    begin
      Read(Celulares,c);
      if (c.nom = nombre) then 
        begin
          ok := true;
          pos := Filepos(Celulares) - 1;
        end;
    end;
  Close(Celulares);
  buscarCelular := pos;
end;

Procedure imprimirCelular(c: rCelular);
Begin
  With c Do
    Begin
      WriteLn('Nombre: ',nom);
      WriteLn('Marca: ',marca);
      WriteLn('Precio: ',precio:0:2);
      WriteLn('Codigo: ',cod);
      WriteLn('Descripcion: ',desc);
      WriteLn('Stock Minimo: ',stockMin);
      WriteLn('Stock Actual: ',stockAct);
    End;
End;

Procedure leerCelular(Var c: rCelular);
Begin
  With c Do
    Begin
      write('Ingrese nombre del celular: ');
      readln(nom);
      If (c.nom <> corte) Then
        Begin
          write('Ingrese codigo del celular: ');
          readln(cod);
          write('Ingrese descripcion del celular: ');
          readln(desc);
          write('Ingrese marca del celular: ');
          readln(marca);
          write('Ingrese precio del celular: ');
          readln(precio);
          write('Ingrese stock minimo del celular: ');
          readln(stockMin);
          write('Ingrese stock actual del celular: ');
          readln(stockAct);
        End;
    End;
End;

procedure modificarStockAct(var Celulares: ArchivoCelulares);
var nom: string; pos: integer; c: rCelular;
begin
  WriteLn();
  Write('Ingrese nombre del celular buscado: '); Readln(nom);
  pos := buscarCelular(Celulares,nom);
  if (pos <> -1) then begin
    Reset(Celulares);
    Seek(Celulares,pos);
    Read(Celulares,c);
    WriteLn();
    Write('Ingrese Stock Actual: '); Readln(c.stockAct);
    Seek(Celulares, pos);
    Write(Celulares,c);
    WriteLn();
    Writeln('Stock modificado exitosamente.');
  end
  else begin
    WriteLn();
    Writeln('El celular buscado no existe.');
    WriteLn();
  end;
  close(Celulares);
end;

procedure copiarCelular(var carga: text; c: rCelular);
begin
  WriteLn(carga,c.cod,' ',c.precio:0:2,' ',c.marca);
  WriteLn(carga,c.stockAct,' ',c.stockMin,' ',c.desc);
  WriteLn(carga,c.nom);
end;

procedure exportarCelularesSinStock(var Celulares: ArchivoCelulares);
var c: rCelular; carga: Text;
begin
  Reset(Celulares);
  Assign(carga,'SinStock.txt');
  Rewrite(carga);
  WriteLn(carga, 'LISTADO DE CELULARES SIN STOCK');
  WriteLn(carga, '============================');
  WriteLn(carga);
  while not(Eof(Celulares)) do begin
    Read(Celulares,c);
    if(c.stockAct = 0) then Begin
      copiarCelular(carga,c);
    end;
  end;
  WriteLn(carga);
  WriteLn(carga, '============================');
  Close(Celulares); Close(carga);
  WriteLn();
  WriteLn('Listado exportado exitosamente.');
  WriteLn();
end;


Procedure agregarCelulares(Var Celulares: ArchivoCelulares);
Var c: rCelular;
Begin
  Reset(Celulares);
  leerCelular(c);
  While (c.nom <> corte) Do 
    Begin
      Seek(Celulares,filesize(Celulares));
      Write(Celulares,c);
      leerCelular(c);
    End;
End;

Procedure crearArchivoCelulares(Var Celulares: ArchivoCelulares);
Var c: rCelular; nomArch:str10; carga: Text;
Begin
  WriteLn();
  Write('Ingrese el nombre del archivo a crear: '); readln(nomArch);
  Assign(Celulares,nomArch + '.bin');
  Rewrite(Celulares);
  Assign(carga,'celulares.txt');
  Reset(carga);
  While Not(Eof(carga)) Do
    Begin
      ReadLn(carga,c.cod,c.precio,c.marca);
      ReadLn(carga,c.stockAct,c.stockMin,c.desc);
      ReadLn(carga,c.nom);
      write(Celulares,c);
    End;
  close(Celulares);
  close(carga);
  WriteLn();
  WriteLn('Archivo creado con exito.');
End;

Procedure celularesSinStock(Var Celulares: ArchivoCelulares);
Var c: rCelular; nomArch: str10;
Begin
  WriteLn();
  Write('Ingrese el nombre del archivo a leer: ');
  readln(nomArch);
  WriteLn();
  Assign(Celulares,nomArch + '.bin');
  Reset(Celulares);
  While Not(Eof(Celulares)) Do
    Begin
      Read(Celulares,c);
      If (c.stockAct < c.stockMin) Then
        Begin
          WriteLn('---------');
          WriteLn();
          imprimirCelular(c);
          WriteLn();
        End;
    End;
  WriteLn('---------');
  WriteLn();
  Close(Celulares);
End;

Procedure buscarCelularesPorDesc(Var Celulares: ArchivoCelulares);
Var c: rCelular; desc: String; alMenosUno: boolean;
Begin
  alMenosUno := false;
  Reset(Celulares);
  Write('Ingrese la descripcion del celular buscado.');
  ReadLn(desc);
  While Not(Eof(Celulares)) Do
    Begin
      Read(Celulares,c);
      If (c.desc = desc) Then
        Begin
          If Not(alMenosUno) Then alMenosUno := true;
          WriteLn('---------');
          WriteLn();
          imprimirCelular(c);
          WriteLn();
        End;
    End;
  Close(Celulares);
  If Not(alMenosUno) Then
    Begin
      WriteLn();
      WriteLn('No se encontro ningun celulr con la descripcion proporcionda');
    End;
End;

Procedure exportarArchivoCelulares(Var Celulares: ArchivoCelulares);
Var carga: Text; c: rCelular;
Begin
  Reset(Celulares);
  Assign(carga,'celulares.txt');
  Rewrite(carga);
  While Not(Eof(Celulares)) Do
    Begin
      Read(Celulares,c);
      copiarCelular(carga,c);
    End;
  close(Celulares);
  close(carga);
  WriteLn();
  WriteLn('Archivo exportado exitosamente.');
  WriteLn();
End;

{programa principal}
Var 
  Celulares: ArchivoCelulares; opc: Integer; nomArch: String;
Begin
  Repeat
    WriteLn();
    WriteLn('---- Tienda de Celulares ----');
    WriteLn();
    WriteLn('---- Menu Principal ----');
    WriteLn();
    WriteLn('-- Opciones -->');
    WriteLn();
    WriteLn('0 --> Cerrar el programa.');
    WriteLn('1 --> Crear nuevo archivo de celulares.');
    WriteLn('2 --> Listar celulares sin stock.');
    WriteLn('3 --> Buscar celulares por palabra clave.');
    WriteLn('4 --> Exportar archivo en formato txt.');
    WriteLn('5 --> Agregar celulares al archivo.');
    WriteLn('6 --> Modificar stock celulares.');
    WriteLn('7 --> Exportar lista de celulares sin stock (formato .txt).');
    WriteLn();
    Write('Ingrese la opcion deseada: ');
    Readln(opc);
    WriteLn();
    If (opc = 1) Then
      Begin
        WriteLn();
        Write('Ingrese el nombre del archivo a crear: ');
        readln(nomArch);
      End
    Else If (opc >= 2) And (opc <= 7) Then
      Begin
        Write('Ingrese el nombre del archivo a leer: ');
        readln(nomArch);
      End;
    WriteLn();
    Assign(Celulares,nomArch + '.bin');
    Case opc Of 
      1: crearArchivoCelulares(Celulares);
      2: celularesSinStock(Celulares);
      3: buscarCelularesPorDesc(Celulares);
      4: exportarArchivoCelulares(Celulares);
      5: agregarCelulares(Celulares);
      6: modificarStockAct(Celulares);
      7: exportarCelularesSinStock(Celulares);
    End;
  Until (opc = 0);
  WriteLn('Programa finalizado.')
End.
