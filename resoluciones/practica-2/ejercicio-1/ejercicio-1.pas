program ejercicio_1_P2;

type
  str10 = string[10];
  comision = record
    cod_empleado: integer;
    nom: str10;
    comision: real;
  end;
  empleado = record
    cod_empleado: Integer;
    nom: str10;
    totComisiones: real;
  end;

  maestro = file of empleado;
  detalle = file of comision;


procedure crearArchivoMaestro(var det1: detalle; var mae1: maestro);
var
  regM: empleado;
  regD: comision;
  cantComision: real;
  codAct: integer;
begin
  Reset(det1);
  Rewrite(mae1); 
  
  if not Eof(det1) then begin  
    read(det1, regD);
    
    while not Eof(det1) do begin
      codAct := regD.cod_empleado;
      regM.cod_empleado := codAct;
      regM.nom := regD.nom;  
      
      cantComision := 0; 
      
      while (not Eof(det1)) and (regD.cod_empleado = codAct) do begin
        cantComision := cantComision + regD.comision;
        Read(det1, regD);
      end;
      regM.totComisiones := cantComision;
      write(mae1, regM);
    end;
  end;
  Close(det1);
  Close(mae1);
end;

{Programa Principal}
var
  mae1: maestro;
  det1: detalle;
begin
  Assign(mae1, 'maestro');
  Assign(det1, 'detalle');
  crearArchivoMaestro(det1, mae1);
end.