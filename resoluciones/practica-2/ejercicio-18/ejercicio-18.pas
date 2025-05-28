program ejercicio_18_P2;

const
	valoralto = 9999;
type
	str10 = string[10];
	Maestro = record
		codLoc: integer;
		nomLoc: str10;
		codMun: integer;
		nomMun: str10;
		codHosp: integer;
		nomHosp: integer;
		fecha: str10;
		cantPositivos: integer;
	end;

	Casos = record
		hospital: integer;
		municipio: integer;
		localidad: integer;
		provincia: integer;
	end;

	ArchivoMaestro = file of Maestro;

{modulos}
procedure leerMaestro(var maestro: ArchivoMaestro; var dato: Maestro);
begin
	if(not(Eof(maestro))) then
		read(maestro,dato)
	else
		dato.codLoc := valoralto;
end;

procedure inicializarContadorCasos(var c: Casos);
begin
	with c do	begin
		hospital := 0;
		municipio := 0;
		localidad := 0;
		provincia := 0;
	end;
end;

procedure generarInforme(var maestro: ArchivoMaestro);
var
	regM: Maestro;
	locAct,munAct,hospAct: integer;
	casos: Casos;
	carga: Text;
begin
	Reset(maestro);
	Assign(carga,'reporte.txt');
	Rewrite(carga);
	leerMaestro(maestro,regM);

	casos.provincia := 0;
	while (regM.codLoc <> valoralto) do begin
		locAct := regM.codLoc;

		WriteLn('Localidad: ',regM.nomLoc);

		casos.localidad := 0;
		while (regM.codLoc = locAct) do begin
			munAct := regM.codMun;

			WriteLn('   Municipio: ',regM.nomMun);

			casos.municipio := 0;
			while (regM.codLoc = locAct) and (regM.codMun = munAct) do begin
				hospAct := regM.codHosp;

				Write('       Hospital: ',regM.nomHosp);
				
				casos.hospital := 0;
				while (regM.codLoc = locAct) and (regM.codMun = munAct) and (regM.codHosp = hospAct) do begin
					casos.hospital := casos.hospital + regM.cantPositivos;
					leerMaestro(maestro,)
				end;

				Write('      Cantidad de casos Hospital: ',casos.hospital);

				casos.municipio := casos.municipio + casos.hospital;

			end;
			WriteLn('Cantidad de Casos Municipio: ',casos.municipio);
			Write(carga,);
			casos.localidad := casos.localidad + casos.municipio;

		end;
		WriteLn('Cantidad de Casos Localidad: ',casos.localidad);
		WriteLn('-----------------------------------------------');

		casos.provincia := casos.provincia + casos.localidad;
	end;
	WriteLn('Cantidad de Casos totales - Provincia: ',casos.provincia);
	close(maestro);
end;

{Programa principal}
var
	mae1: ArchivoMaestro;
begin
	Assign(mae1,'maestro.bin');
	generarInforme(mae1);
End.
