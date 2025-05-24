program ejercicio_5_P2;

const
  valorAlto = 9999;
  dimF = 2;
type

  Sesion = record
    cod_usuario: integer;
    fecha: string;
    tiempo_sesion: real;
  end;

  ArchivoMaestro = file of Sesion;
  ArchivoDetalle = file of Sesion;

  VectorArchivoDetalle = array[1..dimF] of ArchivoDetalle;
  VectorRegistroDetalle = array [1..dimF] of Sesion;

{ Modulos }

  procedure generarVectorDetalles(var v: VectorArchivoDetalle);

    Procedure crearArchivoDetalle(var detalle: ArchivoDetalle);

    Type 
      lSesiones = ^nSesiones;
      nSesiones = Record
        dato: Sesion;
        sig: lSesiones;
      End;

      Procedure leerSesion(Var s: Sesion);
      Begin
        With s Do
          Begin
            write('Ingrese codigo de usuario: ');
            readln(cod_usuario);
            If (cod_usuario <> -1) Then
              Begin
                write('Ingrese fecha de la sesion: '); readln(fecha);
                write('Ingrese tiempo de la sesion: '); readln(tiempo_sesion);
              End;
          End;
      End;

      Procedure insertarOrdenado(Var l: lSesiones; s: Sesion);
      Var 
        nue,ant,act: lSesiones;
      Begin
        new(nue);
        nue^.dato := s;
        nue^.sig := Nil;
        ant := Nil;
        act := l;
        While (act <> Nil) And ((act^.dato.cod_usuario < s.cod_usuario) or ((act^.dato.cod_usuario = s.cod_usuario) and (act^.dato.fecha < s.fecha))) Do
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

      Procedure cargarArchivoDetalle(Var detalle: ArchivoDetalle; l: lSesiones);
      Begin
        While (l <> Nil) Do
          Begin
            write(detalle,l^.dato);
            l := l^.sig;
          End;
      End;
    
    Var 
      s: Sesion;
      pri: lSesiones;
    Begin
      pri := Nil;
      Rewrite(detalle);
      leerSesion(s);
      While (s.cod_usuario <> -1) Do Begin
        insertarOrdenado(pri,s);
        leerSesion(s);
      End;
      cargarArchivoDetalle(detalle,pri);
      close(detalle);
      writeln('Archivo detalle creado exitosamente');
    End;

  var
    i: integer;
    nombre, strI: string;
  begin
    for i := 1 to dimF do begin
      Str(i, strI); 
      nombre := 'detalle' + strI + '.bin';
      Assign(v[i], nombre);
      crearArchivoDetalle(v[i]);
    end;
  end;

  procedure leer(var detalle: ArchivoDetalle; var dato: Sesion);
  begin
    if(not(Eof(detalle))) then
      read(detalle,dato)
    else
      dato.cod_usuario := valorAlto;
  end;

  procedure minimo(var vD: VectorArchivoDetalle; var vR: VectorRegistroDetalle; var minRegD: Sesion);
  var 
    i,minCod,pos:integer;
    minFecha: string;
  begin
    minCod := valorAlto;
    minFecha := 'ZZZ';
    pos := -1;
    for i := 1 to dimF do begin
      if(vR[i].cod_usuario < minCod) or ((vR[i].cod_usuario = minCod) and (vR[i].fecha < minFecha)) then begin
        minCod := vR[i].cod_usuario;
        minFecha := vR[i].fecha;
        minRegD :=  vR[i];
        pos := i;
      end;
    end;
    if(minCod <> valorAlto) then
      leer(vD[pos],vR[pos]);
  end;

  procedure generarArchivoMaestro(var maestro: ArchivoMaestro; vD: VectorArchivoDetalle);
  var
    i,codAct: integer;
    fechaAct: string;
    regM,minRegD: Sesion;
    vR: VectorRegistroDetalle;
    totSesion: real;
  begin
    Rewrite(maestro);
    for i := 1 to dimF do begin
      Reset(vD[i]);
      leer(vD[i],vR[i]);
    end;
    minimo(vD,vR,minRegD);
    while (minRegD.cod_usuario <> valorAlto) do begin
      codAct := minRegD.cod_usuario;
      while (minRegD.cod_usuario = codAct) do begin
        fechaAct := minRegD.fecha;
        totSesion := 0;
        while (minRegD.cod_usuario = codAct) and (minRegD.fecha = fechaAct) do begin
          totSesion := totSesion + minRegD.tiempo_sesion;
          minimo(vD,vR,minRegD);
        end;
        regM.cod_usuario := codAct;
        regM.fecha := fechaAct;
        regM.tiempo_sesion := totSesion;
        write(maestro,regM);
      end;
    end;
    close(maestro);
    for i := 1 to dimF do close(vD[i]); 
    Writeln('Archivo Actualizado con exito.');
  end;

  procedure generarReporteLogs(var maestro: ArchivoMaestro);
  var
    carga: Text;
    s: Sesion;
  begin
    Assign(carga,'reporteLogs.txt');
    Reset(maestro);
    Rewrite(carga);
    writeln(carga,'****REPORTE DE LOGS****');
    writeln(carga,'========================');
    while(not(Eof(maestro))) do begin
      read(maestro,s);
      writeln(carga,'Usuario Nro: ',s.cod_usuario,' - Fecha: ',s.fecha,' - Tiempo total de Sesiones: ',s.tiempo_sesion:0:2,' min.');
      read(maestro,s);
    end;
    writeln(carga,'======================================================');
    writeln('reporte generado exitosamente.');
    close(maestro);
    close(carga);
  end;

{ Programa Principal}
var
  mae1: ArchivoMaestro;
  vD: VectorArchivoDetalle;
  num: integer;
begin
  Assign(mae1,'maestro.bin');
  repeat
    writeln('***MENU DE OPCIONES***');
    writeln('1.- Generar archivos detalle.');
    writeln('2.- Generar archivo Maestro.');
    writeln('3.- Generar reporte de Logs.');
    writeln('(-1) - Finalizar Programa.');
    Write('Opcion elegida: '); readln(num);
    case num of
      1: generarVectorDetalles(vD);
      2: generarArchivoMaestro(mae1,vD);
      3: generarReporteLogs(mae1);
    end;
  until (num = -1);
  Writeln('Programa finalizado');
end.