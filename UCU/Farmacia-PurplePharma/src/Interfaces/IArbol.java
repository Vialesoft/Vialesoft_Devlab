/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Interfaces;

/**
 * @param <T> Tipo del árbol
 * @author Lithium582
**/
public interface IArbol<T> {

    /**
     * Inserta un nuevo nodo en el árbol y retorna false si el nodo ya existe
     *
     * @param pNodo Elemento a insertar
     * @return True si la inserción fue exitosa o false en caso contrario
     */

    public boolean insertar(INodoArbol<T> pNodo);

    /**
     * Busca un elemento dentro del árbol.
     *
     * @param pEtiqueta ID del elemento que se quiere buscar
     * @return Nodo con la etiqueta buscada o null si no existe
     */
    public INodoArbol<T> buscar(Comparable pEtiqueta);
    
    /**
     * Busca los elementos de los nodos cuyo ID se encuentre en medio de los dos valores ingresados
     *
     * @param pValorMinimo Valor mínimo buscado
     * @param pValorMaximo Valor máximo buscado
     * @param pListaRetorno Lista que se cargará con los nodos cuyo parámetro coincida con el valor buscado
     */
    public void buscarInRango(Comparable pValorMinimo, Comparable pValorMaximo, ILista<T> pListaRetorno);

    /**
     * Busca los elementos por el atributo recibido por parámetro
     *
     * @param aParam Nombre del atributo de la clase por el cual debe buscar
     * @param pValorParametro Valor del atributo buscado
     * @param pListaRetorno Lista que se cargará con los nodos cuyo parámetro coincida con el valor buscado
     */
    public void buscarXAtributo(String aParam, String pValorParametro, ILista<T> pListaRetorno);
    
    /**
     * Busca un elemento por el atributo recibido por parámetro
     *
     * @param pEtiqueta ID del elemento que se quiere buscar
     * @param pAttr Nombre del atributo de la clase por el cual debe buscar
     * @return Nodo con la etiqueta buscada o null si no existe
     */
    public String buscarXAtributo(String pAttr, String pStringBuscado);
    
    
    /**
     * Elimina un elemento dada una etiqueta.
     * 
     * @param pEtiqueta ID del elemento que se quiere eliminar
     */
    public Boolean eliminar(Comparable pEtiqueta);
    
    /**
     * Retorna todas las etiquetas del árbol en inOrden
     *
     * @return String conteniendo las etiquetas del árbol en inOrden
     */
    public String inOrden();
    
    /**
     * Retorna todas las etiquetas del árbol en posOrden
     *
     * @return String conteniendo las etiquetas del árbol en posOrden
     */
    public String posOrden();
    
    /**
     * Retorna todas las etiquetas del árbol en preOrden
     *
     * @return String conteniendo las etiquetas del árbol en preOrden
     */
    public String preOrden();
    
    /**
     * Retorna la altura del árbol
     * 
     * @return altura total del árbol
     */
    public int getAltura();
    
    /**
     * Retorna el tamaño del árbol
     * 
     * @return tamaño total del árbol
     */
    public int getTamano();
    
    /**
     * Retorna el nivel donde se encuentra la etiqueta
     * 
     * @param pEtiqueta etiqueta del nodo cuyo nivel quiere saberse
     * @return nivel donde se encuentra la etiqueta en el árbol
     */
    public int getNivel(Comparable pEtiqueta);
    
    /**
     * Retorna la cantidad de hojas del árbol
     * 
     * @return cantidad de hojas del árbol
     */
    public int getHojas();
    
    /**
     * Retorna el nodo lexicográficamente anterior
     * @param pEtiqueta
     * @return Nodo anterior a la etiqueta buscada
    */
    public INodoArbol lexicoGraficamenteAnterior(Comparable pEtiqueta);
	
    /**
     * Retorna un booleano indicando si el árbol es vacío o no
     * @return Booleano indicando si el árbol es vacío o no
    */
    public boolean esVacio();
    
    /**
     * Retorna un booleano indicando si el árbol pudo vaciarse o no
     * @return Booleano indicando si el árbol pudo vaciarse
    */
    public boolean vaciar();
}

