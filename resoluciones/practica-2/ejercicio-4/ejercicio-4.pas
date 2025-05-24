
Program ejercicio_4_P2;

Const 
  valorAlto = 9999;
  dimF = 30;

Type 
  str10 = string[10];
  str20 = string[20];

  Producto = Record
    codProd: integer;
    nom: str10;
    desc: str20;
    stockDisp: integer;
    stockMin: integer;
  End;

  Venta = Record
    codProd: integer;
    uVendidas: integer;
  End;

  ArchivoMaestro = file Of Producto;
  ArchivoDetalle = file Of Venta;

  vectorArchivoDetalle = array [1..dimF] Of ArchivoDetalle;
  vectorRegistroVenta = array [1..dimF] Of Venta;

{modulos}
Procedure crearArchivoMaestro(var maestro: ArchivoMaestro);

Type 
  lProductos = ^nProductos;
  nProductos = Record
    dato: Producto;
    sig: lProductos;
End;

  Procedure leerProducto(Var p: Producto);
  Begin
    With p Do
      Begin
        write('Ingrese codigo del producto: ');
        readln(codProd);
        If (codProd <> -1) Then
          Begin
            write('Ingrese nombre del producto: ');
            readln(nom);
            write('Ingrese descripción del producto: ');
            readln(desc);
            write('Ingrese stock disponible del producto: ');
            readln(stockDisp);
            write('Ingrese stock minimo del producto: ');
            readln(stockMin);
          End;
      End;
  End;

  Procedure insertarOrdenado(Var l: lProductos; p: Producto);
  
  Var 
    nue,ant,act: lProductos;
  Begin
    new(nue);
    nue^.dato := p;
    nue^.sig := Nil;
    ant := Nil;
    act := l;
    While (act <> Nil) And (act^.dato.codProd < p.codProd) Do
      Begin
        ant := act;
        act := act^.sig;
      End;
    If (ant = Nil) Then
      l := nue
    Else
      ant^.sig := nue;
    nue^.sig := act;
  End;

  Procedure cargarArchivoMaestro(Var maestro: ArchivoMaestro; l: lProductos);
  Begin
    While (l <> Nil) Do
      Begin
        write(maestro,l^.dato);
        l := l^.sig;
      End;
  End;

Var 
  p: Producto;
  pri: lProductos;
Begin
  pri := Nil;
  Rewrite(maestro);
  leerProducto(p);
  While (p.codProd <> -1) Do
    Begin
      insertarOrdenado(pri,p);
      leerProducto(p);
    End;
  cargarArchivoMaestro(maestro,pri);
  writeln('Archivo Maestro creado exitosamente');
End;

procedure generarVectorDetalles(var v: vectorArchivoDetalle);

  Procedure crearArchivoDetalle(var detalle: ArchivoDetalle);

  Type 
    lVentas = ^nVentas;
    nVentas = Record
      dato: Venta;
      sig: lVentas;
  End;

    Procedure leerVenta(Var v: Venta);
    Begin
      With v Do
        Begin
          write('Ingrese codigo del producto: ');
          readln(codProd);
          If (codProd <> -1) Then
            Begin
              write('Ingrese cantidad de unidades vendidas del producto: ');
              readln(uVendidas);
            End;
        End;
    End;

    Procedure insertarOrdenado(Var l: lVentas; v: Venta);

    Var 
      nue,ant,act: lVentas;
    Begin
      new(nue);
      nue^.dato := v;
      nue^.sig := Nil;
      ant := Nil;
      act := l;
      While (act <> Nil) And (act^.dato.codProd < v.codProd) Do
        Begin
          ant := act;
          act := act^.sig;
        End;
      If (ant = Nil) Then
        l := nue
      Else
        ant^.sig := nue;
      nue^.sig := act;
    End;

    Procedure cargarArchivoDetalle(Var detalle: ArchivoDetalle; l: lVentas);
    Begin
      While (l <> Nil) Do
        Begin
          write(detalle,l^.dato);
          l := l^.sig;
        End;
    End;

  Var 
    v: Venta;
    pri: lVentas;
  Begin
    pri := Nil;
    Rewrite(detalle);
    leerVenta(v);
    While (v.codProd <> -1) Do
      Begin
        insertarOrdenado(pri,v);
        leerVenta(v);
      End;
    cargarArchivoDetalle(detalle,pri);
    writeln('Archivo detalle creado exitosamente');
  End;

var
  i: integer;
  nombre, strI: string;
begin
  for i := 1 to dimF do begin
    Str(i, strI); 
    nombre := 'detalle' + strI;
    Assign(v[i], nombre);
    crearArchivoDetalle(v[i]);
  end;
end;


Procedure leer(Var det: ArchivoDetalle; Var dato: Venta);
Begin
  If (Not(Eof(det))) Then
    read(det,dato)
  Else
    dato.codProd := valorAlto;
End;

Procedure minimo(vD: vectorArchivoDetalle; vR: vectorRegistroVenta; Var minRegD:
                 venta);

Var 
  i,minCod,pos: integer;
Begin
  minCod := valorAlto;
  pos := 1;
  For i := 1 To dimF Do
    Begin
      If (vR[i].codProd < minCod) Then
        Begin
          minCod := vR[i].codProd;
          minRegD := vR[i];
          pos := i;
        End;
    End;
  If (minRegD.codProd <> valorAlto) Then
    leer(vD[pos],vR[pos]);
End;

Procedure actualizarMaestro(Var maestro: ArchivoMaestro; vDetalles:
                            vectorArchivoDetalle);

Var 
  i,codAct: integer;
  minRegD: Venta;
  regM: Producto;
  totVendido: integer;
  vRegistros: vectorRegistroVenta;
Begin
  read(maestro,regM);
  For i := 1 To dimF Do
    leer(vDetalles[i],vRegistros[i]);
  minimo(vDetalles,vRegistros,minRegD);
  While (minRegD.codProd <> valorAlto) Do Begin
    codAct := minRegD.codProd;
    totVendido := 0;
    While (minRegD.codProd = codAct) Do Begin
      totVendido := totVendido + minRegD.uVendidas;
      minimo(vDetalles,vRegistros,minRegD);
    End;
    While (regM.codProd <> codAct) Do
      read(maestro,regM);
    regM.stockDisp := regM.stockDisp - totVendido;
    Seek(maestro,filepos(maestro) - 1);
    write(maestro,regM);
    If (Not(Eof(maestro))) Then
      read(maestro,regM);
  End;
  writeln('Archivo maestro actualizado.');
End;

{Programa Principal}

Var 
  i: integer;
  mae1: ArchivoMaestro;
  vD: vectorArchivoDetalle;
  num: integer;
  nombre,strI: string;

Begin
  repeat
    writeln('***MENU DE OPCIONES***');
    writeln('1.- Crear Archivo Maestro de productos.');
    writeln('2.- Generar archivos detalle.');
    writeln('3.- Actualizar archivo Maestro.');
    writeln('(-1) - Finalizar Programa.');
    Write('Opcion elegida: '); readln(num);
    case num of
      1: begin
          Assign(mae1,'maestro');
          crearArchivoMaestro(mae1);
        end;
      2: generarVectorDetalles(vD);
      3: begin
          Assign(mae1,'maestro');
          Reset(mae1);
          For i := 1 To dimF Do
            Begin
              str(i,strI);
              nombre := 'detalle' + strI;
              Assign(vD[i],nombre);
              Reset(vD[i]);
            End;
          actualizarMaestro(mae1,vD);
      end;
    end;
  until (num = -1);
  Writeln('Programa finalizado');
End.
