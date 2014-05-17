#!/usr/bin/perl
=begin comment
	Instituto Tecnológico de Costa Rica
	Escuela de Ingeniería en Computación
	Recuperación de Información Textual
	Proyecto 2
	Mario Alberto Retana Rojas - 201029799
	Wei Hua Zheng Ma - 201020990
=end comment
=cut

use List::Util qw(min);     # Usado para encontrar el minimo entre valores dados.
use utf8;


my @matriz;                 # Matriz que "recuerda" los resultados anteriores

#print(&busquedaDinamica($ARGV[0], $ARGV[1], $ARGV[2]) . "\n");

sub busquedaDinamica {
    my($pTexto, $pPatron, $pErrores) = @_;
    
    _inicializarMatriz($pTexto, $pPatron);
    _dinamico($pTexto, $pPatron, $pErrores);
}

sub _inicializarMatriz {
    my($pPatron) = @_;
    @matriz = (); #Se reinicia la matriz cada vez que se busca un nuevo patrón
    
    my $largo_patron = length($pPatron);
    
    for (my $fila = 0; $fila <= $largo_patron; $fila++) {
        $matriz[$fila][0] = $fila;
    }

}

=begin comment
	Actualiza las filas de la matriz para que tengan un valor de cero.
	Esto se hace en cada búsqueda ya que la matriz cambia la cantidad de
	columnas según el tamaño del texto.
	@param $pLargo Largo del texto en el que se busca el patrón.
=end comment
=cut
sub _reiniciarMatriz {
	my($pLargo) = @_;
	for (my $columna = 0; $columna <= $pLargo; $columna++) {
        $matriz[0][$columna] = 0;
    }#fin for
}#fin reiniciar matriz

sub _dinamico {
    my($pTexto, $pPatron, $pErrores) = @_;
    my $largo_texto = length($pTexto);
    my $largo_patron = length($pPatron);
    
    _reiniciarMatriz($largo_texto);
    
    for (my $columna = 1; $columna <= $largo_texto; $columna++) {
        for (my $fila = 1; $fila <= $largo_patron; $fila++) {
            
            if (substr($pTexto, $columna - 1, 1) eq substr($pPatron, $fila - 1, 1)) {
                $matriz[$fila][$columna] = $matriz[$fila - 1][$columna - 1];
            } else {
                $matriz[$fila][$columna] = 1 + min($matriz[$fila - 1][$columna],
                                                $matriz[$fila][$columna - 1],
                                                $matriz[$fila - 1][$columna - 1]);
            }
        }
    }
    
    return _buscarErrores($largo_texto, $largo_patron, $pErrores);
}

sub _buscarErrores {
    my($pLargoT, $pLargoP, $pErrores) = @_;
    my $encontrado = 0;
    
    for (my $columna = 1; $columna <= $pLargoT; $columna++) {
        if ($matriz[$pLargoP][$columna] == $pErrores) {
            $encontrado++;
        }
    }
    
    return $encontrado;
}

sub _imprimirMatriz {
    my($pLargoTexto, $pLargoPatron) = @_;
    
    for (my $fila = 0; $fila <= $pLargoPatron; $fila++) {
        for (my $columna = 0; $columna <= $pLargoTexto; $columna++) {
            print($matriz[$fila][$columna] . "   ");
        }
        print ("\n");
    }
    
    print("\n");
}

1;
