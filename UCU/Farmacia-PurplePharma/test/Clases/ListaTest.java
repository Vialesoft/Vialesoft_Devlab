/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Clases;

import org.junit.Test;

/**
 *
 * @author Lithium582
 */
public class ListaTest {
    Lista<Articulo> objLista;
    
    public ListaTest() {
        objLista = new Lista<Articulo>();
        objLista.Insertar(new NodoLista<Articulo>(new Articulo(),3));
        objLista.Insertar(new NodoLista<Articulo>(new Articulo(),4));
        objLista.Insertar(new NodoLista<Articulo>(new Articulo(),10));
        objLista.Insertar(new NodoLista<Articulo>(new Articulo(),12));
        objLista.Insertar(new NodoLista<Articulo>(new Articulo(),16));
    }

    @Test
    public void testInsertar() {
        objLista.Insertar(new NodoLista<Articulo>(new Articulo(),3));
    }

    @Test
    public void testBuscar() {
        
    }

    @Test
    public void testBorrar() {
        
    }

    @Test
    public void testCantidadDeElementos() {
    }

    @Test
    public void testEsVacia() {
    }

    @Test
    public void testGetPrimero() {
    }
    
}
