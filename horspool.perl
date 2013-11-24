#!/usr/bin/perl
=begin comment
	Instituto Tecnológico de Costa Rica
	Escuela de Ingeniería en Computación
	Recuperación de Información Textual
	Proyecto 2
	Mario Alberto Retana Rojas - 201029799
	Wei Hua Zheng Ma - 2010XXXXX
=end comment
=cut

#use warnings "all";         # Muestra todos los warnings
use utf8;	                # Necesario si el equipo está en esta codificación. 

my @alfabeto = ("a".."z");  # Arreglo que contiene el alfabeto
my %tabla_d;                # Tabla que contiene los corrimientos

print(&busquedaHorspool($ARGV[0], $ARGV[1]) . "\n");

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
    my($pTexto, $pPatron) = @_;
    
    _calcularTabla($pPatron);
    return _horspool($pTexto, $pPatron);
}

=begin comment
    Calcula la tabla de corrimientos usada en el algoritmo de Horspool.
    Los valores se encuentran en la tabla_d.
    @param $pPatron patron a buscar en el texto.
=end comment
=cut
sub _calcularTabla {
    my($pPatron) = @_;
    my $largo_patron = length($pPatron);
    
    foreach my $letra (@alfabeto) {
        $tabla_d{$letra} = $largo_patron;
    }
    
    for (my $index = 0; $index < $largo_patron - 1; $index++) {
        $tabla_d{substr($pPatron, $index, 1)} = $largo_patron - $index - 1;
    }
}

=begin comment
    Algoritmo de Horspool, en donde se tiene una tabla_d precalculada
    utilizada para realizar los corrimientos necesarios. El algoritmo
    fue tomado de apuntes de clase, realizando los cambios necesarios
    tomando en cuenta que la primera posicion de un string es 0.
    @param $pTexto texto en el cual se busca el patron.
    @param $pPatron patron a ser buscado en el texto.
    @returns -1 si no encuentra.
    @returns $index + 1, posicion en donde comienza el patron.
=end comment
=cut
sub _horspool {
    my($pTexto, $pPatron) = @_;
    my $largo_texto = length($pTexto);
    my $largo_patron = length($pPatron);
    
    my $index = 0;
    
    while ($index <= $largo_texto - $largo_patron) {
        my $posicion = 0;
        
        while ($posicion <= $largo_patron &&
                substr($pTexto, $index + $posicion, 1) eq substr($pPatron, $posicion, 1)) {
            $posicion++;
        }
        
        if ($posicion >= $largo_patron) {
            return 1;
        } else {
            $index += $tabla_d{substr($pTexto, $index + $largo_patron - 1, 1)};
        }
    }
    
    return 0;
}
1;
