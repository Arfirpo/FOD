program ejercicio_2_P3_Pte_2;

const
	valorAlto = 9999;
type
	
	MesaElectoral = record
		codLoc: integer;
		nroMesa: integer;
		cantVotos: integer;
	end;

	ArchivoMaestro = file of MesaElectoral;

	lCodigos = ^nCodigos;

	nCodigos = record
		dato: MesaElectoral;
		sig: lCodigos;
	end;

{Modulos}
procedure leer(var maestro: ArchivoMaestro; var dato: MesaElectoral);
begin
	if(not(Eof(maestro))) then
		read(maestro,dato)
	else
		dato.codLoc := valorAlto;
end;

procedure agregarCodigoAdelante(var l: lCodigos; cod: integer);
var nue: lCodigos;
begin
	new(nue);
	nue^.dato := cod;
	nue^.sig := l;
	l := nue;
end;

procedure generaReporte(var maestro: ArchivoMaestro);
var
    regM: MesaElectoral;
    pri: lCodigos;
    codAct, totVotosMesa, totGen, posSig: integer;
begin
	Reset(maestro);
	pri := nil;
	leer(maestro, regM);
	totGen := 0;
	while (regM.cod <> valorAlto) do begin
		if not buscarCodigo(pri, regM.codLoc) then begin
			codAct := regM.codLoc;
			agregarCodigoAdelante(pri, codAct);
			posSig := FilePos(maestro);  // ← Posición del SIGUIENTE registro
			
			// Recorrer TODO el archivo para esta localidad
			Reset(maestro);
			leer(maestro, regM);
			totVotosMesa := 0;
			while (regM.cod <> valorAlto) do begin
				if (regM.codLoc = codAct) then
					totVotosMesa := totVotosMesa + regM.cantVotos;
				leer(maestro, regM);
			end;
			
			writeln('Localidad: ', codAct, ' - Total: ', totVotosMesa);
			totGen := totGen + totVotosMesa;
			
			// Volver a la posición siguiente
			Seek(maestro, posSig);
			leer(maestro, regM);
		end 
		else
			leer(maestro, regM);
  end;
    
    writeln('Total general: ', totGen);
    Close(maestro);
end;

{Programa Principal}
var
	mae1: ArchivoMaestro;
begin
	Assign(mae1,'maestro.bin');
	generaReporte(mae1);
end.
