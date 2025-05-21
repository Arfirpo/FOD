program crearDetalleComision;

type
	str10 = string[10];

  comision = record
    cod_empleado: integer;
    nom: str10;
    comision: real;
  end;

	detalle = file of comision;

	lCom = ^nCom;
  nCom = record
    dato: comision;
    sig: lCom;
  end;

{modulos}
  procedure leerComision(var c: comision);
  begin
    with c do begin
      write('Ingrese codigo de empleado: '); readln(cod_empleado);
      if (cod_empleado <> -1) then begin  // Changed "do" to "then"
        write('Ingrese nombre del empleado: '); readln(nom);
        write('Ingrese monto de la comision del empleado: '); readln(comision);
      end;
    end;
  end;

  procedure insertarOrdenado(var l: lCom; c: comision);
  var
    nue, ant, act: lCom;
  begin
    new(nue);
    nue^.dato := c;
    nue^.sig := nil;
    ant := nil;
    act := l;
    while (act <> nil) and (act^.dato.cod_empleado < c.cod_empleado) do begin
      ant := act;
      act := act^.sig;
    end;
    if (ant = nil) then
      l := nue
    else
      ant^.sig := nue;
    nue^.sig := act;
  end;

  procedure cargarArchivoDetalle(var det: detalle; l: lCom);
  begin
    Rewrite(det);
    while (l <> nil) do begin
      write(det, l^.dato);
      l := l^.sig;
    end;
    Close(det);
  end;
{Programa Principal}
var
	det1: detalle;
  c: comision;
  pri: lCom;
begin
	Assign(det1,'detalle');
  pri := nil;
  leerComision(c);
  while (c.cod_empleado <> -1) do begin
    insertarOrdenado(pri, c);
    leerComision(c);
  end;
  cargarArchivoDetalle(det1, pri);
end.

