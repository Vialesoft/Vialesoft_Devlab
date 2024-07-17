/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UCUGrafos;

import Clases.*;
import java.util.LinkedList;

/**
 *
 * @author Lithium582
 */
public class TCaminos {
    private final LinkedList<TCamino> caminos;
    private TCamino caminoMasCorto;
    
    /**
     * Método que retorna todos los caminos
     * @return Lista de caminos
     */
    public LinkedList<TCamino> getCaminos(){
        return this.caminos;
    }
    
    /**
     * Método que retorna el camino más corto
     * @return Instancia de TCamino indicando el camino más corto
     */
    public TCamino getCaminoMasCorto(){
        return this.caminoMasCorto;
    }
    
    /**
     * Costructor de TCaminos
     */
    public TCaminos(){
        this.caminos = new LinkedList<TCamino>();
        this.caminoMasCorto = null;
    }
    
    /**
     * Método que inserta un nuevo camino a la lista
     * @param pCamino Objeto Camino a ser insertado
     */
    public void agregarCamino(TCamino pCamino) {
        this.caminos.add(pCamino);
        if(this.caminoMasCorto == null) {
            this.caminoMasCorto = pCamino;
        } else {
            if(pCamino.getCosto() < this.caminoMasCorto.getCosto()) {
                this.caminoMasCorto = pCamino;
            }
        }
    }
    
    /**
     * Método que retorna la información del camino más corto
     * @return  String con las etiquetas del camino más corto 
     */
    public String imprimiMasCortoSTR(){
        if(this.caminoMasCorto != null){
            String strRetorno = this.caminoMasCorto.imprimirEtiquetasStr();
            return strRetorno;
        }
        
        return "";
    }
    
    /**
     * Método que imprimie directamente el camino más corto
     */
    public void imprimirCaminoMasCorto(){
        if(this.caminoMasCorto != null){
            this.caminoMasCorto.imprimirEtiquetas();
        } else {
            System.out.println("");
        }
    }
    
    /**
     * Método que imprime todos los caminos
     */
    public void imprimir(){
        this.caminos.forEach((camino) -> {
            camino.imprimirEtiquetas();
        });
    }
    
    /**
     * Método que retorna todos los caminos 
     * @return String con las etiquetas que representan a los caminos
     */
    public String imprimirTodosSTR(){
        String strRetorno = "";
        for(TCamino caminoLambda : this.caminos){
            strRetorno += caminoLambda.imprimirEtiquetasStr() + "\n";
        }
        
        return strRetorno;
    }
}
