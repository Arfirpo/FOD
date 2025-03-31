{4. Agregar al menú del programa del ejercicio 3, opciones para:
a. Añadir uno o más empleados al final del archivo con sus datos ingresados por teclado. Tener en cuenta que no se debe agregar al archivo un empleado con un número de empleado ya registrado (control de unicidad).
b. Modificar la edad de un empleado dado.
c. Exportar el contenido del archivo a un archivo de texto llamado “todos_empleados.txt”.
d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados que no tengan cargado el DNI (DNI en 00).
NOTA: Las búsquedas deben realizarse por número de empleado.}

Program ejercicio4;

const corte = 'fin';

Type 
  str20 = string[20];

  Empleado = Record
    nro: integer;
    apellido: str20;
    nombre: str20;
    edad: integer;
    dni: longint;
  End;

  ArchivoEmpleados = file of Empleado;

{modulos}


procedure leerEmpleado(var e: Empleado);
begin
  with e do begin
    write('Ingrese el apellido del empleado: '); readln(apellido);
    if(apellido <> corte) then begin
      write('Ingrese el nombre del empleado: '); readln(nombre);
      write('Ingrese el Nro del empleado: '); readln(nro);
      write('Ingrese el dni del empleado: '); readln(dni);
      write('Ingrese la edad del empleado: '); readln(edad);
    end;
  end;
end;

procedure crearArchivoEmpleados();

  procedure cargarArchivoEmpleados(var Empleados: ArchivoEmpleados);
  
  var
    e: Empleado;
  begin
    leerEmpleado(e);
    while(e.apellido <> corte) do
      begin
        write(Empleados,e);
        writeln();
        leerEmpleado(e);
      end;
  end;

var
  Empleados: ArchivoEmpleados;
  nombre: string[10];
begin
  writeln();
  write('Ingrese el nombre del archivo: ');
  readln(nombre);
  writeln();
  Assign(Empleados,nombre);
  rewrite(Empleados);
  cargarArchivoEmpleados(Empleados);
  close(Empleados);
  writeln('Archivo creado exitosamente');
end;

procedure procesarArchivoEmpleados();

  procedure imprimirEmpleado(e: Empleado);
  begin
    writeln('Nombre: ',e.nombre);
    writeln('Apellido: ',e.apellido);
    writeln('DNI: ',e.dni);
    writeln('Numero de Empleado: ',e.nro);
    writeln('Edad: ',e.edad);
  end;

  procedure buscarEmpleado(var Empleados: ArchivoEmpleados; nomOape: str20);
  var alMenosUno: boolean; e: Empleado;
  begin
    alMenosUno := false;
    reset(Empleados);
    writeln();
    writeln('--- Lista de Empleados con Nombre/Apellido: ',nomOape,'  ---');
    writeln();
    while not EOF(Empleados) do
    begin
      read(Empleados,e);
      if(e.nombre = nomOape) or (e.apellido = nomOape) then
      begin
        if not alMenosUno then alMenosUno := true;
        imprimirEmpleado(e);        
      end;
    end;

    if not alMenosUno then writeln('No se encontro ningun empleado con ese Nombre/Apellido.');
  end;

  procedure listaDeEmpleados(var Empleados: ArchivoEmpleados);
  var e: Empleado; alMenosUno: boolean;
  begin
    alMenosUno := false;
    reset(Empleados);
    writeln();
    writeln('--- Lista de Empleados ---');
    writeln();
    while not(eof(Empleados)) do
    begin
      read(Empleados,e);
      if e.apellido <> '' then 
      begin
        if not alMenosUno then alMenosUno := true;          
        imprimirEmpleado(e);
      end; 
      writeln();
    end;
  end;

  procedure listaJubilacion(var Empleados: ArchivoEmpleados);
  var e: Empleado; alMenosUno: boolean;
  begin

    alMenosUno := false;
    reset(Empleados);

    writeln();
    writeln('--- Lista de Empleados proximos a Jubilarse ---');
    writeln();
    while not(eof(Empleados)) do
    begin
      read(Empleados,e);
      if(e.edad > 70) then 
      begin
        if not alMenosUno then alMenosUno := true;
        imprimirEmpleado(e);
        writeln();  
      end;
    end;
    if not alMenosUno then writeln('No existen empleados proximos a la edad jubilatoria.')
  end;

  procedure agregarEmpleados(var Empleados: ArchivoEmpleados);

    function numeroLibre(var Empleados: ArchivoEmpleados; num: integer): boolean;
    var 
      e: Empleado; 
      ok: Boolean;
    begin
      Reset(Empleados); // Reset to beginning of file
      ok := true;
      while not(Eof(Empleados)) and ok do begin
        Read(Empleados,e);
        if(e.nro = num) then ok := false;
      end;
      numeroLibre := ok;
    end;

  var 
    e: Empleado;
  begin
    Reset(Empleados);
    Seek(Empleados, FileSize(Empleados)); // Position at end of file
    leerEmpleado(e);
    while e.apellido <> corte do begin
      if numeroLibre(Empleados, e.nro) then begin
        Seek(Empleados, FileSize(Empleados)); // Reset position to end of file
        Write(Empleados, e);
      end
      else
        writeln('Error: Numero de empleado ya existe');
        WriteLn();
      leerEmpleado(e);
    end;
  end;

  procedure actualizarEdadEmpleado(var Empleados: ArchivoEmpleados);
  var e: Empleado; num: integer; esta: boolean;
  begin
    Reset(Empleados);
    esta := false;
    WriteLn();
    Write('Ingrese numero de empleado: '); readln(num);
    while not(Eof(Empleados)) and not(esta) do begin
      Read(Empleados,e);
      if e.nro = num then begin
        esta := true;
        WriteLn();
        Write('Ingrese edad del Empleado: '); ReadLn(e.edad);
        Seek(Empleados,FilePos(Empleados) - 1);
        write(Empleados,e);
      end;
    end;
    if Eof(Empleados) and not(esta) then begin
      WriteLn();
      WriteLn('El empleado con numero ',num,' no existe.');
    end;
  end;

