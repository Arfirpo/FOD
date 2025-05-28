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

	ArchivoMaestro = file of Maestro;

{modulos}
procedure leerMaestro(var maestro: ArchivoMaestro; var dato: Maestro);
begin
	if(not(Eof(maestro))) then
		read(maestro,dato)
	else
		dato.codLoc := valoralto;
end;



{Programa principal}
var
	mae1
begin
	
end.
