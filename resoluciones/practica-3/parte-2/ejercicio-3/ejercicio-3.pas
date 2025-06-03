program ejercicio_3_P3_P2;

const
  valorAlto = 9999;
  dimF = 5;
type

  Sesion = record
    cod_usuario: integer;
    fecha: string;
    tiempo_sesion: real;
  end;

  Usuario = record
    cod_usuario: integer;
    fechas: lFechas;
  end;

  ArchivoMaestro = file of Sesion;
  ArchivoDetalle = file of Sesion;

  VectorArchivoDetalle = array[1..dimF] of ArchivoDetalle;

  lUsuarios = ^nUsuarios;
  nUsuarios = record
    dato: Usuario;
    sig: lUsuarios;
  end;

  lFechas = ^nFechas;
  nFechas = record
    dato: string;
    sig: lFechas;
  end;
{ Modulos }    

  procedure leer(var detalle: ArchivoDetalle; var dato: Sesion);
  begin
    if(not(Eof(detalle))) then
      read(detalle,dato)
    else
      dato.cod_usuario := valorAlto;
  end;


  procedure agregarFecha(var l: lFechas; fecha: string);
  var nue: lFechas;
  begin
    new(nue);
    nue^.dato := fecha;
    nue^.sig := l;
    l := nue;
  end;

  procedure agregarCodUsuario(var l: lUsuarios; codUsuario: integer);
  var nue: lUsuarios;
  begin
    new(nue);
    nue^.dato := codUsuario;
    nue^.sig := l;
    l := nue;
  end;

  function buscarCodigo(l: lUsuarios; codigo: integer): boolean;
  var 
    ok: boolean;
    act: lCodigos;
  begin
    ok := false
    act := l;
    while (act <> nil) and not(ok) do begin
      if(act^.cod_usuario = codigo) then
        ok := true;
      act := act^.sig;
    end;
    buscarCodigo := ok;
  end;

  function buscarFecha(l: lFechas; fecha: string): boolean;
  var 
    ok: boolean;
    act: lFechas;
  begin
    ok := false
    act := l;
    while (act <> nil) and not(ok) do begin
      if(act^.dato = fecha) then
        ok := true;
      act := act^.sig;
    end;
    buscarCodigo := ok;
  end;

  procedure generarArchivoMaestro(var maestro: ArchivoMaestro; vD: VectorArchivoDetalle);
  var
    i,codAct: integer;
    fechaAct: string;
    regM,regD: Sesion;
    totSesion: real;
    encontrado: boolean;
  begin
    Rewrite(maestro);
    // Procesar cada archivo detalle (uno por máquina)
    for i := 1 to dimF do begin
      Reset(vD[i]);
      leer(vD[i],regD);
      // Procesar cada registro del archivo detalle actual
      while (regD.cod_usuario <> valorAlto) do begin
        // Buscar si ya existe una entrada para este usuario y fecha
        encontrado := false;
        seek(maestro,0);
        while (not(Eof(maestro))) and (not(encontrado)) do begin
          read(maestro,regM);
          // Verificar si coinciden usuario y fecha
          if (regM.cod_usuario = regD.cod_usuario) and (regM.fecha = regD.fecha) then begin
            encontrado := true;
             // Acumular el tiempo de sesión
            regM.tiempo_sesion := regM.tiempo_sesion + regD.tiempo_sesion;
          end;
        end;
        // Si ya existia el usuario y la fecha, Actualizar registro existente
        if (encontrado) then begin
          Seek(maestro,filepos(maestro) - 1);
          write(maestro,regM);
        end
        //Sino, Crear nuevo registro en el maestro
        else begin
          regM.cod_usuario := regD.cod_usuario;
          regM.fecha := regD.fecha;
          regM.tiempo_sesion := regD.tiempo_sesion;

          Seek(maestro,filesize(maestro));
          write(maestro,regM);
        end;
      end;
      Close(vD[i]);
    end;
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