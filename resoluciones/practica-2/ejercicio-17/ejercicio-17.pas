program ejercicio_17_P2;

const
  valorAlto = 9999;
  dimF = 10;
type
  str10 = string[10];
  str20 = string[20];
  Moto = record
    codMoto: integer;
    nom: str10;
    desc: str20;
    modelo: str10;
    marca: str10;
    stock: integer;
  end;
  Venta = record
    codMoto: integer;
    precio: real;
    fechaVenta: str10;
  end;

  ArchivoMaestro = file of Motos;
  ArchivoDetalle = file of Venta;

  VectorDeArchivosDetalle = array [1..10] of ArchivoDetalle;
  VectorDeRegistrosDetalle = array [1..10] of Venta;

{ Modulos }

procedure leerDetalle();
procedure minimo();
procedure actualizarMaestro();

{ Programa Principal}
var
  mae1: ArchivoMaestro;
  vD: VectorDeArchivosDetalle;
  i: integer;
  strI,nom: string;
begin
  Assign(mae1,'maestro.bin');
  for i := 1 to dimF do begin
    Str(i,strI);
    nom := 'detalle' + strI + '.bin';
    Assign(vD[i],nom);
  end;
  actualizarMaestro(mae1,vD);
end.