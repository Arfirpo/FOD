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

{Programa Principal}
var
  regM: empleado;
  regD: comision;
  mae1: maestro;
  det1: detalle;
  cantComision;
  codAct:integer;
begin
  Assign(mae1,'maestro');
  Assign(det1,'detalle');
  Reset(det1);
  Rewrite(maestro);
  while (not(Eof(det1))) do begin
    read(det1,regD);
    codAct = regD.cod_empleado;
    regM.cod_empleado = codAct;
    regM.nom = regD.nom;
    while (not(Eof(det1)) and (regD.cod_empleado = codAct)) do begin
      cantComision = cantComision + regD.comision;
      Read(det1,regD);
    end;
    regM.totComisiones = cantComision;
  

  end;
end.
