program ejercicio_15_P2;

const
	valorAlto = 9999;
	dimF = 10;
type
	str10 = string[10];

	Vivienda = record
		luz: integer;
		agua: integer;
		gas: integer;
		sanitarios: integer;
		deChapa: integer;
	end;

	Reporte  = record
		codProv: integer;
		nomProv: str10;
		codLoc: integer;
		nomLoc: str10;
		viviendas: Vivienda;
	end;

	ArchivoMaestro = file of Reporte;
	ArchivoDetalle = file of Reporte;

	VectorArchivoDetalle = array [1..dimF] of ArchivoDetalle;
	VectorRegistroDetalle = array [1..dimF] of Reporte;

{modulos}
procedure leerMaestro(var maestro: ArchivoMaestro; var dato: Reporte);
begin
	if(not(Eof(maestro))) then
		read(maestro,dato)
	else
		dato.codProv := valorAlto;
end;

procedure leerDetalle(var detalle: ArchivoDetalle; var dato: Reporte);
begin
	if(not(Eof(detalle))) then
		read(detalle,dato)
	else
		dato.codProv := valorAlto;
end;

procedure minimo(var vD: VectorArchivoDetalle; var vR: VectorRegistroDetalle; var minRegD: Reporte);
var i,pos: integer;
begin
	minRegD.codProv := valorAlto;
	pos := -1;
	for i := 1 to dimF do begin
		if (vR[i].codProv < minRegD.codProv) or ((vR[i].codProv = minRegD.codProv) and (vR[i].codLoc < minRegD.codLoc)) then begin
			minRegD := vR[i];
			pos := i;
		end;
	end;
	if(minRegD.codProv <> valorAlto) then
		leerDetalle(vD[pos],vR[pos]);
end;

procedure actualizarMaestro(var maestro: ArchivoMaestro; var vD: VectorArchivoDetalle);
var
	regM,minRegD: Reporte;
	provAct,locAct,cantLoc,i: integer;
	vR: VectorRegistroDetalle;
	modificado: boolean;
begin
	Reset(maestro);
	for i := 1 to dimF do begin
		Reset(vD[i]);
		leerDetalle(vD[i],vR[i]);
	end;	
	leerMaestro(maestro,regM);
	minimo(vD,vR,minRegD);
	while (regM.codProv <> valorAlto) do begin
		provAct := regM.codProv;
		cantLoc := 0;
		while (regM.codProv = provAct) do begin
			locAct := regM.codLoc;
			while (regM.codProv = provAct) and (regM.codLoc = locAct) do begin
				modificado := false;
				while (minRegD.codProv = provAct) and (minRegD.codLoc = locAct) do begin
					if not(modificado) then modificado := true;
					regM.viviendas.luz := regM.viviendas.luz - minRegD.viviendas.luz;
					regM.viviendas.agua := regM.viviendas.agua - minRegD.viviendas.agua;
					regM.viviendas.gas := regM.viviendas.gas - minRegD.viviendas.gas;
					regM.viviendas.deChapa := regM.viviendas.deChapa - minRegD.viviendas.deChapa;
					regM.viviendas.sanitarios := regM.viviendas.sanitarios - minRegD.viviendas.sanitarios;
					minimo(vD,vR,minRegD);
				end;

				if(regM.viviendas.deChapa = 0) then
					cantLoc := cantLoc + 1;
				if(modificado) then begin
					seek(maestro,filepos(maestro) - 1);
					write(maestro,regM);
				end;
				leerMaestro(maestro,regM);
			end;
		end;
		Writeln(cantLoc,' localidades de la provincia ',provAct,' no tienen viviendas de chapa.');
	end;
	close(maestro);
	for i := 1 to dimF do
		close(vD[i]);
end;


{Programa principal}
var
	mae1: ArchivoMaestro;
	vD: VectorArchivoDetalle;
	strI,nom: string;
	i: integer;
begin
	Assign(mae1,'maestro.bin');
	for i := 1 to dimF do begin
		str(i,strI);
		nom := 'detalle' + strI + '.bin';
		Assign(vD[i],nom);
	end;
	actualizarMaestro(mae1,vD);
end.
