
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
        writeln('Ingrese el apellido del empleado: ');
        readln(apellido);
        if(apellido <> corte) then begin
          writeln('Ingrese el Nro del empleado: ');
          readln(nro);
          writeln('Ingrese el nombre del empleado: ');
          readln(nombre);
          writeln('Ingrese el dni del empleado: ');
          readln(dni);
          writeln('Ingrese la edad del empleado: ');
          readln(edad);
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
        leerEmpleado(e);
      end;
  end;

var
  Empleados: ArchivoEmpleados;
  nombre: string[10];
begin
  write('Ingrese el nombre del archivo: ');
  readln(nombre);
  Assign(Empleados,nombre);
  rewrite(Empleados);
  cargarArchivoEmpleados(Empleados);
  close(Empleados);
end;

procedure procesarArchivoEmpleados()
var
  nombre: string[10];
  Empleados: ArchivoEmpleados;
begin 
  write('Ingrese el nombre del archivo a leer: ');
  readln(nombre);
  Assign(Empleados,nombre);
  reset(Empleados);
  leerEmpleados(Empleados);
  close(Empleados);
  
end;

{programa principal}
var
  opcion: integer;
begin
  writeln('---- Menu ----');
  writeln('Ingrese el numero de la opcion elegida.');
  writeln('1.-Crear Archivo de empleados.');
  writeln('2.-Abrir archivo ya creado.');
  repeat
    write('Opcion elegida -0 para salir-: ');
    readln(opcion);
    if ((opcion > 2) or (opcion < 0)) then
      writeln('Valor incorrecto. Intente nuevamente.')
  until (opcion = 1) or (opcion = 2) or (opcion = 0);
  if(opcion = 1) then crearArchivoEmpleados()
  else if(opcion = 2) then procesarArchivoEmpleados()
  
 
End.
