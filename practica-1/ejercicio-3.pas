
{3. Realizar un programa que presente un menú con opciones para:
  a. Crear un archivo de registros no ordenados de empleados y completarlo con datos ingresados desde teclado. De cada empleado se registra: número de empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
  b. Abrir el archivo anteriormente generado y
    i. Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado, el cual se proporciona desde el teclado.
    ii. Listar en pantalla los empleados de a uno por línea.
    iii. Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse.
NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario.}

Program ejercicio3;

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

procedure crearArchivoEmpleados();

  procedure cargarArchivoEmpleados(var Empleados: ArchivoEmpleados);
  
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
    writeln('3.- Lista de empleados proximos a jubilarse.');
    writeln('0.- Salir.');
    writeln();
    repeat
      write('Opcion elegida: '); readln(opc);
      writeln();
      if (opc < 0) or (opc > 3) then
      begin
        writeln('Opcion incorrecta. Intente nuevamente. -0 para salir-');
        writeln();
      end;
    until (opc = 0) or (opc = 1) or (opc = 2) or (opc = 3);
    case opc of
      1:  begin
            write('Inrese Nombre/Apellido del Empleado buscado: '); readln(nomOape);
            buscarEmpleado(Empleados,nomOape);
          end;
      2: listaDeEmpleados(Empleados);
      3: listaJubilacion(Empleados);
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