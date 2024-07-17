/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Interfaces;

/**
 * @param <T> Tipo del nodo
 * @author Lithium582
**/
public interface INodoLista<T> {
   /**
     * Retorna el dato contenido en el nodo.
     *
     * @return Data contenido en el nodo.
     */
    public T getObjeto();

    /**
     * Asigna un dato al nodo.
     *
     * @param pValue a asignar.
     */
    public void setObjeto(T pValue);

    /**
     * Asigna el siguiente nodo al node actual.
     *
     * @param pValue Nodo a asignar como siguiente.
     */
    public void setSiguiente(INodoLista<T> pValue);

    /**
     * Retorna el siguiente nodo al nodo actual.
     *
     * @return Siguiente nodo del actual
     */
    public INodoLista<T> getSiguiente();

    /**
     * Imprime los datos del node
     */
    public void print();

    /**
     * Imprime la etiqueta del nodo
     */
    public void PrintEtiqueta();

    /**
     *
     * @param pNodo
     * @return si son iguales, por la clave
     */
    public boolean equals(INodoLista<T> pNodo);

    /**
     * Retorna el tag del nodo
     *
     * @return tag del nodo
     */
    public Comparable getEtiqueta();

    /**
     *
     * @param pEtiqueta
     * @return devuelve -1 si this tiene una tag menor, 0 si son iguales, 1 si es mayor
     */
    public Comparable compareTo(Comparable pEtiqueta);
}
