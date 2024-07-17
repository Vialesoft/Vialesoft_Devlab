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
public class IArticuloTest {
    
    public IArticuloTest() {
    }

    @Test
    public void testGetFechaCreacion() {
    }

    @Test
    public void testSetFechaCreacion() {
    }

    @Test
    public void testGetFechaActualizacion() {
    }

    @Test
    public void testSetFechaActualizacion() {
    }

    @Test
    public void testGetPrecio() {
    }

    @Test
    public void testSetPrecio() {
    }

    @Test
    public void testGetNombre() {
    }

    @Test
    public void testSetNombre() {
    }

    @Test
    public void testGetDescripcion() {
    }

    @Test
    public void testSetDescripcion() {
    }

    @Test
    public void testGetEstado() {
    }

    @Test
    public void testSetEstado() {
    }

    @Test
    public void testGetRefrigerado() {
    }

    @Test
    public void testSetRefrigerado() {
    }

    @Test
    public void testGetReceta() {
    }

    @Test
    public void testSetReceta() {
    }

    @Test
    public void testGetStock() {
    }

    @Test
    public void testSetStock() {
    }

    public class IArticuloImpl implements IArticulo {

        public Integer getID(){
            return 5;
        }
        
        public Date getFechaCreacion() {
            return null;
        }

        public void setFechaCreacion(Date value) {
        }

        public Date getFechaActualizacion() {
            return null;
        }

        public void setFechaActualizacion(Date value) {
        }

        public double getPrecio() {
            return 0.0;
        }

        public void setPrecio(double value) {
        }

        public String getNombre() {
            return "";
        }

        public void setNombre(String value) {
        }

        public String getDescripcion() {
            return "";
        }

        public void setDescripcion(String value) {
        }

        public Boolean getEstado() {
            return null;
        }

        public void setEstado(Boolean value) {
        }

        public boolean getRefrigerado() {
            return false;
        }

        public void setRefrigerado(boolean value) {
        }

        public boolean getReceta() {
            return false;
        }

        public void setReceta(boolean value) {
        }

        public int getStock() {
            return 0;
        }

        public void setStock(Integer value) {
        }
        
        public String toString(String separador){
            return "";
        }
    }
    
}
