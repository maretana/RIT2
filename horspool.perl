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

use utf8;	                # Necesario si el equipo está en esta codificación. 
use Encode;

binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");

=begin comment
    Realiza la busqueda en un texto de un patron siguiendo el algoritmo
    Horspool.
    @param $pTexto texto en el cual se busca el patron.
    @param $pPatron patron a ser buscado en el texto.
    @returns -1 si no encuentra.
    @returns $index + 1, posicion en donde comienza el patron.
=end comment
=cut
sub busquedaHorspool {
    my($pTexto, $pPatron, $pTabla) = @_;
    
    if ($pPatron =~ /[0-9a-zA-Z_ñÑáéíóúüÁÉÍÓÚÜ]+\@i/) {
        my @patron = split(/@/, $pPatron);
        return _horspool($pTexto, $patron[0], 1, $pTabla);
    } else {
        return _horspool($pTexto, $pPatron, 0, $pTabla);
    }
}

=begin comment
    Calcula la tabla de corrimientos usada en el algoritmo de Horspool.
    Los valores se encuentran en la tabla_d.
    @param $pPatron patron a buscar en el texto.
=end comment
=cut
sub _calcularTabla {
    my($pPatron) = @_;
    my @alfabeto = (split(//, "ñÑáéíóúüÁÉÍÓÚÜ_"), ("a"..."z"), ("A"..."Z"), (0..9));    # Arreglo que contiene el alfabeto
    my %tabla_d = ();                                                                   # Tabla que contiene los corrimientos
    my $largo_patron = length($pPatron);
    
    foreach my $letra (@alfabeto) {
        $tabla_d{$letra} = $largo_patron;
    }
    
    for (my $index = 0; $index < $largo_patron - 1; $index++) {
        $tabla_d{substr($pPatron, $index, 1)} = $largo_patron - $index - 1;
    }
    
    return \%tabla_d;
}

=begin comment
    Algoritmo de Horspool, en donde se tiene una tabla_d precalculada
    utilizada para realizar los corrimientos necesarios. El algoritmo
    fue tomado de apuntes de clase, realizando los cambios necesarios
    tomando en cuenta que la primera posicion de un string es 0.
    @param $pTexto texto en el cual se busca el patron.
    @param $pPatron patron a ser buscado en el texto.
    @param $pIgnoreCase indica si se ignora o no mayusculas.
    @param %pTabla tabla con los desplazamientos.
    @returns -1 si no encuentra.
    @returns $index + 1, posicion en donde comienza el patron.
=end comment
=cut
sub _horspool {
    my($pTexto, $pPatron, $pIgnoreCase, $pTabla) = @_;
    my $largo_texto = length($pTexto);
    my $largo_patron = length($pPatron);
    my %tabla_d = %{$pTabla};
    
    my $index = 0;
    
    while ($index <= $largo_texto - $largo_patron) {
        my $posicion = 0;
        
        if ($pIgnoreCase == 1) {
            while ($posicion <= $largo_patron &&
                    lc(substr($pTexto, $index + $posicion, 1)) eq lc(substr($pPatron, $posicion, 1))) {
                $posicion++;
            }
        } else {
            while ($posicion <= $largo_patron &&
                    substr($pTexto, $index + $posicion, 1) eq substr($pPatron, $posicion, 1)) {
                $posicion++;
            }
        }
        
        if ($posicion >= $largo_patron) {
            return 1;
        } else {
            #print(substr($pTexto, $index + $largo_patron - 1, 1) . "\n");
            $index += $tabla_d{substr($pTexto, $index + $largo_patron - 1, 1)};
        }
        
        #print($index . "\n");
    }
    
    return 0;
}
1;
