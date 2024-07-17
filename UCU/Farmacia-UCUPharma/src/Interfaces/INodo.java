/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Interfaces;

/**
 * @T tipo
 * @author Lithium582
**/
public interface INodo<T extends IColeccionable> {
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
    public void setSiguiente(INodo<T> pValue);

    /**
     * Retorna el siguiente nodo al nodo actual.
     *
     * @return Siguiente nodo del actual
     */
    public INodo<T> getSiguiente();

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
    public boolean equals(INodo<T> pNodo);

    /**
     * Retorna el tag del nodo
     *
     * @return tag del nodo
     */
    public Integer getEtiqueta();

    /**
     *
     * @param tag
     * @return devuelve -1 si this tiene una tag menor, 0 si son iguales, 1 si es mayor
     */
    public Comparable compareTo(Integer etiqueta);
}
