program ejercicio_7_P2;

const
  valorAlto = 9999;

type
  str10 = string[10];
  str4 = string[4];
  rangoNotas = 0..10;

  Alumno = record
    codAlu: integer;
    ape: str10;
    nom: str10;
    cursadasAprob:integer;
    finalesAprob: integer;
  end;

  Curso = registro
    codAlu: integer;
    codMat: integer;
    anioCursada: str4;
    resultado: boolean;
  end;

  Final = record
    codAlu: integer;
    codMat: integer;
    fechaExamen: str10;
    nota: rangoNotas;
  end;

  ArchivoMaestro = file of Alumno;
  ArchivoDetalleCursadas = file of Curso;
  ArchivoDetalleFinales = file of Final;

  {modulos}

  procedure leer(var maestro: ArchivoMaestro; var dato: Alumno);
  begin
    if(not(Eof(demaestrotC))) then
      read(maestro,dato)
    else
      dato.codAlu := valorAlto;
  end;

  procedure actualizarMaestro(var maestro: ArchivoMaestro; var detC: ArchivoDetalleCursadas; var detF: ArchivoDetalleFinales);
  var
    regM: Alumno;
    regC: Curso;
    regF: Final;
    aluAct: integer;
  begin
    Reset(maestro);
    Reset(detC);
    Reset(detF);
    leer(maestro,regM);
    while(regM.codAlu <> valorAlto) do begin
      aluAct := regM.codAlu;
      read(detC,regC);
      while (regC.codAlu <> aluAct) do
        read(detC,regC);
      read(detF,regF);
      while (regF.codAlu <> aluAct) do
        read(detF,regF);
    end;
  end;

  {Programa Principal}
  var
    maestro: ArchivoMaestro;
    detC: ArchivoDetalleCursadas;
    detF: ArchivoDetalleFinales;
  begin
    Assign(maestro,'maestro.bin');
    Assign(detC,'detalleCursadas.bin');
    Assign(detF,'detalleFinales.bin');
    actualizarMaestro(maestro,detC,detF);
  end;