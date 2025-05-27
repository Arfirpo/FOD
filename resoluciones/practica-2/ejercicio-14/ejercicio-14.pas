program ejercicio_14_P2;

const
	valorAlto = 'ZZZ';

type
	str10 = string[10];
	Vuelo = record
		destino: str10;
		fecha: str10;
		horaSalida: real;
	end;

	Asiento = record
		vuelo: Vuelo;
		asientos: integer;
	end;

	ArchivoMaestro = file of Asiento;
	ArchivoDetalle = file of Asiento;

	lVuelos = ^nVuelos;
	nVuelos = record
		dato: Vuelo;
		sig: lVuelos;
	end;

{modulos}
procedure leerDetalle(var detalle: ArchivoDetalle; var dato: Asiento);
begin
	if(not(Eof(detalle))) then
		read(detalle,dato)
	else
		dato.vuelo.destino := valorAlto;
end;

procedure minimo(var det1,det2: ArchivoDetalle; var regD1,regD2,minRegD: Asiento);
begin
	minRegD.vuelo.destino := valorAlto;
	if(regD1.vuelo.destino < regD2.vuelo.destino) or ((regD1.vuelo.destino = regD2.vuelo.destino) and (regD1.vuelo.fecha < regD2.vuelo.fecha)) or (((regD1.vuelo.destino = regD2.vuelo.destino)) and ((regD1.vuelo.fecha = regD2.vuelo.fecha)) and ((regD1.vuelo.horaSalida < regD2.vuelo.horaSalida)))
	then begin
		minRegD := regD1;
		leerDetalle(det1,regD1);
	end;
	else begin
		minRegD := regD2;
		leerDetalle(det2,regD2);
	end;
end;

procedure agregarAdelante(var l: lVuelos; v: vuelo);
var nue: lVuelos;
begin
	new(nue);
	nue^.dato := v;
	nue^.sig := l;
	l := nue;
end;

procedure actualizarMaestro(var maestro: ArchivoMaestro; 
														var det1,det2: ArchivoDetalle
														var l: lVuelos);
var
	regM,regD1,regD2,minRegD: Asiento;
	destAct,fechaAct: str10;
	horaSalidaAct: real;
	cantAsientosComprados,minCantidad: integer;
begin
	write('Ingrese cantidad minima de Asiento disponibles: '); readln(minCantidad);
	Reset(maestro);
	Reset(det1);
	Reset(det2);
	leerDetalle(det1,regD1);
	leerDetalle(det2,regD2);
	minimo(det1,det2,regD1,regD2,minRegD);
	read(maestro,regM);
	while (minRegD.vuelo.destino <> valorAlto) do begin
		destAct := minRegD.vuelo.destino;

		while(minRegD.vuelo.destino = destAct) do begin
			fechaAct := minRegD.vuelo.fecha;

			while (minRegD.vuelo.destino = destAct) and (minRegD.vuelo.fecha = fechaAct) do begin
				horaSalidaAct := minRegD.vuelo.horaSalida;

				cantAsientoComprados := 0;
				while (minRegD.vuelo.destino = destAct) and (minRegD.vuelo.fecha = fechaAct) and (minRegD.vuelo.horaSalida = horaSalidaAct) do begin
					cantAsientosComprados := cantAsientosComprados + minRegD.asientos;
					minimo(det1,det2,regD1,regD2,minRegD);
				end;

				while (regM.vuelo.destino <> destAct) or (regM.vuelo.fecha <> fechaAct) or (regM.vuelo.horaSalida <> horaSalidaAct) do
					read(maestro,regM);

				regM.asientos := regM.asientos - cantAsientosComprados;

				if(regM.vuelo.asientos < minCantidad) then
					agregarAdelante(l,regM.vuelo);
				
				seek(maestro,filepos(maestro) - 1);
				write(maestro,regM);
			end;
		end;

		if(not(Eof(maestro))) then
			read(maestro,regM);
	end;
	close(maestro);
	close(det1);
	close(det2);
end;

{Programa principal}
var
	mae1: ArchivoMaestro;
	det1,det2: ArchivoDetalle;
	pri: lVuelos;
begin
	pri := nil;
	Assign(mae1,'maestro.bin');
	Assign(det1,'detalle1.bin');
	Assign(det2,'detalle2.bin');
	actualizarMaestro(mae1,det1,det2,pri);
end.
