program ejercicio_11_P2;

const
	valorAlto = 'ZZZ';
	dimF = 15;

type
	str10 = string[10];
	rangoCat = 1..dimF;
	HorasExtraMensual = record
		depto: str10;
		div: str10;
		nroEmp: integer;
		cat: rangoCat;
		cantHoras: integer;
	end;
	ArchivoMaestro = file of HorasExtraMensual;
	vectorValorHorasExtra = array [rangoCat] of real;

{modulos}

procedure leerMaestro(varmaestro: ArchivoMaestro; var dato: HorasExtraMensual);
begin
	if(not(Eof(maestro))) then
		read(maestro,dato)
	else
		dato.depto := valorAlto;
end;

procedure inicializarVector(var v: vectorValorHorasExtra);
var
	i: integer;
begin
	for i := 1 to dimF do
		v[i] := 0;
end;

procedure cargarVector(var v: vectorValorHorasExtra);
var
	carga: Text;
	i,codError: integer;
	valorHora: real;
	dato: string;
begin
	Assign(carga,'detalle-horas-extra.txt');
	Reset(carga);
	for i := 1 to dimF do begin
		readln(carga,dato);
		readln(carga,dato);
		Val(dato,valorHora,codError);
		if(codError = 0) then
			v[i] := valorHora
		else
			writeln('Error de conversión en la línea ', i, ': "', dato, '"');
	end;
	close(carga);
end;

procedure generarReporte(var maestro: ArchivoMaestro; v: vectorValorHorasExtra);
var
	deptoAct,divAct: str10;
	empAct,catAct: integer;
	hTotEmp,hTotDiv,hTotDepto: integer;
	mTotEmp,mTotDiv,mTotDepto: real;
	regM: HorasExtraMensual;
begin
	Reset(maestro);
	leerMaestro(maestro,regM);
	while (regM.depto <> valorAlto) do begin
		deptoAct := regM.depto;
		Writeln('Departamento: ',deptoAct);
		hTotDepto := 0;
		mTotDepto := 0;
		while (regM.depto = deptoAct) do begin
			divAct := regM.div;
			Writeln('Division: ',divAct);
			hTotDiv := 0;
			mTotDiv := 0;
			while (regM.depto = deptoAct) and (regM.div = divAct) do begin
				empAct := regM.nroEmp;
				catAct := regM.cat;
				Writeln('Numero de Empleado          Total de Hs.          Importe a cobrar');
				hTotEmp := 0;
				mTotEmp := 0;
				while (regM.depto = deptoAct) and (regM.div = divAct) and (regM.nroEmp = empAct) do begin
					hTotEmp := hTotEmp + regM.cantHoras;
					leerMaestro(maestro,regM);
				end;
				mTotEmp := mTotEmp + (hTotEmp * v[catAct]);
				Writeln(empAct,'          ',hTotEmp,'Hs.          $',mTotEmp:0:2);
				hTotDiv := hTotDiv + hTotEmp;
				mTotDiv := mTotDiv + mTotEmp;
			end;
			writeln('Total de horas Division: ',hTotDiv,'Hs.');
			writeln('Monto total Division: $',mTotDiv:0:2);
			hTotDepto := hTotDepto + hTotDiv;
			mTotDepto := mTotDepto + mTotDiv;
		end;
		writeln('Total de horas Departamento: ',hTotDepto,'Hs.');
		writeln('Monto total Departamento: $',mTotDepto:0:2);
	end;
	close(maestro);
end;


{Programa principal}
var
	maestro: ArchivoMaestro;
	v: vectorValorHorasExtra;
begin
	inicializarVector(v);
	cargarVector(v);
	Assign(maestro,'maestro.bin');
	generarReporte(maestro,v);
end.
