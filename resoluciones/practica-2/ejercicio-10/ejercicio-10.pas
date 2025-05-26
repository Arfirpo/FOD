program ejercicio_10_P2;

const
	valorAlto = 9999;

type
	MesaElectoral = record
		codProv: integer;
		codLoc: integer;
		nroMesa: integer;
		cantVotos: integer;
	end;

	ArchivoMaestro = file of MesaElectoral;

{modulos}

procedure leerMaestro(var maestro: ArchivoMaestro; var dato: MesaElectoral);
begin
	if(not(Eof(maestro))) then
		read(maestro,dato)
	else
		dato.codProv := valorAlto;
end;

procedure generarReporte(var maestro: ArchivoMaestro);
var
	regM: MesaElectoral;
	provAct,locAct,totGen,totProv,totLoc: integer;
begin
	reset(maestro);
	leerMaestro(maestro,regM);
	totGen := 0;
	while (regM.codProv <> valorAlto) do begin
		provAct := regM.codProv;
		Writeline('Codigo de Provincia: ',provAct);
		totProv := 0;
		while (regM.codProv = provAct) do begin
			locAct := regM.codLoc;
			Writeline('Codigo de Localidad:          Total de Votos:');
			totLoc := 0;
			while (regM.codProv = provAct) and (regM.codLoc = locAct) do begin
				totLoc := totLoc + regM.cantVotos;
				leerMaestro(maestro,regM);
			end;
			Writeline('    ',locAct,'          ',totLoc);
			totProv := totProv + totLoc;
		end;
		writeln('Total de votos Provincia: ',totProv);
		totGen := totGen + totProv;
	end;
	writeln('Total general de votos: ',totGen);
	close(maestro);
end;


{Programa principal}
var
	mae1: ArchivoMaestro;
begin
	Assign(mae1,'maestro.bin');
	generarReporte(mae1);
end.
