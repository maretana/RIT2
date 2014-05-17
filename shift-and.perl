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

=begin comment
Busca si el patrón está en la palabra usando el método shift-and.
@param $pLinea L[inea en la que se busca el patrón.
@param $pLimite el 1 más significativo según el tamaño de patrón. Se agrega en cada shift.
@param $pMascaras Referencia a un hash que contiene las máscaras de cada letra del patrón.
@returns Retorna la cantidad de veces que encuentra el patrón dentro de la línea.
=end comment
=cut
sub buscarPatron_shift_and{
	my ($pLinea,$pLimite,$pMascaras) = @_;
	my %B = %{$pMascaras};
	my $D = 0;
	my $resultado = 0;
	my $n = length $pLinea;
	for (my $i=0;$i<$n;$i++) {
		my $char = substr $pLinea, $i, 1;
		$D = (($D << 1) | 1) & $B{$char};
		if ($D & $pLimite) {
			$resultado++;
		}#fin si encontro el patrón
	}#fin for
	
	return $resultado;
}#fin buscar patron

=begin comment
	Mete los caracteres del patrón en un array. En el
	caso de las opciones, las mete en el mismo campo
	del array.
	Ej: re[mtz]ar => r,e,mtz,a,r
	@param pPatron el patrón que va a ser procesado.
	@returns Retorna un array con el patrón procesado.
=end comment
=cut
sub procesarPatron {
	my ($pPatron) = @_;
	my $opcion = 0;
	my $cadena = '';
	my $largo = length $pPatron;
	my @p = ();
	#Recorre el patron de forma inversa para que el
	#array @p quede correcto.
	for (my $i=0;$i<$largo;$i++) {
		my $char = substr($pPatron,$i,1);
		if ($char eq '[') {
			$opcion = 1;
		}
		elsif ($char eq ']') {
			$opcion = 0;
			push(@p,$cadena);
			$cadena = '';
		}
		elsif ($opcion) {
			$cadena = $cadena . $char;
		}#si esta en modo opcion
		else {
			push (@p, $char);
		}#fin si no esta dentro de un [ ]
	}#fin for
	#Verifica el tamaño del patron
	my $limite = 8 * length pack 'i', 0;
	$largo = @p;
	if ($largo > $limite) {
		print "$pPatron se va a truncar\n";
		$#p = $largo - 1;
	}#fin si el patron es mas largo que un int en el S.O.
	return @p;
}#fin procesar patrón

=begin comment
	Calcula la mascara del patron. Supone que el largo del patron
	que recibe no es mayor al tamaño de la palabra del S.O.
	@param $pPatron Referencia a un arreglo con el patrón procesado.
					No puede tener un largo mayor al tamaño de la
					palabra del S.O en bits.
	@returns Retorna una referencia a un hash con el valor de la
			 máscara de cada letra del patrón.
=end comment
=cut
sub calcularMascaras {
	my ($pPatron) = @_;
	my @p = @{$pPatron};
	my $m = @p;
	my %B;
	
	for (my $j=0;$j<$m;$j++){
		if (length $p[$j] > 1) {
			for (my $j1=0;$j1<length($p[$j]);$j1++) {
				$char = substr $p[$j],$j1,1;
				$B{$char} = $B{$char} | (1 << $j);
			}#fin for
		}#fin si son opciones
		else {
			$B{$p[$j]} = $B{$p[$j]} | (1 << $j);
		}#fin si no es un caso de opciones
	}#fin for
	
	return \%B;
}#fin calcular mascaras

1;
