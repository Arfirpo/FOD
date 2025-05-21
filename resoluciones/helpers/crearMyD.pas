program crearMyD;

type
	venta = record
		cod_prod: integer;
		u_vendidas: integer;
	end;
	producto = record
		cod_prod: integer;
		nom: string;
		precio: real;
		stock_act: Integer;
		stock_min: Integer;
	end;
	
  lVentas = ^nVentas;
  lProductos = ^nProductos;

  nVentas = record
    dato: venta;
    sig: lVentas;
  end;

  nProductos = record
    dato: producto;
    sig: lProductos;
  end;
  
  ArchivoMaestro = file of producto;
	ArchivoDetalle = file of venta;


{modulos}
  procedure leerProducto(var p: producto);
  begin
    with p do begin
      cod_prod := 1000 + Random(1501);  { Entre 1000 y 2500 }
      write('Ingrese nombre del producto: '); readln(nom);
      precio := 10 + Random * 90;        { Precio entre 10.00 y 100.00 }
      stock_act := Random(41);          { Entre 0 y 40 }
      stock_min := 1 + Random(10);      { Entre 1 y 10 }
    end;
  end;

  procedure leerVenta(var v: venta);
  begin
    with v do begin
      cod_prod := 1000 + Random(1501);  { Entre 1000 y 2500 }
      u_vendidas := Random(31);
    end;
  end;

  procedure insertarOrdenadoP(var l: lProductos; p: producto);
  var
    nue, ant, act: lProductos;
  begin
    new(nue);
    nue^.dato := p;
    nue^.sig := nil;
    ant := nil;
    act := l;
    while (act <> nil) and (act^.dato.cod_prod < p.cod_prod) do begin
      ant := act;
      act := act^.sig;
    end;
    if (ant = nil) then
      l := nue
    else
      ant^.sig := nue;
    nue^.sig := act;
  end;

  procedure insertarOrdenadoV(var l: lVentas; v: venta);
  var
    nue, ant, act: lVentas;
  begin
    new(nue);
    nue^.dato := v;
    nue^.sig := nil;
    ant := nil;
    act := l;
    while (act <> nil) and (act^.dato.cod_prod < v.cod_prod) do begin
      ant := act;
      act := act^.sig;
    end;
    if (ant = nil) then
      l := nue
    else
      ant^.sig := nue;
    nue^.sig := act;
  end;

  procedure cargarArchivoDetalle(var det: ArchivoDetalle; l: lVentas);
  begin
    Rewrite(det);
    while (l <> nil) do begin
      write(det, l^.dato);
      l := l^.sig;
    end;
    Close(det);
  end;

  procedure cargarArchivoMaestro(var mae: ArchivoMaestro; l: lProductos);
  begin
    Rewrite(mae);
    while (l <> nil) do begin
      write(mae, l^.dato);
      l := l^.sig;
    end;
    Close(mae);
  end;


  procedure generarArchivoDetalle(var det: ArchivoDetalle);
  var v: venta; pri: lVentas; i: Integer;
  begin
    pri := nil;
   for i := 1 to 10 do begin
      leerVenta(v);
      insertarOrdenadoV(pri, v);
    end;
    cargarArchivoDetalle(det, pri);
    WriteLn('Archivo detalle generado con exito.');
  end;

  procedure generarArchivoMaestro(var mae: ArchivoMaestro);
  var p: producto; pri: lProductos; i: Integer;
  begin
    pri := nil;
    for i := 1 to 10 do begin
      leerProducto(p);
      insertarOrdenadoP(pri,p);
    end;
    cargarArchivoMaestro(mae,pri);
  WriteLn('Archivo maestro generado con exito.');
  end;

{Programa Principal}
var
	det1: ArchivoDetalle;
  mae1: ArchivoMaestro;
  num: Integer;
begin
  Randomize;
	Assign(det1,'detalle.bin');
  Assign(mae1,'maestro.bin');
  repeat  
    Writeln('***Menu de opciones***');
    Writeln('1.-Generar archivo de productos -Maestro-');
    Writeln('2.-Generar archivo de ventas -Detalle-');
    Writeln('-1 para Salir');
    Write('Opcion elegida: '); ReadLn(num);
    Case num of
      1:  generarArchivoMaestro(mae1);
      2:  generarArchivoDetalle(det1);
    end;
  until (num = -1);
  WriteLn('Programa finalizado');
end.

