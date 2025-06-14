{
Ejercicio - Árbol B para archivo de alumnos

a. Estructuras de datos:
	Un árbol B de orden M permite hasta M-1 claves y M hijos por nodo.
	Definimos los siguientes tipos:

	const
		M = 8;  // calculado en el punto b

	type
		Alumno = record
			nombreApellido: string[50];  // tamaño fijo
			dni: longint;
			legajo: longint;
			anioIngreso: integer;
		end;

		NodoB = record
			cantClaves: integer;  // campo C
			claves: array[1..M-1] of Alumno;  // registros (A)
			hijos: array[1..M] of integer;    // punteros a hijos (B)
		end;

		ArchivoB = file of NodoB;

b. Cálculo del orden M del árbol B:
	Datos:
		- N = tamaño del nodo = 512 bytes
		- A = tamaño de un registro Alumno = 64 bytes
		- B = tamaño de un puntero a hijo = 4 bytes
		- C = tamaño del campo cantClaves = 4 bytes

	Fórmula:
		N = (M-1) * A + M * B + C
		512 = (M-1) * 64 + M * 4 + 4
		512 = 64M - 64 + 4M + 4 = 68M - 60
		572 = 68M
		M ≈ 8.41 → M = 8 (entero)

	Entonces:
		- Máximo de claves por nodo = M - 1 = 7
		- Máximo de hijos por nodo = M = 8

c. Impacto de almacenar toda la información en el árbol:
	- Al usar registros grandes (64 bytes), entran menos claves por nodo.
	- El valor de M se reduce, aumentando la altura del árbol.
	- Esto implica más accesos a disco (menos eficiente).
	- Alternativa: guardar solo claves y un puntero a los datos reales.

d. Clave de identificación:
	- Opción recomendada: legajo (numérico, único, fijo).
	- Otras opciones: DNI (también único), nombre (no recomendado por duplicados).
	- Legajo es más adecuado para ordenamiento y búsqueda eficiente.

e. Búsqueda por legajo:
	- Comienza desde la raíz y desciende comparando claves.
	- Mejor caso: alumno está en la raíz → 1 lectura.
	- Peor caso: alumno está en una hoja → h lecturas.

	Altura estimada:
		h ≈ log_M(n), con M = 8
		Si n = 1000 alumnos → h ≈ log₈(1000) ≈ 3.32 → máx 4 lecturas

f. Búsqueda por otro criterio (e.g., DNI o nombre):
	- No se puede usar búsqueda binaria si no está ordenado por ese campo.
	- Se requiere recorrido completo (búsqueda secuencial).
	- Peor caso: leer todos los nodos del árbol.

	Ejemplo:
		Si hay 1000 alumnos y 7 claves por nodo → 143 nodos aprox.
		Peor caso: hasta 143 lecturas.

	Solución: usar índices secundarios si se requiere buscar por otros campos.
}
