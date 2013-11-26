RIT2
====

Segundo proyecto del curso Recuperación de Información Textual del Instituto Tecnológico de Costa Rica.

<b>Estudiantes:</b>
* Mario Alberto Retana Rojas - 201029799
* Wei Hua Zheng Ma - 201020990

<dl>
        <dt>Uso:</dt>
        <dd>perl busc_secu.perl prefijo ruta_colección [patrones]+</dd>
        <dt>prefijo:</dt>
	<dd>Prefijo de la consulta.</dd>
        <dt>ruta_colección:</dt>
	<dd>Ruta a la carpeta que contiene la colección que se va a analizar.</dd>
        <dt>patrones:</dt>
	<dd>Patrones que se van a consultar. Cada patrón se busca usando un método distinto.Se define &#60palabra> como una secuencia con los caractéres: [0-9a-zA-Z_ñÑáéíóúüÁÉÍÓÚÜ] y al menos uno tiene q ser una letra.</dd>
</dl>
Los métodos a utilizar son:
	
	Horspool:
		<palabra>[@i]? : Una palabra común pero con un @i opcional para definir si se debe diferenciar entra mayúsculas y minúsculas.
	Shift-And:
		<palabra>?[opcion]<palabra>? : Se tiene al menos una palabra pero se define dentro de [ ] los diferentes caracteres que pueden ocupar esa posición.
	Programación dinámica:
		<palabra>#[1-9] : Se escribe el patrón que se busca además de la cantidad de errores aceptados.
	Autómata de estado finito no determinístico:
		<palabra>##[1-9] : Se escribe el patrón que se busca además de la cantidad de errores aceptados.
<dl>
        <dt>Salida</dt>
        <dd>La salida de este programa es un archivo con el nombre prefijo.txt en donde se ordenan los archivos por su similitud descendentemente. En ese archivo se incluye el prefijo, la posición en el ránking, la cantidad de apariciones de cada patrón, la similitud y la ruta del documento.</dd>
</dl>
