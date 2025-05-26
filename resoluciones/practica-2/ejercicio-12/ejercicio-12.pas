program ejercicio_12_P2;

const
	valorAlto = 9999;


type
	
	Fecha = record
		dia: 1..31;
		mes: 1..12;
		anio: integer;
	end;

	Acceso = record
		fecha: Fecha;
		idUsuario: integer;
		tiempoAcceso: real;
	end;

	ArchivoMaestro = file of Acceso;

{modulos}
procedure leerMaestro(var maestro: ArchivoMaestro; var dato: Acceso);
begin
	if(not(Eof(maestro))) then
		read(maestro,dato)
	else
		dato.fecha.anio := valorAlto;
end;

procedure generarReporte(var maestro: ArchivoMaestro; anio: integer);
var
	RegM: Acceso;
	mesAct,diaAct,usuarioAct: integer;
	totAnio,totMes,totDia,totUsuario: real;
begin
	Reset(maestro);
	leerMaestro(maestro,regM);
	while (regM.fecha.anio <> valorAlto) and (regM.fecha.anio < anio) do
		leerMaestro(maestro,regM);

	if (regM.fecha.anio = anio) then begin
		writeln('Anio ',anio);

		totAnio := 0;
		while (regM.fecha.anio = anio) do begin
			mesAct := regM.fecha.mes;
			writeln('   Mes ',mesAct);

			totMes := 0;
			while (regM.fecha.anio = anio) and (regM.fecha.mes = mesAct) do begin
				diaAct := regM.fecha.dia;
				writeln('       Dia ',diaAct);


				totDia := 0;
				while (regM.fecha.anio = anio) and (regM.fecha.mes = mesAct) and (regM.fecha.dia = diaAct) do begin
					usuarioAct := regM.idUsuario;

					totUsuario := 0;
					while (regM.fecha.anio = anio) and (regM.fecha.mes = mesAct) and (regM.fecha.dia = diaAct) and (RegM.idUsuario = usuarioAct) do begin
						totUsuario := totUsuario + regM.tiempoAcceso;
						leerMaestro(maestro,regM);						
					end;
					
					totDia := totDia + totUsuario;
					WriteLn('Id Usuario ',usuarioAct,' - Tiempo Total de Acceso en el dia ',diaAct,' mes ',mesAct,' - ',totUsuario);				
				end;
				totMes := totMes + totDia;
				writeln('Tiempo total de acceso dia: ',diaAct,' - ',totDia,'.');
			end;
			totAnio := totAnio + totMes;
			WriteLn('Total tiempo de Acceso Mes ',mesAct,' - ',totMes);
		end;
		writeln('Tiempo total de acceso anio: ',anio,' - ',totAnio,'.');
	end
	else
		writeln('El anio no fue encontrado.');
	close(maestro);
end;


{Programa principal}
var
	maestro: ArchivoMaestro;
	anio: integer;
begin
	Assign(maestro,'maestro.bin');
	write('Ingrese el anio a buscar: '); readln(anio);
	generarReporte(maestro,anio);
end.
