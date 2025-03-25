
{3. Realizar un programa que presente un menú con opciones para:
  a. Crear un archivo de registros no ordenados de empleados y completarlo con datos ingresados desde teclado. De cada empleado se registra: número de empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
  b. Abrir el archivo anteriormente generado y
    i. Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado, el cual se proporciona desde el teclado.
    ii. Listar en pantalla los empleados de a uno por línea.
    iii. Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse.
NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario.}

Program ejercicio3;

const corte = 'fin'

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
  writeln('Ingrese el apellido del empleado: ');
  readln(e.apellido);
  if(e.apellido <> corte) then
    begin
      
    end;
end;


procedure cargarArchivoEmpleados(var Empleados: ArchivoEmpleados);
var
  e: Empleado;
begin
  leerEmpleado(e);
  while(e.apellido <> corte) do
    begin
      write(Empleado,e);
      leerEmpleado(e);
    end;
    close(Empleado);
end;


{programa principal}
var
  Empleados: ArchivoEmpleados;
  nomArch: string[12];
begin
  write('Ingrese el nombre del archivo: ');
  readln(nomArch);
  Assign(Empleados,nomArch);
  rewrite(Empleados);
  cargarArchivoEmpleados(Empleados);
end;