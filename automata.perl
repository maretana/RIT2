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
sub calcularMascarasAutomata {
	my ($pPatron) = @_;
	my $m = length $pPatron;
	my %B;
	
	for (my $j=0;$j<$m;$j++){
		my $char = substr($pPatron,$j,1);
		$B{$char} = $B{$char} | (1 << $j);
	}#fin for
	
	return \%B;
}#fin calcular mascaras

=begin comment
	Calcula los estados iniciales D del autómata. Hay un D por cada
	error que se indica como permitido.
	@param $pErrores Cantidad de errores permitidos.
	@return Retorna una referencia a un hash con los estados iniciales.
=end comment
=cut
sub calcularEstadosIniciales {
	my ($pErrores) = @_;
	my %D;
	for (my $i=0;$i<=$pErrores;$i++) {
		$D{$i} = (1 << $i) - 1;
	}#fin for
	return \%D;
}#fin calcular estados iniciales

=begin comment
NFA (Non finite automaton) se usa para buscar un patron con la tolerancia
de que ocurran k errores.
@param $pLimite El 1 más significativo según el largo del patrón.
@param $pPalabra Palabra en la que se busca el patrón.
@param $pB Referencia a las máscaras del patrón
@param $pD Referencia a las máscaras de estado iniciales.
@param $pErrores Cantidad de errores acpetables.
@returns Retorna 1 si encuentra el patrón y 0 de lo contrario.
=end comment
=cut
sub NFA{
	my ($pLimite, $pPalabra, $pB, $pD, $pErrores) = @_;
	my %B = %{$pB};
	my %D = %{$pD};
	my $n = length $pPalabra;
	
	for (my $j=0;$j<$n;$j++) {
		my $char = substr $pPalabra, $j, 1;
		my $pD = $D{0};
		my $nD = ($D{0} << 1) & $B{$char};
		$D{0} = $nD;
		for (my $i=1;$i<=$pErrores;$i++) {
			$nD =	(($D{$i} << 1) & $B{$char})	|	#Igual
					$pD						  	|	#Inserción
					$pD << 1					|	#Sustitución
					$nD << 1					|	#Borrado
					1;
		}#fin for
		print "$j.\t$nD\n";
		if ($nD & $pLimite) {
			return 1;
		}#fin si se encontró el patrón
	}#fin for
	return 0;
}#fin Non Finite Automaton

1;
