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

procedure agregarFlor(var flores: tArchFlores; nombre: String; codigo: integer);
var 
  nuevo,cabecera,libre: reg_flor;
  posLibre: integer;
begin
  Reset(flores);
  nuevo.codigo := codigo;
  nuevo.nombre := nombre;
  leer(flores,cabecera);

  if(cabecera.codigo < 0) then begin
    posLibre := -cabecera.codigo;
    Seek(flores,posLibre);
    Read(flores,libre);
    Seek(flores,posLibre);
    Write(flores,nuevo);
    Seek(flores,0);
    Write(flores,libre);
  end
  else begin
    Seek(flores,FileSize(flores));
    Write(flores,nuevo);
  end;
  Close(flores);
end;

procedure listarContenido(var flores: tArchFlores);
var 
  f: reg_flor;
begin
  Reset(flores);
  leer(flores,f);
  WriteLn('**** LISTADO DE FLORES ****');
  WriteLn('===========================');
  while (f.codigo <> valorAlto) do begin
    if not(f.codigo < 1) then begin
      WriteLn('Flor: ',f.nombre,' | Codigo: ',f.codigo,'.');
      WriteLn('---------------------');
    end;
    leer(flores,f);
  end;
  WriteLn('===========================');
  Close(flores);
end;


{Programa Principal}
var
  flores: tArchFlores;
  nom: String;
  nomFlor: string[45];
  cod: integer;
  f: reg_flor;
Begin
  Write('Ingrese el nombre del archivo a abrir: '); 
  Readln(nom);
  nom := nom + '.bin';
  Assign(flores,nom);
  Rewrite(flores);
  f.codigo := 0; //codigo cabecera
  write(flores,f); //guardo la cabecera
  Write('Ingresar codigo de flor: '); Readln(cod);
  while (cod <> -1) do begin
    Write('Ingrese nombre de la flor: '); ReadLn(nomFlor);
    agregarFlor(flores,cod,nomFlor);
    Write('Ingresar codigo de flor: '); Readln(cod);
  end;
End.