/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Interfaces;

/**
 *
 * @author Lithium582
 */
public interface ILista<T extends IColeccionable> {
    
    /**
     *
     * @param pNodo Nuevo nodo
     */
    public void Insertar(INodo<T> pNodo);

    /**
     * Metodo encargado de buscar un nodo cuya key es la indicada.
     *
     * @param pId - ID del nodo a buscar.
     * @return El nodo encontrado. En caso de no encontrarlo, retornar null.
     */
    public INodo<T> Buscar(Integer pId);

    /**
     * Metodo encargado de eliminar un nodo cuya ID es el indicado.
     *
     * @param pId Clave del nodo a eliminar.
     * @return True en caso de que la eliminaci�n haya sido efectuada con éxito.
     */
    public boolean Borrar(Integer pId);

    /**
     * Método encargado de imprimir en consola las keys de los nodos
     * contenidos en la lista.
     * @return 
     */
    public String Print();

    /**
     * Retorna un String con las keys separadas por el separador pasado por
     * parámetro.
     *
     * @param separator Separa las keys
     * @return
     */
    public String Print(String separator);

    /**
     * Retorna la cantidad de elementos de la lista. En caso de que la lista
     * este vac�a, retornar 0.
     *
     * @return Cantidad de elementos de la lista.
     */
    public int CantidadDeElementos();

    /**
     * Indica si la lista contiene o no elementos.
     *
     * @return Si tiene elementos o no.
     */
    public boolean esVacia();

    /**
     * Retorna el primer nodo de la lista.
     *
     * @return Primer nodo de la lista.
     */
    public INodo<T> getPrimero();
}
