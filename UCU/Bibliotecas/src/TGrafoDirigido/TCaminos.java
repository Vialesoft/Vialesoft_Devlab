/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package TGrafoDirigido;

import java.util.LinkedList;

/**
 *
 * @author Lithium582
 */
public class TCaminos {
    private final LinkedList<TCamino> caminos;
    
    /**
     *
     * @return
     */
    public LinkedList<TCamino> getCaminos(){
        return this.caminos;
    }
    
    /**
     *
     */
    public TCaminos(){
        this.caminos = new LinkedList<TCamino>();
    }
    
    /**
     *
     */
    public void imprimir(){
        this.caminos.forEach((camino) -> {
            camino.imprimirEtiquetas();
        });
    }
}
