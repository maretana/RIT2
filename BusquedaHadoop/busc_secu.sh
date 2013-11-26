#Instituto Tecnológico de Costa Rica
#Escuela de Ingeniería en Computación
#Recuperación de Información Textual
#Proyecto 2
#Mario Retana Rojas
#Wei Hua Zheng Ma

if [-d "busqueda_classes"]
then
	rm -rf busqueda_classes
	#hadoop fs -rmr /user/cloudera/busqueda
fi

mkdir busqueda_classes

javac -d busqueda_classes NumeradorArchivos.java
java -cp busqueda_classes/ NumeradorArchivos "/home/cloudera/Hadoop-Ejemplos/man.utf8/"
