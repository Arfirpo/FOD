program ejercicio_13_P2;

const
	valorAlto = 9999;

type
	str10= string[10];
	str30= string[30];
	Log = record
		nro_usuario: integer;
		nombreUsuario: str10;
		nombre: str10;
		apellido: str10;
		cantMailsenviados: integer;
	end;
	Correo = record
		nro_usuario: integer;
		cuentaDestino: str10;
		cuerpoMensaje: str30;
	end;

	ArchivoMaestro = file of Log;
	ArchivoDetalle = file of Correo;

{modulos}

procedure leerMaestro(var maestro: ArchivoMaestro; var dato: Log);
begin
	if(not(Eof(maestro)))
		read(maestro,dato)
	else
		dato.nro_usuario := valorAlto;
end;

procedure leerDetalle(var detalle: ArchivoDetalle; var dato: Correo);
begin
	if(not(Eof(detalle)))
		read(detalle,dato)
	else
		dato.nro_usuario := valorAlto;
end;

procedure actualizarMaestro(var maestro: ArchivoMaestro; var detalle: ArchivoDetalle);
var
	regM: Log;
	regDet: Correo;
	userAct,totMailsEnviados: integer;
begin
	Reset(maestro);
	Reset(detalle);
	leerDetalle(detalle,regD);
	while(regD.nro_usuario <> valorAlto) do begin
		userAct := regD.nro_usuario;

		totMailsEnviados := 0;
		while(regD.nro_usuario = userAct) do begin
			totMailsEnviados := totMailsEnviados + 1;
			leerDetalle(detalle,regD);
		end;

		leerMaestro(maestro,regM);
		while(regM.nro_usuario <> userAct) do
			leerMaestro(maestro,regM);
		
		regM.cantMailsenviados := regM.cantMailsenviados + totMailsEnviados;
		seek(maestro,filepos(maestro) - 1);
		write(maestro,regM);
	end;
	close(maestro);
	close(detalle);
end;

procedure generarReporte(var maestro: ArchivoMaestro);
var
	carga: Text;
	regM: Log;
begin
	Reset(maestro);
	Assign(carga,'registroMailsDiario.txt');
	Rewrite(carga);
	leerMaestro(maestro,regM);
	writeln(carga,'*** REGISTRO DE MAILS ENVIADOS ***');
	while (regM.nro_usuario <> valorAlto) do begin
		writeln(carga,'Usuario ',regM.nro_usuario,' - Cantidad Mensajes enviados: ',regM.cantMailsenviados,'.');
		leerMaestro(maestro,regM);
	end;
	close(maestro);
	close(carga);
end;

procedure actualizarMaestroYGenerarReporte(var maestro: ArchivoMaestro; var detalle: ArchivoDetalle);
var
  regM: Log;
  regD: Correo;
  userAct, totMailsEnviados: integer;
  reporte: Text;
begin
  Reset(maestro);
  Reset(detalle);
  Assign(reporte, 'registroMailsDiario.txt');
  Rewrite(reporte);
  writeln(reporte, '*** REGISTRO DE MAILS ENVIADOS ***');

  leerDetalle(detalle, regD);
  leerMaestro(maestro, regM);

  while (regM.nro_usuario <> valorAlto) do begin
    userAct := regM.nro_usuario;
    totMailsEnviados := 0;

    // Acumular los correos enviados por este usuario
    while (regD.nro_usuario = userAct) do begin
      totMailsEnviados := totMailsEnviados + 1;
      leerDetalle(detalle, regD);
    end;

    // Actualizar el maestro
    regM.cantMailsenviados := regM.cantMailsenviados + totMailsEnviados;
    seek(maestro, filepos(maestro) - 1);
    write(maestro, regM);

    // Escribir en el reporte
    writeln(reporte, 'Usuario ', regM.nro_usuario, ' - Cantidad Mensajes enviados: ', regM.cantMailsenviados, '.');

    // Leer siguiente registro del maestro
    leerMaestro(maestro, regM);
  end;

  close(maestro);
  close(detalle);
  close(reporte);
end;


{Programa Principal}
var
	mae1: ArchivoMaestro;
	det1: ArchivoDetalle;
begin
	Assign(mae1,'/var/log/logmail.dat');
	Assign(det1,'detalle.bin');
	actualizarMaestro(mae1,det1);
	generarReporte(mae1);
	actualizarMaestroYGenerarReporte(mae1,det1);
end;