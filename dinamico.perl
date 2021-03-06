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
    my($pTexto, $pPatron) = @_;
    @matriz = (); #Se reinicia la matriz cada vez que se busca un nuevo patrón
    
    my $largo_texto = length($pTexto);
    my $largo_patron = length($pPatron);
    
    for (my $fila = 0; $fila <= $largo_patron; $fila++) {
        $matriz[$fila][0] = $fila;
    }
    
    for (my $columna = 0; $columna <= $largo_texto; $columna++) {
        $matriz[0][$columna] = 0;
    }
}

sub _dinamico {
    my($pTexto, $pPatron, $pErrores) = @_;
    my $largo_texto = length($pTexto);
    my $largo_patron = length($pPatron);
    
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
    
    return _buscarErrores($pTexto, $pPatron, $pErrores);
}

sub _buscarErrores {
    my($pTexto, $pPatron, $pErrores) = @_;
    my $largo_texto = length($pTexto);
    my $largo_patron = length($pPatron);
    my $encontrado = 0;
    
    for (my $columna = 1; $columna <= $largo_texto; $columna++) {
        if ($matriz[$largo_patron][$columna] == $pErrores) {
            $encontrado = 1;
            last;
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
