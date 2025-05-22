program ejercicio_3_P2;

const valorAlto = 9999;

type
	str10 = string[10];

	Provincia = record
		nombreProv: str10;
		cantAlfa: integer;
		totEnc: integer;
	end;

	ReporteAgencia = record
		nombreProv: str10;
		codLocalidad: integer;
		cantAlfa: integer;
		cantEnc: integer;
	end;

	ArchivoMaestro = file of Provincia;
	ArchivoDetalle = file of ReporteAgencia;

	{modulos}
	procedure leer(var detalle: ArchivoDetalle; var dato: ReporteAgencia);
	begin
		if(not(Eof(detalle))) then
			read(detalle,dato)
		else
			dato.nombreProv := valorAlto;
	end;

	procedure minimo(var det1, det2: ArchivoDetalle; var regD1,regD2,regMin: ReporteAgencia);
	begin
		if(regD1.nombreProv <= regD2.nombreProv) then begin
			regMin := regD1;
			leer(det1,regD1);
		end
		else begin
			regMin := regD2;
			leer(det2,regD2);
		end;
	end;

	procedure actualizarMaestro(var maestro: ArchivoMaestro; var detalle1,detalle2: ArchivoDetalle);
	var
		regM: Provincia;
		regD1,regD2,regMin: ReporteAgencia;
		provAct: str10;
		totEncProv: integer;
		totAlfaProv: integer;
	begin
		Reset(maestro);
		Reset(detalle1);
		Reset(detalle2);
		read(maestro,regM);
		leer(detalle1,regD1);
		leer(detalle2,regD2);
		minimo(detalle1,detalle2,regD1,regD2,regMin);
		while (regMin.nombreProv <> valorAlto) do begin
			provAct := regMin.nombreProv;
			totAlfaProv := 0;
			totEncProv := 0;
			while (regMin.nombreProv = provAct) do begin
				totAlfaProv := totAlfaProv + regMin.cantAlfa;
				totEncProv := totEncProv + regMin.cantEnc;
				minimo(detalle1,detalle2,regD1,regD2,regMin);
			end;
			while (regM.nombreProv <> provAct) do
				read(maestro,regM);
			regM.cantAlfa := regM.cantAlfa + totAlfaProv;
			regM.totEnc := regM.totEnc + totEncProv;
			Seek(maestro,filepos(maestro) - 1);
			write(maestro,regM);
			if(not(Eof(maestro))) then
				read(maestro,regM);
		end;
		close(maestro);
		close(detalle1);
		close(detalle2);
	end;

{Programa principal}
var
	mae1: ArchivoMaestro;
	det1,det2: ArchivoDetalle;
begin
	Assign(mae1,'maestro');
	Assign(det1,'detalle1');
	Assign(det2,'detalle2');
	actualizarMaestro(mae1,det1,det2);
end.
