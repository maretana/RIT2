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

use utf8;

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
    my %tabla_d = ();                                                                   # Tabla que contiene los corrimientos
    my $largo_patron = length($pPatron);
    my $patron = $pPatron;
    
    if ($pPatron =~ /[0-9a-zA-Z_ñÑáéíóúüÁÉÍÓÚÜ]+\@i/) {
		$patron = lc($pPatron);
	}#fin si se ignora el case
    for (my $index = 0; $index < $largo_patron - 1; $index++) {
        $tabla_d{substr($patron, $index, 1)} = $largo_patron - $index -1;
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
    @returns Retorna la cantidad de veces que encuentra el patrón en el texto.
=end comment
=cut
sub _horspool {
    my($pTexto, $pPatron, $pIgnoreCase, $pTabla) = @_;
    my $largo_texto = length($pTexto);
    my $largo_patron = length($pPatron);
    my $texto = $pTexto;
    my $patron = $pPatron;
    my %tabla_d = %{$pTabla};
    
    my $index = 0;
    my $resultado = 0;
    
    if ($pIgnoreCase==1) {
		$texto = lc($texto);
		$patron = lc($patron);
	}#fin si no se difernecia entre mayúsculas y minúsculas
    
    while ($index < $largo_texto - $largo_patron) {
        my $posicion = 0;
        
        while ($posicion < $largo_patron and (substr($texto,$index+$posicion,1) eq substr($patron,$posicion,1))) {
			$posicion++;
		}#fin while
		
        if ($posicion == $largo_patron) {
            $resultado++;
		}#fin si se encontró el patrón
        
        $letra = substr($texto,$index+$largo_patron-1,1);
		if ( defined($tabla_d{$letra}) ) {
			$index += $tabla_d{$letra};
		}
		else {
			$index += $largo_patron;
		}
    }
    
    return $resultado;
}
1;
