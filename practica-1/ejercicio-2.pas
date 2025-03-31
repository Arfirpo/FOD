{Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados creado en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y el promedio de los números ingresados. El nombre del archivo a procesar debe ser proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el contenido del archivo en pantalla.}

Program ejercicio_2_P1;

Type 
  archivoEnteros = file Of integer;

{modulos}
Procedure leerArchivo(Var Enteros: archivoEnteros);

Var 
  entero,cant,menor: integer;
  prom: real;
Begin
  cant := 0;
  menor := 0;
  prom := 0;

  reset(Enteros);

  writeln('Lista de numeros enteros: ');
  While Not(eof(Enteros)) Do
    Begin
      read(Enteros,entero);
      cant += 1;
      prom += entero;
      If (entero < 1500) Then
        menor += 1;
      writeln(entero);
    End;
  prom := prom / filesize(Enteros);
  close(Enteros);

  writeln();
  writeln('La cantidad de numeros menores a 1500 fue de: ',menor);
  writeln('El promedio de los numeros ingresados fue de: ',prom:0:1);
End;

{programa principal}

Var 
  Enteros: archivoEnteros;
  arch: string[15];

Begin
  write('Ingrese el nombre del archivo a buscar: ');
  readln(arch);
  Assign(Enteros,arch);
  leerArchivo(Enteros);
End.
