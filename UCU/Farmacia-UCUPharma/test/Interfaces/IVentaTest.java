/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Interfaces;

import java.util.Date;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 *
 * @author Lithium582
 */
public class IVentaTest {
    
    public IVentaTest() {
    }

    @Test
    public void testGetFecha() {
    }

    @Test
    public void testGetIdArticulo() {
    }

    @Test
    public void testSetIdArticulo() {
    }

    @Test
    public void testGetCantidad() {
    }

    @Test
    public void testSetCantidad() {
    }

    @Test
    public void testGetValorFinal() {
    }

    public class IVentaImpl implements IVenta {

        public Integer getID(){
            return 5;
        }
        
        public Date GetFecha() {
            return null;
        }

        public Integer GetIdArticulo() {
            return null;
        }

        public void SetIdArticulo(Integer value) {
        }

        public Integer GetCantidad() {
            return null;
        }

        public void SetCantidad(Integer value) {
        }

        public Double GetValorFinal() {
            return null;
        }
        
        public String toString(String separador){
            return "";
        }
    }
    
}
