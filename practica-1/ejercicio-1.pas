
Program ejercicio1;

Type 
  archivo = file Of integer;

  Procedure agregarNumeros(Var arc: archivo);
  Var 
    nro: integer;
  Begin
    writeln('Ingrese un numero de teclado');
    readln(nro);
    While (nro <> 30000) Do
      Begin
        write(arc, nro);
        writeln('Ingrese un numero de teclado');
        readln(nro);
      End;
    close(arc);
  End;

Var 
  nombre: string[15];
  arc: archivo;
Begin
  writeln('Ingrese un nombre de archivo');
  readln(nombre);
  assign(arc, nombre);
  rewrite(arc);
  agregarNumeros(arc);
End.
