program ejercicio_19_P2;

const
	valorAlto = 9999;
	dimF = 50;

type
	str10 = string[10];

	Direccion = record
		calle: integer;
		nro: integer;
		piso: integer;
		depto: integer;
		ciudad: str10;
	end;

	PartidaNacimiento = record
		nroPartidaNac: integer;
		nom: str10;
		ape: str10;
		dir: Direccion;
		matMedico: integer;
		nomYapeMadre: str10;
		dniMadre: integer;
		nomYapePadre: str10;
		dniPadre: integer;
	end;

	ActaDefuncion = record
		nroPartidaNac: integer;
		nomYapeFallecido: str10;
		matMedicoDec: integer;
		fechaYhoraDec: str10;
		lugarDec: str10;
	end;

	Maestro = record
		nac: PartidaNacimiento;
		fallecio: boolean;
		matMedicoDec: integer;
		fechaYhoraDec: str10;
		lugarDec: str10;
	end;

	ArchivoMaestro = file of Maestro;

	ArchivoDetalleNacimientos = file of PartidaNacimiento;
	ArchivoDetalleDefunciones = file of ActaDefuncion;

	VectorDetalleNacimientos = array [1..dimF] of ArchivoDetalleNacimientos;
	VectorDetalleDefunciones = array [1..dimF] of ArchivoDetalleDefunciones;

	VectorRegistroDetalleNacimientos = array [1..dimF] of PartidaNacimiento;
	VectorRegistroDetalleDefunciones = array [1..dimF] of ActaDefuncion;

{modulos}
procedure leerDetalleNac(var detalle: ArchivoDetalleNacimientos; var dato: PartidaNacimiento);
begin
	if(not(Eof(detalle))) then
		read(detalle,dato)
	else
		dato.nroPartidaNac := valorAlto;
end;

procedure leerDetalleDec(var detalle: ArchivoDetalleDefunciones; var dato: ActaDefuncion);
begin
	if(not(Eof(detalle))) then
		read(detalle,dato)
	else
		dato.nroPartidaNac := valorAlto;
end;

procedure minimoNac(var vD: VectorDetalleNacimientos; var vR: VectorRegistroDetalleNacimientos; var minRegDN: PartidaNacimiento);
var
	i,pos: integer;
begin
		minRegDN.nroPartidaNac := valorAlto;
		for i := 1 to dimF do begin
			if(vR[i].nroPartidaNac < minRegDN.nroPartidaNac) then begin
				minRegDN := vR[i];
				pos := i;
			end;
		end;
		if(minRegDN.nroPartidaNac <> valorAlto) then
			leerDetalleNac(vD[pos],vR[pos]);
end;

procedure minimoDec(var vD: VectorDetalleDefunciones; var vR: VectorRegistroDetalleDefunciones; var minRegDD: ActaDefuncion);
var
	i,pos: integer;
begin
		minRegDD.nroPartidaNac := valorAlto;
		for i := 1 to dimF do begin
			if(vR[i].nroPartidaNac < minRegDD.nroPartidaNac) then begin
				minRegDD := vR[i];
				pos := i;
			end;
		end;
		if(minRegDD.nroPartidaNac <> valorAlto) then
			leerDetalleDec(vD[pos],vR[pos]);
end;

procedure exportarDatos(var carga: Text; regM: Maestro);
begin
	writeln(carga,'==========================================');
	writeln(carga,'Nombre: ',regM.nac.nom,' ',regM.nac.ape,'.');
	writeln(carga,'--------------------------------');
	writeln(carga,'***PARTIDA DE NACIMIENTO***');
	writeln(carga,'--------------------------------');
	writeln(carga,'Nro. de Partida: ',regM.nac.nroPartidaNac,'.');
	writeln(carga,'--------------------------------');
	writeln(carga,'Direccion: Calle ',regM.nac.dir.calle,' | Nro. ',regM.nac.dir.nro,' | piso ',regM.nac.dir.piso,' | depto. ',regM.nac.dir.depto,' | ciudad ',regM.nac.dir.ciudad,'.');
	writeln(carga,'--------------------------------');
	writeln(carga,'Medico interviniente - Matricula Prov. Nro. : ',regM.nac.matMedico,'.');
	writeln(carga,'--------------------------------');
	writeln(carga,'Datos de la Madre: Nombre',regM.nac.nomYapeMadre,' | DNI Nro. ',regM.nac.dniMadre,'.');
	writeln(carga,'--------------------------------');
	writeln(carga,'Datos del Padre: Nombre',regM.nac.nomYapePadre,' | DNI Nro. ',regM.nac.dniPadre,'.');
	if(regM.fallecio) then begin
		writeln(carga,'--------------------------------');
		writeln(carga,'***ACTA DE DEFUNCION***');
		writeln(carga,'--------------------------------');
		writeln(carga,'Medico interviniente - Matricula Prov. Nro. : ',regM.matMedicoDec,'.');
		writeln(carga,'--------------------------------');
		writeln(carga,'Fecha y Hora del fallecimiento: ',regM.fechaYhoraDec,'.');
		writeln(carga,'--------------------------------');
		writeln(carga,'Lugar del fallecimiento: ',regM.lugarDec,'.');
		writeln(carga,'--------------------------------');
	end;
	writeln(carga,'==========================================');
end;

procedure generarArchivoMaestro(var maestro: ArchivoMaestro; var vD1: VectorDetalleNacimientos; var vD2: VectorDetalleDefunciones);
var
	minRegDN: PartidaNacimiento;
	minRegDD: ActaDefuncion;
	vR1: VectorRegistroDetalleNacimientos;
	vR2: VectorRegistroDetalleDefunciones;
	regM: Maestro;
	carga: Text;
	i,nroPartAct: integer;
begin
	for i := 1 to dimF do begin
		Reset(vD1[i]);
		leerDetalleNac(vD1[i],vR1[i]);
		Reset(vD2[i]);
		leerDetalleDec(vD2[i],vR2[i]);
	end;
	Assign(carga,'registroPersonas.txt');
	Rewrite(carga);
	Rewrite(maestro);
	minimoNac(vD1,vR1,minRegDN);
	minimoDec(vD2,vR2,minRegDD);

	while (minRegDN.nroPartidaNac <> valorAlto) do begin
		regM.nac := minRegDN;
		regM.fallecio := false;

		if (minRegDD.nroPartidaNac = minRegDN.nroPartidaNac) then begin
			regM.fallecio := true;
			regM.matMedicoDec := minRegDD.matMedicoDec;
			regM.fechaYhoraDec := minRegDD.fechaYhoraDec;
			regM.lugarDec := minRegDD.lugarDec;
			minimoDec(vD2,vR2,minRegDD);
		end;

		write(maestro, regM);
		exportarDatos(carga, regM);
		minimoNac(vD1, vR1, minRegDN); 
	end;

	close(maestro);
	close(carga);
	for i := 1 to dimF do begin
		close(vD1[i]);
		close(vD2[i]);
	end;
end;

{Programa principal}
var
	mae1: ArchivoMaestro;
	vD1: VectorDetalleNacimientos;
	vD2: VectorDetalleDefunciones;
	i: integer;
	strI,nom: string;
begin
	Assign(mae1,'maestro.bin');
	for i := 1 to dimF do begin
		Str(i,strI);
		nom := 'detalleNac' + strI + '.bin';
		Assign(vD1[i],nom);
		nom := 'detalleDec' + strI + '.bin';
		Assign(vD2[i],nom);
	end;
	generarArchivoMaestro(mae1,vD1,vD2);
end.
