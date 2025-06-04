{
Ejercicio 2 - Índice con Árbol B sobre archivo de alumnos

a. Estructuras de datos:

  type
    Alumno = record
      nombreApellido: string[50];
      dni: longint;
      legajo: longint;
      anioIngreso: integer;
    end;

  ArchivoAlumnos = file of Alumno;

  RegistroIndice = record
    dni: longint;         // clave de búsqueda
    pos: longint;         // posición del alumno en el archivo de datos
  end;

    const
      M = 42;  // valor calculado en el inciso b

    type
      NodoIndice = record
        cantClaves: integer;                              // campo C
        claves: array[1..M-1] of RegistroIndice;           // (A)
        hijos: array[1..M] of integer;                     // (B)
      end;

    ArchivoIndice = file of NodoIndice;

b. Cálculo del orden M del árbol B usado como índice:

  Datos:
    - Tamaño del nodo: N = 512 bytes
    - A = tamaño de RegistroIndice = 8 bytes (dni + pos)
    - B = tamaño de puntero a hijo = 4 bytes
    - C = campo cantClaves = 4 bytes

  Fórmula adaptada:
    N = (M-1) * A + M * B + C
    512 = (M-1)*8 + M*4 + 4
    512 = 8M - 8 + 4M + 4 = 12M - 4
    516 = 12M → M = 43

  Resultado:
    - M = 43
    - Máximo de claves = 42
    - Máximo de hijos = 43

c. ¿Qué implica un mayor orden (M)?
  - Más claves por nodo → menos niveles → menor altura del árbol
  - Menor cantidad de accesos a disco en búsquedas
  - Más eficiente para índices, ya que las claves son pequeñas (solo DNI y posición)

d. Proceso de búsqueda del alumno con DNI 12345678:

  1. Abrir el archivo índice (árbol B).
  2. Comenzar desde la raíz.
  3. Comparar el DNI buscado con las claves en el nodo.
  4. Si se encuentra el DNI, obtener la posición del alumno en el archivo de datos.
  5. Si no está, seguir el puntero al hijo correspondiente.
  6. Repetir hasta encontrar el DNI o llegar a una hoja.
  7. Usar la posición para acceder directamente al archivo de alumnos.
  8. Leer y mostrar los datos del alumno.

e. ¿Qué ocurre si se busca por legajo?

  - No tiene sentido usar el índice por DNI si buscamos por legajo.
  - El árbol B ordenado por DNI no permite búsquedas eficientes por legajo.
  - Sería necesario recorrer todo el árbol (búsqueda secuencial en el peor caso).

  Solución:
    - Crear un segundo índice (otro árbol B) ordenado por legajo.
    - Este árbol almacenaría pares (legajo, pos) y permitiría búsquedas eficientes.

f. Búsqueda por rango (e.g., DNI entre 40000000 y 45000000):

  Problemas:
    - Un árbol B permite búsquedas por rango, pero no de forma inmediata.
    - Se debe ubicar el menor valor del rango (40000000), luego recorrer hojas hacia la derecha.
    - Esto implica acceso secuencial a múltiples nodos hoja.
    - Si el árbol no mantiene enlaces entre hojas, el recorrido es costoso (requiere re-navegar desde raíz).

  Mejora:
    - En la implementación del índice, conviene que las hojas del árbol B estén encadenadas entre sí para facilitar recorridos por rango.
}
