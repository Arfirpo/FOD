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

  Curso = record
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

  procedure leerCurso(var detalleC: ArchivoDetalleCursadas; var dato: Curso);
  begin
    if(not(Eof(detalleC))) then
      read(detalleC,dato)
    else
      dato.codAlu := valorAlto;
  end;

  procedure leerFinal(var detalleF: ArchivoDetalleFinales; var dato: Final);
  begin
    if(not(Eof(detalleF))) then
      read(detalleF,dato)
    else
      dato.codAlu := valorAlto;
  end;

  procedure actualizarMaestro(var maestro: ArchivoMaestro; var detC: ArchivoDetalleCursadas; var detF: ArchivoDetalleFinales);
  var
    regM: Alumno;
    regC: Curso;
    regF: Final;
    aluAct,matAct: integer;
    cantCursadasApro,cantFinalesAprob: integer;
  begin
    Reset(maestro);
    Reset(detC);
    Reset(detF);
    leerCurso(detC,regC);
    leerFinal(detF,regF);
    while(not(Eof(maestro))) do begin
      read(maestro,regM);
      aluAct := regM.codAlu;

      cantCursadasApro := 0;
      while (regC.codAlu <> valorAlto) and (regC.codAlu = aluAct) do begin
        matAct := regC.codMat;
        while (regC.codAlu <> valorAlto) and (regC.codAlu = aluAct) and (regC.codMat = matAct) do begin
          if(regC.resultado) then cantCursadasApro := cantCursadasApro + 1;
          leerCurso(detC,regC);
        end;
      end;

      cantFinalesAprob := 0;
      while (regF.codAlu <> valorAlto) and (regF.codAlu = aluAct) do begin
        matAct := regF.codMat;
        while (regF.codAlu <> valorAlto) and (regF.codAlu = aluAct) and (regF.codMat = matAct) do begin
          if(regF.nota >= 4) then cantFinalesAprob := cantFinalesAprob + 1;
          leerFinal(detF,regF);
        end;
      end;

      regM.cursadasAprob := regM.cursadasAprob + cantCursadasApro;
      regM.finalesAprob := regM.finalesAprob + cantFinalesAprob;

      Seek(maestro,filepos(maestro) - 1);
      write(maestro,regM);
    end;
    close(maestro);
    close(detC);
    close(detF);
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