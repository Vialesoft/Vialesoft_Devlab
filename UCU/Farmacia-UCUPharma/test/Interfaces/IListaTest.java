/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Interfaces;

import org.junit.Test;
import static org.junit.Assert.*;

/**
 *
 * @author Lithium582
 */
public class IListaTest {
    
    public IListaTest() {
    }

    @Test
    public void testInsertar() {
    }

    @Test
    public void testBuscar() {
    }

    @Test
    public void testBorrar() {
    }

    @Test
    public void testPrint_0args() {
    }

    @Test
    public void testPrint_String() {
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

    public class IListaImpl<T extends IColeccionable> implements ILista<T> {

        public void Insertar(INodo<T> pNodo) {
        }

        public INodo<T> Buscar(Integer pId) {
            return null;
        }

        public boolean Borrar(Integer pId) {
            return false;
        }

        public String Print() {
            return "";
        }

        public String Print(String separator) {
            return "";
        }

        public int CantidadDeElementos() {
            return 0;
        }

        public boolean esVacia() {
            return false;
        }

        public INodo<T> getPrimero() {
            return null;
        }
    }
    
}
