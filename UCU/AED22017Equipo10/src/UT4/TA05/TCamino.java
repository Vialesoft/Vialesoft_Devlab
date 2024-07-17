/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UT4.TA05;

import java.util.LinkedList;

/**
 *
 * @author Lithium582
 */
public class TCamino {
    public TVertice origen;
    public LinkedList<Comparable> otrosVertices; //LinkedList es la más apropiada
    private double costoTotal;
    
    public TVertice getOrigen(){
        return this.origen;
    }
    
    public LinkedList<Comparable> getOtrosVertices(){
        return this.otrosVertices;
    }
    
    public double getCosto(){
        return this.costoTotal;
    }
    
    private void setCosto(double unCosto){
        this.costoTotal = unCosto;
    }
    
    public TCamino(TVertice v){
        this.origen = v;
        this.otrosVertices = new LinkedList<Comparable>();
        this.costoTotal = 0;
    }
    
    public boolean agregarAdyacencia(TAdyacencia adyacenciaActual){
        if(adyacenciaActual.getDestino() != null){
            costoTotal += adyacenciaActual.getCosto();
            String etiquetaDestino = adyacenciaActual.getDestino().getEtiqueta().toString();
            
            return otrosVertices.add(etiquetaDestino);
        }
        //Retorno "FÁLSSE"
        return false;
    }
    
    public boolean eliminarAdyacencia(TAdyacencia adyacenciaActual){
        String etiquetaAEliminar = adyacenciaActual.getDestino().getEtiqueta().toString();
        if(otrosVertices.contains(etiquetaAEliminar)){
            costoTotal -= adyacenciaActual.getCosto();
            return (otrosVertices.remove(etiquetaAEliminar));
        }
        
        return false;
    }
    
    public void imprimirEtiquetas(){
        System.out.println("Verificar que no duplique el origen");
        System.out.println(origen.getEtiqueta());
        
        for(Comparable comp : otrosVertices){
            System.out.println(comp.toString());
        }
    }
    
    public String imprimirEtiquetasStr(){
        String resultado = "Verificar que no duplique el origen";
        resultado += "\n" + origen.getEtiqueta();
        
        for(Comparable comp : otrosVertices){
            resultado += ", " + comp.toString();
        }
        
        return resultado;
    }
    
    public TCamino copiar(){
        TVertice origen = new TVertice(this.getOrigen().getEtiqueta());
        TCamino copia = new TCamino(origen);
        origen.getAdyacentes().addAll(this.getOrigen().getAdyacentes());
        copia.getOtrosVertices().addAll(this.getOtrosVertices());
        
        return copia;
    }
    
}
