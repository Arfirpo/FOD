{5. Realizar un programa para una tienda de celulares, que presente un menú con opciones para:
	a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos ingresados desde un archivo de texto denominado “celulares.txt”. Los registros correspondientes a los celulares deben contener: código de celular, nombre, descripción, marca, precio, stock mínimo y stock disponible.
	b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock mínimo.
	c. Listar en pantalla los celulares del archivo cuya descripción contenga una cadena de caracteres proporcionada por el usuario.
	d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado “celulares.txt” con todos los celulares del mismo. El archivo de texto generado podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que debería respetar el formato dado para este tipo de archivos en la NOTA 2.
NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario.
NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en tres líneas consecutivas. En la primera se especifica: código de celular, el precio y marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo “celulares.txt”.}

program ejercicio_5_P1;

type
	str10 = string[10];

	rCelular = record
		cod: Integer;
		desc: String;
		marca: str10;
    precio: Real;
		nom: str10;
		stockMin: Integer;
		stockAct: Integer;
	end;

  ArchivoCelulares = file of rCelular;

{modulos}

  procedure crearArchivoCelulares(var Celulares: ArchivoCelulares);
  var c: rCelular; nomArch:str10; carga: Text;
  begin
    WriteLn();
    Write('Ingrese el nombre del archivo a crear: '); readln(nomArch);
    Assign(Celulares,nomArch + '.bin');
    Rewrite(Celulares);
    Assign(carga,'celulares.txt');
    Reset(carga);
    while not(Eof(carga)) do begin
      ReadLn(carga,c.cod,c.precio,c.marca);
      ReadLn(carga,c.stockAct,c.stockMin,c.desc);
      ReadLn(carga,c.nom);
      write(Celulares,c);
    end;
    close(Celulares); close(carga);
    WriteLn();
    WriteLn('Archivo creado con exito.')
  end;

  procedure imprimirCelular(c: rCelular);
  begin
    with c do begin
      WriteLn('Nombre: ',nom);
      WriteLn('Marca: ',marca);
      WriteLn('Precio: ',precio:0:2);
      WriteLn('Codigo: ',cod);
      WriteLn('Descripcion: ',desc);
      WriteLn('Stock Minimo: ',stockMin);
      WriteLn('Stock Actual: ',stockAct);
    end;
  end;

  procedure celularesSinStock(var Celulares: ArchivoCelulares);
  var c: rCelular; nomArch:str10; 
  begin
    WriteLn();
    Write('Ingrese el nombre del archivo a leer: '); readln(nomArch);
    WriteLn();
    Assign(Celulares,nomArch + '.bin');
    Reset(Celulares);
    while not(Eof(Celulares)) do begin
      Read(Celulares,c);
      if(c.stockAct < c.stockMin) then begin
        WriteLn('---------');
        WriteLn();
        imprimirCelular(c);
        WriteLn();
      end;
    end;
    WriteLn('---------');
    WriteLn();
    Close(Celulares);
  end;

  procedure buscarCelularesPorDesc(var Celulares: ArchivoCelulares);
  var c: rCelular; desc: String; alMenosUno: boolean;
  begin
    alMenosUno := false;
    Reset(Celulares);
    Write('Ingrese la descripcion del celular buscado.'); ReadLn(desc);
    while not(Eof(Celulares)) do begin
      Read(Celulares,c);
      if(c.desc = desc) then begin
        if not(alMenosUno) then alMenosUno := true;
        WriteLn('---------');
        WriteLn();
        imprimirCelular(c);
        WriteLn();
      end;
    end;
    Close(Celulares);
    if not(alMenosUno) then begin
      WriteLn();
      WriteLn('No se encontro ningun celulr con la descripcion proporcionda');
    end;
  end;

  procedure exportarArchivoCelulares(var Celulares: ArchivoCelulares);
  var carga: Text; c: rCelular;
  begin
    Reset(Celulares);
    Assign(carga,'celulares.txt');
    Rewrite(carga);
    while not(Eof(Celulares)) do begin
      Read(Celulares,c);
      WriteLn(carga,c.cod,' ',c.precio:0:2,' ',c.marca);
      WriteLn(carga,c.stockAct,' ',c.stockMin,' ',c.desc);
      WriteLn(carga,c.nom);
    end;
    close(Celulares); close(carga);
    WriteLn();
    WriteLn('Archivo exportado exitosamente.');
    WriteLn();
  end;

{programa principal}
var
  Celulares: ArchivoCelulares;
  opc: Integer;
begin
  repeat
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
    WriteLn();
    Write('Ingrese la opcion deseada: '); Readln(opc);
    WriteLn();
    if(opc = 1) then begin
      WriteLn();
      Write('Ingrese el nombre del archivo a crear: '); readln(nomArch);
    end
    else if(opc >= 2) and (opc <= 4) then begin
      Write('Ingrese el nombre del archivo a leer: '); readln(nomArch);
    end;
    WriteLn();
    Assign(Celulares,nomArch + '.bin');
    case opc of
      1: crearArchivoCelulares(Celulares);
      2: celularesSinStock(Celulares);
      3: buscarCelularesPorDesc(Celulares);
      4: exportarArchivoCelulares(Celulares);
    end;
  until (opc = 0);
  WriteLn('Programa finalizado.')
End.