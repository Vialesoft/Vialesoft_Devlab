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
public class INodoTest {
    
    public INodoTest() {
    }

    @Test
    public void testGetObjeto() {
    }

    @Test
    public void testSetObjeto() {
    }

    @Test
    public void testSetSiguiente() {
    }

    @Test
    public void testGetSiguiente() {
    }

    @Test
    public void testPrint() {
    }

    @Test
    public void testPrintEtiqueta() {
    }

    @Test
    public void testEquals() {
    }

    @Test
    public void testGetEtiqueta() {
    }

    @Test
    public void testCompareTo() {
    }

    public class INodoImpl<T extends IColeccionable> implements INodo<T> {

        public T getObjeto() {
            return null;
        }

        public void setObjeto(T pValue) {
        }

        public void setSiguiente(INodo<T> pValue) {
        }

        public INodo<T> getSiguiente() {
            return null;
        }

        public void print() {
        }

        public void PrintEtiqueta() {
        }

        public boolean equals(INodo<T> pNodo) {
            return false;
        }

        public Integer getEtiqueta() {
            return null;
        }

        public Comparable compareTo(Integer etiqueta) {
            return null;
        }
    }
    
}
