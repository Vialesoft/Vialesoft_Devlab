/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Manejador.Archivos;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author user
 */
public class ManejadorArchivos {
    /**
     * Lee el archivo y lo carga en un array de bytes
     *
     * @param pFileName Nombre del archivo
     * @return Array de bytes que conteniendo la información del archivo cargado
     */
    public static byte[] readToBytes(String pFileName) {
        try {
            FileInputStream in = new FileInputStream(pFileName);
            byte[] bytes = new byte[(int) in.getChannel().size()];
            in.read(bytes);
            in.close();
            return bytes;
        } catch (IOException ex) {
            //Logger.getLogger(ExSystem.class.getName()).log(Level.SEVERE, null, ex);
            System.out.println("ReadToBytes CATCH");
        }
        return null;
    }

    /**
     * Método que escribe en un archivo el contenido de un array de bytes
     *
     * @param pFileName Nombre del archivo
     * @param pFileContent Contenido en bytes del archivo del archivo, o si se
     * realiza un append al final
     * @return Retorna un booleano confirmando la operación
     */
    public static boolean writeFromBytes(String pFileName, byte[] pFileContent) {
        boolean retValue = false;
        try {
            FileOutputStream out = new FileOutputStream(pFileName);
            out.write(pFileContent);
            out.flush();
            out.close();
            retValue = true;
        } catch (IOException ex) {
            //Logger.getLogger(ExSystem.class.getName()).log(Level.SEVERE, null, ex);
        }
        return retValue;
    }

    /**
     * Lee el archivo linea a linea y nos retorna un ArrayList donde cada
     * elemento es una linea
     *
     * @param pFileName
     * @param pIgnoreHead
     * @return Arraylist donde cada elemento es una linea del archivo
     * @throws java.io.FileNotFoundException
     */
    public static ArrayList<String> readFile(String pFileName, boolean pIgnoreHead)
            throws FileNotFoundException, IOException {
        FileInputStream fis;
        ArrayList<String> linesArr = null;
        try {
            linesArr = new ArrayList();
            fis = new FileInputStream(pFileName);

            BufferedReader br = new BufferedReader(new InputStreamReader(fis, "cp1252"));
            String actualLine = br.readLine();

            if (pIgnoreHead) {
                actualLine = br.readLine();
            }
            while (actualLine != null) {
                linesArr.add(actualLine);
                actualLine = br.readLine();
            }
            fis.close();
            br.close();
        } catch (FileNotFoundException e) {
            throw new FileNotFoundException(e.getMessage());
        } catch (IOException e) {
            throw new IOException(e.getMessage(), e);
        }
        return linesArr;
    }

    /**
     * Metodo que escribe en un archivo.
     *
     * @param pFileName Archivo a escribir
     * @param pLineList Lineas a escribir
     * @param pAppend Booleano que controla si se elimina el contenido anterior
     * del archivo, o si se realiza un append al final
     * @throws java.io.IOException
     */
    public static void writeFile(String pFileName, String[] pLineList, Boolean pAppend)
            throws IOException {
        try {
            FileWriter fWr = new FileWriter(pFileName, pAppend);
            BufferedWriter buffWr = new BufferedWriter(fWr);
            for (String thisLine : pLineList) {
                buffWr.write(thisLine);
                buffWr.newLine();
            }
            buffWr.close();
            fWr.close();
        } catch (IOException e) {
            throw new IOException(e.getMessage());
        }
    }
}
