program ejercicio_1_P2;

type
  str10 = string[10];
  comision = record
    cod_empleado: integer;
    nom: str10;
    comision: real;
  end;
  empleado = record
    cod_empleado: Integer;
    nom: str10;
    totComisiones: real;
  end;

  maestro = file of empleado;
  detalle = file of comision;
  
  // Added missing type definition
  lCom = ^nCom;
  nCom = record
    dato: comision;
    sig: lCom;
  end;

{modulos}
procedure crearArchivoDetalle(var det: detalle);

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

var 
  c: comision;
  pri: lCom;
begin
  pri := nil;
  leerComision(c);
  while (c.cod_empleado <> -1) do begin
    insertarOrdenado(pri, c);
    leerComision(c);
  end;
  cargarArchivoDetalle(det, pri);
end;

procedure crearArchivoMaestro(var det1: detalle; var mae1: maestro);
var
  regM: empleado;
  regD: comision;
  cantComision: real;
  codAct: integer;
begin
  Reset(det1);
  Rewrite(mae1);  // Changed maestro to mae1
  
  if not Eof(det1) then begin  // Added check before first read
    read(det1, regD);
    
    while not Eof(det1) do begin
      codAct := regD.cod_empleado;
      regM.cod_empleado := codAct;
      regM.nom := regD.nom;  
      
      cantComision := 0; 
      
      while (not Eof(det1)) and (regD.cod_empleado = codAct) do begin
        cantComision := cantComision + regD.comision;
        Read(det1, regD);
      end;
      regM.totComisiones := cantComision;
      write(mae1, regM);
    end;
  end;
  Close(det1);
  Close(mae1);
end;

{Programa Principal}
var
  mae1: maestro;
  det1: detalle;
begin
  Assign(mae1, 'maestro');
  Assign(det1, 'detalle');
  crearArchivoDetalle(det1);
  crearArchivoMaestro(det1, mae1);
end.