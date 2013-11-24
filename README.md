RIT2
====

Segundo proyecto del curso Recuperación de Información Textual del Instituto Tecnológico de Costa RIca.

Uso:
perl busc_secu.perl prefijo ruta_colección [patrones]+

prefijo:
	Prefijo de la consulta.

ruta_colección:
	Ruta a la carpeta que contiene la colección que se va a analizar.

patrones:
	Patrones que se van a consultar. Cada patrón se busca usando un método distinto.
	Se define <palabra> como una secuencia del con los caractéres: [0-9a-zA-Z_ñÑáéíóúüÁÉÍÓÚÜ] y al menos uno tiene q ser una letra.
	Los métodos a utilizar son:
	Horspool:
		<palabra>[@i]? : Una palabra común pero con un @i opcional para definir si se debe diferenciar entra mayúsculas y minúsculas.

	Shift-And:
		<palabra>?[opcion]<palabra>? : Se tiene al menos una palabra pero se define dentro de [ ] los diferentes caracteres que pueden ocupar esa posición.

	Programación dinámica:
		<palabra>#[1-9] : Se escribe el patrón que se busca además de la cantidad de errores aceptados.

	Autómata de estado finito no determinístico:
		<palabra>##[1-9] : Se escribe el patrón que se busca además de la cantidad de errores aceptados.
