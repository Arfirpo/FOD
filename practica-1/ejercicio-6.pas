{6. Agregar al menú del programa del ejercicio 5, opciones para:
	a. Añadir uno o más celulares al final del archivo con sus datos ingresados por teclado.
	b. Modificar el stock de un celular dado.
	c. Exportar el contenido del archivo binario a un archivo de texto denominado: ”SinStock.txt”, con aquellos celulares que tengan stock 0.
NOTA: Las búsquedas deben realizarse por nombre de celular.}

program ejercicio_5_P1;

const corte = 'fin';

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

  procedure leerCelular(var c: rCelular);
  begin
	with c do begin
		write('Ingrese nombre del celular: '); readln(nom);
    if(c.nom <> corte) then begin
      write('Ingrese codigo del celular: '); readln(cod);
      write('Ingrese descripcion del celular: '); readln(desc);
      write('Ingrese marca del celular: '); readln(marca);
      write('Ingrese precio del celular: '); readln(precio);
      write('Ingrese stock minimo del celular: '); readln(stockMin);
      write('Ingrese stock actual del celular: '); readln(stockAct);
    end;
	end;
  end;

  procedure crearArchivoCelulares(var Celulares: ArchivoCelulares);
  var c: rCelular; nomArch:str10; carga: Text;
  begin
    WriteLn();
    Write('Ingrese el nombre del archivo a crear: '); readln(nomArch);
    Assign(Celulares,nomArch);
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


  procedure celularesSinStock(var Celulares: ArchivoCelulares);
  var c: rCelular; nomArch:str10; 
  begin
    WriteLn();
    Write('Ingrese el nombre del archivo a leer: '); readln(nomArch);
    WriteLn();
    Assign(Celulares,nomArch);
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
    Assign(Celulares,nomArch);
    case opc of
      1: crearArchivoCelulares(Celulares);
      2: celularesSinStock(Celulares);
      3: buscarCelularesPorDesc(Celulares);
      4: exportarArchivoCelulares(Celulares);
    end;
  until (opc = 0);
  WriteLn('Programa finalizado.')
End.
