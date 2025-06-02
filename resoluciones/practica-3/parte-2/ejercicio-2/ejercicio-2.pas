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

	lMesas = ^nMesas;

	nMesas = record
		dato: MesaElectoral;
		sig: lMesas;
	end;

{Modulos}
procedure leer(var maestro: ArchivoMaestro; var dato: MesaElectoral);
begin
	if(not(Eof(maestro))) then
		read(maestro,dato)
	else
		dato.codLoc := valorAlto;
end;

procedure agregarAdelante(var l: lMesas; m: MesaElectoral);
var nue: lMesas;
begin
	new(nue);
	nue^.dato := m;
	nue^.sig := l;
	l := nue;
end;

{Programa Principal}
var
	mae1: ArchivoMaestro;
begin
	Assign(mae1,'maestro.bin');
	generaReporte(mae1);
end.
