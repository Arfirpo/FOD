program ejercicio_6_P3;

const
  valorAlto = 9999;

type
  str10 = string[10];
  str20 = string[20];
  Prenda = record
    codPrenda: integer;
    descripcion: str20;
    colores: str10;
    tipoPrenda:str10;
    stock: integer;
    pUnitario: real;
  end;
  ArchivoMaestro = file of Prenda;
  ArchivoDetalle = file of Integer;

{modulos}
procedure leerDetalle(var codPrendas: ArchivoDetalle; var dato: integer);
begin
  if(not(Eof(codPrendas))) then
    read(codPrendas,dato)
  else
    dato := valorAlto;
end;

procedure leerMaestro(var maestro: ArchivoMaestro; var dato: Prenda);
begin
  if(not(Eof(maestro))) then
    read(maestro,dato)
  else
    dato.codPrenda := valorAlto;
end;

procedure actualizarMaestro(var maestro: ArchivoMaestro; var detalle: ArchivoDetalle);

  procedure bajaLogica(var maestro: ArchivoMaestro; var detalle: ArchivoDetalle);
  var
    regM: Prenda;
    regD: integer;
    encontre: Boolean;
  begin
    Reset(maestro);
    Reset(detalle);
    leerDetalle(detalle,regD);
    while (regD <> valorAlto) do begin
      Seek(maestro,0);
      leerMaestro(maestro,regM);
      encontre := false;
      while (regM.codPrenda <> valorAlto) and not(encontre) do begin
        if(regM.codPrenda = regD) then begin
          regM.stock := -Abs(regM.stock);
          Seek(maestro,FilePos(maestro) - 1);
          write(maestro,regM);
          encontre := True;
        end
        else
          leerMaestro(maestro,regM);
      end;
      leerDetalle(detalle,regD);
    end;
    Close(maestro);
    Close(detalle);
  end;

  procedure actualizarConBajas(var maestro: ArchivoMaestro);
  var
    maestro2: ArchivoMaestro;
    regM: Prenda;
  begin
    Reset(maestro);
    Assign(maestro2,'maestroActualizado.bin');
    Rewrite(maestro2);
    leerMaestro(maestro,regM);
    while (regM.codPrenda <> valorAlto) do begin
      if not(regM.stock < 0) then
        write(maestro2,regM);
      leerMaestro(maestro,regM);
    end;
    close(maestro);
    close(maestro2);
    Erase(maestro);
    Rename(maestro2,'maestro.bin');
  end;


var
begin
  bajaLogica(maestro,detalle);
  actualizarConBajas(maestro);
end;


{Programa Principal}
var
  mae1: ArchivoMaestro;
  det1: ArchivoDetalle;
begin
  Assign(mae1,'maestro.bin');
  Assign(det1,'detalle.bin');
  actualizarMaestro(mae1,det1);
  WriteLn('Archivo maestro actualizado.');
End.