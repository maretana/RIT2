package busquedahadoop;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.util.StringTokenizer;

/**
 * Instituto Tecnológico de Costa Rica
 * Escuela de Ingeniería en Computación
 * Recuperación de Información Textual
 * Proyecto 2
 * @author Mario Retana Rojas - 201029799
 * @author Wei Hua Zheng Ma - 201020990
 */
public class NumeradorArchivos {
    
    /**
     * Este programa recibe la ruta a una colección de archivos
     * y genera un archivo que contiene el nombre de todos los
     * archivos junto con un doc id asignado.
     * @param args La ruta a la colección de archivos.
     */
    public static void main(String[] args) throws Exception {
        String ruta = args[0];
        NumeradorArchivos na = new NumeradorArchivos();
        na.detectarArchivos(ruta);
    }//fin main
    
    /**
     * Detecta todos los archivos que se encuentran en un ruta.
     * @param pRuta La ruta en donde se van a buscar archivos.
     */
    public void detectarArchivos(String pRuta) throws Exception {
        File directorio = new File(pRuta);
        PrintWriter salida = new PrintWriter("DocID.txt");
        int indice = 0;
        for (File fileEntry : directorio.listFiles()) {
            if (fileEntry.isDirectory()) {
                indice = detectarArchivos(fileEntry.getAbsolutePath(), indice, salida);
            } else {
                salida.println(indice + ";" + fileEntry.getAbsolutePath());
                indice++;
            }
        }//fin for
        salida.close();
    }//fin detectar archivos

    /**
     * Detecta los archivos de una sub carpeta y de sus otras subcarpetas.
     * @param pRuta Ruta de la subcarpeta que se esta buscando
     * @param pIndice Indice del docID
     * @return Retorna el nuevo indice del docID
     * @throws FileNotFoundException 
     */
    private int detectarArchivos(String pRuta, int pIndice, PrintWriter pSalida) throws Exception {
        File directorio = new File(pRuta);
        int indice = pIndice;
        for (File fileEntry : directorio.listFiles()) {
            if (fileEntry.isDirectory()) {
                indice = detectarArchivos(fileEntry.getAbsolutePath(), indice, pSalida);
            } else {
                pSalida.println(indice + ";" + fileEntry.getAbsolutePath());
                indice++;
            }
        }//fin for
        return indice;
    }//fin detectar archivos
    
}//fin clase numerador archivos
