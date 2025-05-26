program ejercicio_9_P2;

const
  valorAlto = 9999;
  anioActual = 2025;

type
  str10 = string[10];

  Fecha = record
    dia: 1..31;
    mes: 1..12;
    anio: 1950..anioActual;
  end;

  Cliente = record
    codCli: integer;
    nom: str10;
    ape: str10;
  end;

  Venta = record
    cliente: Cliente;
    fecha: Fecha;
    montoVenta: real;
  end;

ArchivoMaestro = file of Venta;

{modulos}

procedure leerMaestro(var maestro: ArchivoMaestro; var dato: Venta);
begin
  if(not(Eof(maestro))) then
    read(maestro,dato)
  else
    dato.cliente.codCli := valorAlto;
end;

procedure generarReporte(var maestro: ArchivoMaestro);
var
  regM: Venta;
  totMes,totAnio,totEmpresa: real;
  cliAct,anioAct,mesAct: integer;
begin
  Reset(maestro);
  leerMaestro(maestro,regM);
  totEmpresa := 0;
  while(regM.cliente.codCli <> valorAlto) do begin
    cliAct := regM.cliente.codCli;

    writeln('Cliente Nro ',cliAct,' - Nombre: ',regM.cliente.nom,' - Apellido: ',regM.cliente.ape,'.');

    while (regM.cliente.codCli = cliAct) do begin
      anioAct := regM.fecha.anio;
      totAnio := 0;

      while (regM.cliente.codCli = cliAct) and (regM.fecha.anio = anioAct) do begin
        
        mesAct := regM.fecha.mes;
        totMes := 0;

        while (regM.cliente.codCli = cliAct) and (regM.fecha.anio = anioAct) and (regM.fecha.mes = mesAct) do begin
          totMes := totMes + regM.montoVenta;
          leerMaestro(maestro,regM);
        end;

        if(totMes > 0) then
          writeln('El total comprado en el mes ',mesAct,' es de $',totMes:0:2,'.');
        totAnio := totAnio + totMes;

      end;  
      if(totAnio > 0) then
          writeln('El total comprado en el anio ',anioAct,' es de $',totAnio:0:2,'.');
      totEmpresa := totEmpresa + totAnio;
    end;  
  end;
  if(totEmpresa > 0) then
      writeln('El total obtenido por la Empresa es de $',totEmpresa:0:2,'.');
  close(maestro);
end;
{Programa Principal}
var
  mae1: ArchivoMaestro;
begin
  Assign(mae1,'maestro.bin');
  generarReporte(mae1);
end;