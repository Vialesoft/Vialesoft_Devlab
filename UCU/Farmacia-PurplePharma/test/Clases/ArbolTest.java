/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Clases;

import org.junit.Test;
import static org.junit.Assert.*;

/**
 *
 * @author Lithium582
 */
public class ArbolTest {
    Arbol<Articulo> objArbol;
    
    public ArbolTest() {
        objArbol = new Arbol();
        objArbol.insertar(new NodoArbol<Articulo>(3,new Articulo()));
        objArbol.insertar(new NodoArbol<Articulo>(4,new Articulo()));
        objArbol.insertar(new NodoArbol<Articulo>(10,new Articulo()));
        objArbol.insertar(new NodoArbol<Articulo>(12,new Articulo()));
        objArbol.insertar(new NodoArbol<Articulo>(16,new Articulo()));
    }

    @Test
    public void testInOrden() {
        System.out.println("Test InOrden");
        assertEquals("Test InOrden", "3-4-10-12-16",objArbol.inOrden());
    }

    @Test
    public void testEsVacio() {
        System.out.println("Test EsVacio");
        assertFalse("Test EsVacio",objArbol.esVacio());
    }

    @Test
    public void testEliminar() {
        objArbol.eliminar(10);
        assertEquals("Test Eliminar", "3-4-12-16",objArbol.inOrden());
    }

    @Test
    public void testLexicoGraficamenteAnterior() {
        assertEquals("Test LexicoGraficamenteAnterior", "4",objArbol.lexicoGraficamenteAnterior(10).getEtiqueta().toString());
    }

    @Test
    public void testPosOrden() {
        assertEquals("Test PosOrden", "-4-10-12-163",objArbol.posOrden());
    }

    @Test
    public void testPreOrden() {
        assertEquals("Test PreOrden", "3-4-10-12-16",objArbol.preOrden());
    }

    @Test
    public void testGetAltura() {
        assertEquals("Test PreOrden", 4,objArbol.getAltura());
    }

    @Test
    public void testGetTamano() {
        assertEquals("Test PreOrden", 5,objArbol.getTamano());
    }

    @Test
    public void testGetNivel() {
        assertEquals("Test PreOrden", 5,objArbol.getNivel(16));
    }

    @Test
    public void testGetHojas() {
        assertEquals("Test PreOrden", 1,objArbol.getHojas());
    }
    
}
