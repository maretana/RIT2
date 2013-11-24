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

use utf8;
use Encode;
use File::Find;

require "shift-and.perl";
require "horspool.perl";

binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");

use constant SIMILITUD => 0;

$argc = @ARGV;

if ($argc < 3) {
	die "Argumentos insuficientes!\n";
}#fin si argumentos insuficientes

$prefijo = $ARGV[0];
$ruta = $ARGV[1];

find(sub {push(@documentos,$File::Find::name) if -f}, $ruta);

foreach $documento (@documentos) {
	open(DOCUMENTO, $documento) || die "No se pudo abrir '$documento'.\n";
	@palabras = ();							#palabras del archivo
	while (<DOCUMENTO>) {
		while ($_ =~ m/[0-9a-zA-Z_ñÑáéíóúüÁÉÍÓÚÜ]*[a-zA-ZñÑáéíóúüÁÉÍÓÚÜ]+[0-9a-zA-Z_ñÑáéíóúüÁÉÍÓÚÜ]*/g) {
			push @palabras, $&;
		}#fin while
	}#fin while
	my @info_doc = ();
	for (my $i=2;$i<$argc;$i++) {
		$patron = $ARGV[$i];
		if ($patron =~ /\[[0-9a-zA-Z_ñÑáéíóúüÁÉÍÓÚÜ]+\]/) {		#SHIFT-AND
			my @p = procesarPatron($patron);
			my $B = calcularMascaras(\@p);
			my $m = @p;
			$m = 1 << ($m - 1);
			$apariciones = 0;
			foreach $palabra (@palabras) {
				$apariciones += buscarPatron_shift_and($palabra,$m,$B);
			}#fin for
			push @info_doc, $apariciones;
		}#fin si es búsqueda con opciones
		
		elsif ($patron =~ /##/){
			die "Autómata de estado finito no determinístico no implementado\n";
		}#fin si es búsqueda con errores 2
		
		elsif ($patron =~ /#/){
			die "Programación dinámica no implementada\n";
		}#fi si es busqueda con errores 1
		
		elsif ($patron =~ /[0-9a-zA-Z_ñÑáéíóúüÁÉÍÓÚÜ]+/) {	#HORSPOOL
			_calcularTabla($patron);
			$apariciones = 0;
			foreach $palabra (@palabras) {
				$apariciones += _horspool($palabra,$patron);
			}#fin for
			push @info_doc, $apariciones;
		}#fin si es busqueda simple
		else {
			print "$patron: Patron no válido\n";
			#Se elimina el patrón del array
			splice @ARGV, $i, 1;
			$i--;
			$argc = @ARGV;
		}#fin si no se calzó con algún patrón soportado
	}#fin for
	_calcularSimilitud(\@info_doc);
	$docs{$documento} = \@info_doc;
	close DOCUMENTO;
}#fin for

open(SALIDA, ">$prefijo.txt") || die "No se pudo abrir '$prefijo.txt'.\n";
print SALIDA "Prefijo\tPos\t";
for (my $i=2;$i<$argc;$i++) {
	print SALIDA "$ARGV[$i]\t";
}#fin for
print SALIDA "Similitud\tDocumento\n";

foreach $documento (sort { @{$docs{$b}}[SIMILITUD] <=> @{$docs{$a}}[SIMILITUD] } keys %docs) {
	my @info = @{$docs{$documento}};
	if ($info[SIMILITUD] > 0){
		$pos++;
		my $largo = @info;
		print SALIDA "$prefijo\t$pos\t";
		for (my $i=1;$i<$largo;$i++) {
			my $s = $info[$i] . "";
			printf SALIDA "%". length($ARGV[$i+1]). "s\t",$s;
		}#fin for
		printf SALIDA "%.7f\t%s\n", $info[SIMILITUD], $documento;
	}
}#fin for


sub _calcularSimilitud {
	my ($pInfo) = @_;
	my $largoinfo = @$pInfo;
	my $count = 0;
	my $suma = 0;
	my $div = 1 / ($largoinfo);
	for (my $i=0;$i<$largoinfo;$i++) {
		if (@$pInfo[$i] > 0) {
			$count++;
			$suma += 1 - (1 / (log(@$pInfo[$i] + 1)/ log(2)));
		}#fin si contiene ese patron al menos una vez
	}#fin for
	my $val = $count + ($div*$suma);
	unshift @$pInfo, $val;
}#fin calcular similitud
