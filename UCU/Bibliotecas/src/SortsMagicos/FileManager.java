/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package SortsMagicos;

import java.io.*;
import java.util.ArrayList;

/**
 * Clase manejadora de archivos que tanto escribe como lee los mismos.
 */
public class FileManager {

    /**
     * Constructor de FileManager
     */
    public FileManager() {
    }

    /**
     * Lee el archivo linea a linea y nos retorna un ArrayList donde cada
     * elemento es una linea
     *
     * @param filename
     * @param ignoreHeader
     * @return Arraylist donde cada elemento es una linea del archivo
     * @throws java.io.FileNotFoundException
     */
    public ArrayList<String> readFile(String filename, boolean ignoreHeader)
            throws FileNotFoundException, IOException {
        FileInputStream fr;
        ArrayList<String> lineas = null;
        try {
            lineas = new ArrayList();
            fr = new FileInputStream(filename);
            BufferedReader br = new BufferedReader(new InputStreamReader(fr, "cp1252"));
            String actualLine = br.readLine();
            if (ignoreHeader) {
                actualLine = br.readLine();
            }
            while (actualLine != null) {
                lineas.add(actualLine);
                actualLine = br.readLine();
            }
            fr.close();
            br.close();
        } catch (FileNotFoundException e) {
            throw new FileNotFoundException(e.getMessage());
        } catch (IOException e) {
            throw new IOException(e.getMessage(), e);
        }
        return lineas;
    }

    /**
     * Metodo que escribe en un archivo.
     *
     * @param filename Archivo a escribir
     * @param linesList Lineas a escribir
     * @param append Booleano que controla si se elimina el contenido anterior
     * del archivo, o si se realiza un append al final
     * @throws java.io.IOException
     */
    public void writeFile(String filename, String[] linesList, Boolean append)
            throws IOException {
        FileWriter fw;
        try {
            fw = new FileWriter(filename, append);
            BufferedWriter bw = new BufferedWriter(fw);
            for (int i = 0; i < linesList.length; i++) {
                String thisLine = linesList[i];
                bw.write(thisLine);
                bw.newLine();
            }
            bw.close();
            fw.close();
        } catch (IOException e) {
            throw new IOException(e.getMessage());
        }
    }
}