var
  nombre: string[10];
  Empleados: ArchivoEmpleados;
  opc: integer;
  nomOape: str20;
begin
  writeln();
  write('Ingrese el nombre del archivo a leer: '); readln(nombre);
  Assign(Empleados,nombre);
  writeln();
  writeln('-- Archivo de ',nombre,' --');
  writeln();

  repeat
    writeln();
    writeln('-- Opciones --');
    writeln();
    writeln('1.- Buscar empleado por nombre o apellido.');
    writeln('2.- Ver lista de empleados completa.');
    writeln('3.- Ver lista de empleados proximos a jubilarse.');
    writeln('4.- Agregar empleados al archivo.');
    writeln('5.- Actualizar edad de un empleado.');
    writeln('0.- Salir.');
    writeln();
    repeat
      write('Opcion elegida: '); readln(opc);
      writeln();
      if (opc < 0) or (opc > 5) then
      begin
        writeln('Opcion incorrecta. Intente nuevamente. -0 para salir-');
        writeln();
      end;
    until (opc >= 0) and (opc <= 5);
    case opc of
      1:  begin
            write('Inrese Nombre/Apellido del Empleado buscado: '); readln(nomOape);
            buscarEmpleado(Empleados,nomOape);
          end;
      2: listaDeEmpleados(Empleados);
      3: listaJubilacion(Empleados);
      4: agregarEmpleados(Empleados);
      5: actualizarEdadEmpleado(Empleados);
      0: break;
    end;
  until false;
  
  close(Empleados);
  
end;

{programa principal}
var
  opcion: integer;
begin
  repeat
    writeln();
    writeln('---- Menu Principal ----');
    writeln();
    writeln('1.-Crear Archivo de empleados.');
    writeln('2.-Abrir archivo ya creado.');
    writeln();
    repeat
      write('Opcion elegida -0 para salir-: '); readln(opcion);
      if ((opcion > 2) or (opcion < 0)) then
        writeln('Valor incorrecto. Intente nuevamente.')
    until (opcion = 1) or (opcion = 2) or (opcion = 0);
    if(opcion = 1) then crearArchivoEmpleados()
    else if(opcion = 2) then procesarArchivoEmpleados()
  until (opcion = 0);
End.