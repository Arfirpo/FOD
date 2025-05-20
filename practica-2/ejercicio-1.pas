{
1.- Una empresa posee un archivo con información de los ingresos percibidos por diferentes empleados en concepto de comisión, de cada uno de ellos se conoce: codigo de empleado, nombre y monto de la comisión. La información del archivo se encuentra ordenada por codigo de empleado y cada empleado puede aparecer mas de una vez en el archivo de comisiones.
Realice un procedimiento que reciba el archivo anteriormente descripto y lo compacte. En consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una unica vez con el valor total de sus comisiones.
NOTA: no se conoce a priori la cantidad de empleados. Además, el archivo debe ser recorrido una única vez.
}

program ejercicio_1_P2;

type
	empleado = record
		cod_empleado: integer;
		nom: string;
		tot_comisiones: real;
	end;
	comision = record
		cod_empleado: integer;
		nom: string;
		monto_comision: real;
	end;
	maestro = file of empleado;
	detalle = file of comision;

{Programa principal}
var
	regM: empleado;
	regD: comision;
	mae1: maestro;
	det1: detalle;
	codAct: integer;
	totComisiones: real;
begin
	assign(mae1,'maestro');
	assign(det1,'detalle');
	rewrite(mae1); //creo el archivo maestro
	reset(det1); //reinicio el archivo detalle
	read(detalle,regD);
	while(not(Eof(det1))) de begin
		codAct = regD.cod_empleado;
		regM.cod_empleado = regD.cod_empleado;
		regM.nom = regD.nom;
		tot_comisiones = 0;
		while(not(Eof(det1) and (regD.cod_empleado = codAct))) do begin
			tot_comisiones = tot_comisiones + regD.monto_comision;
		end;
		regM.tot_comisiones = tot_comisiones;
		write(maestro,regM);
		read(detalle,regD);
	end;
	close(mae1);
	close(det1);
end.
