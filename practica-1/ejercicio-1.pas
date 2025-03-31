Program ejercicio1;

Type 
  archivo = file Of integer;

Procedure agregarNumeros(Var arc: archivo);

Var 
  nro: integer;
Begin
  write('Ingrese un numero de teclado: ');
  readln(nro);
  While (nro <> 30000) Do
    Begin
      write(arc, nro);
      write('Ingrese un numero de teclado: ');
      readln(nro);
    End;
  close(arc);
End;

Var 
  nombre: string[15];
  arch: archivo;
Begin
  write('Ingrese un nombre de archivo: ');
  readln(nombre);
  assign(arch, nombre);
  rewrite(arch);
  agregarNumeros(arch);
End.
