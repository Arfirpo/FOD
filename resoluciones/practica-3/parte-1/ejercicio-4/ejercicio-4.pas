program ejercicio_4_P3;

const
  valorAlto = 9999;

type
  reg_flor = record 
  nombre: String[45]; 
  codigo: integer; 
end; 
 
  tArchFlores = file of reg_flor;

{modulos}
procedure leer(var flores: tArchFlores; var dato: reg_flor);
begin
  if(not(Eof(flores))) then
    read(flores,dato)
  else
    dato.codigo := valorAlto;
end;


{Programa Principal}
var
  flores: tArchFlores;
  nom: String;
Begin
  Write('Ingrese el nombre del archivo a abrir: '); 
  Readln(nom);
  nom := nom + '.bin';
  Assign(flores,nom);
  agregarFlor(flores);
End.