program ejercicio_1_P4;


//punto A
const
  orden = 'M';

type
  str8 = String[8];
  Alumno = record
    nomYape: string[15];
    dni: str8;
    legajo: str8;
    anioIngreso: string[4];
  end;

  nodo = record
    datos: array [0..orden - 1] of Alumno;
    hijos: array [0..orden] of integer;
    cantDatos: integer; 
  end;

  ArchivoArbolB = file of nodo;

var

begin
  
End.


{
//punto b

N = (M-1) * A + M * B + C

512 = (M-1) * 64 + M * 4 + 4

512 = 64M - 64 + 4M + 4
512 = 68M - 60
512 + 60 = 68M
572 / 68 = M
M = 8,41

En este arbol B entrarian 7 (M-1) registros de persona porque eñ orden del arbol es 8 (M).


//punto c

El valor de M determina la cantidad máxima de claves y de hijos que puede tener un nodo en el árbol B. Un valor mayor de 
M resultará en nodos más grandes y, por lo tanto, en una estructura de árbol B más ancha y menos profunda. Por otro lado, un valor menor de 
M resultará en nodos más pequeños y en una estructura de árbol B más profunda pero más estrecha.


//punto d

Yo elegiria un campo del registro alumnos que posea caracter de univoco (que no se pueda repetir, que sea unico. En este caso podria ser el campo dni o el campo legajo.)

//punto e

En el mejor de los casos, se necesita de una única lectura para encontrar un alumno por su clave de identificación.
En el peor de los casos, se necesita de h lectureas (con h altura del árbol).

//punto f

Si se desea buscar un alumno por un criterio diferente se debe tener en cuenta el árbol por completo, siendo necesarias n lecturas en el 
peor de los casos, siendo n la cantidad total de nodos que hay en el árbol.

}
